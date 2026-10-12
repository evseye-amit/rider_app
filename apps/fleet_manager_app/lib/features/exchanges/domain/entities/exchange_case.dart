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
  review,
  startReturn,
  finishReturn,
  chooseScooter,
  sendOffer,
  awaitRider,
  settleDeposits,
  startHandover,
  finishHandover,
  none,
}

class ScooterOption extends Equatable {
  const ScooterOption({required this.id, required this.number, this.model, this.hubId});

  final String id;
  final String number;
  final String? model;
  final String? hubId;

  String get label => [number, ?model].join(' · ');

  @override
  List<Object?> get props => [id, number, model, hubId];
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
  const CaseOffer({required this.id, required this.expiresAt, required this.quote});

  final String id;
  final DateTime expiresAt;
  final CaseQuote quote;

  @override
  List<Object?> get props => [id, expiresAt, quote];
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
    this.reservedUntil,
    this.rentalPeriodType,
    this.durationValue,
    this.durationUnit,
    this.pendingOffer,
    this.acceptedOffer,
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
  final DateTime? reservedUntil;
  final String? rentalPeriodType;
  final int? durationValue;
  final String? durationUnit;
  final CaseOffer? pendingOffer;
  final CaseOffer? acceptedOffer;
  final bool canCancel;

  CaseStep get nextStep => switch (status) {
    CaseStatus.requested => CaseStep.review,
    CaseStatus.approved => oldScooterReturned ? CaseStep.chooseScooter : CaseStep.startReturn,
    CaseStatus.returnPending => CaseStep.finishReturn,
    CaseStatus.replacementSelected => CaseStep.sendOffer,
    CaseStatus.offerPresented => CaseStep.awaitRider,
    CaseStatus.depositPending => CaseStep.settleDeposits,
    CaseStatus.handoverPending => newAllocationId == null ? CaseStep.startHandover : CaseStep.finishHandover,
    _ => CaseStep.none,
  };

  bool get needsStaff => status.isOpen && nextStep != CaseStep.awaitRider;

  bool get canChooseScooter =>
      oldScooterReturned &&
      (status == CaseStatus.approved ||
          status == CaseStatus.replacementSelected ||
          status == CaseStatus.offerPresented);

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
    reservedUntil,
    rentalPeriodType,
    durationValue,
    durationUnit,
    pendingOffer,
    acceptedOffer,
    canCancel,
  ];
}
