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

class FlavorException implements Exception {
  const FlavorException(this.problems);

  final List<String> problems;
}

class Flavor {
  const Flavor({
    required this.name,
    required this.dir,
    required this.companyCode,
    required this.riderAppName,
    required this.fleetAppName,
    required this.supportEmail,
    required this.palette,
  });

  final String name;
  final String dir;
  final String companyCode;
  final String riderAppName;
  final String fleetAppName;
  final String supportEmail;
  final Map<String, int> palette;

  String appName(AppTarget app) => app.key == 'rider' ? riderAppName : fleetAppName;

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

    String text(String key, {bool required = true}) {
      final String value = yaml[key]?.toString().trim() ?? '';
      if (value.isEmpty && required) problems.add('flavors/$name/flavor.yaml: "$key" is required.');
      return value;
    }

    final String companyCode = text('companyCode');
    final String riderAppName = text('riderAppName');
    final String fleetAppName = text('fleetAppName');
    final String supportEmail = text('supportEmail', required: false);

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
      riderAppName: riderAppName,
      fleetAppName: fleetAppName,
      supportEmail: supportEmail,
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
