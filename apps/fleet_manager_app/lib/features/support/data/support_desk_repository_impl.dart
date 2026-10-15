import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/desk_ticket.dart';
import '../domain/support_desk_repository.dart';

typedef _RiderCard = ({String name, String? mobile, String? vehicle});

class SupportDeskRepositoryImpl implements SupportDeskRepository {
  SupportDeskRepositoryImpl(this._support, this._api);

  final SupportApi _support;
  final ApiClient _api;
  final Map<String, _RiderCard> _riders = {};

  static const int _bulkLookupAfter = 5;
  static const int _pageSize = 100;

  @override
  Future<Result<DeskPage>> tickets({String? cursor, TicketStatus? status}) async {
    final Result<SupportTicketPage> page = await _support.list(
      cursor: cursor,
      status: status == null ? null : _wire(status),
    );
    if (page case Err<SupportTicketPage>(:final failure)) return Result.err(failure);
    final SupportTicketPage value = (page as Ok<SupportTicketPage>).value;
    await _lookUp({for (final SupportTicketDto ticket in value.items) ticket.riderId});
    return Result.ok(
      DeskPage(
        tickets: [for (final SupportTicketDto ticket in value.items) _ticket(ticket, _riders[ticket.riderId])],
        nextCursor: value.nextCursor,
      ),
    );
  }

  @override
  Future<Result<DeskThread>> ticket(String id) async {
    final Result<SupportTicketDetailDto> detail = await _support.detail(id);
    if (detail case Err<SupportTicketDetailDto>(:final failure)) return Result.err(failure);
    final SupportTicketDetailDto value = (detail as Ok<SupportTicketDetailDto>).value;
    final _RiderCard? rider = (await _rider(value.ticket.riderId)).valueOrNull ?? _riders[value.ticket.riderId];
    final String riderUserId = value.ticket.createdById;
    return Result.ok(
      DeskThread(
        ticket: _ticket(value.ticket, rider),
        vehicleNumber: rider?.vehicle,
        messages: [
          for (final SupportReplyDto reply in value.replies)
            DeskMessage(id: reply.id, body: reply.body, at: reply.createdAt, fromRider: reply.authorId == riderUserId),
        ],
        attachments: [
          for (final SupportAttachmentDto photo in value.attachments)
            DeskAttachment(
              id: photo.id,
              at: photo.uploadedAt,
              fromRider: photo.uploadedById == riderUserId,
              isPdf: photo.isPdf,
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<void>> reply(String id, String message) async => (await _support.reply(id, message)).map((_) {});

  @override
  Future<Result<void>> setStatus(String id, TicketStatus status) async =>
      (await _support.setStatus(id, _wire(status))).map((_) {});

  @override
  Future<Result<void>> attach(String id, File photo) async =>
      (await _support.attach(id, photo, mimeType: _mimeOf(photo))).map((_) {});

  @override
  Future<Result<String>> attachmentUrl(String id, String attachmentId) => _support.attachmentUrl(id, attachmentId);

  Future<void> _lookUp(Set<String> riderIds) async {
    final Set<String> missing = {
      for (final String id in riderIds)
        if (id.isNotEmpty && !_riders.containsKey(id)) id,
    };
    if (missing.isEmpty) return;
    if (missing.length > _bulkLookupAfter) {
      final Result<List<Map<String, dynamic>>> all = await _api.get<List<Map<String, dynamic>>>(
        '/riders',
        query: {'pageSize': _pageSize},
        parse: _rows,
      );
      for (final Map<String, dynamic> row in all.valueOrNull ?? const <Map<String, dynamic>>[]) {
        final String id = row['id']?.toString() ?? '';
        if (id.isNotEmpty) _riders[id] = _card(row);
      }
    }
    await Future.wait([
      for (final String id in missing)
        if (!_riders.containsKey(id)) _rider(id),
    ]);
  }

  Future<Result<_RiderCard>> _rider(String id) async {
    final Result<_RiderCard> result = await _api.get<_RiderCard>(
      '/riders/$id',
      parse: (data) => _card(Map<String, dynamic>.from(data as Map)),
    );
    if (result case Ok<_RiderCard>(:final value)) _riders[id] = value;
    return result;
  }

  static _RiderCard _card(Map<String, dynamic> row) {
    String? vehicle;
    for (final Object? allocation in row['allocations'] as List<dynamic>? ?? const []) {
      if (allocation is! Map) continue;
      final String? number = (allocation['fleet'] as Map?)?['vehicleNumber']?.toString();
      if (number == null || number.isEmpty) continue;
      vehicle = number;
      if (allocation['status'] == 'ACTIVE') break;
    }
    final String mobile = row['mobile']?.toString() ?? '';
    return (name: row['name']?.toString() ?? '—', mobile: mobile.isEmpty ? null : mobile, vehicle: vehicle);
  }

  static List<Map<String, dynamic>> _rows(dynamic data) => [
    for (final Object? row in data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>)
      if (row is Map) Map<String, dynamic>.from(row),
  ];

  static DeskTicket _ticket(SupportTicketDto dto, _RiderCard? rider) => DeskTicket(
    id: dto.id,
    subject: dto.subject,
    status: _status(dto.status),
    riderId: dto.riderId,
    riderName: rider?.name ?? '—',
    riderMobile: rider?.mobile,
    hubId: dto.hubId,
    lastActivityAt: dto.lastActivityAt,
    createdAt: dto.createdAt,
    resolvedAt: dto.resolvedAt,
  );

  static TicketStatus _status(SupportTicketStatus status) => switch (status) {
    SupportTicketStatus.open => TicketStatus.open,
    SupportTicketStatus.inProgress => TicketStatus.inProgress,
    SupportTicketStatus.resolved => TicketStatus.resolved,
  };

  static SupportTicketStatus _wire(TicketStatus status) => switch (status) {
    TicketStatus.open => SupportTicketStatus.open,
    TicketStatus.inProgress => SupportTicketStatus.inProgress,
    TicketStatus.resolved => SupportTicketStatus.resolved,
  };

  static String _mimeOf(File file) {
    final String name = file.path.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
