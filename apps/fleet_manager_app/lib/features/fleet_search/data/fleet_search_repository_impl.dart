import 'package:evseye_core/evseye_core.dart';

import '../domain/fleet_search_repository.dart';
import '../domain/usecases/fleet_search_usecases.dart';

class FleetSearchRepositoryImpl implements FleetSearchRepository {
  const FleetSearchRepositoryImpl(this._api);

  final FleetSearchApi _api;

  @override
  Future<Result<GlobalFleetPage>> search(ScooterSearchQuery query) => _api.search(query: query.text, page: query.page);

  @override
  Future<Result<GlobalFleetDetailDto>> scooter(String fleetId) => _api.detail(fleetId);

  @override
  Future<Result<List<GlobalFleetRiderDto>>> riders(String fleetId) => _api.riders(fleetId);
}
