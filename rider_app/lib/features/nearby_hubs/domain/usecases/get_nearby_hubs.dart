import 'package:evseye_core/evseye_core.dart';

import '../../../../core/location/geo_point.dart';
import '../entities/nearby_hub.dart';
import '../nearby_hubs_repository.dart';

class GetNearbyHubs extends UseCase<List<NearbyHub>, GeoPoint> {
  const GetNearbyHubs(this._repository);

  final NearbyHubsRepository _repository;

  @override
  Future<Result<List<NearbyHub>>> call(GeoPoint params) => _repository.nearby(params);
}
