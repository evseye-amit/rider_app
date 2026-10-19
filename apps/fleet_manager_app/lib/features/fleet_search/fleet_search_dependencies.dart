import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/fleet_search_repository_impl.dart';
import 'domain/fleet_search_repository.dart';
import 'domain/usecases/fleet_search_usecases.dart';

final fleetSearchRepositoryProvider = Provider<FleetSearchRepository>(
  (ref) => FleetSearchRepositoryImpl(ref.watch(fleetSearchApiProvider)),
);

final searchScootersProvider = Provider<SearchScooters>(
  (ref) => SearchScooters(ref.watch(fleetSearchRepositoryProvider)),
);

final getScooterProvider = Provider<GetScooter>((ref) => GetScooter(ref.watch(fleetSearchRepositoryProvider)));

final getScooterRidersProvider = Provider<GetScooterRiders>(
  (ref) => GetScooterRiders(ref.watch(fleetSearchRepositoryProvider)),
);
