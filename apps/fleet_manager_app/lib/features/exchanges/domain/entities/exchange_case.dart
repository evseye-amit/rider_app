import 'package:equatable/equatable.dart';

enum CaseStatus {
  requested,
  approved,
  returnPending,
  replacementSelected,
  offerPresented,
  depositPending,
  handoverPending,
  completed,
  rejected,
  cancelled,
  expired;

  bool get isOpen => switch (this) {
    CaseStatus.completed || CaseStatus.rejected || CaseStatus.cancelled || CaseStatus.expired => false,
    _ => true,
  };
}

enum CaseStep {
  checkIn,
  finishCheckIn,
  chooseScooter,
  sendOffer,
  awaitRider,
  settleDeposits,
  startHandover,
  finishHandover,
  none,
}

enum CaseStage { returnScooter, offer, deposit, handover, done }

class ScooterOption extends Equatable {
  const ScooterOption({required this.id, required this.number, this.model, this.code, this.hubId, this.hubName});

  final String id;
  final String number;
  final String? model;
  final String? code;
  final String? hubId;
  final String? hubName;

  String get label => [number, ?model].join(' · ');

  @override
  List<Object?> get props => [id, number, model, code, hubId, hubName];
}

class CaseQuote extends Equatable {
  const CaseQuote({
    required this.newRent,
    required this.rentAdjustment,
    required this.depositMoved,
    required this.depositToPay,
    required this.depositExcess,
    required this.refundsExcess,
    required this.fee,
    required this.feeWaived,
    this.period,
    this.scooterName,
    this.newRentFrom,
  });

  final num newRent;
  final num rentAdjustment;
  final num depositMoved;
  final num depositToPay;
  final num depositExcess;
  final bool refundsExcess;
  final num fee;
  final bool feeWaived;
  final String? period;
  final String? scooterName;
  final DateTime? newRentFrom;

  @override
  List<Object?> get props => [
    newRent,
    rentAdjustment,
    depositMoved,
    depositToPay,
    depositExcess,
    refundsExcess,
    fee,
    feeWaived,
    period,
    scooterName,
    newRentFrom,
  ];
}

class CaseOffer extends Equatable {
  const CaseOffer({required this.id, required this.expiresAt, required this.quote, this.hash = ''});

  final String id;
  final DateTime expiresAt;
  final CaseQuote quote;
  final String hash;

  bool get hasExpired => !expiresAt.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id, expiresAt, quote, hash];
}

class DepositOutcome extends Equatable {
  const DepositOutcome({required this.due, required this.securityShortfall});

  final num due;
  final num securityShortfall;

  bool get settled => due <= 0;

  num get newDeposit => due - securityShortfall;

  @override
  List<Object?> get props => [due, securityShortfall];
}

class ExchangeCase extends Equatable {
  const ExchangeCase({
    required this.id,
    required this.status,
    required this.reasonCode,
    required this.createdAt,
    required this.riderName,
    this.riderMobile,
    this.reason,
    this.agreementNumber,
    this.oldScooter,
    this.replacementScooter,
    this.oldAllocationId,
    this.newAllocationId,
    this.oldScooterReturned = false,
    this.checkInId,
    this.plannedHubId,
    this.plannedDate,
    this.reservedUntil,
    this.rentalPeriodType,
    this.durationValue,
    this.durationUnit,
    this.batteryPlanId,
    this.pendingOffer,
    this.acceptedOffer,
    this.completedAt,
    this.canCancel = false,
  });

  final String id;
  final CaseStatus status;
  final String reasonCode;
  final DateTime createdAt;
  final String riderName;
  final String? riderMobile;
  final String? reason;
  final String? agreementNumber;
  final ScooterOption? oldScooter;
  final ScooterOption? replacementScooter;
  final String? oldAllocationId;
  final String? newAllocationId;
  final bool oldScooterReturned;
  final String? checkInId;
  final String? plannedHubId;
  final DateTime? plannedDate;
  final DateTime? reservedUntil;
  final String? rentalPeriodType;
  final int? durationValue;
  final String? durationUnit;
  final String? batteryPlanId;
  final CaseOffer? pendingOffer;
  final CaseOffer? acceptedOffer;
  final DateTime? completedAt;
  final bool canCancel;

  CaseStep get nextStep => switch (status) {
    CaseStatus.requested => CaseStep.checkIn,
    CaseStatus.approved => oldScooterReturned ? CaseStep.chooseScooter : CaseStep.checkIn,
    CaseStatus.returnPending => checkInId != null ? CaseStep.finishCheckIn : CaseStep.checkIn,
    CaseStatus.replacementSelected => CaseStep.sendOffer,
    CaseStatus.offerPresented => CaseStep.awaitRider,
    CaseStatus.depositPending => CaseStep.settleDeposits,
    CaseStatus.handoverPending => newAllocationId == null ? CaseStep.startHandover : CaseStep.finishHandover,
    _ => CaseStep.none,
  };

  CaseStage? get stage => switch (status) {
    CaseStatus.completed => CaseStage.done,
    CaseStatus.rejected || CaseStatus.cancelled || CaseStatus.expired => null,
    _ => switch (nextStep) {
      CaseStep.checkIn || CaseStep.finishCheckIn => CaseStage.returnScooter,
      CaseStep.chooseScooter || CaseStep.sendOffer || CaseStep.awaitRider => CaseStage.offer,
      CaseStep.settleDeposits => CaseStage.deposit,
      CaseStep.startHandover || CaseStep.finishHandover => CaseStage.handover,
      CaseStep.none => null,
    },
  };

  bool get needsStaff => status.isOpen && (nextStep != CaseStep.awaitRider || holdLapsed);

  bool get holdLapsed => switch (nextStep) {
    CaseStep.sendOffer => reservedUntil?.isBefore(DateTime.now()) ?? false,
    CaseStep.awaitRider => pendingOffer?.hasExpired ?? true,
    _ => false,
  };

  @override
  List<Object?> get props => [
    id,
    status,
    reasonCode,
    createdAt,
    riderName,
    riderMobile,
    reason,
    agreementNumber,
    oldScooter,
    replacementScooter,
    oldAllocationId,
    newAllocationId,
    oldScooterReturned,
    checkInId,
    plannedHubId,
    plannedDate,
    reservedUntil,
    rentalPeriodType,
    durationValue,
    durationUnit,
    batteryPlanId,
    pendingOffer,
    acceptedOffer,
    completedAt,
    canCancel,
  ];
}
