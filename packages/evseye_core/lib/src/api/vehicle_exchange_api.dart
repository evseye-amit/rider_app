import '../utils/result.dart';
import 'api_client.dart';

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

String _text(Object? value) => value?.toString() ?? '';

String? _textOrNull(Object? value) {
  final String text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

num _num(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

List<VehicleExchange> _many(dynamic data) => (data as List<dynamic>? ?? const [])
    .whereType<Map>()
    .map((e) => VehicleExchange.fromJson(Map<String, dynamic>.from(e)))
    .toList(growable: false);

VehicleExchange _one(dynamic data) => VehicleExchange.fromJson(_map(data));

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
    orElse: () => VehicleExchangeOfferStatus.cancelled,
  );
}

class ExchangeQuoteDto {
  const ExchangeQuoteDto({
    required this.currency,
    required this.recurringAmount,
    required this.rentAdjustment,
    required this.depositTransfer,
    required this.depositAdditional,
    required this.depositExcess,
    required this.exchangeFee,
    required this.feeWaived,
    this.vehicleModel,
    this.vehicleVariant,
    this.hubName,
    this.rentalPeriod,
    this.billingStartAt,
    this.excessPolicy,
  });

  factory ExchangeQuoteDto.fromParts(Map<String, dynamic> pricing, Map<String, dynamic> difference) {
    final Map<String, dynamic> vehicle = _map(pricing['vehicle']);
    final Map<String, dynamic> rental = _map(pricing['rental']);
    final Map<String, dynamic> proration = _map(difference['proration']);
    final Map<String, dynamic> deposit = _map(difference['deposit']);
    return ExchangeQuoteDto(
      currency: _textOrNull(pricing['currency']) ?? 'INR',
      recurringAmount: _num(_map(pricing['totals'])['recurringAmount']),
      rentAdjustment: _num(proration['net']),
      depositTransfer: _num(deposit['transfer']),
      depositAdditional: _num(deposit['additionalRequired']),
      depositExcess: _num(deposit['excess']),
      exchangeFee: _num(difference['exchangeFee']),
      feeWaived: difference['feeWaived'] == true,
      vehicleModel: _textOrNull(vehicle['modelName']),
      vehicleVariant: _textOrNull(vehicle['variantName']),
      hubName: _textOrNull(_map(pricing['hub'])['name']),
      rentalPeriod: _textOrNull(rental['period']),
      billingStartAt: _date(difference['billingStartAt']),
      excessPolicy: _textOrNull(difference['excessPolicy']),
    );
  }

  factory ExchangeQuoteDto.fromPreview(Map<String, dynamic> json) => ExchangeQuoteDto.fromParts(_map(json['pricing']), {
    'proration': json['proration'],
    'billingStartAt': json['billingStartAt'],
    'deposit': json['depositDifference'],
    'excessPolicy': json['excessPolicy'],
    'exchangeFee': json['exchangeFee'],
    'feeWaived': json['feeWaived'],
  });

  final String currency;
  final num recurringAmount;
  final num rentAdjustment;
  final num depositTransfer;
  final num depositAdditional;
  final num depositExcess;
  final num exchangeFee;
  final bool feeWaived;
  final String? vehicleModel;
  final String? vehicleVariant;
  final String? hubName;
  final String? rentalPeriod;
  final DateTime? billingStartAt;
  final String? excessPolicy;

  bool get refundsExcess => excessPolicy == 'REFUND_REQUEST';
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
    commercialDifference: _map(json['commercialDifference']),
    pricingSnapshot: _map(json['pricingSnapshot']),
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

  ExchangeQuoteDto get quote => ExchangeQuoteDto.fromParts(pricingSnapshot, commercialDifference);
}

class VehicleExchange {
  const VehicleExchange({
    required this.id,
    required this.agreementId,
    required this.status,
    required this.reasonCode,
    required this.createdAt,
    this.riderId,
    this.reason,
    this.oldVehicleId,
    this.replacementVehicleId,
    this.oldAllocationId,
    this.newAllocationId,
    this.returnInspectionId,
    this.agreementNumber,
    this.rentalPeriodType,
    this.durationValue,
    this.durationUnit,
    this.batteryPlanId,
    this.proposedEffectiveAt,
    this.effectiveAt,
    this.reservationExpiresAt,
    this.acceptedAt,
    this.completedAt,
    this.offers = const [],
  });

