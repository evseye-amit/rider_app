import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/support_ticket.dart';
import '../domain/support_repository.dart';

class SupportRepositoryImpl implements SupportRepository {
  const SupportRepositoryImpl(this._api);

  final SupportApi _api;

  @override
  Future<Result<TicketPage>> tickets({String? cursor}) async => (await _api.list(cursor: cursor)).map(
    (page) =>
        TicketPage(tickets: [for (final SupportTicketDto dto in page.items) _ticket(dto)], nextCursor: page.nextCursor),
  );

  @override
  Future<Result<TicketThread>> ticket(String id) async => (await _api.detail(id)).map((detail) {
    final String riderId = detail.ticket.createdById;
    return TicketThread(
      ticket: _ticket(detail.ticket),
      messages: [
        for (final SupportReplyDto reply in detail.replies)
          TicketMessage(id: reply.id, body: reply.body, at: reply.createdAt, fromRider: reply.authorId == riderId),
      ],
      attachments: [
        for (final SupportAttachmentDto photo in detail.attachments)
          TicketAttachment(
            id: photo.id,
            at: photo.uploadedAt,
            fromRider: photo.uploadedById == riderId,
            isPdf: photo.isPdf,
          ),
      ],
    );
  });

  @override
  Future<Result<RaisedTicket>> raise({
    required String subject,
    required String message,
    required List<File> photos,
  }) async {
    final Result<SupportTicketDto> created = await _api.create(subject: subject, message: message);
    if (created case Err<SupportTicketDto>(:final failure)) return Result.err(failure);
    final SupportTicketDto ticket = (created as Ok<SupportTicketDto>).value;
    int failed = 0;
    for (final File photo in photos) {
      if (await _api.attach(ticket.id, photo, mimeType: _mimeOf(photo)) is Err) failed++;
    }
    return Result.ok(RaisedTicket(ticket: _ticket(ticket), failedPhotos: failed));
  }

  @override
  Future<Result<TicketStatus>> reply(String id, String message) async => (await _api.reply(id, message)).map(_status);

  @override
  Future<Result<void>> attach(String id, File photo) async =>
      (await _api.attach(id, photo, mimeType: _mimeOf(photo))).map((_) {});

  @override
  Future<Result<String>> attachmentUrl(String id, String attachmentId) => _api.attachmentUrl(id, attachmentId);

  static SupportTicket _ticket(SupportTicketDto dto) => SupportTicket(
    id: dto.id,
    subject: dto.subject,
    status: _status(dto.status),
    lastActivityAt: dto.lastActivityAt,
    createdAt: dto.createdAt,
  );

  static TicketStatus _status(SupportTicketStatus status) => switch (status) {
    SupportTicketStatus.open => TicketStatus.open,
    SupportTicketStatus.inProgress => TicketStatus.inProgress,
    SupportTicketStatus.resolved => TicketStatus.resolved,
  };

  static String _mimeOf(File file) {
    final String name = file.path.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
