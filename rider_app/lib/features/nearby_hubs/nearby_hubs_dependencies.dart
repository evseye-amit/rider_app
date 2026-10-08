import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/nearby_hubs_repository_impl.dart';
import 'domain/nearby_hubs_repository.dart';
import 'domain/usecases/get_nearby_hubs.dart';

final nearbyHubsRepositoryProvider = Provider<NearbyHubsRepository>(
  (ref) => NearbyHubsRepositoryImpl(ref.watch(riderHubsApiProvider)),
);

final getNearbyHubsProvider = Provider<GetNearbyHubs>((ref) => GetNearbyHubs(ref.watch(nearbyHubsRepositoryProvider)));