  factory VehicleExchange.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> agreement = _map(json['agreement']);
    final Map<String, dynamic> pricing = _map(agreement['pricingSnapshot']);
    final Map<String, dynamic> rental = _map(pricing['rental']);
    return VehicleExchange(
      id: _text(json['id']),
      agreementId: _text(json['agreementId']),
      status: VehicleExchangeStatus.parse(json['status']),
      reasonCode: _text(json['reasonCode']),
      createdAt: _date(json['createdAt']) ?? DateTime.now(),
      riderId: _textOrNull(json['riderId']),
      reason: json['reason']?.toString(),
      oldVehicleId: _textOrNull(json['oldVehicleId']),
      replacementVehicleId: _textOrNull(json['replacementVehicleId']),
      oldAllocationId: _textOrNull(json['oldAllocationId']),
      newAllocationId: _textOrNull(json['newAllocationId']),
      returnInspectionId: _textOrNull(json['returnInspectionId']),
      agreementNumber: _textOrNull(agreement['agreementNumber']),
      rentalPeriodType: _textOrNull(agreement['rentalPeriodType']),
      durationValue: (rental['durationValue'] as num?)?.toInt(),
      durationUnit: _textOrNull(rental['durationUnit']),
      batteryPlanId: _textOrNull(_map(pricing['batteryPlan'])['id']) ?? _textOrNull(agreement['batteryPlanId']),
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
  }

  final String id;
  final String agreementId;
  final VehicleExchangeStatus status;
  final String reasonCode;
  final DateTime createdAt;
  final String? riderId;
  final String? reason;
  final String? oldVehicleId;
  final String? replacementVehicleId;
  final String? oldAllocationId;
  final String? newAllocationId;
  final String? returnInspectionId;
  final String? agreementNumber;
  final String? rentalPeriodType;
  final int? durationValue;
  final String? durationUnit;
  final String? batteryPlanId;
  final DateTime? proposedEffectiveAt;
  final DateTime? effectiveAt;
  final DateTime? reservationExpiresAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final List<VehicleExchangeOffer> offers;

  bool get oldVehicleReturned => returnInspectionId != null && status != VehicleExchangeStatus.returnPending;

  bool get canCancel => status.canCancel && returnInspectionId == null;

  bool get reservationLapsed => reservationExpiresAt != null && DateTime.now().isAfter(reservationExpiresAt!);

  VehicleExchangeOffer? get pendingOffer =>
      reservationLapsed ? null : offers.where((offer) => offer.isPresented && !offer.hasExpired).firstOrNull;

  VehicleExchangeOffer? get presentedOffer => offers.where((offer) => offer.isPresented).firstOrNull;

  VehicleExchangeOffer? get acceptedOffer =>
      offers.where((offer) => offer.status == VehicleExchangeOfferStatus.accepted).firstOrNull;
}

class AgreementVersion {
  const AgreementVersion({
    required this.id,
    required this.versionNumber,
    required this.status,
    required this.recurringAmount,
    required this.effectiveFrom,
    this.vehicleModel,
    this.vehicleVariant,
  });

  factory AgreementVersion.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> vehicle = _map(_map(json['pricingSnapshot'])['vehicle']);
    return AgreementVersion(
      id: _text(json['id']),
      versionNumber: (json['versionNumber'] as num?)?.toInt() ?? 0,
      status: _text(json['status']),
      recurringAmount: _num(json['recurringAmount']),
      effectiveFrom: _date(json['effectiveFrom']) ?? _date(json['createdAt']) ?? DateTime.now(),
      vehicleModel: _textOrNull(vehicle['modelName']),
      vehicleVariant: _textOrNull(vehicle['variantName']),
    );
  }

  final String id;
  final int versionNumber;
  final String status;
  final num recurringAmount;
  final DateTime effectiveFrom;
  final String? vehicleModel;
  final String? vehicleVariant;
}

class DepositSettlementDto {
  const DepositSettlementDto({required this.status, required this.additionalRequired, this.riderSecurityShortfall = 0});

