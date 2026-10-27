import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../utils/result.dart';
import 'api_client.dart';

enum PhotoEntity {
  rider('RIDER'),
  fleet('FLEET'),
  battery('BATTERY'),
  controller('CONTROLLER'),
  inspection('INSPECTION');

  const PhotoEntity(this.wire);

  final String wire;
}

class RemotePhoto {
  const RemotePhoto({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.photoType,
    required this.status,
    this.downloadUrl,
  });

  factory RemotePhoto.fromJson(Map<String, dynamic> json) => RemotePhoto(
        id: json['id'] as String,
        entityType: json['entityType']?.toString() ?? '',
        entityId: json['entityId']?.toString() ?? '',
        photoType: json['photoType']?.toString() ?? '',
        status: json['status']?.toString() ?? 'PENDING_UPLOAD',
        downloadUrl: json['downloadUrl']?.toString(),
      );

  final String id;
  final String entityType;
  final String entityId;
  final String photoType;

  final String status;

  final String? downloadUrl;

  bool get isComplete => status == 'COMPLETE';
}

class PhotoRequirement {
  const PhotoRequirement({
    required this.photoType,
    required this.isRequired,
    this.label,
  });

  factory PhotoRequirement.fromJson(Map<String, dynamic> json) => PhotoRequirement(
        photoType: json['photoType']?.toString() ?? '',
        isRequired: json['isRequired'] as bool? ?? false,
        label: json['label']?.toString(),
      );

  final String photoType;
  final bool isRequired;
  final String? label;

  String get title {
    if (label != null && label!.isNotEmpty) return label!;
    final String spaced = photoType.replaceAll('_', ' ').toLowerCase();
    return spaced.isEmpty ? photoType : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }
}

class MediaApi {
  const MediaApi(this._client);

  final ApiClient _client;

  static const int maxReceiptBytes = 5 * 1024 * 1024;

