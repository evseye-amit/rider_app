import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../flavor/flavor_config.dart';
import '../push/push_notifications.dart';

class AppRelease {
  const AppRelease({
    required this.appCode,
    required this.platform,
    required this.applicationId,
    required this.channel,
    required this.version,
    required this.build,
  });

  static final RegExp _applicationId = RegExp(r'^[A-Za-z][A-Za-z0-9_-]*(?:\.[A-Za-z0-9_-]+)+$');
  static final RegExp _version = RegExp(r'^(0|[1-9]\d{0,8})\.(0|[1-9]\d{0,8})\.(0|[1-9]\d{0,8})$');
  static final RegExp _androidBuild = RegExp(r'^[1-9]\d{0,9}$');
  static final RegExp _iosBuild = RegExp(r'^(0|[1-9]\d{0,9})(\.(0|[1-9]\d{0,9})){0,2}$');
  static const int _maxAndroidBuild = 2100000000;

  final String appCode;
  final String platform;
  final String applicationId;
  final String channel;
  final String version;
  final String build;

  static Future<AppRelease?> load(PushApp app) async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      final AppRelease release = AppRelease(
        appCode: app.wire,
        platform: Platform.isIOS ? 'IOS' : 'ANDROID',
        applicationId: info.packageName,
        channel: FlavorConfig.releaseChannel,
        version: info.version,
        build: info.buildNumber,
      );
      return release.isValid ? release : null;
    } on Object {
      return null;
    }
  }

  bool get isValid =>
      applicationId.length >= 3 &&
      applicationId.length <= 200 &&
      _applicationId.hasMatch(applicationId) &&
      (channel == 'PRODUCTION' || channel == 'TEST') &&
      _version.hasMatch(version) &&
      _validBuild;

  bool get _validBuild {
    if (platform == 'ANDROID') return _androidBuild.hasMatch(build) && int.parse(build) <= _maxAndroidBuild;
    return _iosBuild.hasMatch(build) && build.split('.').any((part) => int.parse(part) > 0);
  }

  Map<String, String> get headers => {
    'X-App-Code': appCode,
    'X-App-Platform': platform,
    'X-App-Id': applicationId,
    'X-App-Channel': channel,
    'X-App-Version': version,
    'X-App-Build': build,
  };

  Map<String, Object> get body => {
    'appCode': appCode,
    'platform': platform,
    'applicationId': applicationId,
    'channel': channel,
    'installed': {'version': version, 'build': build},
  };

  String get key => [appCode, platform, applicationId, channel, version, build].join('|');
}

final appReleaseProvider = Provider<AppRelease?>((_) => null);
