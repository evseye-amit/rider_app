import 'dart:math' as math;

import 'package:equatable/equatable.dart';

class GeoPoint extends Equatable {
  const GeoPoint({required this.latitude, required this.longitude});

  static const double _earthRadiusMeters = 6371000;

  final double latitude;
  final double longitude;

  double distanceTo(GeoPoint other) {
    final double latitudeDelta = _radians(other.latitude - latitude);
    final double longitudeDelta = _radians(other.longitude - longitude);
    final double sinLatitude = math.sin(latitudeDelta / 2);
    final double sinLongitude = math.sin(longitudeDelta / 2);
    final double haversine =
        sinLatitude * sinLatitude +
        math.cos(_radians(latitude)) * math.cos(_radians(other.latitude)) * sinLongitude * sinLongitude;
    return 2 * _earthRadiusMeters * math.asin(math.min(1, math.sqrt(haversine)));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;

  @override
  List<Object?> get props => [latitude, longitude];
}
