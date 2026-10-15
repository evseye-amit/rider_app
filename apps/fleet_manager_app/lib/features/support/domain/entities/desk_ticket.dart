import 'package:equatable/equatable.dart';

enum TicketStatus { open, inProgress, resolved }

class DeskTicket extends Equatable {
  const DeskTicket({
    required this.id,
    required this.subject,
    required this.status,
    required this.riderId,
    required this.riderName,
    required this.lastActivityAt,
    required this.createdAt,
    this.riderMobile,
    this.hubId,
    this.resolvedAt,
  });

  final String id;
  final String subject;
  final TicketStatus status;
  final String riderId;
  final String riderName;
  final String? riderMobile;
  final String? hubId;
  final DateTime lastActivityAt;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  @override
  List<Object?> get props => [
    id,
    subject,
    status,
    riderId,
    riderName,
    riderMobile,
    hubId,
    lastActivityAt,
    createdAt,
    resolvedAt,
  ];
}

class DeskMessage extends Equatable {
  const DeskMessage({required this.id, required this.body, required this.at, required this.fromRider});

  final String id;
  final String body;
  final DateTime at;
  final bool fromRider;

  @override
  List<Object?> get props => [id, body, at, fromRider];
}

class DeskAttachment extends Equatable {
  const DeskAttachment({required this.id, required this.at, required this.fromRider, required this.isPdf});

  final String id;
  final DateTime at;
  final bool fromRider;
  final bool isPdf;

  @override
  List<Object?> get props => [id, at, fromRider, isPdf];
}

class DeskThread extends Equatable {
  const DeskThread({required this.ticket, required this.messages, required this.attachments, this.vehicleNumber});

  final DeskTicket ticket;
  final List<DeskMessage> messages;
  final List<DeskAttachment> attachments;
  final String? vehicleNumber;

  @override
  List<Object?> get props => [ticket, messages, attachments, vehicleNumber];
}

class DeskPage extends Equatable {
  const DeskPage({required this.tickets, this.nextCursor});

  final List<DeskTicket> tickets;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [tickets, nextCursor];
}
