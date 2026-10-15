Map<String, dynamic> jsonMap(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const <String, dynamic>{};

List<Map<String, dynamic>> jsonMaps(Object? value) => [
  if (value is List)
    for (final Object? item in value)
      if (item is Map) Map<String, dynamic>.from(item),
];

String jsonText(Object? value) => value?.toString() ?? '';

String? jsonTextOrNull(Object? value) {
  final String text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

num jsonNum(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

num? jsonNumOrNull(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '');

int? jsonIntOrNull(Object? value) => value is int ? value : int.tryParse(value?.toString() ?? '');

bool jsonBool(Object? value) => value == true || value?.toString() == 'true';

DateTime? jsonDate(Object? value) => value == null ? null : DateTime.tryParse(value.toString())?.toLocal();

DateTime jsonDateOr(Object? value, DateTime fallback) => jsonDate(value) ?? fallback;

List<String> jsonStrings(Object? value) => [
  if (value is List)
    for (final Object? item in value)
      if (item != null) item.toString(),
];
