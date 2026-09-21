import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/rider.dart';
import '../domain/riders_repository.dart';

class RidersRepositoryImpl implements RidersRepository {
  const RidersRepositoryImpl(this._api);

  final ApiClient _api;

  static const int _maxPageSize = 100;

  @override
  Future<Result<List<Rider>>> getRiders() async {
    final List<Result<List<Map<String, dynamic>>>> results = await Future.wait([
      _api.get<List<Map<String, dynamic>>>('/riders', query: {'pageSize': _maxPageSize}, parse: _rows),
      _api.get<List<Map<String, dynamic>>>('/allocations', query: {'pageSize': _maxPageSize}, parse: _rows),
    ]);
    if (results[0] case Err<List<Map<String, dynamic>>>(:final failure)) return Result.err(failure);

    final Map<String, String> vehicles = {};
    if (results[1] case Ok<List<Map<String, dynamic>>>(:final value)) {
      for (final row in value) {
        if (row['status'] != 'ACTIVE') continue;
        final String? riderId = row['riderId']?.toString();
        final String? number = (row['fleet'] as Map?)?['vehicleNumber']?.toString();
        if (riderId != null && number != null && number.isNotEmpty) vehicles[riderId] = number;
      }
    }

    return Result.ok([
      for (final row in (results[0] as Ok<List<Map<String, dynamic>>>).value)
        _riderFrom(row, vehicles[row['id']?.toString()]),
    ]);
  }

  static List<Map<String, dynamic>> _rows(dynamic data) {
    final List<dynamic> raw = data is Map ? (data['items'] as List<dynamic>? ?? const []) : data as List<dynamic>;
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList(growable: false);
  }

  static Rider _riderFrom(Map<String, dynamic> json, String? vehicleNumber) {
    return Rider(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '—',

      riderCode: json['riderCode']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      teamLead: '',
      plan: '',
      state: _stateFrom(json['status']?.toString()),
      vehicleNumber: vehicleNumber,
      joinedOn: DateTime.tryParse(json['joiningDate']?.toString() ?? ''),
      kycStatus: null,
      exitReason: null,
    );
  }

  static RiderState _stateFrom(String? status) => switch (status) {
        'ACTIVE' => RiderState.active,
        'ONBOARDING' => RiderState.onboarding,
        _ => RiderState.exited,
      };
}
