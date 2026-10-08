import '../location/geo_point.dart';

class MapPlace {
  const MapPlace({
    required this.id,
    required this.title,
    required this.position,
    this.subtitle,
    this.distanceMeters,
    this.etaMinutes,
    this.badge,
  });

  final String id;
  final String title;
  final GeoPoint position;
  final String? subtitle;
  final double? distanceMeters;
  final int? etaMinutes;
  final String? badge;
}
