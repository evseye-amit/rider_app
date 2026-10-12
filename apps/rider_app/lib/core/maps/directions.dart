import 'package:url_launcher/url_launcher.dart';

import '../location/geo_point.dart';

abstract final class Directions {
  static Future<bool> open(GeoPoint destination) => launchUrl(
    Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'destination': '${destination.latitude},${destination.longitude}',
      'travelmode': 'two-wheeler',
    }),
    mode: LaunchMode.externalApplication,
  );

  const Directions._();
}
