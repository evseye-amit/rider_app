import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class AttendancePeriod {
  const AttendancePeriod({required this.id, required this.checkInAt, this.checkOutAt});

  factory AttendancePeriod.fromJson(Map<String, dynamic> json) => AttendancePeriod(
    id: jsonText(json['id']),
    checkInAt: jsonDateOr(json['checkInAt'], DateTime.now()),
    checkOutAt: jsonDate(json['checkOutAt']),
  );

  final String id;
  final DateTime checkInAt;
  final DateTime? checkOutAt;

  bool get isOpen => checkOutAt == null;
}

class AttendanceApi {
  const AttendanceApi(this._client);

  final ApiClient _client;

  Future<Result<AttendancePeriod?>> current() => _client.get<AttendancePeriod?>(
    '/attendance/periods',
    query: {'page': 1, 'pageSize': 1},
    parse: (data) {
      final List<Map<String, dynamic>> items = jsonMaps(jsonMap(data)['items']);
      if (items.isEmpty) return null;
      final AttendancePeriod latest = AttendancePeriod.fromJson(items.first);
      return latest.isOpen ? latest : null;
    },
  );

  Future<Result<bool>> isPresent() async => (await current()).map((period) => period != null);

  Future<Result<bool>> mark(bool present) async {
    final Result<AttendancePeriod> changed = await _client.post<AttendancePeriod>(
      present ? '/attendance/check-in' : '/attendance/check-out',
      parse: (data) => AttendancePeriod.fromJson(jsonMap(data)),
    );
    if (changed.isOk) return Result.ok(present);
    if (await isPresent() case Ok<bool>(:final value) when value == present) return Result.ok(present);
    return switch (changed) {
      Err<AttendancePeriod>(:final failure) => Result.err(failure),
      Ok<AttendancePeriod>() => Result.ok(present),
    };
  }
}
