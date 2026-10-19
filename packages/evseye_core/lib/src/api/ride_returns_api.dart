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

enum PenaltyCaseStatus {
  draft('DRAFT'),
  riderApprovalPending('RIDER_APPROVAL_PENDING'),
  managerApprovalPending('MANAGER_APPROVAL_PENDING'),
  riderDisputed('RIDER_DISPUTED'),
  posted('POSTED'),
  unknown('');

  const PenaltyCaseStatus(this.wire);

  final String wire;

  static PenaltyCaseStatus parse(Object? value) =>
      PenaltyCaseStatus.values.firstWhere((status) => status.wire == value?.toString(), orElse: () => unknown);
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

class PenaltyItemDto {
  const PenaltyItemDto({
    required this.id,
    required this.revision,
    required this.position,
    required this.priceId,
    required this.details,
    required this.evidencePhotoIds,
    this.priceCode,
    this.category = PenaltyCategory.unknown,
    this.description,
    this.amount,
    this.currency,
  });

  factory PenaltyItemDto.fromJson(Map<String, dynamic> json) => PenaltyItemDto(
    id: jsonText(json['id']),
    revision: jsonIntOrNull(json['revision']) ?? 0,
    position: jsonIntOrNull(json['position']) ?? 0,
    priceId: jsonText(json['priceListItemId']),
    details: jsonText(json['details']),
    evidencePhotoIds: jsonStrings(json['evidencePhotoIds']),
    priceCode: jsonTextOrNull(json['priceCode']),
    category: PenaltyCategory.parse(json['category']),
    description: jsonTextOrNull(json['description']),
    amount: jsonNumOrNull(json['amount']),
    currency: jsonTextOrNull(json['currency']),
  );

  final String id;
  final int revision;
  final int position;
  final String priceId;
  final String details;
  final List<String> evidencePhotoIds;
  final String? priceCode;
  final PenaltyCategory category;
  final String? description;
  final num? amount;
  final String? currency;
}

class PenaltyCaseDto {
  const PenaltyCaseDto({
    required this.id,
    required this.inspectionId,
    required this.currentRevision,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.items,
    this.submittedAt,
    this.riderApprovedRevision,
    this.riderApprovedAt,
    this.riderDisputedRevision,
    this.riderDisputedAt,
    this.riderDisputeReason,
    this.adminOverrideRevision,
    this.adminOverrideReason,
    this.managerApprovedRevision,
    this.managerApprovedAt,
    this.postedAt,
  });

  factory PenaltyCaseDto.fromJson(Map<String, dynamic> json) {
    final int revision = jsonIntOrNull(json['currentRevision']) ?? 0;
    final List<PenaltyItemDto> items = [
      for (final Map<String, dynamic> item in jsonMaps(json['items'])) PenaltyItemDto.fromJson(item),
    ].where((item) => item.revision == revision).toList()..sort((a, b) => a.position.compareTo(b.position));
    return PenaltyCaseDto(
      id: jsonText(json['id']),
      inspectionId: jsonText(json['inspectionId']),
      currentRevision: revision,
      totalAmount: jsonNum(json['totalAmount']),
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      status: PenaltyCaseStatus.parse(json['status']),
      items: items,
      submittedAt: jsonDate(json['submittedAt']),
      riderApprovedRevision: jsonIntOrNull(json['riderApprovedRevision']),
      riderApprovedAt: jsonDate(json['riderApprovedAt']),
      riderDisputedRevision: jsonIntOrNull(json['riderDisputedRevision']),
      riderDisputedAt: jsonDate(json['riderDisputedAt']),
      riderDisputeReason: jsonTextOrNull(json['riderDisputeReason']),
      adminOverrideRevision: jsonIntOrNull(json['adminOverrideRevision']),
      adminOverrideReason: jsonTextOrNull(json['adminOverrideReason']),
      managerApprovedRevision: jsonIntOrNull(json['managerApprovedRevision']),
      managerApprovedAt: jsonDate(json['managerApprovedAt']),
      postedAt: jsonDate(json['postedAt']),
    );
  }

