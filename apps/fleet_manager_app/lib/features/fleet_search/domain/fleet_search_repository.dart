import 'package:evseye_core/evseye_core.dart';

import 'usecases/fleet_search_usecases.dart';

abstract interface class FleetSearchRepository {
  Future<Result<GlobalFleetPage>> search(ScooterSearchQuery query);

  Future<Result<GlobalFleetDetailDto>> scooter(String fleetId);

  Future<Result<List<GlobalFleetRiderDto>>> riders(String fleetId);
}
