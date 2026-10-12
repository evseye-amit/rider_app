import 'flavor.dart';

String flavorConfigSource(Flavor flavor) {
  final int primary = flavor.palette['primary']!;
  final Map<String, int> colours = {
    for (final String key in paletteKeys) key: flavor.palette[key]!,
    'primaryOverlay': _withAlpha(primary, 0x1F),
    'primarySelection': _withAlpha(primary, 0x33),
  };

  final StringBuffer out = StringBuffer()
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln('abstract final class FlavorConfig {')
    ..writeln('  static const String name = ${_dartString(flavor.name)};')
    ..writeln('  static const String companyCode = ${_dartString(flavor.companyCode)};')
    ..writeln()
    ..writeln('  static const String riderAppName = ${_dartString(flavor.riderAppName)};')
    ..writeln('  static const String fleetAppName = ${_dartString(flavor.fleetAppName)};')
    ..writeln('  static const String supportEmail = ${_dartString(flavor.supportEmail)};')
    ..writeln();
  for (final MapEntry<String, int> colour in colours.entries) {
    out.writeln('  static const Color ${colour.key} = Color(${_hex(colour.value)});');
  }
  out
    ..writeln()
    ..writeln('  const FlavorConfig._();')
    ..writeln('}');
  return out.toString();
}

String androidStringsSource(String appName) {
  String escaped = appName
      .replaceAll(r'\', r'\\')
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll("'", r"\'")
      .replaceAll('"', r'\"');
  if (escaped.startsWith('@') || escaped.startsWith('?')) escaped = '\\$escaped';
  return '<?xml version="1.0" encoding="utf-8"?>\n'
      '<resources>\n'
      '    <string name="app_name">$escaped</string>\n'
      '</resources>\n';
}

String manifestWithAppNameLabel(String manifest) {
  final int start = manifest.indexOf('<application');
  if (start < 0) throw const FormatException('AndroidManifest.xml has no <application> element.');
  final int end = manifest.indexOf('>', start);
  final String tag = manifest.substring(start, end);
  final RegExp label = RegExp(r'android:label="[^"]*"');
  final String updated = label.hasMatch(tag)
      ? tag.replaceFirst(label, 'android:label="@string/app_name"')
      : tag.replaceFirst('<application', '<application\n        android:label="@string/app_name"');
  return manifest.replaceRange(start, end, updated);
}

String plistWithDisplayName(String plist, String appName) {
  final RegExp entry = RegExp(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)');
  if (!entry.hasMatch(plist)) throw const FormatException('Info.plist has no CFBundleDisplayName string.');
  final String escaped = appName.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
  return plist.replaceFirstMapped(entry, (m) => '${m[1]}$escaped${m[2]}');
}

int _withAlpha(int argb, int alpha) => (alpha << 24) | (argb & 0x00FFFFFF);

String _hex(int argb) => '0x${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}';

String _dartString(String value) {
  final String escaped = value.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$').replaceAll('\n', r'\n');
  if (escaped.contains("'") && !escaped.contains('"')) return '"$escaped"';
  return "'${escaped.replaceAll("'", r"\'")}'";
}
