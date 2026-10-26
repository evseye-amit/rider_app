import 'dart:convert';
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

class IosFirebase {
  const IosFirebase({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.bundleId,
    this.storageBucket = '',
  });

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String bundleId;
  final String storageBucket;
}

class AppFlavor {
  const AppFlavor({
    required this.appName,
    required this.androidApplicationId,
    required this.iosBundleId,
    required this.version,
    this.appStoreId = '',
    this.androidFirebase = false,
    this.iosFirebase,
  });

  final String appName;
  final String androidApplicationId;
  final String iosBundleId;
  final String version;
  final String appStoreId;
  final bool androidFirebase;
  final IosFirebase? iosFirebase;

  String get versionName => version.split('+').first;

  String get buildNumber => version.split('+').last;
}

class Flavor {
  const Flavor({
    required this.name,
    required this.dir,
    required this.companyCode,
    required this.supportEmail,
    required this.razorpayKeyId,
    required this.razorpayName,
    required this.apps,
    required this.palette,
  });

  final String name;
  final String dir;
  final String companyCode;
  final String supportEmail;
  final String razorpayKeyId;
  final String razorpayName;
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
    final String razorpayKeyId = text(
      yaml,
      'razorpayKeyId',
      required: false,
      format: RegExp(r'^rzp_(test|live)_[A-Za-z0-9]+$'),
      hint: 'a Razorpay key ID such as rzp_test_xxxxxxxxxxxxxx',
    );
    final String razorpayName = text(yaml, 'razorpayName', required: false);
    if (razorpayKeyId.isNotEmpty && razorpayName.isEmpty) {
      problems.add('flavors/$name/flavor.yaml: "razorpayName" is required when "razorpayKeyId" is set.');
    }

    final Map<String, AppFlavor> apps = {};
    for (final AppTarget target in appTargets) {
      final Object? section = yaml[target.key];
      if (section is! Map) {
        problems.add('flavors/$name/flavor.yaml: the "${target.key}" section is required.');
        continue;
      }
      final String prefix = '${target.key}.';
      final String androidApplicationId = text(
        section,
        'androidApplicationId',
        prefix: prefix,
        format: _androidId,
        hint: 'com.company.app',
      );
      final String iosBundleId = text(section, 'iosBundleId', prefix: prefix, format: _iosId, hint: 'com.company.app');
      final File androidFirebase = File(p.join(dir, target.key, androidFirebaseName));
      final File iosFirebase = File(p.join(dir, target.key, iosFirebaseName));
      if (androidFirebase.existsSync()) {
        final String? problem = _androidFirebaseProblem(androidFirebase, androidApplicationId);
        if (problem != null) problems.add('flavors/$name/${target.key}/$androidFirebaseName: $problem');
      }
      final ({IosFirebase? config, String? problem}) ios = iosFirebase.existsSync()
          ? _iosFirebase(iosFirebase, iosBundleId)
          : (config: null, problem: null);
      if (ios.problem case final String problem) problems.add('flavors/$name/${target.key}/$iosFirebaseName: $problem');
      apps[target.key] = AppFlavor(
        appName: text(section, 'appName', prefix: prefix),
        androidApplicationId: androidApplicationId,
        iosBundleId: iosBundleId,
        version: text(section, 'version', prefix: prefix, format: _version, hint: '"1.0.0+1"'),
        appStoreId: text(
          section,
          'appStoreId',
          prefix: prefix,
          required: false,
          format: _appStoreId,
          hint: 'the numeric Apple ID from App Store Connect, such as "6450000000"',
        ),
        androidFirebase: androidFirebase.existsSync(),
        iosFirebase: ios.config,
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
      razorpayKeyId: razorpayKeyId,
      razorpayName: razorpayName,
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

final RegExp _plistString = RegExp(r'<key>([^<]+)</key>\s*<string>([^<]*)</string>');

const List<String> _iosFirebaseKeys = ['API_KEY', 'GOOGLE_APP_ID', 'GCM_SENDER_ID', 'PROJECT_ID', 'BUNDLE_ID'];

String? _androidFirebaseProblem(File file, String applicationId) {
  final Object? json;
  try {
    json = jsonDecode(file.readAsStringSync());
  } on FormatException {
    return 'is not valid JSON.';
  }
  final bool found = switch (json) {
    {'client': final List<Object?> clients} => clients.any(
      (client) => switch (client) {
        {'client_info': {'android_client_info': {'package_name': final String id}}} => id == applicationId,
        _ => false,
      },
    ),
    _ => false,
  };
  return found
      ? null
      : 'has no Android app for $applicationId. Download it from the Firebase app with that package name.';
}

({IosFirebase? config, String? problem}) _iosFirebase(File file, String bundleId) {
  final Map<String, String> values = {
    for (final RegExpMatch match in _plistString.allMatches(file.readAsStringSync()))
      match.group(1)!: _unescapeXml(match.group(2)!),
  };
  final List<String> missing = [
    for (final String key in _iosFirebaseKeys)
      if ((values[key] ?? '').isEmpty) key,
  ];
  if (missing.isNotEmpty) return (config: null, problem: 'is missing ${missing.join(', ')}.');
  if (values['BUNDLE_ID'] != bundleId) {
    return (
      config: null,
      problem: 'is for ${values['BUNDLE_ID']}, not $bundleId. Download it from the Firebase app with that bundle ID.',
    );
  }
  return (
    config: IosFirebase(
      apiKey: values['API_KEY']!,
      appId: values['GOOGLE_APP_ID']!,
      messagingSenderId: values['GCM_SENDER_ID']!,
      projectId: values['PROJECT_ID']!,
      bundleId: bundleId,
      storageBucket: values['STORAGE_BUCKET'] ?? '',
    ),
    problem: null,
  );
}

String _unescapeXml(String value) => value
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&');
