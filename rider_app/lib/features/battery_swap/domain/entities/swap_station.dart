import 'package:equatable/equatable.dart';

import '../../../../core/location/geo_point.dart';

class SwapStation extends Equatable {
  const SwapStation({
    required this.id,
    required this.name,
    required this.position,
    this.area,
    this.city,
    this.units,
    this.distanceMeters,
  });

  final String id;
  final String name;
  final GeoPoint position;
  final String? area;
  final String? city;
  final int? units;
  final double? distanceMeters;

  String get address => [?area, ?city].where((part) => part.isNotEmpty).join(', ');

  SwapStation withDistanceFrom(GeoPoint origin) => SwapStation(
    id: id,
    name: name,
    position: position,
    area: area,
    city: city,
    units: units,
    distanceMeters: origin.distanceTo(position),
  );

  @override
  List<Object?> get props => [id, name, position, area, city, units, distanceMeters];
}
