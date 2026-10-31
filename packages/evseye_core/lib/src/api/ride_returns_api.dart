import 'dart:math';

import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'vehicle_submission_api.dart';

enum RideReturnStatus {
  requested('REQUESTED'),
  returned('RETURNED'),
  cancelled('CANCELLED'),
  unknown('');

  const RideReturnStatus(this.wire);

  final String wire;

  static RideReturnStatus parse(Object? value) =>
      RideReturnStatus.values.firstWhere((status) => status.wire == value?.toString(), orElse: () => unknown);
}

enum PenaltyCategory {
  damage('DAMAGE'),
  missingItem('MISSING_ITEM'),
  unknown('');

  const PenaltyCategory(this.wire);

  final String wire;

  static PenaltyCategory parse(Object? value) =>
      PenaltyCategory.values.firstWhere((category) => category.wire == value?.toString(), orElse: () => unknown);
}

class RideReturnDto {
  const RideReturnDto({
    required this.id,
    required this.riderId,
    required this.agreementId,
    required this.requestedDate,
    required this.reasonCode,
    required this.requestSource,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.allocationId,
    this.plannedHubId,
    this.receivedHubId,
    this.receivedAt,
    this.reasonText,
    this.cancelledAt,
    this.submission,
  });

  factory RideReturnDto.fromJson(Map<String, dynamic> json) {
    final DateTime createdAt = jsonDateOr(json['createdAt'], DateTime.now());
    return RideReturnDto(
      id: jsonText(json['id']),
      riderId: jsonText(json['riderId']),
      agreementId: jsonText(json['agreementId']),
      requestedDate: jsonDateOr(json['requestedTerminationDate'], createdAt),
      reasonCode: jsonText(json['reasonCode']),
      requestSource: jsonText(json['requestSource']),
      status: RideReturnStatus.parse(json['status']),
      createdAt: createdAt,
      updatedAt: jsonDateOr(json['updatedAt'], createdAt),
      allocationId: jsonTextOrNull(json['allocationId']),
      plannedHubId: jsonTextOrNull(json['plannedHubId']),
      receivedHubId: jsonTextOrNull(json['receivedHubId']),
      receivedAt: jsonDate(json['actualTerminationDate']),
      reasonText: jsonTextOrNull(json['reasonText']),
      cancelledAt: jsonDate(json['cancelledAt']),
      submission: SubmissionSummaryDto.maybe(json['vehicleSubmission']),
    );
  }

  final String id;
  final String riderId;
  final String agreementId;
  final DateTime requestedDate;
  final String reasonCode;
  final String requestSource;
  final RideReturnStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? allocationId;
  final String? plannedHubId;
  final String? receivedHubId;
  final DateTime? receivedAt;
  final String? reasonText;
  final DateTime? cancelledAt;
  final SubmissionSummaryDto? submission;
}

class RideReturnPage {
  const RideReturnPage({required this.items, this.nextCursor});

  factory RideReturnPage.fromJson(Map<String, dynamic> json) => RideReturnPage(
    items: [for (final Map<String, dynamic> item in jsonMaps(json['items'])) RideReturnDto.fromJson(item)],
    nextCursor: jsonTextOrNull(json['nextCursor']),
  );

  final List<RideReturnDto> items;
  final String? nextCursor;
}

class PenaltyPriceDto {
  const PenaltyPriceDto({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.description,
    required this.amount,
    required this.currency,
    this.isSpare = false,
    this.evidenceRequired = true,
    this.version,
    this.origin,
    this.masterUpdateAvailable = false,
    this.masterInactive = false,
    this.allowedFindingTypes = const <String>[],
  });

  factory PenaltyPriceDto.fromJson(Map<String, dynamic> json) => PenaltyPriceDto(
    id: jsonText(json['id']),
    code: jsonText(json['code']),
    name: jsonTextOrNull(json['name']) ?? jsonText(json['description']),
    category: PenaltyCategory.parse(json['category']),
    description: jsonText(json['description']),
    amount: jsonNum(json['amount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    isSpare: jsonBool(json['isSpare']),
    evidenceRequired: json['evidenceRequired'] != false,
    version: jsonIntOrNull(json['configurationVersion'] ?? json['version']),
    origin: jsonTextOrNull(json['origin']),
    masterUpdateAvailable: jsonBool(json['masterUpdateAvailable']),
    masterInactive: jsonBool(json['masterInactive']),
    allowedFindingTypes: (json['allowedFindingTypes'] is List ? json['allowedFindingTypes'] as List : const <dynamic>[])
        .map((value) => value.toString())
        .toList(growable: false),
  );

  final String id;
  final String code;
  final String name;
  final PenaltyCategory category;
  final String description;
  final num amount;
  final String currency;
  final bool isSpare;
  final bool evidenceRequired;
  final int? version;
  final String? origin;
  final bool masterUpdateAvailable;
  final bool masterInactive;
  final List<String> allowedFindingTypes;

  int? get configurationVersion => version;
}

String newIdempotencyKey() {
  final Random random = Random.secure();
  return List<String>.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
}

String newUuid() {
  final Random random = Random.secure();
  final List<int> bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final String hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

class RideReturnsApi {
  const RideReturnsApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/ride-returns';

  Future<Result<RideReturnPage>> list({String? cursor, int limit = 25}) => _client.get<RideReturnPage>(
    _base,
    query: {'limit': limit, 'cursor': ?cursor},
    parse: (data) => RideReturnPage.fromJson(jsonMap(data)),
  );

  Future<Result<RideReturnDto>> detail(String id) =>
      _client.get<RideReturnDto>('$_base/$id', parse: (data) => RideReturnDto.fromJson(jsonMap(data)));

  Future<Result<RideReturnDto>> request({
    required DateTime plannedReturnDate,
    required String idempotencyKey,
    String? reasonCode,
    String? plannedHubId,
    String? notes,
    double? latitude,
    double? longitude,
  }) => _client.post<RideReturnDto>(
    _base,
    headers: {'Idempotency-Key': idempotencyKey},
    body: {
      'plannedReturnDate': plannedDateWire(plannedReturnDate),
      'reasonCode': ?reasonCode,
      'plannedHubId': ?plannedHubId,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      if (latitude != null && longitude != null) ...{'latitude': latitude, 'longitude': longitude},
    },
    parse: (data) => RideReturnDto.fromJson(jsonMap(data)),
  );

  Future<Result<void>> cancel(String id) => _client.post<void>('$_base/$id/cancel', parse: (_) {});
}
