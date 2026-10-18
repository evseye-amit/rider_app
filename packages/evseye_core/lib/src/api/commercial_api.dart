import '../utils/result.dart';
import 'api_client.dart';

class CommercialLine {
  const CommercialLine({required this.type, required this.amount, this.refundable = false});

  factory CommercialLine.fromJson(Map<String, dynamic> json) => CommercialLine(
    type: json['type']?.toString() ?? '',
    amount: _money(json['amount']),
    refundable: json['refundable'] == true,
  );

  final String type;
  final num amount;
  final bool refundable;
}

class CommercialUsage {
  const CommercialUsage({required this.type, required this.unit, required this.rate});

  factory CommercialUsage.fromJson(Map<String, dynamic> json) => CommercialUsage(
    type: json['type']?.toString() ?? '',
    unit: json['unit']?.toString() ?? '',
    rate: _money(json['rate']),
  );

  final String type;
  final String unit;
  final num rate;
}

class CommercialBreakdown {
  const CommercialBreakdown({
    required this.period,
    required this.recurringAmount,
    required this.payableToday,
    required this.refundableAmount,
    this.currency = 'INR',
    this.durationValue,
    this.durationUnit,
    this.modelName,
    this.variantName,
    this.recurringCharges = const [],
    this.oneTimeCharges = const [],
    this.deposits = const [],
    this.usageCharges = const [],
    this.includedServices = const [],
  });

  factory CommercialBreakdown.fromJson(Map<String, dynamic> json, {String? period}) {
    final Map<String, dynamic> vehicle = _map(json['vehicle']);
    return CommercialBreakdown(
      period: (period ?? json['period'] ?? json['rentalPeriodType'])?.toString().toUpperCase() ?? '',
      recurringAmount: _money(json['recurringAmount']),
      payableToday: _money(json['payableToday']),
      refundableAmount: _money(json['refundableAmount']),
      currency: json['currency']?.toString() ?? 'INR',
      durationValue: (json['durationValue'] as num?)?.toInt(),
      durationUnit: json['durationUnit']?.toString(),
      modelName: _text(vehicle['modelName']),
      variantName: _text(vehicle['variantName']),
      recurringCharges: _lines(json['recurringCharges']),
      oneTimeCharges: _lines(json['oneTimeCharges']),
      deposits: _lines(json['refundableDeposits']),
      usageCharges: [for (final Map<String, dynamic> row in _maps(json['usageCharges'])) CommercialUsage.fromJson(row)],
      includedServices: [
        if (json['includedServices'] is List)
          for (final Object? service in json['includedServices'] as List)
            if (_text(service) case final String text) text,
      ],
    );
  }

  final String period;
  final num recurringAmount;
  final num payableToday;
  final num refundableAmount;
  final String currency;
  final int? durationValue;
  final String? durationUnit;
  final String? modelName;
  final String? variantName;
  final List<CommercialLine> recurringCharges;
  final List<CommercialLine> oneTimeCharges;
  final List<CommercialLine> deposits;
  final List<CommercialUsage> usageCharges;
  final List<String> includedServices;

  num get nonRefundableAmount => payableToday - refundableAmount;
}

class CommercialTerms {
  const CommercialTerms({required this.version, required this.title, required this.content});

  factory CommercialTerms.fromJson(Map<String, dynamic> json) => CommercialTerms(
    version: json['termsVersion']?.toString() ?? '',
    title: json['termsTitle']?.toString() ?? '',
    content: json['termsContent']?.toString() ?? '',
  );

  final String version;
  final String title;
  final String content;

  bool get isEmpty => content.trim().isEmpty;
}

class CommercialOffer {
  const CommercialOffer({
    required this.id,
    required this.status,
    required this.breakdown,
    required this.terms,
    this.offerNumber,
    this.validUntil,
  });

  factory CommercialOffer.fromJson(Map<String, dynamic> json) => CommercialOffer(
    id: json['id']?.toString() ?? '',
    offerNumber: _text(json['offerNumber']),
    status: json['status']?.toString().toUpperCase() ?? '',
    validUntil: _date(json['validUntil']),
    breakdown: CommercialBreakdown.fromJson(json),
    terms: CommercialTerms.fromJson(json),
  );

  final String id;
  final String? offerNumber;
  final String status;
  final DateTime? validUntil;
  final CommercialBreakdown breakdown;
  final CommercialTerms terms;

  bool get isPresented => status == 'PRESENTED';
  bool get isAccepted => status == 'ACCEPTED';
}

class CommercialAgreement {
  const CommercialAgreement({
    required this.id,
    required this.status,
    required this.breakdown,
    required this.terms,
    this.agreementNumber,
    this.batteryPlanName,
    this.acceptedAt,
    this.startDate,
  });

  factory CommercialAgreement.fromJson(Map<String, dynamic> json) => CommercialAgreement(
    id: json['id']?.toString() ?? '',
    agreementNumber: _text(json['agreementNumber']),
    status: json['status']?.toString().toUpperCase() ?? '',
    breakdown: CommercialBreakdown.fromJson(json),
    terms: CommercialTerms.fromJson(json),
    batteryPlanName: _text(_map(json['batteryPlan'])['name']),
    acceptedAt: _date(json['acceptedAt']),
    startDate: _date(json['startDate']),
  );

  final String id;
  final String? agreementNumber;
  final String status;
  final CommercialBreakdown breakdown;
  final CommercialTerms terms;
  final String? batteryPlanName;
  final DateTime? acceptedAt;
  final DateTime? startDate;
}

