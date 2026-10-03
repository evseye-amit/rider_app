import 'package:equatable/equatable.dart';

enum ExchangeStage {
  requested,
  inReview,
  offerReady,
  accepted,
  awaitingHandover,
  completed,
  closed;

  bool get isOpen => this != ExchangeStage.completed && this != ExchangeStage.closed;

  bool get needsRider => this == ExchangeStage.offerReady;
}

class ExchangeOffer extends Equatable {
  const ExchangeOffer({
    required this.id,
    required this.hash,
    required this.termsTitle,
    required this.termsBody,
    required this.termsVersion,
    required this.expiresAt,
    required this.isPresented,
    this.rentDifference,
    this.depositDifference,
  });

  final String id;
  final String hash;
  final String termsTitle;
  final String termsBody;
  final String termsVersion;
  final DateTime expiresAt;
  final bool isPresented;
  final num? rentDifference;
  final num? depositDifference;

  bool get hasExpired => DateTime.now().isAfter(expiresAt);

  bool get isActionable => isPresented && !hasExpired;

  @override
  List<Object?> get props => [id, hash, termsTitle, termsVersion, expiresAt, isPresented];
}

class ExchangeRequest extends Equatable {
  const ExchangeRequest({
    required this.id,
    required this.agreementId,
    required this.stage,
    required this.statusCode,
    required this.reasonCode,
    required this.createdAt,
    this.reason,
    this.effectiveAt,
    this.reservationExpiresAt,
    this.completedAt,
    this.canCancel = false,
    this.offers = const [],
  });

  final String id;
  final String agreementId;
  final ExchangeStage stage;
  final String statusCode;
  final String reasonCode;
  final DateTime createdAt;
  final String? reason;
  final DateTime? effectiveAt;
  final DateTime? reservationExpiresAt;
  final DateTime? completedAt;
  final bool canCancel;
  final List<ExchangeOffer> offers;

  ExchangeOffer? get pendingOffer => offers.where((offer) => offer.isActionable).firstOrNull;

  @override
  List<Object?> get props => [id, agreementId, stage, statusCode, reasonCode, createdAt, completedAt, offers];
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
