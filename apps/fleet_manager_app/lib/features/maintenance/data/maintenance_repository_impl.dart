import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/maintenance_vehicle.dart';
import '../domain/maintenance_repository.dart';
import '../domain/usecases/maintenance_usecases.dart';

class MaintenanceRepositoryImpl implements MaintenanceRepository {
  const MaintenanceRepositoryImpl(this._api, this._media);

  final ApiClient _api;
  final MediaApi _media;

  static const String _base = '/fleet-manager/maintenance/fleets';
  static const int _pageSize = 20;
  static final RegExp _reportReason = RegExp(r'^Submission report [0-9a-fA-F-]{36}:\s*(.*)$', dotAll: true);

  @override
  Future<Result<MaintenanceVehicleList>> vehicles(MaintenanceQuery query) {
    final String search = query.search.trim();
    return _api.get<MaintenanceVehicleList>(
      _base,
      query: {
        'page': query.page,
        'pageSize': _pageSize,
        'hubId': ?query.hubId,
        if (search.isNotEmpty) 'search': search,
      },
      parse: (data) => _list(_map(data)),
    );
  }

  @override
  Future<Result<MaintenanceVehicleDetail>> vehicle(String fleetId) =>
      _api.get<MaintenanceVehicleDetail>('$_base/$fleetId', parse: (data) => _detail(_map(data)));

  @override
  Future<Result<String>> photoUrl(String photoId) => _media.downloadUrl(photoId);

  @override
  Future<Result<void>> changeStatus(String fleetId, String status) =>
      _api.patch<void>('/fleets/$fleetId/status', body: {'status': status}, parse: (_) {});

  static MaintenanceVehicleList _list(Map<String, dynamic> json) {
    final Map<String, dynamic> meta = _map(json['meta']);
    final int page = _int(meta['page']);
    return MaintenanceVehicleList(
      items: [for (final Map<String, dynamic> item in _maps(json['items'])) _vehicle(item)],
      page: page < 1 ? 1 : page,
      totalPages: _int(meta['totalPages']),
      total: _int(meta['total']),
      underMaintenance: _int(_map(json['summary'])['underMaintenance']),
    );
  }

  static MaintenanceVehicleDetail _detail(Map<String, dynamic> json) {
    final Map<String, dynamic> meta = _map(json['historyMeta']);
    final int historyLimit = _int(meta['statusHistoryLimit']);
    final int reportLimit = _int(meta['mechanicReportLimit']);
    return MaintenanceVehicleDetail(
      vehicle: _vehicle(_map(json['fleet']), report: _report(json['latestMechanicReport'])),
      history: [for (final Map<String, dynamic> row in _maps(json['statusHistory'])) ?_change(row)],
      reports: [for (final Map<String, dynamic> row in _maps(json['mechanicReports'])) ?_report(row)],
      photos: [for (final Map<String, dynamic> row in _maps(json['evidencePhotos'])) ?_photo(row)],
      moreHistory: meta['hasMoreStatusHistory'] == true,
      moreReports: meta['hasMoreMechanicReports'] == true,
      historyLimit: historyLimit > 0 ? historyLimit : 100,
      reportLimit: reportLimit > 0 ? reportLimit : 50,
    );
  }

  static MaintenanceVehicle _vehicle(Map<String, dynamic> json, {MechanicReport? report}) {
    final Map<String, dynamic> oem = _map(json['oem']);
    final Map<String, dynamic> move = _map(json['lastRecordedMaintenanceChange']);
    final DateTime? movedAt = _date(move['createdAt']);
    final String fleetCode = _text(json['fleetCode']) ?? '';
    return MaintenanceVehicle(
      id: _text(json['id']) ?? '',
      fleetCode: fleetCode,
      vehicleNumber: _text(json['vehicleNumber']) ?? fleetCode,
      chassisNumber: _text(json['chassisNumber']) ?? '',
      modelName: _text(json['modelName']),
      variantName: _text(json['variantName']),
      colour: _text(json['colour']),
      onboardingStatus: _text(json['onboardingStatus']) ?? '',
      allocationEnabled: json['allocationEnabled'] != false,
      odometerKm: num.tryParse(json['odometerKm']?.toString() ?? ''),
      oemName: _text(oem['displayName']) ?? _text(oem['name']),
      categoryName: _text(_map(json['vehicleCategory'])['name']),
      typeName: _text(_map(json['vehicleType'])['name']),
      hub: _hub(json['hub']),
      currentHub: _hub(json['currentHub']),
      homeHub: _hub(json['homeHub']),
      updatedAt: _date(json['updatedAt']),
      movedToMaintenance: movedAt == null ? null : MaintenanceMove(at: movedAt),
      latestReport: report ?? _report(json['latestMechanicReport']),
      status: _text(json['status']) ?? 'MAINTENANCE',
    );
  }

  static MaintenanceHub? _hub(Object? raw) {
    final Map<String, dynamic> json = _map(raw);
    final String? id = _text(json['id']);
    if (id == null) return null;
    final String code = _text(json['code']) ?? '';
    return MaintenanceHub(id: id, code: code, name: _text(json['name']) ?? code);
  }

  static MechanicReport? _report(Object? raw) {
    final Map<String, dynamic> json = _map(raw);
    final String? id = _text(json['id']);
    final DateTime? createdAt = _date(json['createdAt']);
    if (id == null || createdAt == null) return null;
    return MechanicReport(
      id: id,
      deep: json['stage']?.toString().toUpperCase() == 'DEEP',
      mechanicName: _text(json['mechanicName']) ?? '',
      summary: _text(json['summary']) ?? '',
      safeForReuse: json['safeForReuse'] == true,
      unsafeReason: _text(json['unsafeReason']),
      checksComplete: json['checksComplete'] == true,
      evidencePhotoIds: [for (final Object? photoId in json['evidencePhotoIds'] as List? ?? const []) ?_text(photoId)],
      createdAt: createdAt,
      confirmedAt: _date(json['confirmedAt']),
      fleetStatus: MaintenanceFleetStatus.maybe(json['fleetStatus']),
    );
  }

  static MaintenanceStatusChange? _change(Map<String, dynamic> json) {
    final String? id = _text(json['id']);
    final String? to = _text(json['toStatus']);
    final DateTime? at = _date(json['createdAt']);
    if (id == null || to == null || at == null) return null;
    final String? reason = _text(json['reason']);
    final RegExpMatch? report = reason == null ? null : _reportReason.firstMatch(reason);
    return MaintenanceStatusChange(
      id: id,
      from: _text(json['fromStatus']),
      to: to,
      reason: report == null ? reason : _text(report.group(1)),
      fromReport: report != null,
      at: at,
    );
  }

  static EvidencePhoto? _photo(Map<String, dynamic> json) {
    final String? id = _text(json['id']);
    if (id == null) return null;
    return EvidencePhoto(
      id: id,
      photoType: _text(json['photoType']) ?? '',
      mimeType: _text(json['mimeType']),
      uploadedAt: _date(json['uploadedAt']),
    );
  }

  static Map<String, dynamic> _map(Object? raw) => raw is Map ? Map<String, dynamic>.from(raw) : const {};

  static List<Map<String, dynamic>> _maps(Object? raw) => [
    if (raw is List)
      for (final Object? item in raw)
        if (item is Map) Map<String, dynamic>.from(item),
  ];

  static String? _text(Object? raw) {
    final String text = raw?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static DateTime? _date(Object? raw) => raw == null ? null : DateTime.tryParse(raw.toString())?.toLocal();

  static int _int(Object? raw) => raw is num ? raw.toInt() : int.tryParse(raw?.toString() ?? '') ?? 0;
}
