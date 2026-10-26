import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

import 'flavor.dart';
import 'recolour.dart';
import 'templates.dart';
import 'workspace.dart';

Future<int> run(List<String> args) async {
  final ArgParser parser = ArgParser()
    ..addOption('flavor', abbr: 'f', help: 'Client folder under flavors/ to apply, e.g. whizz.')
    ..addOption('root', help: 'EVSEYE repository root. Found from the current folder when omitted.')
    ..addFlag('skip-icons', negatable: false, help: 'Copy files only; do not regenerate launcher icons and splash.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

  final ArgResults options;
  try {
    options = parser.parse(args);
  } on FormatException catch (e) {
    stderr
      ..writeln(e.message)
      ..writeln(parser.usage);
    return 64;
  }

  final Workspace? workspace = Workspace.find(options['root'] as String? ?? Directory.current.path);
  if (workspace == null) {
    stderr.writeln('Could not find the EVSEYE root (the folder holding flavors/ and packages/). Pass --root.');
    return 66;
  }

  final String? name = options['flavor'] as String? ?? options.rest.firstOrNull;
  final bool help = options['help'] as bool;
  if (help || name == null) {
    stdout
      ..writeln('Usage: dart run evseye_flavors --flavor <name>')
      ..writeln()
      ..writeln(parser.usage)
      ..writeln()
      ..writeln('Flavors: ${workspace.flavorNames.join(', ')}')
      ..writeln('Applied: ${workspace.appliedFlavor ?? 'none'}');
    return help ? 0 : 64;
  }

  final Flavor flavor;
  try {
    flavor = Flavor.load(workspace, name);
  } on FlavorException catch (e) {
    for (final String problem in e.problems) {
      stderr.writeln(problem);
    }
    return 65;
  }

  stdout.writeln('Applying "${flavor.name}" to ${workspace.root}');
  try {
    _applyCore(workspace, flavor);
    for (final AppTarget app in appTargets) {
      _applyApp(workspace, flavor, app);
    }
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    return 65;
  }

  if (!(options['skip-icons'] as bool)) {
    for (final AppTarget app in appTargets) {
      stdout.writeln('\n${app.folder}: launcher icons and splash');
      final String dir = workspace.appDir(app);
      if (!await _dartRun(dir, ['flutter_launcher_icons']) || !await _dartRun(dir, ['flutter_native_splash:create'])) {
        stderr.writeln('Icon or splash generation failed in ${app.folder}.');
        return 70;
      }
    }
  }

  stdout
    ..writeln()
    ..writeln('Applied "${flavor.name}". Rebuild both apps to pick up the new name, icon and splash.');
  return 0;
}

void _applyCore(Workspace workspace, Flavor flavor) {
  _write(workspace.flavorConfigFile, flavorConfigSource(flavor));
  _write(workspace.firebaseConfigFile, firebaseConfigSource(flavor));
  for (final String image in brandImages) {
    _copy(flavor.file(image), p.join(workspace.artDir, image));
  }
  final int primary = flavor.palette['primary']!;
  final bool original = sameHue(primary, baseArtColour);
  final List<String> art = workspace.sharedArt;
  int recoloured = 0;
  for (final String file in art) {
    final String target = p.join(workspace.artDir, file);
    final String own = flavor.file('art', file);
    final String base = p.join(workspace.baseArtDir, file);
    if (File(own).existsSync()) {
      _copy(own, target);
    } else if (original) {
      _copy(base, target);
    } else {
      final Uint8List png = File(base).readAsBytesSync();
      _writeBytes(target, recolourPng(png, fromHue: hueOf(baseArtColour), toHue: hueOf(primary)));
      recoloured++;
    }
  }
  final String note = recoloured == 0 ? '' : ' ($recoloured recoloured to ${_hex(primary)})';
  stdout.writeln('evseye_core: colours, names, banner, intro images, ${art.length} illustrations$note');
}

String _apkName(Flavor flavor, AppTarget app) {
  final String client = flavor.name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return [if (client.isNotEmpty) client, app.apkLabel].join('-');
}

String _hex(int argb) => '#${(argb & 0xFFFFFF).toRadixString(16).toUpperCase().padLeft(6, '0')}';

void _applyApp(Workspace workspace, Flavor flavor, AppTarget app) {
  final AppFlavor config = flavor.app(app);
  for (final String icon in iconImages) {
    _copy(flavor.file(app.key, icon), p.join(workspace.imagesDir(app), icon));
  }
  _write(workspace.stringsFile(app), androidStringsSource(config.appName));
  _write(workspace.androidFlavorFile(app), androidFlavorSource(config, apkName: _apkName(flavor, app)));
  _write(workspace.iosFlavorFile(app), iosFlavorSource(config));
  final String androidFirebase = workspace.androidFirebaseFile(app);
  if (config.androidFirebase) {
    _copy(flavor.file(app.key, androidFirebaseName), androidFirebase);
  } else if (File(androidFirebase).existsSync()) {
    File(androidFirebase).deleteSync();
  }
  stdout.writeln(
    '${app.folder}: "${config.appName}", Android ${config.androidApplicationId}, '
    'iOS ${config.iosBundleId}, version ${config.version}, '
    'push notifications: Android ${config.androidFirebase ? 'on' : 'off'}, '
    'iOS ${config.iosFirebase == null ? 'off' : 'on'}',
  );
}

void _write(String path, String content) {
  final File file = File(path);
  if (file.existsSync() && file.readAsStringSync() == content) return;
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

void _copy(String from, String to) => _writeBytes(to, File(from).readAsBytesSync());

void _writeBytes(String path, List<int> bytes) {
  final File file = File(path);
  if (file.existsSync() && _sameBytes(file.readAsBytesSync(), bytes)) return;
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes);
}

bool _sameBytes(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Future<bool> _dartRun(String dir, List<String> args) async {
  final Process process = await Process.start(
    Platform.resolvedExecutable,
    ['run', ...args],
    workingDirectory: dir,
    mode: ProcessStartMode.inheritStdio,
  );
  return await process.exitCode == 0;
}
