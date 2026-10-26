import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/core_providers.dart';
import 'firebase_config.dart';

enum PushApp {
  rider('RIDER_APP'),
  fleetManager('FLEET_MANAGER_APP');

  const PushApp(this.wire);

  final String wire;

  bool get _android => switch (this) {
    PushApp.rider => FirebaseConfig.riderAndroid,
    PushApp.fleetManager => FirebaseConfig.fleetAndroid,
  };

  FirebaseOptions? get _ios => switch (this) {
    PushApp.rider => FirebaseConfig.riderIos,
    PushApp.fleetManager => FirebaseConfig.fleetIos,
  };
}

class PushMessage {
  const PushMessage({required this.title, required this.body, required this.data});

  factory PushMessage.from(RemoteMessage message) => PushMessage(
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    data: _data(message),
  );

  final String title;
  final String body;
  final Map<String, String> data;
}

abstract final class PushNotifications {
  static bool _ready = false;

  static bool get isReady => _ready;

  static Future<void> initialize(PushApp app) async {
    final FirebaseOptions? ios = app._ios;
    final bool configured = Platform.isAndroid ? app._android : Platform.isIOS && ios != null;
    if (!configured) return;
    try {
      await Firebase.initializeApp(options: Platform.isIOS ? ios : null);
      _ready = true;
    } on Object {
      _ready = false;
    }
  }

  static Stream<PushMessage> get messages =>
      _ready ? FirebaseMessaging.onMessage.map(PushMessage.from) : const Stream.empty();

  static Stream<Map<String, String>> get taps =>
      _ready ? FirebaseMessaging.onMessageOpenedApp.map(_data) : const Stream.empty();

  static Future<Map<String, String>?> initialTap() async {
    if (!_ready) return null;
    try {
      final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
      return message == null ? null : _data(message);
    } on Object {
      return null;
    }
  }
}

class PushRegistration {
  PushRegistration(this._ref);

  static const String _installationKey = 'push.installation_id';

  final Ref _ref;
  StreamSubscription<String>? _tokenRefresh;

  Future<void> start() async {
    if (!PushNotifications.isReady) return;
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      _tokenRefresh ??= messaging.onTokenRefresh.listen((token) => unawaited(_send(token)));
      final String? token = await _token(messaging);
      if (token != null) await _send(token);
    } on Object {
      return;
    }
  }

  Future<void> stop({bool unregister = true}) async {
    await _tokenRefresh?.cancel();
    _tokenRefresh = null;
    if (!unregister || !PushNotifications.isReady) return;
    await _ref.read(pushDevicesApiProvider).unregister(_installationId);
  }

  Future<String?> _token(FirebaseMessaging messaging) async {
    if (Platform.isIOS) {
      for (int attempt = 0; attempt < 5; attempt++) {
        if (await messaging.getAPNSToken() != null) return messaging.getToken();
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      return null;
    }
    return messaging.getToken();
  }

  Future<void> _send(String token) async {
    await _ref
        .read(pushDevicesApiProvider)
        .register(
          installationId: _installationId,
          appCode: _ref.read(pushAppProvider).wire,
          platform: Platform.isIOS ? 'IOS' : 'ANDROID',
          token: token,
        );
  }

  String get _installationId {
    final SharedPreferences preferences = _ref.read(sharedPreferencesProvider);
    final String? saved = preferences.getString(_installationKey);
    if (saved != null && saved.isNotEmpty) return saved;
    final String created = _uuid();
    unawaited(preferences.setString(_installationKey, created));
    return created;
  }
}

final pushAppProvider = Provider<PushApp>(
  (_) => throw StateError('pushAppProvider must be overridden in ProviderScope with the app being run.'),
);

final pushRegistrationProvider = Provider<PushRegistration>((ref) {
  final PushRegistration registration = PushRegistration(ref);
  ref.onDispose(() => unawaited(registration.stop(unregister: false)));
  return registration;
});

Map<String, String> _data(RemoteMessage message) => {
  for (final MapEntry<String, dynamic> entry in message.data.entries) entry.key: entry.value?.toString() ?? '',
};

String _uuid() {
  final Random random = Random.secure();
  final List<int> bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3F) | 0x80;
  final String hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}
