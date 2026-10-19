import 'dart:io';

import 'package:path/path.dart' as p;

class AppTarget {
  const AppTarget({required this.key, required this.folder, required this.apkLabel});

  final String key;
  final String folder;
  final String apkLabel;
}

const List<AppTarget> appTargets = [
  AppTarget(key: 'rider', folder: 'rider_app', apkLabel: 'rider'),
  AppTarget(key: 'fleet', folder: 'fleet_manager_app', apkLabel: 'fleet-manager'),
];

const List<String> brandImages = ['banner.png', 'intro_1.png', 'intro_2.png'];

const List<String> iconImages = ['app_icon.png', 'app_icon_foreground.png'];

class Workspace {
  const Workspace(this.root);

  final String root;

  String get flavorsDir => p.join(root, 'flavors');

  String get baseArtDir => p.join(root, 'packages', 'evseye_flavors', 'art');

  String get coreDir => p.join(root, 'packages', 'evseye_core');

  String get artDir => p.join(coreDir, 'assets', 'art');

  String get flavorConfigFile => p.join(coreDir, 'lib', 'src', 'flavor', 'flavor_config.dart');

  String appDir(AppTarget app) => p.join(root, 'apps', app.folder);

  String imagesDir(AppTarget app) => p.join(appDir(app), 'assets', 'images');

  String stringsFile(AppTarget app) =>
      p.join(appDir(app), 'android', 'app', 'src', 'main', 'res', 'values', 'strings.xml');

  String androidFlavorFile(AppTarget app) => p.join(appDir(app), 'android', 'flavor.properties');

  String iosFlavorFile(AppTarget app) => p.join(appDir(app), 'ios', 'Flutter', 'Flavor.xcconfig');

  List<String> get flavorNames {
    final Directory dir = Directory(flavorsDir);
    if (!dir.existsSync()) return const [];
    return [
      for (final Directory sub in dir.listSync().whereType<Directory>())
        if (File(p.join(sub.path, 'flavor.yaml')).existsSync()) p.basename(sub.path),
    ]..sort();
  }

  List<String> get sharedArt {
    final Directory dir = Directory(baseArtDir);
    if (!dir.existsSync()) return const [];
    return [
      for (final File file in dir.listSync().whereType<File>())
        if (p.extension(file.path) == '.png') p.basename(file.path),
    ]..sort();
  }

  String? get appliedFlavor {
    final File file = File(flavorConfigFile);
    if (!file.existsSync()) return null;
    return RegExp(r"static const String name = '([^']*)';").firstMatch(file.readAsStringSync())?.group(1);
  }

  static Workspace? find(String start) {
    Directory dir = Directory(p.normalize(p.absolute(start)));
    while (true) {
      if (Directory(p.join(dir.path, 'flavors')).existsSync() &&
          Directory(p.join(dir.path, 'packages', 'evseye_core')).existsSync()) {
        return Workspace(dir.path);
      }
      final Directory parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  }
}
