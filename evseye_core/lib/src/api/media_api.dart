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

  Future<Result<List<PhotoRequirement>>> requirements(PhotoEntity entity) {
    return _client.get<List<PhotoRequirement>>(
      '/media/photo-requirements',
      query: {'entityType': entity.wire},
      parse: (data) => (data as List<dynamic>)
          .map((e) => PhotoRequirement.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false),
    );
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

    try {
      final Dio plain = Dio();
      final Response<dynamic> put = await plain.put<dynamic>(
        uploadUrl,
        data: Stream<List<int>>.fromIterable([bytes]),
        options: Options(
          headers: _signedHeaders(uploadUrl, mimeType, bytes.length),
          validateStatus: (_) => true,
        ),
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );
      final int status = put.statusCode ?? 0;
      if (status < 200 || status >= 300) {
        return Result.err(ServerFailure('Upload failed (${put.statusCode}).', status));
      }
    } on DioException catch (e) {
      return Result.err(NetworkFailure('Could not upload the photo. (${e.message})'));
    }

    return _client.post<RemotePhoto>(
      '/media/$photoId/complete',
      parse: (data) => RemotePhoto.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<String>> downloadUrl(String photoId) {
    return _client.get<String>(
      '/media/$photoId/download-url',
      parse: (data) => data is Map ? data['url']?.toString() ?? '' : data.toString(),
    );
  }

  static Map<String, dynamic> _signedHeaders(String url, String mimeType, int length) {
    final Set<String> signed = (Uri.parse(url).queryParameters['X-Amz-SignedHeaders'] ?? '')
        .split(';')
        .map((h) => h.trim().toLowerCase())
        .where((h) => h.isNotEmpty)
        .toSet();

    final Map<String, dynamic> headers = <String, dynamic>{
      Headers.contentLengthHeader: length,
    };
    if (signed.isEmpty || signed.contains('content-type')) {
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
