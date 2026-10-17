import 'package:equatable/equatable.dart';

enum ReturnStatus { requested, returned, cancelled }

enum ChargesStage { reviewing, awaitingYou, awaitingManager, disputed, settled }

enum ChargeKind { damage, missingItem, other }

class ReturnCharge extends Equatable {
  const ReturnCharge({
    required this.description,
    required this.details,
    required this.kind,
    required this.evidenceCount,
    this.amount,
  });

  final String description;
  final String details;
  final ChargeKind kind;
  final int evidenceCount;
  final num? amount;

  @override
  List<Object?> get props => [description, details, kind, evidenceCount, amount];
}

class ReturnCharges extends Equatable {
  const ReturnCharges({
    required this.stage,
    required this.total,
    required this.items,
    required this.approvedByYou,
    required this.approvedByAdmin,
    this.submittedAt,
    this.approvedAt,
    this.disputeReason,
    this.disputedAt,
    this.postedAt,
  });

  final ChargesStage stage;
  final num total;
  final List<ReturnCharge> items;
  final bool approvedByYou;
  final bool approvedByAdmin;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final String? disputeReason;
  final DateTime? disputedAt;
  final DateTime? postedAt;

  bool get canRespond => stage == ChargesStage.awaitingYou;

  bool get canDispute => stage == ChargesStage.awaitingYou || stage == ChargesStage.awaitingManager;

  @override
  List<Object?> get props => [
    stage,
    total,
    items,
    approvedByYou,
    approvedByAdmin,
    submittedAt,
    approvedAt,
    disputeReason,
    disputedAt,
    postedAt,
  ];
}

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
    this.charges,
    this.usesCheckIn = true,
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
  final ReturnCharges? charges;
  final bool usesCheckIn;
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

  bool get isOpen => usesCheckIn
      ? status == ReturnStatus.requested || checkIn == CheckInStage.inProgress || checkIn == CheckInStage.finalChecks
      : status == ReturnStatus.requested || (status == ReturnStatus.returned && charges?.stage != ChargesStage.settled);

  bool get needsYou => !usesCheckIn && (charges?.canRespond ?? false);

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
    charges,
    usesCheckIn,
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

class ApprovalCode extends Equatable {
  const ApprovalCode({required this.requestId, required this.expiresAt});

  final String requestId;
  final DateTime expiresAt;

  @override
  List<Object?> get props => [requestId, expiresAt];
}
