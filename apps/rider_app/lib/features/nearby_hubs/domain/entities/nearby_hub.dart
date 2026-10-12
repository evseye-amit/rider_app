import 'package:equatable/equatable.dart';

import '../../../../core/location/geo_point.dart';

class NearbyHub extends Equatable {
  const NearbyHub({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.distanceMeters,
    this.etaMinutes,
  });

  final String id;
  final String name;
  final String address;
  final GeoPoint position;
  final double distanceMeters;
  final int? etaMinutes;

  @override
  List<Object?> get props => [id, name, address, position, distanceMeters, etaMinutes];
}
