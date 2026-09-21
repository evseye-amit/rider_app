import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/hub_profile.dart';
import '../domain/entities/hub_summary.dart';
import '../domain/hub_repository.dart';

class HubRepositoryImpl implements HubRepository {
  const HubRepositoryImpl(this._api);

  final ApiClient _api;

  static const int _maxPageSize = 100;

  @override
  Future<Result<List<HubProfile>>> listHubs() async {
    final Result<List<HubProfile>> result = await _api.get<List<HubProfile>>(
      '/hubs',
      parse: (data) {
        final List<dynamic> rows =
            data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>;
        return rows
            .map((e) => _hubFromApi(Map<String, dynamic>.from(e as Map)))
            .toList(growable: false);
      },
    );
    return result.map(
      (hubs) => [...hubs]..sort((a, b) => a.code.compareTo(b.code)),
    );
  }

  static HubProfile _hubFromApi(Map<String, dynamic> json) {
    final String line1 = json['addressLine1']?.toString() ?? '';
    final String city = json['city']?.toString() ?? '';
    final String postal = json['postalCode']?.toString() ?? '';
    final String address =
        [line1, city, postal].where((p) => p.isNotEmpty).join(', ');

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

    final Map<String, int> queues = await _queueCounts();

    return _api.get<HubSummary>(
      '/dashboard',
      parse: (data) {
        final Map<String, dynamic> d = Map<String, dynamic>.from(data as Map);
        final Map<String, dynamic> fleet = Map<String, dynamic>.from(d['fleet'] as Map? ?? const {});
        final Map<String, dynamic> riders = Map<String, dynamic>.from(d['riders'] as Map? ?? const {});
        final Map<String, dynamic> ops = Map<String, dynamic>.from(d['operations'] as Map? ?? const {});

        int count(Map<String, dynamic> m, String key) => (m[key] as num?)?.toInt() ?? 0;
        final int total = fleet.values.fold(0, (sum, v) => sum + ((v as num?)?.toInt() ?? 0));
        final int allocated = count(fleet, 'ALLOCATED') + count(fleet, 'IN_USE');

        return HubSummary(
          hubName: hub['name'] as String? ?? '—',
          hubCode: hub['code'] as String? ?? '—',
          fleet: FleetStatusBreakdown(
            total: total,
            allocated: allocated,
            available: count(fleet, 'AVAILABLE'),
            inService: count(fleet, 'MAINTENANCE') + count(fleet, 'INSPECTION_PENDING'),
            offRoad: count(fleet, 'OUT_OF_SERVICE'),
          ),
          ridersActive: count(riders, 'ACTIVE'),

          ridersPresent: 0,
          ridersOnboarding: count(riders, 'ONBOARDING'),
          utilisation: total == 0 ? 0 : allocated / total,
          uptime: 0,
          pendingAllocations: queues['waiting'] ?? 0,
          pendingDeallocations: queues['returns'] ?? 0,
          openMaintenance: 0,
          overdueMaintenance: 0,
          batteryHealthAverage: 0,
          chargingBaysBusy: 0,
          chargingBaysTotal: (hub['chargingPoints'] as num?)?.toInt() ?? 0,
          todayAllocations: count(ops, 'allocationsToday'),
          todayDeallocations: count(ops, 'deallocationsToday'),
          weeklyAllocations: const [],
          weeklyLabels: const [],
          alerts: const [],
        );
      },
    );
  }

  @override
  Future<Result<HubProfile>> getProfile(String hubCode) async {
    final Result<List<HubProfile>> hubs = await listHubs();
    return hubs.fold(
      Result<HubProfile>.err,
      (list) {
        for (final hub in list) {
          if (hub.code == hubCode) return Result.ok(hub);
        }
        return list.isEmpty
            ? const Result.err(NotFoundFailure('No hub is assigned to you.'))
            : Result.ok(list.first);
      },
    );
  }

  Future<Map<String, int>> _queueCounts() async {
    final Result<Map<String, int>> result = await _api.get<Map<String, int>>(
      '/allocations',
      query: {'pageSize': _maxPageSize},
      parse: (data) {
        final List<dynamic> rows = data is Map
            ? (data['items'] as List<dynamic>? ?? const [])
            : data as List<dynamic>;
        int waiting = 0;
        int returns = 0;
        for (final row in rows) {
          switch ((row as Map)['status']?.toString()) {
            case 'INITIATED' || 'INSPECTION_PENDING' || 'OTP_PENDING':
              waiting++;
            case 'DEALLOCATION_INITIATED':
              returns++;
          }
        }
        return {'waiting': waiting, 'returns': returns};
      },
    );
    return result.valueOrNull ?? const {'waiting': 0, 'returns': 0};
  }

  Future<Map<String, dynamic>> _hub(String hubCode) async {
    final Result<List<Map<String, dynamic>>> rows =
        await _api.get<List<Map<String, dynamic>>>(
      '/hubs',
      parse: (data) {
        final List<dynamic> raw = data is Map
            ? (data['items'] as List<dynamic>? ?? const [])
            : data as List<dynamic>;
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