  final String id;
  final String inspectionId;
  final int currentRevision;
  final num totalAmount;
  final String currency;
  final PenaltyCaseStatus status;
  final List<PenaltyItemDto> items;
  final DateTime? submittedAt;
  final int? riderApprovedRevision;
  final DateTime? riderApprovedAt;
  final int? riderDisputedRevision;
  final DateTime? riderDisputedAt;
  final String? riderDisputeReason;
  final int? adminOverrideRevision;
  final String? adminOverrideReason;
  final int? managerApprovedRevision;
  final DateTime? managerApprovedAt;
  final DateTime? postedAt;

  bool get riderApproved => riderApprovedRevision != null && riderApprovedRevision == currentRevision;

  bool get adminOverridden => adminOverrideRevision != null && adminOverrideRevision == currentRevision;

  bool get managerApproved => managerApprovedRevision != null && managerApprovedRevision == currentRevision;
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
    this.penaltyCase,
    this.submissionRequired = true,
    this.submission,
  });

  factory RideReturnDto.fromJson(Map<String, dynamic> json) {
    final DateTime createdAt = jsonDateOr(json['createdAt'], DateTime.now());
    final Map<String, dynamic> penalty = jsonMap(json['returnPenaltyCase']);
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
      penaltyCase: penalty.isEmpty ? null : PenaltyCaseDto.fromJson(penalty),
      submissionRequired: json['submissionRequired'] != false,
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
  final PenaltyCaseDto? penaltyCase;
  final bool submissionRequired;
  final SubmissionSummaryDto? submission;

  bool get isOpen => submissionRequired
      ? status == RideReturnStatus.requested || (submission != null && !submission!.isFinished)
      : status == RideReturnStatus.requested ||
            (status == RideReturnStatus.returned && penaltyCase?.status != PenaltyCaseStatus.posted);
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

class PenaltyOtpChallenge {
  const PenaltyOtpChallenge({required this.otpRequestId, required this.expiresAt});

  factory PenaltyOtpChallenge.fromJson(Map<String, dynamic> json) => PenaltyOtpChallenge(
    otpRequestId: jsonText(json['otpRequestId']),
    expiresAt: jsonDateOr(json['expiresAt'], DateTime.now().add(const Duration(minutes: 5))),
  );

  final String otpRequestId;
  final DateTime expiresAt;
}

class ReturnInspectionDto {
  const ReturnInspectionDto({required this.id, required this.type, required this.status, this.safeForReuse});

  factory ReturnInspectionDto.fromJson(Map<String, dynamic> json) => ReturnInspectionDto(
    id: jsonText(json['id']),
    type: jsonText(json['type']),
    status: jsonText(json['status']),
    safeForReuse: json['safeForReuse'] is bool ? json['safeForReuse'] as bool : null,
  );

  final String id;
  final String type;
  final String status;
  final bool? safeForReuse;

  bool get isCompleted => status == 'COMPLETED';
}

class ReturnVehicleDto {
  const ReturnVehicleDto({required this.id, required this.number, this.model, this.colour});

  factory ReturnVehicleDto.fromJson(Map<String, dynamic> json) {
    final String model = [?jsonTextOrNull(json['modelName']), ?jsonTextOrNull(json['variantName'])].join(' ');
    return ReturnVehicleDto(
      id: jsonText(json['id']),
      number: jsonTextOrNull(json['vehicleNumber']) ?? jsonText(json['fleetCode']),
      model: model.isEmpty ? null : model,
      colour: jsonTextOrNull(json['colour']),
    );
  }

  final String id;
  final String number;
  final String? model;
  final String? colour;
}

class StaffRideReturnDto {
  const StaffRideReturnDto({required this.rideReturn, this.vehicle, this.inspection, this.allocationStatus});

  factory StaffRideReturnDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> allocation = jsonMap(json['allocation']);
    final Map<String, dynamic> fleet = jsonMap(allocation['fleet']);
    final ReturnInspectionDto? inspection = [
      for (final Map<String, dynamic> row in jsonMaps(allocation['inspections'])) ReturnInspectionDto.fromJson(row),
    ].where((row) => row.type == 'POST_DEALLOCATION').firstOrNull;
    return StaffRideReturnDto(
      rideReturn: RideReturnDto.fromJson(json),
      vehicle: fleet.isEmpty ? null : ReturnVehicleDto.fromJson(fleet),
      inspection: inspection,
      allocationStatus: jsonTextOrNull(allocation['status']),
    );
  }

  final RideReturnDto rideReturn;
  final ReturnVehicleDto? vehicle;
  final ReturnInspectionDto? inspection;
  final String? allocationStatus;
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
    version: jsonIntOrNull(json['version']),
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
}

