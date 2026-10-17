import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';
import 'ride_returns_api.dart';

enum SubmissionSource {
  returns('RETURN'),
  exchange('EXCHANGE');

  const SubmissionSource(this.wire);

  final String wire;
}

enum SubmissionPhase {
  scheduled('SCHEDULED'),
  checks('CHECKS'),
  all('ALL');

  const SubmissionPhase(this.wire);

  final String wire;
}

enum SubmissionNextAction {
  capturePhotos('CAPTURE_PHOTOS_AND_BASIC_REPORT'),
  reviewAndImpose('REVIEW_AND_IMPOSE'),
  collectOtps('COLLECT_OTPS_OR_RECORD_BYPASS'),
  deepCheck('DEEP_MECHANIC_CHECK'),
  complete('COMPLETE');

  const SubmissionNextAction(this.wire);

  final String wire;

  static SubmissionNextAction parse(Object? raw) =>
      values.firstWhere((action) => action.wire == raw?.toString(), orElse: () => SubmissionNextAction.capturePhotos);
}

enum SubmissionReportStatus {
  draft('DRAFT'),
  submitted('SUBMITTED'),
  posted('POSTED'),
  cancelled('CANCELLED');

  const SubmissionReportStatus(this.wire);

  final String wire;

  static SubmissionReportStatus parse(Object? raw) =>
      values.firstWhere((status) => status.wire == raw?.toString(), orElse: () => SubmissionReportStatus.draft);
}

enum SubmissionStage {
  basic('BASIC'),
  deep('DEEP');

  const SubmissionStage(this.wire);

  final String wire;

  static SubmissionStage parse(Object? raw) => raw?.toString() == 'DEEP' ? SubmissionStage.deep : SubmissionStage.basic;
}

enum SubmissionParty {
  rider('RIDER'),
  teamLead('TEAM_LEAD');

  const SubmissionParty(this.wire);

  final String wire;
}

class SubmissionSummaryDto {
  const SubmissionSummaryDto({
    required this.id,
    required this.status,
    required this.mechanicChecksComplete,
    this.hubId,
    this.confirmedAt,
  });

  factory SubmissionSummaryDto.fromJson(Map<String, dynamic> json) => SubmissionSummaryDto(
    id: jsonText(json['id']),
    status: jsonText(json['status']),
    mechanicChecksComplete: jsonBool(json['mechanicChecksComplete']),
    hubId: jsonTextOrNull(json['hubId']),
    confirmedAt: jsonDate(json['confirmedAt']),
  );

  static SubmissionSummaryDto? maybe(Object? raw) {
    final Map<String, dynamic> json = jsonMap(raw);
    return json.isEmpty ? null : SubmissionSummaryDto.fromJson(json);
  }

  final String id;
  final String status;
  final bool mechanicChecksComplete;
  final String? hubId;
  final DateTime? confirmedAt;

  bool get isConfirmed => status == 'CONFIRMED';

  bool get isFinished => isConfirmed && mechanicChecksComplete;
}

class SubmissionRequestDto {
  const SubmissionRequestDto({
    required this.id,
    required this.source,
    required this.status,
    required this.riderName,
    required this.riderMobile,
    required this.createdAt,
    this.plannedDate,
    this.plannedHubId,
    this.reasonCode,
    this.notes,
    this.submission,
  });

