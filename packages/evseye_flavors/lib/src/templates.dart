import 'flavor.dart';

String flavorConfigSource(Flavor flavor) {
  final int primary = flavor.palette['primary']!;
  final Map<String, int> colours = {
    for (final String key in paletteKeys) key: flavor.palette[key]!,
    'primaryOverlay': _withAlpha(primary, 0x1F),
    'primarySelection': _withAlpha(primary, 0x33),
  };
  final AppFlavor rider = flavor.apps['rider']!;
  final AppFlavor fleet = flavor.apps['fleet']!;

  final StringBuffer out = StringBuffer()
    ..writeln("import 'dart:ui';")
    ..writeln()
    ..writeln('abstract final class FlavorConfig {')
    ..writeln('  static const String name = ${_dartString(flavor.name)};')
    ..writeln('  static const String companyCode = ${_dartString(flavor.companyCode)};')
    ..writeln('  static const String supportEmail = ${_dartString(flavor.supportEmail)};')
    ..writeln('  static const String upiId = ${_dartString(flavor.upiId)};')
    ..writeln('  static const String upiPayeeName = ${_dartString(flavor.upiPayeeName)};')
    ..writeln('  static const String upiMerchantCode = ${_dartString(flavor.upiMerchantCode)};')
    ..writeln()
    ..writeln('  static const String riderAppName = ${_dartString(rider.appName)};')
    ..writeln('  static const String riderVersion = ${_dartString(rider.versionName)};')
    ..writeln('  static const String riderAndroidApplicationId = ${_dartString(rider.androidApplicationId)};')
    ..writeln('  static const String riderIosBundleId = ${_dartString(rider.iosBundleId)};')
    ..writeln('  static const String riderAppStoreId = ${_dartString(rider.appStoreId)};')
    ..writeln('  static const String fleetAppName = ${_dartString(fleet.appName)};')
    ..writeln('  static const String fleetVersion = ${_dartString(fleet.versionName)};')
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

String androidFlavorSource(AppFlavor app, {required String apkName}) =>
    'applicationId=${app.androidApplicationId}\n'
    'versionName=${app.versionName}\n'
    'versionCode=${app.buildNumber}\n'
    'apkName=$apkName\n';

String iosFlavorSource(AppFlavor app) =>
    'FLAVOR_BUNDLE_ID=${app.iosBundleId}\n'
    'FLAVOR_APP_NAME=${app.appName}\n'
    'FLUTTER_BUILD_NAME=${app.versionName}\n'
    'FLUTTER_BUILD_NUMBER=${app.buildNumber}\n';

int _withAlpha(int argb, int alpha) => (alpha << 24) | (argb & 0x00FFFFFF);

String _hex(int argb) => '0x${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}';

String _dartString(String value) {
  final String escaped = value.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$').replaceAll('\n', r'\n');
  if (escaped.contains("'") && !escaped.contains('"')) return '"$escaped"';
  return "'${escaped.replaceAll("'", r"\'")}'";
}
