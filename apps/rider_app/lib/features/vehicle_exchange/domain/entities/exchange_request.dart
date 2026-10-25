import 'package:equatable/equatable.dart';

enum ExchangeStatus {
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
    ExchangeStatus.completed || ExchangeStatus.rejected || ExchangeStatus.cancelled || ExchangeStatus.expired => false,
    _ => true,
  };
}

enum ExchangeStep { requested, approval, returnScooter, offer, deposit, handover }

enum RentPeriod {
  daily,
  weekly,
  fortnightly,
  monthly,
  quarterly,
  custom;

  static RentPeriod? parse(String? value) => switch (value) {
    'DAILY' => RentPeriod.daily,
    'WEEKLY' => RentPeriod.weekly,
    'FORTNIGHTLY' => RentPeriod.fortnightly,
    'MONTHLY' => RentPeriod.monthly,
    'QUARTERLY' => RentPeriod.quarterly,
    'CUSTOM' => RentPeriod.custom,
    _ => null,
  };
}

enum ExchangeReason {
  breakdown('VEHICLE_BREAKDOWN'),
  unsafe('VEHICLE_UNSAFE'),
  safety('SAFETY_EXCHANGE'),
  upgrade('UPGRADE'),
  other('OTHER');

  const ExchangeReason(this.code);

  final String code;
}

class ExchangeQuote extends Equatable {
  const ExchangeQuote({
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
    this.hubName,
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
  final RentPeriod? period;
  final String? scooterName;
  final String? hubName;
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
    hubName,
    newRentFrom,
  ];
}

class ExchangeOffer extends Equatable {
  const ExchangeOffer({
    required this.id,
    required this.hash,
    required this.expiresAt,
    required this.isPresented,
    required this.isAccepted,
    required this.quote,
  });

  final String id;
  final String hash;
  final DateTime expiresAt;
  final bool isPresented;
  final bool isAccepted;
  final ExchangeQuote quote;

  bool get hasExpired => DateTime.now().isAfter(expiresAt);

  bool get isActionable => isPresented && !hasExpired;

  @override
  List<Object?> get props => [id, hash, expiresAt, isPresented, isAccepted, quote];
}

class ExchangeRequest extends Equatable {
  const ExchangeRequest({
    required this.id,
    required this.agreementId,
    required this.status,
    required this.reasonCode,
    required this.createdAt,
    this.reason,
    this.oldScooterReturned = false,
    this.completedAt,
    this.canCancel = false,
    this.offers = const [],
    this.plannedDate,
    this.usesCheckIn = true,
    this.checkInId,
  });

  final String id;
  final String agreementId;
  final ExchangeStatus status;
  final String reasonCode;
  final DateTime createdAt;
  final String? reason;
  final bool oldScooterReturned;
  final DateTime? completedAt;
  final bool canCancel;
  final List<ExchangeOffer> offers;
  final DateTime? plannedDate;
  final bool usesCheckIn;
  final String? checkInId;

  List<ExchangeStep> get steps => usesCheckIn
      ? [
          for (final ExchangeStep step in ExchangeStep.values)
            if (step != ExchangeStep.approval) step,
        ]
      : ExchangeStep.values;

  bool get isCheckingIn => usesCheckIn && checkInId != null && !oldScooterReturned;

  ExchangeOffer? get pendingOffer => offers.where((offer) => offer.isActionable).firstOrNull;

  ExchangeOffer? get acceptedOffer => offers.where((offer) => offer.isAccepted).firstOrNull;

  bool get needsRider => status == ExchangeStatus.offerPresented;

  bool isStepDone(ExchangeStep step) {
    final bool handedOver = status == ExchangeStatus.completed;
    final bool depositSettled = handedOver || status == ExchangeStatus.handoverPending;
    final bool offerAccepted = depositSettled || status == ExchangeStatus.depositPending || acceptedOffer != null;
    final bool returned = oldScooterReturned || handedOver;
    return switch (step) {
      ExchangeStep.requested => true,
      ExchangeStep.approval =>
        returned ||
            offerAccepted ||
            switch (status) {
              ExchangeStatus.approved ||
              ExchangeStatus.returnPending ||
              ExchangeStatus.replacementSelected ||
              ExchangeStatus.offerPresented => true,
              _ => false,
            },
      ExchangeStep.returnScooter => returned,
      ExchangeStep.offer => offerAccepted,
      ExchangeStep.deposit => depositSettled,
      ExchangeStep.handover => handedOver,
    };
  }

  ExchangeStep? get currentStep => steps.where((step) => !isStepDone(step)).firstOrNull;

  @override
  List<Object?> get props => [
    id,
    agreementId,
    status,
    reasonCode,
    createdAt,
    reason,
    oldScooterReturned,
    completedAt,
    canCancel,
    offers,
    plannedDate,
    usesCheckIn,
    checkInId,
  ];
}