class PenaltyLineInput {
  const PenaltyLineInput({required this.priceId, required this.details, required this.evidencePhotoIds});

  final String priceId;
  final String details;
  final List<String> evidencePhotoIds;

  Map<String, dynamic> toJson() => {'priceId': priceId, 'details': details, 'evidencePhotoIds': evidencePhotoIds};
}

String newIdempotencyKey() {
  final Random random = Random.secure();
  return List<String>.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
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

  Future<Result<PenaltyOtpChallenge>> requestPenaltyOtp(String id) async {
    await _client.ensureFreshSession();
    return _client.post<PenaltyOtpChallenge>(
      '$_base/$id/penalties/otp/request',
      refreshOnUnauthorized: false,
      parse: (data) => PenaltyOtpChallenge.fromJson(jsonMap(data)),
    );
  }

  Future<Result<void>> verifyPenaltyOtp(String id, {required String otpRequestId, required String code}) async {
    await _client.ensureFreshSession();
    return _client.post<void>(
      '$_base/$id/penalties/otp/verify',
      body: {'otpRequestId': otpRequestId, 'code': code},
      refreshOnUnauthorized: false,
      parse: (_) {},
    );
  }

  Future<Result<void>> dispute(String id, String reason) =>
      _client.post<void>('$_base/$id/penalties/dispute', body: {'reason': reason}, parse: (_) {});
}

class ReturnDeskApi {
  const ReturnDeskApi(this._client);

  final ApiClient _client;

  static const String _base = '/client/ride-returns';

  Future<Result<RideReturnPage>> list({String? cursor, int limit = 50, RideReturnStatus? status}) =>
      _client.get<RideReturnPage>(
        _base,
        query: {'limit': limit, 'cursor': ?cursor, 'status': ?status?.wire},
        parse: (data) => RideReturnPage.fromJson(jsonMap(data)),
      );

  Future<Result<StaffRideReturnDto>> detail(String id) =>
      _client.get<StaffRideReturnDto>('$_base/$id', parse: (data) => StaffRideReturnDto.fromJson(jsonMap(data)));

  Future<Result<void>> receive(String id, {required String hubId, DateTime? receivedAt, String? backdateReason}) =>
      _client.post<void>(
        '$_base/$id/receive',
        body: {
          'receivedHubId': hubId,
          if (receivedAt != null) 'receivedAt': receivedAt.toUtc().toIso8601String(),
          if (receivedAt != null && backdateReason != null) 'backdateReason': backdateReason,
        },
        parse: (_) {},
      );

  Future<Result<void>> savePenalties(String id, List<PenaltyLineInput> items) => _client.put<void>(
    '$_base/$id/penalties',
    body: {
      'items': [for (final PenaltyLineInput item in items) item.toJson()],
    },
    parse: (_) {},
  );

  Future<Result<void>> submitPenalties(String id) => _client.post<void>('$_base/$id/penalties/submit', parse: (_) {});

  Future<Result<void>> approvePenalties(String id) => _client.post<void>('$_base/$id/penalties/approve', parse: (_) {});

  Future<Result<void>> overrideRiderApproval(String id, String reason) =>
      _client.post<void>('$_base/$id/penalties/override-rider-approval', body: {'reason': reason}, parse: (_) {});

  Future<Result<List<PenaltyPriceDto>>> prices() => _client.get<List<PenaltyPriceDto>>(
    '/client/return-penalty-prices',
    parse: (data) => [for (final Map<String, dynamic> row in jsonMaps(data)) PenaltyPriceDto.fromJson(row)],
  );

  Future<Result<void>> completeInspection(String inspectionId, {required bool safeForReuse, String? unsafeReason}) =>
      _client.post<void>(
        '/inspections/$inspectionId/complete',
        body: {'safeForReuse': safeForReuse, if (!safeForReuse && unsafeReason != null) 'unsafeReason': unsafeReason},
        parse: (_) {},
      );
}
