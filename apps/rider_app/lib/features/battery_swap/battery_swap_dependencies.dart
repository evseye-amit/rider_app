import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/swap_stations_repository_impl.dart';
import 'domain/swap_stations_repository.dart';
import 'domain/usecases/get_nearby_swap_stations.dart';

final swapStationsRepositoryProvider = Provider<SwapStationsRepository>(
  (ref) => SwapStationsRepositoryImpl(ref.watch(swapStationsApiProvider)),
);

final getNearbySwapStationsProvider = Provider<GetNearbySwapStations>(
  (ref) => GetNearbySwapStations(ref.watch(swapStationsRepositoryProvider)),
);
