import 'package:evseye_core/evseye_core.dart';

import '../../../../core/location/geo_point.dart';
import '../entities/swap_station.dart';
import '../swap_stations_repository.dart';

class GetNearbySwapStations extends UseCase<List<SwapStation>, GeoPoint> {
  const GetNearbySwapStations(this._repository);

  static const int limit = 20;

  final SwapStationsRepository _repository;

  @override
  Future<Result<List<SwapStation>>> call(GeoPoint params) async => (await _repository.all()).map((stations) {
    final List<SwapStation> measured = [for (final SwapStation station in stations) station.withDistanceFrom(params)]
      ..sort((a, b) => (a.distanceMeters ?? double.infinity).compareTo(b.distanceMeters ?? double.infinity));
    return measured.take(limit).toList(growable: false);
  });
}
