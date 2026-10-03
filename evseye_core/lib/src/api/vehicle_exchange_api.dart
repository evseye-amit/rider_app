import '../utils/result.dart';
import 'api_client.dart';

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

String _text(Object? value) => value?.toString() ?? '';

enum VehicleExchangeStatus {
  requested('REQUESTED'),
  approved('APPROVED'),
  replacementSelected('REPLACEMENT_SELECTED'),
  offerPresented('OFFER_PRESENTED'),
  accepted('ACCEPTED'),
  returnPending('RETURN_PENDING'),
  depositPending('DEPOSIT_PENDING'),
  handoverPending('HANDOVER_PENDING'),
  completed('COMPLETED'),
  rejected('REJECTED'),
  cancelled('CANCELLED'),
  expired('EXPIRED');

  const VehicleExchangeStatus(this.wire);

  final String wire;

  static VehicleExchangeStatus parse(Object? value) => VehicleExchangeStatus.values.firstWhere(
    (status) => status.wire == value?.toString(),
    orElse: () => VehicleExchangeStatus.requested,
  );

  bool get isOpen => switch (this) {
    VehicleExchangeStatus.completed ||
    VehicleExchangeStatus.rejected ||
    VehicleExchangeStatus.cancelled ||
    VehicleExchangeStatus.expired => false,
    _ => true,
  };

  bool get awaitsRider => this == VehicleExchangeStatus.offerPresented;

  bool get canCancel => switch (this) {
    VehicleExchangeStatus.requested ||
    VehicleExchangeStatus.approved ||
    VehicleExchangeStatus.replacementSelected ||
    VehicleExchangeStatus.offerPresented => true,
    _ => false,
  };
}

enum VehicleExchangeOfferStatus {
  presented('PRESENTED'),
  accepted('ACCEPTED'),
  rejected('REJECTED'),
  expired('EXPIRED'),
  cancelled('CANCELLED'),
  superseded('SUPERSEDED');

  const VehicleExchangeOfferStatus(this.wire);

  final String wire;

  static VehicleExchangeOfferStatus parse(Object? value) => VehicleExchangeOfferStatus.values.firstWhere(
    (status) => status.wire == value?.toString(),
    orElse: () => VehicleExchangeOfferStatus.presented,
  );
}

class VehicleExchangeOffer {
  const VehicleExchangeOffer({
    required this.id,
    required this.status,
    required this.offerHash,
    required this.termsTitle,
    required this.termsSnapshot,
    required this.termsVersion,
    required this.expiresAt,
    this.commercialDifference = const {},
    this.pricingSnapshot = const {},
    this.acceptedAt,
  });

  factory VehicleExchangeOffer.fromJson(Map<String, dynamic> json) => VehicleExchangeOffer(
    id: _text(json['id']),
    status: VehicleExchangeOfferStatus.parse(json['status']),
    offerHash: _text(json['offerHash']),
    termsTitle: _text(json['termsTitle']),
    termsSnapshot: _text(json['termsSnapshot']),
    termsVersion: _text(json['termsVersion']),
    expiresAt: _date(json['expiresAt']) ?? DateTime.now(),
    commercialDifference: json['commercialDifference'] is Map
        ? Map<String, dynamic>.from(json['commercialDifference'] as Map)
        : const {},
    pricingSnapshot: json['pricingSnapshot'] is Map
        ? Map<String, dynamic>.from(json['pricingSnapshot'] as Map)
        : const {},
    acceptedAt: _date(json['acceptedAt']),
  );

  final String id;
  final VehicleExchangeOfferStatus status;
  final String offerHash;
  final String termsTitle;
  final String termsSnapshot;
  final String termsVersion;
  final DateTime expiresAt;
  final Map<String, dynamic> commercialDifference;
  final Map<String, dynamic> pricingSnapshot;
  final DateTime? acceptedAt;

  bool get isPresented => status == VehicleExchangeOfferStatus.presented;

  bool get hasExpired => DateTime.now().isAfter(expiresAt);
}