class AllocationCommercial {
  const AllocationCommercial({required this.allocationId, this.offer, this.agreement});

  factory AllocationCommercial.fromJson(Map<String, dynamic> json) => AllocationCommercial(
    allocationId: json['allocationId']?.toString() ?? '',
    offer: json['offer'] is Map ? CommercialOffer.fromJson(_map(json['offer'])) : null,
    agreement: json['agreement'] is Map ? CommercialAgreement.fromJson(_map(json['agreement'])) : null,
  );

  final String allocationId;
  final CommercialOffer? offer;
  final CommercialAgreement? agreement;

  bool get isAccepted => agreement != null;

  bool get awaitingRider => agreement == null && (offer?.isPresented ?? false);

  bool get needsPlan => agreement == null && !(offer?.isPresented ?? false);

  CommercialBreakdown? get breakdown => agreement?.breakdown ?? offer?.breakdown;
}

class BatteryPlanOption {
  const BatteryPlanOption({required this.id, required this.code, required this.name});

  factory BatteryPlanOption.fromJson(Map<String, dynamic> json) => BatteryPlanOption(
    id: json['id']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
    name: _text(json['name']) ?? json['code']?.toString() ?? '',
  );

  final String id;
  final String code;
  final String name;
}

class RentalPlanOption {
  const RentalPlanOption({
    required this.rateCardName,
    required this.selection,
    required this.breakdown,
    this.rateCardCode,
    this.versionNumber,
    this.baseRent,
    this.rentTax,
    this.rentChanges = const [],
    this.scooterAgeMonths,
  });

  factory RentalPlanOption.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> card = _map(json['rateCard']);
    final Map<String, dynamic> rent = _map(json['rentalBreakdown']);
    return RentalPlanOption(
      rateCardName: _text(card['name']) ?? _text(card['code']) ?? '',
      rateCardCode: _text(card['code']),
      versionNumber: (card['versionNumber'] as num?)?.toInt(),
      selection: _map(json['selection']),
      breakdown: CommercialBreakdown.fromJson(json),
      baseRent: rent['baseAmount'] == null ? null : _money(rent['baseAmount']),
      rentTax: rent['taxAmount'] == null ? null : _money(rent['taxAmount']),
      rentChanges: _lines(rent['changes']),
      scooterAgeMonths: (json['scooterAgeMonths'] as num?)?.toInt(),
    );
  }

  final String rateCardName;
  final String? rateCardCode;
  final int? versionNumber;
  final Map<String, dynamic> selection;
  final CommercialBreakdown breakdown;
  final num? baseRent;
  final num? rentTax;
  final List<CommercialLine> rentChanges;
  final int? scooterAgeMonths;

  String get key => [
    selection['rateCardVersionId'],
    selection['rentalPeriodType'],
    selection['durationValue'],
    selection['durationUnit'],
    selection['batteryPlanId'],
  ].join(':');
}

class RentalPlanList {
  const RentalPlanList({required this.items, required this.batteryPlans});

  factory RentalPlanList.fromJson(Map<String, dynamic> json) => RentalPlanList(
    items: [for (final Map<String, dynamic> row in _maps(json['items'])) RentalPlanOption.fromJson(row)],
    batteryPlans: [for (final Map<String, dynamic> row in _maps(json['batteryPlans'])) BatteryPlanOption.fromJson(row)],
  );

  final List<RentalPlanOption> items;
  final List<BatteryPlanOption> batteryPlans;
}

class CommercialApi {
  const CommercialApi(this._client);

  final ApiClient _client;

  static const String _deployments = '/mobile-deployments';

  Future<Result<RentalPlanList>> plans(String allocationId, {String? batteryPlanId}) => _client.get<RentalPlanList>(
    '$_deployments/$allocationId/plans',
    query: {'batteryPlanId': ?batteryPlanId},
    parse: (data) => RentalPlanList.fromJson(_map(data)),
  );

  Future<Result<AllocationCommercial>> selectPlan(
    String allocationId,
    RentalPlanOption plan, {
    required String idempotencyKey,
  }) => _client.post<AllocationCommercial>(
    '$_deployments/$allocationId/commercial-offer',
    headers: {'Idempotency-Key': idempotencyKey},
    body: plan.selection,
    parse: (data) => AllocationCommercial.fromJson(_map(data)),
  );

  Future<Result<AllocationCommercial>> allocationCommercial(String allocationId) => _client.get<AllocationCommercial>(
    '$_deployments/$allocationId/commercial-offer',
    parse: (data) => AllocationCommercial.fromJson(_map(data)),
  );

  Future<Result<CommercialAgreement>> acceptOffer(String offerId, {required String termsVersion}) =>
      _client.post<CommercialAgreement>(
        '/rider-app/commercial-offers/$offerId/accept',
        body: {'consent': true, 'acceptedTermsVersion': termsVersion},
        parse: (data) => CommercialAgreement.fromJson(_map(data)),
      );
}

Map<String, dynamic> _map(Object? raw) => raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

List<Map<String, dynamic>> _maps(Object? raw) => [
  if (raw is List)
    for (final Object? item in raw)
      if (item is Map) Map<String, dynamic>.from(item),
];

List<CommercialLine> _lines(Object? raw) => [
  for (final Map<String, dynamic> row in _maps(raw)) CommercialLine.fromJson(row),
];

String? _text(Object? raw) {
  final String text = raw?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

num _money(Object? raw) => raw is num ? raw : num.tryParse(raw?.toString() ?? '') ?? 0;

DateTime? _date(Object? raw) => raw == null ? null : DateTime.tryParse(raw.toString())?.toLocal();
