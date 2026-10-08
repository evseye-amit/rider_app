import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'geo_point.dart';

enum LocationIssue { serviceDisabled, denied, deniedForever, unavailable }

class LocationException implements Exception {
  const LocationException(this.issue);

  final LocationIssue issue;
}

class LocationService {
  const LocationService();

  static const LocationSettings _settings = LocationSettings(
    accuracy: LocationAccuracy.high,
    timeLimit: Duration(seconds: 20),
  );

  Future<GeoPoint> current() async {
    if (!await Geolocator.isLocationServiceEnabled()) throw const LocationException(LocationIssue.serviceDisabled);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    switch (permission) {
      case LocationPermission.deniedForever:
        throw const LocationException(LocationIssue.deniedForever);
      case LocationPermission.denied || LocationPermission.unableToDetermine:
        throw const LocationException(LocationIssue.denied);
      case LocationPermission.whileInUse || LocationPermission.always:
        break;
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(locationSettings: _settings);
      return GeoPoint(latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException {
      final Position? last = await Geolocator.getLastKnownPosition();
      if (last == null) throw const LocationException(LocationIssue.unavailable);
      return GeoPoint(latitude: last.latitude, longitude: last.longitude);
    }
  }

  Future<void> openSettings(LocationIssue issue) async {
    switch (issue) {
      case LocationIssue.serviceDisabled:
        await Geolocator.openLocationSettings();
      case LocationIssue.deniedForever:
        await Geolocator.openAppSettings();
      case LocationIssue.denied || LocationIssue.unavailable:
        return;
    }
  }
}

final locationServiceProvider = Provider<LocationService>((_) => const LocationService());

final currentLocationProvider = FutureProvider.autoDispose<GeoPoint>(
  (ref) => ref.watch(locationServiceProvider).current(),
);
