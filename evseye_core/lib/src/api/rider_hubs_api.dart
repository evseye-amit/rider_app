import '../utils/result.dart';
import 'api_client.dart';

double _coordinate(Object? value) => value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '') ?? 0;

num? _numberOrNull(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '');

Map<String, dynamic> _map(Object? value) => value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

class NearbyHubDto {
  const NearbyHubDto({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.straightLineMeters,
    this.roadMeters,
    this.etaMinutes,
  });

  factory NearbyHubDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> location = _map(json['location']);
    final Map<String, dynamic> distance = _map(json['distance']);
    final Map<String, dynamic> travel = _map(json['travel']);
    return NearbyHubDto(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: _coordinate(location['latitude']),
      longitude: _coordinate(location['longitude']),
      straightLineMeters: _numberOrNull(distance['straightLineMeters']) ?? 0,
      roadMeters: _numberOrNull(distance['roadMeters']),
      etaMinutes: _numberOrNull(travel['estimatedMinutes'])?.toInt(),
    );
  }

  final String id;
  final String code;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final num straightLineMeters;
  final num? roadMeters;
  final int? etaMinutes;
}

class RiderHubsApi {
  RiderHubsApi(this._client);

  final ApiClient _client;

  Future<Result<List<NearbyHubDto>>> nearby({required double latitude, required double longitude, int limit = 20}) =>
      _client.get<List<NearbyHubDto>>(
        '/rider/hubs/nearby',
        query: {'latitude': latitude, 'longitude': longitude, 'limit': limit},
        parse: (data) => [
          for (final Object? hub in _map(data)['hubs'] as List? ?? const [])
            if (hub is Map) NearbyHubDto.fromJson(Map<String, dynamic>.from(hub)),
        ],
      );
}