  static String imageMimeType(String path) {
    final String lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  Future<Result<List<RemotePhoto>>> photos({
    required PhotoEntity entity,
    required String entityId,
  }) {
    return _client.get<List<RemotePhoto>>(
      '/media/photos',
      query: {'entityType': entity.wire, 'entityId': entityId},
      parse: (data) => (data as List<dynamic>)
          .map((e) => RemotePhoto.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false),
    );
  }

  Future<Result<RemotePhoto>> upload({
    required PhotoEntity entity,
    required String entityId,
    required String photoType,
    required File file,
    String mimeType = 'image/jpeg',
    void Function(double progress)? onProgress,
  }) async {
    final Uint8List bytes = await file.readAsBytes();
    final String fileName = _fileNameFor(photoType, mimeType);

    final Result<Map<String, dynamic>> intent = await _client.post<Map<String, dynamic>>(
      '/media/upload-intents',
      body: {
        'entityType': entity.wire,
        'entityId': entityId,
        'photoType': photoType,
        'mimeType': mimeType,
        'fileName': fileName,
        'sizeBytes': bytes.length,
      },
      parse: (data) => Map<String, dynamic>.from(data as Map),
    );
    if (intent case Err<Map<String, dynamic>>(:final failure)) return Result.err(failure);

    final Map<String, dynamic> payload = (intent as Ok<Map<String, dynamic>>).value;
    final Map<String, dynamic> photoJson =
        Map<String, dynamic>.from(payload['photo'] as Map);
    final String uploadUrl = payload['uploadUrl'] as String;
    final String photoId = photoJson['id'] as String;

    final Result<bool> sent = await _putObject(uploadUrl, bytes, mimeType, onProgress);
    if (sent case Err<bool>(:final failure)) return Result.err(failure);

    return _client.post<RemotePhoto>(
      '/media/$photoId/complete',
      parse: (data) => RemotePhoto.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<RemotePhoto>> uploadOnboardingDocument({
    required String fieldCode,
    required File file,
    String mimeType = 'image/jpeg',
    void Function(double progress)? onProgress,
  }) async {
    final Uint8List bytes = await file.readAsBytes();
    final String fileName = _fileNameFor(fieldCode, mimeType);

    final Result<Map<String, dynamic>> intent = await _client.post<Map<String, dynamic>>(
      '/rider-app/onboarding/documents/upload-intent',
      body: {
        'fieldCode': fieldCode,
        'mimeType': mimeType,
        'fileName': fileName,
        'sizeBytes': bytes.length,
      },
      parse: (data) => Map<String, dynamic>.from(data as Map),
    );
    if (intent case Err<Map<String, dynamic>>(:final failure)) return Result.err(failure);

    final Map<String, dynamic> payload = (intent as Ok<Map<String, dynamic>>).value;
    final Map<String, dynamic> photoJson = Map<String, dynamic>.from(payload['photo'] as Map);
    final String uploadUrl = payload['uploadUrl'] as String;
    final String photoId = photoJson['id'] as String;

    final Result<bool> sent = await _putObject(uploadUrl, bytes, mimeType, onProgress);
    if (sent case Err<bool>(:final failure)) return Result.err(failure);

    return _client.post<RemotePhoto>(
      '/rider-app/onboarding/documents/$photoId/complete',
      parse: (data) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(data as Map);
        final Object? photo = map['photo'];
        return RemotePhoto.fromJson(photo is Map ? Map<String, dynamic>.from(photo) : map);
      },
    );
  }

  Future<Result<RemotePhoto>> uploadThrough({
    required String intentPath,
    required String photoType,
    required String Function(String photoId) completePath,
    required File file,
    String mimeType = 'image/jpeg',
    void Function(double progress)? onProgress,
  }) async {
    final Uint8List bytes = await file.readAsBytes();
    final Result<Map<String, dynamic>> intent = await _client.post<Map<String, dynamic>>(
      intentPath,
      body: {
        'photoType': photoType,
        'mimeType': mimeType,
        'fileName': _fileNameFor(photoType, mimeType),
        'sizeBytes': bytes.length,
      },
      parse: (data) => Map<String, dynamic>.from(data as Map),
    );
    if (intent case Err<Map<String, dynamic>>(:final failure)) return Result.err(failure);

    final Map<String, dynamic> payload = (intent as Ok<Map<String, dynamic>>).value;
    final String photoId = Map<String, dynamic>.from(payload['photo'] as Map)['id'] as String;
    final Result<bool> sent = await _putObject(
      payload['uploadUrl'] as String,
      bytes,
      mimeType,
      onProgress,
      alwaysSendContentType: true,
    );
    if (sent case Err<bool>(:final failure)) return Result.err(failure);

    return _client.post<RemotePhoto>(
      completePath(photoId),
      parse: (data) => RemotePhoto.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<RemotePhoto>> uploadPaymentReceipt({required String paymentId, required File file}) async {
    final String base = '/rider-app/billing/payment-transactions/DEPLOYMENT/$paymentId/receipts';
    final String mimeType = imageMimeType(file.path);
    final Uint8List bytes = await file.readAsBytes();
    final Result<Map<String, dynamic>> intent = await _client.post<Map<String, dynamic>>(
      '$base/upload-intent',
      body: {'fileName': _fileNameFor('receipt', mimeType), 'mimeType': mimeType, 'sizeBytes': bytes.length},
      parse: (data) => Map<String, dynamic>.from(data as Map),
    );
    if (intent case Err<Map<String, dynamic>>(:final failure)) return Result.err(failure);

    final Map<String, dynamic> payload = (intent as Ok<Map<String, dynamic>>).value;
    final String photoId = Map<String, dynamic>.from(payload['photo'] as Map)['id'] as String;
    final Result<bool> sent = await _putObject(
      payload['uploadUrl'] as String,
      bytes,
      mimeType,
      null,
      alwaysSendContentType: true,
    );
    if (sent case Err<bool>(:final failure)) return Result.err(failure);

    return _client.post<RemotePhoto>(
      '$base/$photoId/complete',
      parse: (data) => RemotePhoto.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<bool>> _putObject(
    String uploadUrl,
    Uint8List bytes,
    String mimeType,
    void Function(double progress)? onProgress, {
    bool alwaysSendContentType = false,
  }) async {
    try {
      final Dio plain = Dio();
      final Response<dynamic> put = await plain.put<dynamic>(
        uploadUrl,
        data: Stream<List<int>>.fromIterable([bytes]),
        options: Options(
          headers: _signedHeaders(uploadUrl, mimeType, bytes.length, alwaysSendContentType),
          validateStatus: (_) => true,
        ),
        onSendProgress: (sentBytes, total) {
          if (total > 0) onProgress?.call(sentBytes / total);
        },
      );
      final int status = put.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        return Result.err(ServerFailure('Upload failed (${put.statusCode}).', status));
      }
      return const Result.ok(true);
    } on DioException catch (e) {
      return Result.err(NetworkFailure('Could not upload the photo. (${e.message})'));
    }
  }

  Future<Result<String>> downloadUrl(String photoId) {
    return _client.get<String>(
      '/media/$photoId/download-url',
      parse: (data) => data is Map ? data['url']?.toString() ?? '' : data.toString(),
    );
  }

  static Map<String, dynamic> _signedHeaders(String url, String mimeType, int length, bool alwaysSendContentType) {
    final Set<String> signed = (Uri.parse(url).queryParameters['X-Amz-SignedHeaders'] ?? '')
        .split(';')
        .map((h) => h.trim().toLowerCase())
        .where((h) => h.isNotEmpty)
        .toSet();

    final Map<String, dynamic> headers = <String, dynamic>{
      Headers.contentLengthHeader: length,
    };
    if (alwaysSendContentType || signed.isEmpty || signed.contains('content-type')) {
      headers[Headers.contentTypeHeader] = mimeType;
    }
    if (signed.contains('x-amz-server-side-encryption')) {
      headers['x-amz-server-side-encryption'] = 'AES256';
    }
    return headers;
  }

  static String _fileNameFor(String photoType, String mimeType) {
    final String ext = switch (mimeType) {
      'image/png' => 'png',
      'image/webp' => 'webp',
      _ => 'jpg',
    };

    return '${photoType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.$ext';
  }
}
