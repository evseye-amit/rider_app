import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../battery_swap_dependencies.dart';
import '../../domain/entities/swap_station.dart';

final nearbySwapStationsProvider = FutureProvider.autoDispose.family<List<SwapStation>, GeoPoint>(
  (ref, origin) async => (await ref.watch(getNearbySwapStationsProvider)(origin)).getOrThrow(),
);
