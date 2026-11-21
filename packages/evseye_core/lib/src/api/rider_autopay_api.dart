import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class AutoPayMandateDto {
  const AutoPayMandateDto({
    required this.id,
    required this.status,
    required this.maxAmount,
    required this.cancellationPending,
    this.expiresAt,
    this.authorizationUrl,
  });

  factory AutoPayMandateDto.fromJson(Map<String, dynamic> json) => AutoPayMandateDto(
    id: jsonText(json['mandateId'] ?? json['id']),
    status: jsonText(json['status']).toUpperCase(),
    maxAmount: jsonNum(json['maxAmount']),
    cancellationPending: jsonBool(json['cancellationPending']),
    expiresAt: jsonDate(json['expiresAt']),
    authorizationUrl: jsonTextOrNull(jsonMap(json['authorization'])['url']),
  );

  final String id;
  final String status;
  final num maxAmount;
  final bool cancellationPending;
  final DateTime? expiresAt;
  final String? authorizationUrl;
}

class AutoPayRechargeDto {
  const AutoPayRechargeDto({
    required this.id,
    required this.status,
    required this.amount,
    this.scheduledAt,
    this.completedAt,
    this.createdAt,
  });

  factory AutoPayRechargeDto.fromJson(Map<String, dynamic> json) => AutoPayRechargeDto(
    id: jsonText(json['id']),
    status: jsonText(json['status']).toUpperCase(),
    amount: jsonNum(json['amount']),
    scheduledAt: jsonDate(json['scheduledAt']),
    completedAt: jsonDate(json['completedAt']),
    createdAt: jsonDate(json['createdAt']),
  );

  final String id;
  final String status;
  final num amount;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
}

class RiderAutoPayDto {
  const RiderAutoPayDto({
    required this.effectiveStatus,
    required this.revision,
    required this.enabled,
    required this.threshold,
    required this.rechargeAmount,
    required this.policyRevision,
    required this.minimumLeadHours,
    required this.cooldownHours,
    required this.canEnable,
    required this.canSetup,
    required this.requests,
    this.setupMaxAmount,
    this.mandate,
  });

  factory RiderAutoPayDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> policy = jsonMap(json['policy']);
    final Map<String, dynamic> actions = jsonMap(json['actions']);
    final Map<String, dynamic> mandate = jsonMap(json['mandate']);
    return RiderAutoPayDto(
      effectiveStatus: jsonText(json['effectiveStatus']).toUpperCase(),
      revision: jsonIntOrNull(json['revision']) ?? 0,
      enabled: jsonBool(json['enabled']),
      threshold: jsonNum(policy['threshold']),
      rechargeAmount: jsonNum(policy['rechargeAmount']),
      policyRevision: jsonIntOrNull(policy['revision']) ?? 0,
      minimumLeadHours: jsonNum(json['minimumLeadHours']),
      cooldownHours: jsonNum(json['cooldownHours']),
      canEnable: jsonBool(actions['canEnable']),
      canSetup: jsonBool(actions['canSetup']),
      requests: [for (final Map<String, dynamic> row in jsonMaps(json['requests'])) AutoPayRechargeDto.fromJson(row)],
      setupMaxAmount: jsonNumOrNull(jsonMap(json['setupTerms'])['maxAmount']),
      mandate: mandate.isEmpty ? null : AutoPayMandateDto.fromJson(mandate),
    );
  }

  final String effectiveStatus;
  final int revision;
  final bool enabled;
  final num threshold;
  final num rechargeAmount;
  final int policyRevision;
  final num minimumLeadHours;
  final num cooldownHours;
  final bool canEnable;
  final bool canSetup;
  final List<AutoPayRechargeDto> requests;
  final num? setupMaxAmount;
  final AutoPayMandateDto? mandate;
}

class RiderAutoPayApi {
  const RiderAutoPayApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/autopay';

  static const String _consentVersion = 'unified-autopay-v1';

  static RiderAutoPayDto _state(dynamic data) => RiderAutoPayDto.fromJson(jsonMap(data));

  static AutoPayMandateDto _mandate(dynamic data) => AutoPayMandateDto.fromJson(jsonMap(data));

  static String _mandatePath(String mandateId) => '$_base/mandates/${Uri.encodeComponent(mandateId)}';

  Future<Result<RiderAutoPayDto>> current() => _client.get<RiderAutoPayDto>(_base, parse: _state);

  Future<Result<RiderAutoPayDto>> enable({
    required String mandateId,
    required int expectedRevision,
    required int consentRevision,
  }) => _client.put<RiderAutoPayDto>(
    _base,
    body: {
      'enabled': true,
      'expectedRevision': expectedRevision,
      'mandateId': mandateId,
      'consentRevision': consentRevision,
      'consentVersion': _consentVersion,
    },
    parse: _state,
  );

  Future<Result<AutoPayMandateDto>> setUpMandate({required String email, required String idempotencyKey}) =>
      _client.post<AutoPayMandateDto>(
        '$_base/mandates',
        headers: {'Idempotency-Key': idempotencyKey},
        body: {'email': email},
        parse: _mandate,
      );

  Future<Result<AutoPayMandateDto>> verifyMandate(String mandateId) =>
      _client.post<AutoPayMandateDto>('${_mandatePath(mandateId)}/verify', parse: _mandate);
}
