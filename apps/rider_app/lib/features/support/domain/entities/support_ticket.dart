import 'package:equatable/equatable.dart';

enum TicketStatus { open, inProgress, resolved }

class SupportTicket extends Equatable {
  const SupportTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.lastActivityAt,
    required this.createdAt,
  });

  final String id;
  final String subject;
  final TicketStatus status;
  final DateTime lastActivityAt;
  final DateTime createdAt;

  bool get isActive => status != TicketStatus.resolved;

  @override
  List<Object?> get props => [id, subject, status, lastActivityAt, createdAt];
}

class TicketMessage extends Equatable {
  const TicketMessage({required this.id, required this.body, required this.at, required this.fromRider});

  final String id;
  final String body;
  final DateTime at;
  final bool fromRider;

  @override
  List<Object?> get props => [id, body, at, fromRider];
}

class TicketAttachment extends Equatable {
  const TicketAttachment({required this.id, required this.at, required this.fromRider, required this.isPdf});

  final String id;
  final DateTime at;
  final bool fromRider;
  final bool isPdf;

  @override
  List<Object?> get props => [id, at, fromRider, isPdf];
}

class TicketThread extends Equatable {
  const TicketThread({required this.ticket, required this.messages, required this.attachments});

  final SupportTicket ticket;
  final List<TicketMessage> messages;
  final List<TicketAttachment> attachments;

  @override
  List<Object?> get props => [ticket, messages, attachments];
}

class TicketPage extends Equatable {
  const TicketPage({required this.tickets, this.nextCursor});

  final List<SupportTicket> tickets;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [tickets, nextCursor];
}

class RaisedTicket extends Equatable {
  const RaisedTicket({required this.ticket, required this.failedPhotos});

  final SupportTicket ticket;
  final int failedPhotos;

  @override
  List<Object?> get props => [ticket, failedPhotos];
}
