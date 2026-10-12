import 'package:evseye_core/evseye_core.dart';

import '../../../core/location/geo_point.dart';
import '../domain/entities/swap_station.dart';
import '../domain/swap_stations_repository.dart';

class SwapStationsRepositoryImpl implements SwapStationsRepository {
  SwapStationsRepositoryImpl(this._api);

  final SwapStationsApi _api;

  List<SwapStation>? _cache;

  @override
  Future<Result<List<SwapStation>>> all() async {
    if (_cache case final List<SwapStation> cached) return Result.ok(cached);
    final Result<List<SwapStation>> result = (await _api.stations()).map(
      (stations) => [for (final SwapStationDto station in stations) _station(station)],
    );
    if (result case Ok<List<SwapStation>>(:final value)) _cache = value;
    return result;
  }

  SwapStation _station(SwapStationDto dto) => SwapStation(
    id: dto.id,
    name: dto.name,
    position: GeoPoint(latitude: dto.latitude, longitude: dto.longitude),
    area: dto.area,
    city: dto.city,
    units: dto.units,
  );
}
