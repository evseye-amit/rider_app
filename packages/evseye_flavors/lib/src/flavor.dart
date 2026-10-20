import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'workspace.dart';

const List<String> paletteKeys = [
  'primary',
  'primaryBright',
  'primaryDeep',
  'primaryWash',
  'primaryInk',
  'onInkSecondary',
  'onInkMuted',
  'textOnPrimary',
];

final RegExp _flavorName = RegExp(r'^[a-z][a-z0-9]*$');

final RegExp _hexColour = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

final RegExp _androidId = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$');

final RegExp _iosId = RegExp(r'^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$');

final RegExp _version = RegExp(r'^\d+\.\d+\.\d+\+\d+$');

final RegExp _appStoreId = RegExp(r'^\d{6,12}$');

class FlavorException implements Exception {
  const FlavorException(this.problems);

  final List<String> problems;
}

class AppFlavor {
  const AppFlavor({
    required this.appName,
    required this.androidApplicationId,
    required this.iosBundleId,
    required this.version,
    this.appStoreId = '',
  });

  final String appName;
  final String androidApplicationId;
  final String iosBundleId;
  final String version;
  final String appStoreId;

  String get versionName => version.split('+').first;

  String get buildNumber => version.split('+').last;
}

class Flavor {
  const Flavor({
    required this.name,
    required this.dir,
    required this.companyCode,
    required this.supportEmail,
    required this.upiId,
    required this.upiPayeeName,
    required this.upiMerchantCode,
    required this.apps,
    required this.palette,
  });

  final String name;
  final String dir;
  final String companyCode;
  final String supportEmail;
  final String upiId;
  final String upiPayeeName;
  final String upiMerchantCode;
  final Map<String, AppFlavor> apps;
  final Map<String, int> palette;

  AppFlavor app(AppTarget target) => apps[target.key]!;

  String file(String first, [String? second]) => p.join(dir, first, second);

  static Flavor load(Workspace workspace, String name) {
    final String dir = p.join(workspace.flavorsDir, name);
    final File yamlFile = File(p.join(dir, 'flavor.yaml'));
    if (!_flavorName.hasMatch(name) || !yamlFile.existsSync()) {
      throw FlavorException(['No flavor called "$name". Available: ${workspace.flavorNames.join(', ')}']);
    }

    final List<String> problems = [];
    final Object? document;
    try {
      document = loadYaml(yamlFile.readAsStringSync());
    } on YamlException catch (e) {
      throw FlavorException(['flavors/$name/flavor.yaml: ${e.message}']);
    }
    final Map<Object?, Object?> yaml = document is Map ? document : const {};

    String text(
      Map<Object?, Object?> section,
      String key, {
      String prefix = '',
      bool required = true,
      RegExp? format,
      String? hint,
    }) {
      final String value = section[key]?.toString().trim() ?? '';
      if (value.isEmpty) {
        if (required) problems.add('flavors/$name/flavor.yaml: "$prefix$key" is required.');
      } else if (format != null && !format.hasMatch(value)) {
        problems.add('flavors/$name/flavor.yaml: "$prefix$key" must look like $hint.');
      }
      return value;
    }

    final String companyCode = text(
      yaml,
      'companyCode',
      required: false,
      format: RegExp(r'^[a-z0-9-]+$'),
      hint: 'a lowercase code such as yogmaya',
    );
    final String supportEmail = text(yaml, 'supportEmail', required: false);
    final String upiId = text(
      yaml,
      'upiId',
      required: false,
      format: RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$'),
      hint: 'a UPI ID such as pinkrides@okaxis',
    );
    final String upiPayeeName = text(yaml, 'upiPayeeName', required: false);
    final String upiMerchantCode = text(
      yaml,
      'upiMerchantCode',
      required: false,
      format: RegExp(r'^\d{4}$'),
      hint: 'a 4-digit merchant category code such as 7512',
    );
    if (upiId.isNotEmpty && upiPayeeName.isEmpty) {
      problems.add('flavors/$name/flavor.yaml: "upiPayeeName" is required when "upiId" is set.');
    }

    final Map<String, AppFlavor> apps = {};
    for (final AppTarget target in appTargets) {
      final Object? section = yaml[target.key];
      if (section is! Map) {
        problems.add('flavors/$name/flavor.yaml: the "${target.key}" section is required.');
        continue;
      }
      final String prefix = '${target.key}.';
      apps[target.key] = AppFlavor(
        appName: text(section, 'appName', prefix: prefix),
        androidApplicationId: text(
          section,
          'androidApplicationId',
          prefix: prefix,
          format: _androidId,
          hint: 'com.company.app',
        ),
        iosBundleId: text(section, 'iosBundleId', prefix: prefix, format: _iosId, hint: 'com.company.app'),
        version: text(section, 'version', prefix: prefix, format: _version, hint: '"1.0.0+1"'),
        appStoreId: text(
          section,
          'appStoreId',
          prefix: prefix,
          required: false,
          format: _appStoreId,
          hint: 'the numeric Apple ID from App Store Connect, such as "6450000000"',
        ),
      );
    }

    final Object? colours = yaml['colors'];
    final Map<String, int> palette = {};
    for (final String key in paletteKeys) {
      final int? argb = parseColour(colours is Map ? colours[key]?.toString() : null);
      if (argb == null) {
        problems.add('flavors/$name/flavor.yaml: colors.$key must be a quoted hex colour, like "#0062FF".');
      } else {
        palette[key] = argb;
      }
    }

    final List<String> required = [
      ...brandImages,
      for (final AppTarget app in appTargets)
        for (final String icon in iconImages) p.join(app.key, icon),
    ];
    for (final String relative in required) {
      if (!File(p.join(dir, relative)).existsSync()) problems.add('Missing file: flavors/$name/$relative');
    }
    if (workspace.sharedArt.isEmpty) problems.add('No illustrations found in packages/evseye_flavors/art.');

    if (problems.isNotEmpty) throw FlavorException(problems);
    return Flavor(
      name: name,
      dir: dir,
      companyCode: companyCode,
      supportEmail: supportEmail,
      upiId: upiId,
      upiPayeeName: upiPayeeName,
      upiMerchantCode: upiMerchantCode,
      apps: apps,
      palette: palette,
    );
  }
}

int? parseColour(String? value) {
  final Match? match = value == null ? null : _hexColour.firstMatch(value.trim());
  if (match == null) return null;
  final String hex = match.group(1)!;
  final int parsed = int.parse(hex, radix: 16);
  return hex.length == 6 ? 0xFF000000 | parsed : parsed;
}
