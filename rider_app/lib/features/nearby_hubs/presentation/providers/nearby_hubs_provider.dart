import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../domain/entities/nearby_hub.dart';
import '../../nearby_hubs_dependencies.dart';

final nearbyHubsProvider = FutureProvider.autoDispose.family<List<NearbyHub>, GeoPoint>(
  (ref, origin) async => (await ref.watch(getNearbyHubsProvider)(origin)).getOrThrow(),
);