  factory SubmissionRequestDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rider = jsonMap(json['rider']);
    final SubmissionSource source = json['source'] == 'EXCHANGE' ? SubmissionSource.exchange : SubmissionSource.returns;
    return SubmissionRequestDto(
      id: jsonText(json['id']),
      source: source,
      status: jsonText(json['status']),
      riderName: jsonText(rider['name']),
      riderMobile: jsonText(rider['mobile']),
      createdAt: jsonDateOr(json['createdAt'], DateTime.now()),
      plannedDate: jsonDate(
        source == SubmissionSource.exchange ? json['plannedReturnDate'] : json['requestedTerminationDate'],
      ),
      plannedHubId: jsonTextOrNull(json['plannedHubId']),
      reasonCode: jsonTextOrNull(json['reasonCode']),
      notes: jsonTextOrNull(source == SubmissionSource.exchange ? json['reason'] : json['reasonText']),
      submission: SubmissionSummaryDto.maybe(json['vehicleSubmission']),
    );
  }

  final String id;
  final SubmissionSource source;
  final String status;
  final String riderName;
  final String riderMobile;
  final DateTime createdAt;
  final DateTime? plannedDate;
  final String? plannedHubId;
  final String? reasonCode;
  final String? notes;
  final SubmissionSummaryDto? submission;
}

class SubmissionQueuePage {
  const SubmissionQueuePage({required this.items, required this.page, required this.hasMore});

  final List<SubmissionRequestDto> items;
  final int page;
  final bool hasMore;
}

class SubmissionBattery {
  const SubmissionBattery({required this.id, this.code, this.serialNumber});

  final String id;
  final String? code;
  final String? serialNumber;
}

class SubmissionController {
  const SubmissionController({required this.id, this.number});

  final String id;
  final String? number;
}

class SubmissionAssets {
  const SubmissionAssets({
    this.vehicleNumber,
    this.chassisNumber,
    this.batteries = const [],
    this.controllers = const [],
    this.iotDeviceId,
  });

  factory SubmissionAssets.fromJson(Map<String, dynamic> json) => SubmissionAssets(
    vehicleNumber: jsonTextOrNull(json['vehicleNumber']),
    chassisNumber: jsonTextOrNull(json['chassisNumber']),
    batteries: [
      for (final Map<String, dynamic> row in jsonMaps(json['batteries']))
        SubmissionBattery(
          id: jsonText(row['id']),
          code: jsonTextOrNull(row['code']),
          serialNumber: jsonTextOrNull(row['serialNumber']),
        ),
    ],
    controllers: [
      for (final Map<String, dynamic> row in jsonMaps(json['controllers']))
        SubmissionController(id: jsonText(row['id']), number: jsonTextOrNull(row['number'])),
    ],
    iotDeviceId: jsonTextOrNull(json['iotDeviceId']),
  );

  final String? vehicleNumber;
  final String? chassisNumber;
  final List<SubmissionBattery> batteries;
  final List<SubmissionController> controllers;
  final String? iotDeviceId;
}

class SubmissionPhotoDto {
  const SubmissionPhotoDto({required this.id, required this.photoType, this.uploadedAt});

  factory SubmissionPhotoDto.fromJson(Map<String, dynamic> json) => SubmissionPhotoDto(
    id: jsonText(json['id']),
    photoType: jsonText(json['photoType']),
    uploadedAt: jsonDate(json['uploadedAt']),
  );

  final String id;
  final String photoType;
  final DateTime? uploadedAt;
}

class SubmissionPenaltyItemDto {
  const SubmissionPenaltyItemDto({
    required this.priceId,
    required this.code,
    required this.category,
    required this.description,
    required this.quantity,
    required this.unitAmount,
    required this.amount,
    required this.currency,
    required this.details,
    required this.evidencePhotoIds,
  });

