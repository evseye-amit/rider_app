import 'package:equatable/equatable.dart';

enum ReturnState { requested, returned, cancelled }

enum PenaltyStage { draft, awaitingRider, awaitingManager, disputed, posted }

enum PenaltyKind { damage, missingItem }

class PenaltyLine extends Equatable {
  const PenaltyLine({
    required this.priceId,
    required this.details,
    required this.evidencePhotoIds,
    this.description,
    this.kind,
    this.amount,
  });

  final String priceId;
  final String details;
  final List<String> evidencePhotoIds;
  final String? description;
  final PenaltyKind? kind;
  final num? amount;

  PenaltyLine priced(PenaltyPrice? price) => price == null
      ? this
      : PenaltyLine(
          priceId: priceId,
          details: details,
          evidencePhotoIds: evidencePhotoIds,
          description: description ?? price.description,
          kind: kind ?? price.kind,
          amount: amount ?? price.amount,
        );

  @override
  List<Object?> get props => [priceId, details, evidencePhotoIds, description, kind, amount];
}

class PenaltyState extends Equatable {
  const PenaltyState({
    required this.stage,
    required this.total,
    required this.lines,
    required this.riderApproved,
    required this.adminOverridden,
    required this.managerApproved,
    this.disputeReason,
    this.overrideReason,
    this.submittedAt,
    this.postedAt,
  });

  final PenaltyStage stage;
  final num total;
  final List<PenaltyLine> lines;
  final bool riderApproved;
  final bool adminOverridden;
  final bool managerApproved;
  final String? disputeReason;
  final String? overrideReason;
  final DateTime? submittedAt;
  final DateTime? postedAt;

  bool get editable => stage == PenaltyStage.draft || stage == PenaltyStage.disputed;

  @override
  List<Object?> get props => [
    stage,
    total,
    lines,
    riderApproved,
    adminOverridden,
    managerApproved,
    disputeReason,
    overrideReason,
    submittedAt,
    postedAt,
  ];
}

class ReturnCase extends Equatable {
  const ReturnCase({
    required this.id,
    required this.state,
    required this.riderName,
    required this.reasonCode,
    required this.plannedDate,
    required this.createdAt,
    this.riderMobile,
    this.notes,
    this.plannedHubId,
    this.receivedHubId,
    this.receivedAt,
    this.vehicleNumber,
    this.vehicleModel,
    this.inspectionId,
    this.inspectionDone = false,
    this.safeForReuse,
    this.penalty,
  });

  final String id;
  final ReturnState state;
  final String riderName;
  final String? riderMobile;
  final String reasonCode;
  final String? notes;
  final DateTime plannedDate;
  final DateTime createdAt;
  final String? plannedHubId;
  final String? receivedHubId;
  final DateTime? receivedAt;
  final String? vehicleNumber;
  final String? vehicleModel;
  final String? inspectionId;
  final bool inspectionDone;
  final bool? safeForReuse;
  final PenaltyState? penalty;

  bool get awaitingScooter => state == ReturnState.requested;

  bool get needsInspection => state == ReturnState.returned && !inspectionDone;

  bool get chargesEditable => state == ReturnState.returned && inspectionDone && (penalty == null || penalty!.editable);

  bool get closed => state == ReturnState.cancelled || penalty?.stage == PenaltyStage.posted;

  @override
  List<Object?> get props => [
    id,
    state,
    riderName,
    riderMobile,
    reasonCode,
    notes,
    plannedDate,
    createdAt,
    plannedHubId,
    receivedHubId,
    receivedAt,
    vehicleNumber,
    vehicleModel,
    inspectionId,
    inspectionDone,
    safeForReuse,
    penalty,
  ];
}

class ReturnCasePage extends Equatable {
  const ReturnCasePage({required this.items, this.nextCursor});

  final List<ReturnCase> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [items, nextCursor];
}

class PenaltyPrice extends Equatable {
  const PenaltyPrice({
    required this.id,
    required this.code,
    required this.description,
    required this.amount,
    required this.kind,
  });

  final String id;
  final String code;
  final String description;
  final num amount;
  final PenaltyKind kind;

  @override
  List<Object?> get props => [id, code, description, amount, kind];
}

class InspectionSlot extends Equatable {
  const InspectionSlot({required this.photoType, required this.label, required this.required});

  final String photoType;
  final String label;
  final bool required;

  @override
  List<Object?> get props => [photoType, label, required];
}

class InspectionPhoto extends Equatable {
  const InspectionPhoto({required this.id, required this.photoType});

  final String id;
  final String photoType;

  @override
  List<Object?> get props => [id, photoType];
}

class InspectionSheet extends Equatable {
  const InspectionSheet({required this.slots, required this.photos});

  final List<InspectionSlot> slots;
  final List<InspectionPhoto> photos;

  @override
  List<Object?> get props => [slots, photos];
}