class VehicleExchange {
  const VehicleExchange({
    required this.id,
    required this.agreementId,
    required this.status,
    required this.reasonCode,
    required this.createdAt,
    this.reason,
    this.oldVehicleId,
    this.replacementVehicleId,
    this.proposedEffectiveAt,
    this.effectiveAt,
    this.reservationExpiresAt,
    this.acceptedAt,
    this.completedAt,
    this.offers = const [],
  });

  factory VehicleExchange.fromJson(Map<String, dynamic> json) => VehicleExchange(
    id: _text(json['id']),
    agreementId: _text(json['agreementId']),
    status: VehicleExchangeStatus.parse(json['status']),
    reasonCode: _text(json['reasonCode']),
    createdAt: _date(json['createdAt']) ?? DateTime.now(),
    reason: json['reason']?.toString(),
    oldVehicleId: json['oldVehicleId']?.toString(),
    replacementVehicleId: json['replacementVehicleId']?.toString(),
    proposedEffectiveAt: _date(json['proposedEffectiveAt']),
    effectiveAt: _date(json['effectiveAt']),
    reservationExpiresAt: _date(json['reservationExpiresAt']),
    acceptedAt: _date(json['acceptedAt']),
    completedAt: _date(json['completedAt']),
    offers: (json['offers'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => VehicleExchangeOffer.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  final String id;
  final String agreementId;
  final VehicleExchangeStatus status;
  final String reasonCode;
  final DateTime createdAt;
  final String? reason;
  final String? oldVehicleId;
  final String? replacementVehicleId;
  final DateTime? proposedEffectiveAt;
  final DateTime? effectiveAt;
  final DateTime? reservationExpiresAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final List<VehicleExchangeOffer> offers;

  VehicleExchangeOffer? get pendingOffer => offers.where((offer) => offer.isPresented && !offer.hasExpired).firstOrNull;
}

class AgreementVersion {
  const AgreementVersion({required this.id, required this.versionNumber, required this.createdAt, this.reason});

  factory AgreementVersion.fromJson(Map<String, dynamic> json) => AgreementVersion(
    id: _text(json['id']),
    versionNumber: (json['versionNumber'] as num?)?.toInt() ?? 0,
    createdAt: _date(json['createdAt']) ?? DateTime.now(),
    reason: json['changeReason']?.toString() ?? json['reason']?.toString(),
  );

  final String id;
  final int versionNumber;
  final DateTime createdAt;
  final String? reason;
}

class VehicleExchangeApi {
  const VehicleExchangeApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/vehicle-exchanges';

  Future<Result<List<VehicleExchange>>> list() => _client.get<List<VehicleExchange>>(
    _base,
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => VehicleExchange.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  Future<Result<VehicleExchange>> details(String id) => _client.get<VehicleExchange>('$_base/$id', parse: _one);

  Future<Result<VehicleExchange>> request({required String agreementId, required String reasonCode, String? reason}) =>
      _client.post<VehicleExchange>(
        _base,
        body: {
          'agreementId': agreementId,
          'reasonCode': reasonCode,
          if (reason != null && reason.isNotEmpty) 'reason': reason,
        },
        parse: _one,
      );

  Future<Result<VehicleExchange>> accept({required String id, required String offerId, required String offerHash}) =>
      _client.post<VehicleExchange>(
        '$_base/$id/accept',
        body: {'offerId': offerId, 'offerHash': offerHash, 'consent': true},
        parse: _one,
      );

  Future<Result<VehicleExchange>> rejectOffer({required String id, required String offerId, required String reason}) =>
      _client.post<VehicleExchange>(
        '$_base/$id/reject-offer',
        body: {'offerId': offerId, 'reason': reason},
        parse: _one,
      );

  Future<Result<VehicleExchange>> cancel(String id) => _client.post<VehicleExchange>('$_base/$id/cancel', parse: _one);

  Future<Result<List<AgreementVersion>>> agreementVersions(String agreementId) => _client.get<List<AgreementVersion>>(
    '$_base/agreements/$agreementId/versions',
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => AgreementVersion.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  static VehicleExchange _one(dynamic data) => VehicleExchange.fromJson(Map<String, dynamic>.from(data as Map));
}
