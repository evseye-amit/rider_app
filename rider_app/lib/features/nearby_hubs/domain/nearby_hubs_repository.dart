import 'package:evseye_core/evseye_core.dart';

import '../../../core/location/geo_point.dart';
import 'entities/nearby_hub.dart';

abstract interface class NearbyHubsRepository {
  Future<Result<List<NearbyHub>>> nearby(GeoPoint origin);
}
