import 'package:evseye_core/evseye_core.dart';

import '../../../core/location/geo_point.dart';
import '../domain/entities/nearby_hub.dart';
import '../domain/nearby_hubs_repository.dart';

class NearbyHubsRepositoryImpl implements NearbyHubsRepository {
  const NearbyHubsRepositoryImpl(this._api);

  final RiderHubsApi _api;

  @override
  Future<Result<List<NearbyHub>>> nearby(GeoPoint origin) async => (await _api.nearby(
    latitude: origin.latitude,
    longitude: origin.longitude,
  )).map((hubs) => [for (final NearbyHubDto hub in hubs) _hub(hub)]);

  NearbyHub _hub(NearbyHubDto dto) => NearbyHub(
    id: dto.id,
    name: dto.name,
    address: dto.address,
    position: GeoPoint(latitude: dto.latitude, longitude: dto.longitude),
    distanceMeters: (dto.roadMeters ?? dto.straightLineMeters).toDouble(),
    etaMinutes: dto.etaMinutes,
  );
}
