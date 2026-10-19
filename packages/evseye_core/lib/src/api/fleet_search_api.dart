import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class GlobalFleetDto {
  const GlobalFleetDto({
    required this.id,
    required this.fleetCode,
    required this.vehicleNumber,
    required this.chassisNumber,
    required this.status,
    required this.canManage,
    this.modelName,
    this.variantName,
    this.colour,
    this.oemName,
    this.vehicleTypeName,
    this.hubId,
    this.hubName,
    this.hubCity,
    this.accessReason,
  });

  factory GlobalFleetDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> hub = jsonMap(json['currentHub']);
    final Map<String, dynamic> access = jsonMap(json['access']);
    final String fleetCode = jsonText(json['fleetCode']);
    return GlobalFleetDto(
      id: jsonText(json['id']),
      fleetCode: fleetCode,
      vehicleNumber: jsonTextOrNull(json['vehicleNumber']) ?? fleetCode,
      chassisNumber: jsonText(json['chassisNumber']),
      status: jsonText(json['status']),
      canManage: jsonBool(access['canManage']),
      modelName: jsonTextOrNull(json['modelName']),
      variantName: jsonTextOrNull(json['variantName']),
      colour: jsonTextOrNull(json['colour']),
      oemName: jsonTextOrNull(jsonMap(json['oem'])['name']),
      vehicleTypeName: jsonTextOrNull(jsonMap(json['vehicleType'])['name']),
      hubId: jsonTextOrNull(hub['id']),
      hubName: jsonTextOrNull(hub['name']),
      hubCity: jsonTextOrNull(hub['city']),
      accessReason: jsonTextOrNull(access['reason']),
    );
  }

  final String id;
  final String fleetCode;
  final String vehicleNumber;
  final String chassisNumber;
  final String status;
  final bool canManage;
  final String? modelName;
  final String? variantName;
  final String? colour;
  final String? oemName;
  final String? vehicleTypeName;
  final String? hubId;
  final String? hubName;
  final String? hubCity;
  final String? accessReason;

  String get modelLine => [?modelName, ?variantName].join(' · ');
}

class GlobalFleetAllocationDto {
  const GlobalFleetAllocationDto({
    required this.id,
    required this.status,
    this.allocatedAt,
    this.riderId,
    this.riderCode,
    this.riderName,
  });

  factory GlobalFleetAllocationDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rider = jsonMap(json['rider']);
    return GlobalFleetAllocationDto(
      id: jsonText(json['id']),
      status: jsonText(json['status']),
      allocatedAt: jsonDate(json['allocatedAt']),
      riderId: jsonTextOrNull(rider['id']),
      riderCode: jsonTextOrNull(rider['riderCode']),
      riderName: jsonTextOrNull(rider['name']),
    );
  }

  final String id;
  final String status;
  final DateTime? allocatedAt;
  final String? riderId;
  final String? riderCode;
  final String? riderName;
}

class GlobalFleetSubmissionDto {
  const GlobalFleetSubmissionDto({
    required this.id,
    required this.status,
    required this.mechanicChecksComplete,
    required this.isExchange,
    this.confirmedAt,
  });

  factory GlobalFleetSubmissionDto.fromJson(Map<String, dynamic> json) => GlobalFleetSubmissionDto(
    id: jsonText(json['id']),
    status: jsonText(json['status']),
    mechanicChecksComplete: jsonBool(json['mechanicChecksComplete']),
    isExchange: jsonTextOrNull(json['exchangeRequestId']) != null,
    confirmedAt: jsonDate(json['confirmedAt']),
  );

  final String id;
  final String status;
  final bool mechanicChecksComplete;
  final bool isExchange;
  final DateTime? confirmedAt;

  bool get isCancelled => status == 'CANCELLED';

  bool get isDone => status == 'CONFIRMED' && mechanicChecksComplete;
}

class GlobalFleetDetailDto {
  const GlobalFleetDetailDto({required this.fleet, this.allocation, this.submission, this.frontPhotoUrl});

  factory GlobalFleetDetailDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> allocation = jsonMap(json['allocation']);
    final Map<String, dynamic> submission = jsonMap(json['submission']);
    return GlobalFleetDetailDto(
      fleet: GlobalFleetDto.fromJson(json),
      allocation: allocation.isEmpty ? null : GlobalFleetAllocationDto.fromJson(allocation),
      submission: submission.isEmpty ? null : GlobalFleetSubmissionDto.fromJson(submission),
      frontPhotoUrl: jsonTextOrNull(jsonMap(json['frontPhoto'])['url']),
    );
  }

  final GlobalFleetDto fleet;
  final GlobalFleetAllocationDto? allocation;
  final GlobalFleetSubmissionDto? submission;
  final String? frontPhotoUrl;
}

class GlobalFleetRiderDto {
  const GlobalFleetRiderDto({
    required this.allocationId,
    required this.status,
    required this.riderName,
    this.riderCode,
    this.from,
    this.to,
  });

  factory GlobalFleetRiderDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rider = jsonMap(json['rider']);
    return GlobalFleetRiderDto(
      allocationId: jsonText(json['id']),
      status: jsonText(json['status']),
      riderName: jsonTextOrNull(rider['name']) ?? '—',
      riderCode: jsonTextOrNull(rider['riderCode']),
      from: jsonDate(json['allocatedAt']) ?? jsonDate(json['createdAt']),
      to: jsonDate(json['deallocatedAt']),
    );
  }

  final String allocationId;
  final String status;
  final String riderName;
  final String? riderCode;
  final DateTime? from;
  final DateTime? to;
}

class GlobalFleetPage {
  const GlobalFleetPage({required this.items, required this.page, required this.hasMore});

  final List<GlobalFleetDto> items;
  final int page;
  final bool hasMore;
}

class FleetSearchApi {
  const FleetSearchApi(this._client);

  final ApiClient _client;

  static const String _base = '/mobile-deployments/fleet-manager/fleets';
  static const int _historySize = 50;

  Future<Result<GlobalFleetPage>> search({required String query, int page = 1, int limit = 25}) =>
      _client.get<GlobalFleetPage>(
        '$_base/search',
        query: {'search': query, 'page': page, 'limit': limit},
        parse: (data) {
          final List<GlobalFleetDto> items = jsonMaps(data).map(GlobalFleetDto.fromJson).toList(growable: false);
          return GlobalFleetPage(items: items, page: page, hasMore: items.length >= limit);
        },
      );

  Future<Result<GlobalFleetDetailDto>> detail(String id) =>
      _client.get<GlobalFleetDetailDto>('$_base/$id', parse: (data) => GlobalFleetDetailDto.fromJson(jsonMap(data)));

  Future<Result<List<GlobalFleetRiderDto>>> riders(String id) => _client.get<List<GlobalFleetRiderDto>>(
    '/allocations',
    query: {'fleetId': id, 'pageSize': _historySize},
    parse: (data) => jsonMaps(jsonMap(data)['items']).map(GlobalFleetRiderDto.fromJson).toList(growable: false),
  );
}
