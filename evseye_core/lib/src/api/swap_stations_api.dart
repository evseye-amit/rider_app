import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

import '../l10n/active_locale.dart';
import '../utils/result.dart';

class SwapStationDto {
  const SwapStationDto({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.site,
    this.area,
    this.city,
    this.siteType,
    this.units,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? site;
  final String? area;
  final String? city;
  final String? siteType;
  final int? units;
}

class SwapStationsApi {
  SwapStationsApi({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 40),
              responseType: ResponseType.plain,
            ),
          );

  static final Uri source = Uri.parse(
    'https://www.google.com/maps/d/kml?mid=1XErKgWV7YDqib3_9SEF1gvm17tYTVHg&forcekml=1',
  );

  final Dio _dio;

  Future<Result<List<SwapStationDto>>> stations() async {
    final String kml;
    try {
      kml = (await _dio.getUri<String>(source)).data ?? '';
    } on DioException {
      return Result.err(NetworkFailure(ActiveLocale.strings.errorCouldNotReachServerCheck));
    }
    final List<SwapStationDto>? stations = await Isolate.run(() => _parseStations(kml));
    return stations == null ? const Result.err(ServerFailure()) : Result.ok(stations);
  }
}

List<SwapStationDto>? _parseStations(String kml) {
  final XmlDocument document;
  try {
    document = XmlDocument.parse(kml);
  } on XmlException {
    return null;
  }

  final List<SwapStationDto> stations = [];
  for (final XmlElement placemark in document.findAllElements('Placemark')) {
    final List<String> coordinates =
        placemark.findAllElements('coordinates').firstOrNull?.innerText.trim().split(',') ?? const [];
    if (coordinates.length < 2) continue;
    final double? longitude = double.tryParse(coordinates[0].trim());
    final double? latitude = double.tryParse(coordinates[1].trim());
    if (latitude == null || longitude == null) continue;

    final Map<String, String> data = {
      for (final XmlElement field in placemark.findAllElements('Data'))
        if (field.getAttribute('name') case final String name) name: field.getElement('value')?.innerText.trim() ?? '',
    };
    String? value(String key) => (data[key]?.isEmpty ?? true) ? null : data[key];

    final String name = placemark.getElement('name')?.innerText.trim() ?? '';
    stations.add(
      SwapStationDto(
        id: '${value('QIS ID/No.') ?? 'station'}-${stations.length}',
        name: name.isNotEmpty ? name : value('QIS New Name') ?? '',
        latitude: latitude,
        longitude: longitude,
        site: value('QIS New Name'),
        area: value('Area'),
        city: value('City'),
        siteType: value('Site Type'),
        units: double.tryParse(value('No. of QIS') ?? '')?.toInt(),
      ),
    );
  }
  return stations;
}