  factory SubmissionPenaltyItemDto.fromJson(Map<String, dynamic> json) => SubmissionPenaltyItemDto(
    priceId: jsonText(json['priceId']),
    code: jsonText(json['code']),
    category: PenaltyCategory.parse(json['category']),
    description: jsonText(json['description']),
    quantity: jsonIntOrNull(json['quantity']) ?? 1,
    unitAmount: jsonNum(json['unitAmount']),
    amount: jsonNum(json['amount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    details: jsonText(json['details']),
    evidencePhotoIds: jsonStrings(json['evidencePhotoIds']),
  );

  final String priceId;
  final String code;
  final PenaltyCategory category;
  final String description;
  final int quantity;
  final num unitAmount;
  final num amount;
  final String currency;
  final String details;
  final List<String> evidencePhotoIds;
}

class SubmissionReportDto {
  const SubmissionReportDto({
    required this.id,
    required this.stage,
    required this.status,
    required this.mechanicName,
    required this.summary,
    required this.safeForReuse,
    required this.checksComplete,
    required this.evidencePhotoIds,
    required this.items,
    required this.totalAmount,
    required this.currency,
    required this.riderVerified,
    required this.teamLeadVerified,
    required this.createdAt,
    this.unsafeReason,
    this.riderBypassReason,
    this.teamLeadBypassReason,
    this.confirmedAt,
    this.cancellationReason,
  });

  factory SubmissionReportDto.fromJson(Map<String, dynamic> json) => SubmissionReportDto(
    id: jsonText(json['id']),
    stage: SubmissionStage.parse(json['stage']),
    status: SubmissionReportStatus.parse(json['status']),
    mechanicName: jsonText(json['mechanicName']),
    summary: jsonText(json['summary']),
    safeForReuse: jsonBool(json['safeForReuse']),
    checksComplete: jsonBool(json['checksComplete']),
    evidencePhotoIds: jsonStrings(json['evidencePhotoIds']),
    items: jsonMaps(json['items']).map(SubmissionPenaltyItemDto.fromJson).toList(growable: false),
    totalAmount: jsonNum(json['totalAmount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    riderVerified: jsonTextOrNull(json['riderVerifiedUserId']) != null,
    teamLeadVerified: jsonTextOrNull(json['teamLeadVerifiedUserId']) != null,
    createdAt: jsonDateOr(json['createdAt'], DateTime.now()),
    unsafeReason: jsonTextOrNull(json['unsafeReason']),
    riderBypassReason: jsonTextOrNull(json['riderBypassReason']),
    teamLeadBypassReason: jsonTextOrNull(json['teamLeadBypassReason']),
    confirmedAt: jsonDate(json['confirmedAt']),
    cancellationReason: jsonTextOrNull(json['cancellationReason']),
  );

  final String id;
  final SubmissionStage stage;
  final SubmissionReportStatus status;
  final String mechanicName;
  final String summary;
  final bool safeForReuse;
  final bool checksComplete;
  final List<String> evidencePhotoIds;
  final List<SubmissionPenaltyItemDto> items;
  final num totalAmount;
  final String currency;
  final bool riderVerified;
  final bool teamLeadVerified;
  final DateTime createdAt;
  final String? unsafeReason;
  final String? riderBypassReason;
  final String? teamLeadBypassReason;
  final DateTime? confirmedAt;
  final String? cancellationReason;

  bool get isOpen => status == SubmissionReportStatus.draft || status == SubmissionReportStatus.submitted;
}

class VehicleSubmissionDto {
  const VehicleSubmissionDto({
    required this.id,
    required this.source,
    required this.requestId,
    required this.status,
    required this.mechanicChecksComplete,
    required this.inspectionId,
    required this.hubName,
    required this.riderName,
    required this.riderMobile,
    required this.assets,
    required this.requiredPhotoTypes,
    required this.missingPhotoTypes,
    required this.photos,
    required this.reports,
    required this.nextAction,
    required this.createdAt,
    this.guidance,
    this.confirmedAt,
  });

  factory VehicleSubmissionDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> hub = jsonMap(json['hub']);
    final Map<String, dynamic> rider = jsonMap(json['rider']);
    final String? returnRequestId = jsonTextOrNull(json['returnRequestId']);
    return VehicleSubmissionDto(
      id: jsonText(json['id']),
      source: returnRequestId != null ? SubmissionSource.returns : SubmissionSource.exchange,
      requestId: returnRequestId ?? jsonText(json['exchangeRequestId']),
      status: jsonText(json['status']),
      mechanicChecksComplete: jsonBool(json['mechanicChecksComplete']),
      inspectionId: jsonText(json['inspectionId']),
      hubName: jsonText(hub['name']),
      riderName: jsonText(rider['name']),
      riderMobile: jsonText(rider['mobile']),
      assets: SubmissionAssets.fromJson(jsonMap(json['assetSnapshot'])),
      requiredPhotoTypes: jsonStrings(json['requiredPhotoTypes']),
      missingPhotoTypes: jsonStrings(json['missingPhotoTypes']),
      photos: jsonMaps(json['photos']).map(SubmissionPhotoDto.fromJson).toList(growable: false),
      reports: jsonMaps(json['reports']).map(SubmissionReportDto.fromJson).toList(growable: false),
      nextAction: SubmissionNextAction.parse(json['nextAction']),
      createdAt: jsonDateOr(json['createdAt'], DateTime.now()),
      guidance: jsonTextOrNull(json['confirmationGuidance']),
      confirmedAt: jsonDate(json['confirmedAt']),
    );
  }

  final String id;
  final SubmissionSource source;
  final String requestId;
  final String status;
  final bool mechanicChecksComplete;
  final String inspectionId;
  final String hubName;
  final String riderName;
  final String riderMobile;
  final SubmissionAssets assets;
  final List<String> requiredPhotoTypes;
  final List<String> missingPhotoTypes;
  final List<SubmissionPhotoDto> photos;
  final List<SubmissionReportDto> reports;
  final SubmissionNextAction nextAction;
  final DateTime createdAt;
  final String? guidance;
  final DateTime? confirmedAt;

  bool get isConfirmed => status == 'CONFIRMED';

  SubmissionReportDto? get openReport => reports.where((report) => report.isOpen).lastOrNull;

  SubmissionPhotoDto? photoFor(String photoType) => photos.where((photo) => photo.photoType == photoType).lastOrNull;
}

class SubmissionOtpRecipient {
  const SubmissionOtpRecipient({
    required this.party,
    required this.available,
    this.phone,
    this.otpRequestId,
    this.expiresAt,
    this.message,
    this.error,
  });

  factory SubmissionOtpRecipient.fromJson(Map<String, dynamic> json) => SubmissionOtpRecipient(
    party: json['party'] == 'TEAM_LEAD' ? SubmissionParty.teamLead : SubmissionParty.rider,
    available: jsonBool(json['available']),
    phone: jsonTextOrNull(json['phone']),
    otpRequestId: jsonTextOrNull(json['otpRequestId']),
    expiresAt: jsonDate(json['expiresAt']),
    message: jsonTextOrNull(json['message']),
    error: jsonTextOrNull(json['error']),
  );

  final SubmissionParty party;
  final bool available;
  final String? phone;
  final String? otpRequestId;
  final DateTime? expiresAt;
  final String? message;
  final String? error;

  bool get sent => otpRequestId != null;
}

class SubmissionOtpDispatch {
  const SubmissionOtpDispatch({required this.amount, required this.currency, required this.recipients, this.guidance});

  factory SubmissionOtpDispatch.fromJson(Map<String, dynamic> json) => SubmissionOtpDispatch(
    amount: jsonNum(json['amount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    recipients: jsonMaps(json['recipients']).map(SubmissionOtpRecipient.fromJson).toList(growable: false),
    guidance: jsonTextOrNull(json['guidance']),
  );

  final num amount;
  final String currency;
  final List<SubmissionOtpRecipient> recipients;
  final String? guidance;

  SubmissionOtpRecipient? recipient(SubmissionParty party) =>
      recipients.where((recipient) => recipient.party == party).firstOrNull;
}

class SubmissionHubOption {
  const SubmissionHubOption({
    required this.id,
    required this.name,
    this.code,
    this.city,
    this.latitude,
    this.longitude,
  });

  factory SubmissionHubOption.fromJson(Map<String, dynamic> json) => SubmissionHubOption(
    id: jsonText(json['id']),
    name: jsonText(json['name']),
    code: jsonTextOrNull(json['code']),
    city: jsonTextOrNull(json['city']),
    latitude: jsonNumOrNull(json['latitude'])?.toDouble(),
    longitude: jsonNumOrNull(json['longitude'])?.toDouble(),
  );

  final String id;
  final String name;
  final String? code;
  final String? city;
  final double? latitude;
  final double? longitude;
}

class SubmissionOptions {
  const SubmissionOptions({required this.hubs, required this.hasActiveVehicle, this.defaultHub, this.selection});

  factory SubmissionOptions.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> defaultHub = jsonMap(json['defaultHub']);
    return SubmissionOptions(
      hubs: jsonMaps(json['hubs']).map(SubmissionHubOption.fromJson).toList(growable: false),
      hasActiveVehicle: jsonMap(json['activeAllocation']).isNotEmpty,
      defaultHub: defaultHub.isEmpty ? null : SubmissionHubOption.fromJson(defaultHub),
      selection: jsonTextOrNull(json['selection']),
    );
  }

  final List<SubmissionHubOption> hubs;
  final bool hasActiveVehicle;
  final SubmissionHubOption? defaultHub;
  final String? selection;
}

class SubmissionPenaltyInput {
  const SubmissionPenaltyInput({
    required this.priceId,
    required this.quantity,
    required this.details,
    required this.evidencePhotoIds,
  });

  final String priceId;
  final int quantity;
  final String details;
  final List<String> evidencePhotoIds;

  Map<String, dynamic> toJson() => {
    'priceId': priceId,
    'quantity': quantity,
    'details': details,
    'evidencePhotoIds': evidencePhotoIds,
  };
}

class SubmissionReportInput {
  const SubmissionReportInput({
    required this.stage,
    required this.mechanicName,
    required this.summary,
    required this.safeForReuse,
    required this.checksComplete,
    required this.evidencePhotoIds,
    required this.items,
    this.unsafeReason,
  });

  final SubmissionStage stage;
  final String mechanicName;
  final String summary;
  final bool safeForReuse;
  final bool checksComplete;
  final List<String> evidencePhotoIds;
  final List<SubmissionPenaltyInput> items;
  final String? unsafeReason;

  Map<String, dynamic> toJson() => {
    'stage': stage.wire,
    'mechanicName': mechanicName,
    'summary': summary,
    'safeForReuse': safeForReuse,
    if (!safeForReuse) 'unsafeReason': unsafeReason,
    'checksComplete': checksComplete,
    'evidencePhotoIds': evidencePhotoIds,
    'items': [for (final SubmissionPenaltyInput item in items) item.toJson()],
  };
}

String plannedDateWire(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class VehicleSubmissionApi {
  const VehicleSubmissionApi(this._client);

  final ApiClient _client;

  static const String _staff = '/client/vehicle-submissions';
  static const String _reports = '/client/vehicle-submission-reports';
  static const String _rider = '/rider-app/vehicle-submissions';

  Future<Result<SubmissionOptions>> options({double? latitude, double? longitude}) => _client.get<SubmissionOptions>(
    '$_rider/options',
    query: {
      if (latitude != null && longitude != null) ...{'latitude': latitude, 'longitude': longitude},
    },
    parse: (data) => SubmissionOptions.fromJson(jsonMap(data)),
  );

  Future<Result<VehicleSubmissionDto>> riderDetail(String id) =>
      _client.get<VehicleSubmissionDto>('$_rider/$id', parse: (data) => VehicleSubmissionDto.fromJson(jsonMap(data)));

  Future<Result<String>> riderPhotoUrl(String id, String photoId) =>
      _client.get<String>('$_rider/$id/photos/$photoId/url', parse: _url);

  Future<Result<SubmissionQueuePage>> queue({
    required SubmissionSource source,
    required SubmissionPhase phase,
    int page = 1,
    int limit = 20,
  }) => _client.get<SubmissionQueuePage>(
    '$_staff/requests',
    query: {'source': source.wire, 'phase': phase.wire, 'page': page, 'limit': limit},
    parse: (data) {
      final List<Map<String, dynamic>> rows = jsonMaps(data);
      return SubmissionQueuePage(
        items: rows.map(SubmissionRequestDto.fromJson).toList(growable: false),
        page: page,
        hasMore: rows.length >= limit,
      );
    },
  );

  Future<Result<String>> start({required SubmissionSource source, required String requestId, String? hubId}) =>
      _client.post<String>(
        source == SubmissionSource.returns
            ? '/client/ride-returns/$requestId/submission/start'
            : '/vehicle-exchanges/$requestId/submission/start',
        body: {'hubId': ?hubId},
        parse: (data) => jsonText(jsonMap(data)['id']),
      );

  Future<Result<VehicleSubmissionDto>> detail(String id) =>
      _client.get<VehicleSubmissionDto>('$_staff/$id', parse: (data) => VehicleSubmissionDto.fromJson(jsonMap(data)));

  Future<Result<String>> photoUrl(String id, String photoId) =>
      _client.get<String>('$_staff/$id/photos/$photoId/url', parse: _url);

  Future<Result<List<PenaltyPriceDto>>> penaltyPrices() => _client.get<List<PenaltyPriceDto>>(
    '/client/return-penalty-prices',
    parse: (data) => jsonMaps(data).map(PenaltyPriceDto.fromJson).toList(growable: false),
  );

  Future<Result<void>> recordReport(String id, SubmissionReportInput input, {required String idempotencyKey}) =>
      _client.post<void>(
        '$_staff/$id/reports',
        headers: {'Idempotency-Key': idempotencyKey},
        body: input.toJson(),
        parse: (_) {},
      );

  Future<Result<void>> impose(String reportId) => _client.post<void>('$_reports/$reportId/impose', parse: (_) {});

  Future<Result<void>> cancelReport(String reportId, String reason) =>
      _client.post<void>('$_reports/$reportId/cancel', body: {'reason': reason}, parse: (_) {});

  Future<Result<SubmissionOtpDispatch>> requestOtps(String reportId, {SubmissionParty? party}) =>
      _client.post<SubmissionOtpDispatch>(
        '$_reports/$reportId/otp/request',
        body: {'party': party?.wire ?? 'BOTH'},
        parse: (data) => SubmissionOtpDispatch.fromJson(jsonMap(data)),
      );

  Future<Result<void>> verifyOtp(
    String reportId, {
    required SubmissionParty party,
    required String otpRequestId,
    required String code,
  }) async {
    await _client.ensureFreshSession();
    return _client.post<void>(
      '$_reports/$reportId/otp/verify',
      body: {'party': party.wire, 'otpRequestId': otpRequestId, 'code': code},
      refreshOnUnauthorized: false,
      parse: (_) {},
    );
  }

  Future<Result<void>> confirm(String reportId, {String? riderBypassReason, String? teamLeadBypassReason}) =>
      _client.post<void>(
        '$_reports/$reportId/confirm',
        body: {'riderBypassReason': ?riderBypassReason, 'teamLeadBypassReason': ?teamLeadBypassReason},
        parse: (_) {},
      );

  Future<Result<String>> createStaffReturn({
    required String riderId,
    required DateTime plannedDate,
    required String idempotencyKey,
    String reasonCode = 'VEHICLE_RETURN',
    String? hubId,
  }) => _client.post<String>(
    '/client/ride-returns',
    headers: {'Idempotency-Key': idempotencyKey},
    body: {
      'riderId': riderId,
      'reasonCode': reasonCode,
      'plannedReturnDate': plannedDateWire(plannedDate),
      'plannedHubId': ?hubId,
    },
    parse: (data) => jsonText(jsonMap(data)['id']),
  );

  static String _url(dynamic data) => data is Map ? jsonText(data['url']) : jsonText(data);
}
