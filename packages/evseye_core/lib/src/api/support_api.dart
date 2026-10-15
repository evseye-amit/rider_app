import 'dart:io';

import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'media_api.dart';

enum SupportTicketStatus {
  open('OPEN'),
  inProgress('IN_PROGRESS'),
  resolved('RESOLVED');

  const SupportTicketStatus(this.wire);

  final String wire;

  static SupportTicketStatus parse(Object? value) =>
      SupportTicketStatus.values.firstWhere((status) => status.wire == value?.toString(), orElse: () => open);
}

class SupportTicketDto {
  const SupportTicketDto({
    required this.id,
    required this.riderId,
    required this.status,
    required this.subject,
    required this.description,
    required this.createdById,
    required this.lastActivityAt,
    required this.createdAt,
    this.hubId,
    this.resolvedAt,
  });

  factory SupportTicketDto.fromJson(Map<String, dynamic> json) {
    final DateTime createdAt = jsonDateOr(json['createdAt'], DateTime.now());
    return SupportTicketDto(
      id: jsonText(json['id']),
      riderId: jsonText(json['riderId']),
      status: SupportTicketStatus.parse(json['status']),
      subject: jsonText(json['subject']),
      description: jsonText(json['description']),
      createdById: jsonText(json['createdById']),
      lastActivityAt: jsonDateOr(json['lastActivityAt'], createdAt),
      createdAt: createdAt,
      hubId: jsonTextOrNull(json['hubId']),
      resolvedAt: jsonDate(json['resolvedAt']),
    );
  }

  final String id;
  final String riderId;
  final SupportTicketStatus status;
  final String subject;
  final String description;
  final String createdById;
  final DateTime lastActivityAt;
  final DateTime createdAt;
  final String? hubId;
  final DateTime? resolvedAt;
}

class SupportReplyDto {
  const SupportReplyDto({required this.id, required this.authorId, required this.body, required this.createdAt});

  factory SupportReplyDto.fromJson(Map<String, dynamic> json) => SupportReplyDto(
    id: jsonText(json['id']),
    authorId: jsonText(json['authorId']),
    body: jsonText(json['body']),
    createdAt: jsonDateOr(json['createdAt'], DateTime.now()),
  );

  final String id;
  final String authorId;
  final String body;
  final DateTime createdAt;
}

class SupportAttachmentDto {
  const SupportAttachmentDto({
    required this.id,
    required this.mimeType,
    required this.sizeBytes,
    required this.uploadedById,
    required this.uploadedAt,
  });

  factory SupportAttachmentDto.fromJson(Map<String, dynamic> json) => SupportAttachmentDto(
    id: jsonText(json['id']),
    mimeType: jsonText(json['mimeType']),
    sizeBytes: jsonIntOrNull(json['sizeBytes']) ?? 0,
    uploadedById: jsonText(json['uploadedById']),
    uploadedAt: jsonDate(json['uploadedAt']) ?? jsonDateOr(json['createdAt'], DateTime.now()),
  );

  final String id;
  final String mimeType;
  final int sizeBytes;
  final String uploadedById;
  final DateTime uploadedAt;

  bool get isPdf => mimeType == 'application/pdf';
}

class SupportTicketDetailDto {
  const SupportTicketDetailDto({required this.ticket, required this.replies, required this.attachments});

  factory SupportTicketDetailDto.fromJson(Map<String, dynamic> json) => SupportTicketDetailDto(
    ticket: SupportTicketDto.fromJson(json),
    replies: [for (final Map<String, dynamic> reply in jsonMaps(json['replies'])) SupportReplyDto.fromJson(reply)]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
    attachments: [
      for (final Map<String, dynamic> photo in jsonMaps(json['photos'])) SupportAttachmentDto.fromJson(photo),
    ]..sort((a, b) => a.uploadedAt.compareTo(b.uploadedAt)),
  );

  final SupportTicketDto ticket;
  final List<SupportReplyDto> replies;
  final List<SupportAttachmentDto> attachments;
}

class SupportTicketPage {
  const SupportTicketPage({required this.items, this.nextCursor});

  factory SupportTicketPage.fromJson(Map<String, dynamic> json) => SupportTicketPage(
    items: [for (final Map<String, dynamic> item in jsonMaps(json['items'])) SupportTicketDto.fromJson(item)],
    nextCursor: jsonTextOrNull(json['nextCursor']),
  );

  final List<SupportTicketDto> items;
  final String? nextCursor;
}

class SupportApi {
  const SupportApi._(this._client, this._media, this._base);

  factory SupportApi.rider(ApiClient client, MediaApi media) =>
      SupportApi._(client, media, '/rider-app/support/tickets');

  factory SupportApi.staff(ApiClient client, MediaApi media) => SupportApi._(client, media, '/client/support/tickets');

  final ApiClient _client;
  final MediaApi _media;
  final String _base;

  Future<Result<SupportTicketPage>> list({String? cursor, int limit = 25, SupportTicketStatus? status}) =>
      _client.get<SupportTicketPage>(
        _base,
        query: {'limit': limit, 'cursor': ?cursor, 'status': ?status?.wire},
        parse: (data) => SupportTicketPage.fromJson(jsonMap(data)),
      );

  Future<Result<SupportTicketDetailDto>> detail(String id) => _client.get<SupportTicketDetailDto>(
    '$_base/$id',
    parse: (data) => SupportTicketDetailDto.fromJson(jsonMap(data)),
  );

  Future<Result<SupportTicketDto>> create({required String subject, required String message}) =>
      _client.post<SupportTicketDto>(
        _base,
        body: {'subject': subject, 'message': message},
        parse: (data) => SupportTicketDto.fromJson(jsonMap(data)),
      );

  Future<Result<SupportTicketStatus>> reply(String id, String message) => _client.post<SupportTicketStatus>(
    '$_base/$id/replies',
    body: {'message': message},
    parse: (data) => SupportTicketStatus.parse(jsonMap(data)['status']),
  );

  Future<Result<SupportTicketDto>> setStatus(String id, SupportTicketStatus status) => _client.patch<SupportTicketDto>(
    '$_base/$id/status',
    body: {'status': status.wire},
    parse: (data) => SupportTicketDto.fromJson(jsonMap(data)),
  );

  Future<Result<RemotePhoto>> attach(String id, File file, {String mimeType = 'image/jpeg'}) => _media.uploadThrough(
    intentPath: '$_base/$id/attachments/upload-intent',
    photoType: 'ATTACHMENT_${DateTime.now().microsecondsSinceEpoch}',
    completePath: (photoId) => '$_base/$id/attachments/$photoId/complete',
    file: file,
    mimeType: mimeType,
  );

  Future<Result<String>> attachmentUrl(String id, String photoId) => _client.get<String>(
    '$_base/$id/attachments/$photoId/download-url',
    parse: (data) => jsonText(jsonMap(data)['url']),
  );
}
