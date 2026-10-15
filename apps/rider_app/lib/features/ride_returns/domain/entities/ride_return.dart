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

  bool get canCancel => status == ReturnStatus.requested && receivedAt == null;

  bool get isOpen =>
      status == ReturnStatus.requested || (status == ReturnStatus.returned && charges?.stage != ChargesStage.settled);

  bool get needsYou => charges?.canRespond ?? false;

  @override
  List<Object?> get props => [id, status, reasonCode, plannedDate, createdAt, notes, receivedAt, cancelledAt, charges];
}

class ReturnPage extends Equatable {
  const ReturnPage({required this.returns, this.nextCursor});

  final List<RideReturn> returns;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [returns, nextCursor];
}

class ReturnablePlan extends Equatable {
  const ReturnablePlan({required this.agreementId, required this.number, this.scooterName});

  final String agreementId;
  final String number;
  final String? scooterName;

  @override
  List<Object?> get props => [agreementId, number, scooterName];
}

class ReturnHub extends Equatable {
  const ReturnHub({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceMeters,
    this.etaMinutes,
  });

  final String id;
  final String name;
  final String address;
  final num distanceMeters;
  final int? etaMinutes;

  @override
  List<Object?> get props => [id, name, address, distanceMeters, etaMinutes];
}

class ApprovalCode extends Equatable {
  const ApprovalCode({required this.requestId, required this.expiresAt});

  final String requestId;
  final DateTime expiresAt;

  @override
  List<Object?> get props => [requestId, expiresAt];
}