  factory DepositSettlementDto.fromJson(Map<String, dynamic> json) => DepositSettlementDto(
    status: VehicleExchangeStatus.parse(json['status']),
    additionalRequired: _num(json['additionalRequired']),
    riderSecurityShortfall: _num(json['riderSecurityShortfall']),
  );

  final VehicleExchangeStatus status;
  final num additionalRequired;
  final num riderSecurityShortfall;
}

class VehicleExchangeApi {
  const VehicleExchangeApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/vehicle-exchanges';

  Future<Result<List<VehicleExchange>>> list() => _client.get<List<VehicleExchange>>(_base, parse: _many);

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

  Future<Result<void>> accept({required String id, required String offerId, required String offerHash}) =>
      _client.post<void>('$_base/$id/accept', body: {'offerId': offerId, 'offerHash': offerHash, 'consent': true});

  Future<Result<void>> rejectOffer({required String id, required String offerId, required String reason}) =>
      _client.post<void>('$_base/$id/reject-offer', body: {'offerId': offerId, 'reason': reason});

  Future<Result<void>> cancel(String id) => _client.post<void>('$_base/$id/cancel');

  Future<Result<List<AgreementVersion>>> agreementVersions(String agreementId) => _client.get<List<AgreementVersion>>(
    '$_base/agreements/$agreementId/versions',
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => AgreementVersion.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );
}

class ExchangeOperationsApi {
  const ExchangeOperationsApi(this._client);

  final ApiClient _client;

  static const String _base = '/vehicle-exchanges';

  Future<Result<List<VehicleExchange>>> list() => _client.get<List<VehicleExchange>>(_base, parse: _many);

  Future<Result<VehicleExchange>> details(String id) => _client.get<VehicleExchange>('$_base/$id', parse: _one);

  Future<Result<void>> approve(String id) => _client.post<void>('$_base/$id/approve');

  Future<Result<void>> reject(String id, {required String reason}) =>
      _client.post<void>('$_base/$id/reject', body: {'reason': reason});

  Future<Result<void>> startReturn(String id) => _client.post<void>('$_base/$id/return');

  Future<Result<void>> confirmReturn(String id) => _client.post<void>('$_base/$id/confirm-return');

  Future<Result<void>> selectReplacement(
    String id, {
    required String vehicleId,
    required String rentalPeriodType,
    String? hubId,
    int? durationValue,
    String? durationUnit,
    String? batteryPlanId,
  }) => _client.post<void>(
    '$_base/$id/replacement',
    body: {
      'vehicleId': vehicleId,
      'rentalPeriodType': rentalPeriodType,
      'hubId': ?hubId,
      'durationValue': ?durationValue,
      'durationUnit': ?durationUnit,
      'batteryPlanId': ?batteryPlanId,
    },
  );

  Future<Result<void>> acceptOnBehalf(
    String id, {
    required String offerId,
    required String offerHash,
    required String consentReference,
    required String reason,
  }) => _client.post<void>(
    '$_base/$id/accept',
    body: {
      'offerId': offerId,
      'offerHash': offerHash,
      'consent': true,
      'riderConsentReference': consentReference,
      'assistedReason': reason,
    },
  );

  Future<Result<void>> rejectOfferOnBehalf(String id, {required String offerId, required String reason}) =>
      _client.post<void>('$_base/$id/reject-offer', body: {'offerId': offerId, 'reason': reason});

  Future<Result<ExchangeQuoteDto>> preview(String id) =>
      _client.get<ExchangeQuoteDto>('$_base/$id/preview', parse: (data) => ExchangeQuoteDto.fromPreview(_map(data)));

  Future<Result<void>> sendOffer(String id) => _client.post<void>('$_base/$id/offer');

  Future<Result<DepositSettlementDto>> settleDeposits(String id) => _client.post<DepositSettlementDto>(
    '$_base/$id/reconcile-deposits',
    parse: (data) => DepositSettlementDto.fromJson(_map(data)),
  );

  Future<Result<void>> startHandover(String id) => _client.post<void>('$_base/$id/handover');

  Future<Result<void>> complete(String id) => _client.post<void>('$_base/$id/complete');

  Future<Result<void>> cancel(String id) => _client.post<void>('$_base/$id/cancel');
}
