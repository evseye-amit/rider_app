import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/hub_profile.dart';
import '../domain/entities/hub_summary.dart';
import '../domain/hub_repository.dart';

class HubRepositoryImpl implements HubRepository {
  const HubRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<Result<List<HubProfile>>> listHubs() async {
    final Result<List<HubProfile>> result = await _api.get<List<HubProfile>>(
      '/hubs',
      parse: (data) {
        final List<dynamic> rows = data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>;
        return rows.map((e) => _hubFromApi(Map<String, dynamic>.from(e as Map))).toList(growable: false);
      },
    );
    return result.map((hubs) => [...hubs]..sort((a, b) => a.code.compareTo(b.code)));
  }

  static HubProfile _hubFromApi(Map<String, dynamic> json) {
    final String line1 = json['addressLine1']?.toString() ?? '';
    final String city = json['city']?.toString() ?? '';
    final String postal = json['postalCode']?.toString() ?? '';
    final String address = [line1, city, postal].where((p) => p.isNotEmpty).join(', ');

    return HubProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '—',
      code: json['code']?.toString() ?? '—',
      address: address.isEmpty ? '—' : address,
      city: city.isEmpty ? '—' : city,
      capacity: (json['vehicleCapacity'] as num?)?.toInt() ?? 0,
      openedOn: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      chargingBays: (json['chargingPoints'] as num?)?.toInt() ?? 0,
      serviceBays: 0,
      teamLeads: const [],
    );
  }

  @override
  Future<Result<HubSummary>> getSummary(String hubCode) async {
    final Map<String, dynamic> hub = await _hub(hubCode);
    final String? hubId = hub['id']?.toString();

    return _api.get<HubSummary>(
      '/fleet-manager/home',
      query: {if (hubId != null && hubId.isNotEmpty) 'hubId': hubId},
      parse: (data) {
        final Map<String, dynamic> home = _map(data);
        final Map<String, dynamic> selected = _map(home['hub']);
        final Map<String, dynamic> summary = _map(home['summary']);
        final Map<String, dynamic> fleet = _map(summary['fleetUtilisation']);
        final Map<String, dynamic> riders = _map(summary['riders']);
        final Map<String, dynamic> parking = _map(selected['parking']);

        int count(Map<String, dynamic> m, String key) => (m[key] as num?)?.toInt() ?? 0;

        return HubSummary(
          hubName: selected['name']?.toString() ?? hub['name']?.toString() ?? '—',
          hubCode: selected['code']?.toString() ?? hub['code']?.toString() ?? '—',
          fleetAllocated: count(fleet, 'allocated'),
          fleetTotal: count(fleet, 'total'),
          ridersPresent: count(riders, 'present'),
          ridersActive: count(riders, 'active'),
          parkingOccupied: count(parking, 'occupiedSlots'),
          parkingCapacity: count(parking, 'capacity'),
          queue: summary.isEmpty
              ? null
              : HubQueue(
                  allotments: count(summary, 'pendingAllocation'),
                  submissions: count(summary, 'pendingSubmission'),
                  readyForDeployment: count(summary, 'readyForDeployment'),
                  underMaintenance: count(summary, 'underMaintenance'),
                ),
        );
      },
    );
  }

  @override
  Future<Result<HubProfile>> getProfile(String hubCode) async {
    final Result<List<HubProfile>> hubs = await listHubs();
    return hubs.fold(Result<HubProfile>.err, (list) {
      for (final hub in list) {
        if (hub.code == hubCode) return Result.ok(hub);
      }
      return list.isEmpty ? Result.err(NotFoundFailure(ActiveLocale.strings.hubNoHubAssigned)) : Result.ok(list.first);
    });
  }

  static Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : const {};

  Future<Map<String, dynamic>> _hub(String hubCode) async {
    final Result<List<Map<String, dynamic>>> rows = await _api.get<List<Map<String, dynamic>>>(
      '/hubs',
      parse: (data) {
        final List<dynamic> raw = data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>;
        return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
      },
    );
    final List<Map<String, dynamic>> list = rows.valueOrNull ?? const [];
    if (list.isEmpty) return const {};
    for (final hub in list) {
      if (hub['code'] == hubCode) return hub;
    }
    return list.first;
  }
}
