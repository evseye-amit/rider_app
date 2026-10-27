import 'package:equatable/equatable.dart';

enum ReturnStatus { requested, returned, cancelled }

enum CheckInStage { none, inProgress, finalChecks, done }

class RideReturn extends Equatable {
  const RideReturn({
    required this.id,
    required this.status,
    required this.reasonCode,
    required this.plannedDate,
    required this.createdAt,
    this.notes,
    this.receivedAt,
    this.cancelledAt,
    this.checkInId,
    this.checkInConfirmed = false,
    this.checksComplete = false,
  });

  final String id;
  final ReturnStatus status;
  final String reasonCode;
  final DateTime plannedDate;
  final DateTime createdAt;
  final String? notes;
  final DateTime? receivedAt;
  final DateTime? cancelledAt;
  final String? checkInId;
  final bool checkInConfirmed;
  final bool checksComplete;

  CheckInStage get checkIn => checkInId == null
      ? CheckInStage.none
      : !checkInConfirmed
      ? CheckInStage.inProgress
      : checksComplete
      ? CheckInStage.done
      : CheckInStage.finalChecks;

  bool get canCancel => status == ReturnStatus.requested && receivedAt == null && checkInId == null;

  @override
  List<Object?> get props => [
    id,
    status,
    reasonCode,
    plannedDate,
    createdAt,
    notes,
    receivedAt,
    cancelledAt,
    checkInId,
    checkInConfirmed,
    checksComplete,
  ];
}

class ReturnPage extends Equatable {
  const ReturnPage({required this.returns, this.nextCursor});

  final List<RideReturn> returns;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [returns, nextCursor];
}
