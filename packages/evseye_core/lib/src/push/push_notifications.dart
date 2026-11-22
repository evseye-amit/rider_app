import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/active_locale.dart';
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
  static const String _channelId = 'evseye_notifications';
  static const String _icon = 'ic_notification';

  static bool _ready = false;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  static final StreamController<Map<String, String>> _taps = StreamController<Map<String, String>>.broadcast();

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
      return;
    }
    FirebaseMessaging.onMessageOpenedApp.listen((message) => _taps.add(_data(message)));
    try {
      if (Platform.isAndroid) {
        await _setUpAndroidForeground();
      } else {
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } on Object {
      return;
    }
  }

  static Future<void> _setUpAndroidForeground() async {
    await _local.initialize(
      settings: const InitializationSettings(android: AndroidInitializationSettings(_icon)),
      onDidReceiveNotificationResponse: (response) {
        final Map<String, String>? data = _decode(response.payload);
        if (data != null) _taps.add(data);
      },
    );
    await _local
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    FirebaseMessaging.onMessage.listen((message) => unawaited(_present(message)));
  }

  static AndroidNotificationChannel get _channel => AndroidNotificationChannel(
    _channelId,
    ActiveLocale.strings.notificationsNotifications,
    importance: Importance.high,
  );

  static Future<void> _present(RemoteMessage message) async {
    final RemoteNotification? notification = message.notification;
    if (notification == null || ((notification.title ?? '').isEmpty && (notification.body ?? '').isEmpty)) return;
    final AndroidNotificationChannel channel = _channel;
    try {
      await _local.show(
        id: (message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}').hashCode & 0x7fffffff,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: _icon,
            styleInformation: BigTextStyleInformation(notification.body ?? ''),
          ),
        ),
        payload: jsonEncode(_data(message)),
      );
    } on Object {
      return;
    }
  }

  static Stream<PushMessage> get messages =>
      _ready ? FirebaseMessaging.onMessage.map(PushMessage.from) : const Stream.empty();

  static Stream<Map<String, String>> get taps => _ready ? _taps.stream : const Stream.empty();

  static Future<Map<String, String>?> initialTap() async {
    if (!_ready) return null;
    try {
      final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) return _data(message);
      if (!Platform.isAndroid) return null;
      final NotificationAppLaunchDetails? launch = await _local.getNotificationAppLaunchDetails();
      if (launch == null || !launch.didNotificationLaunchApp) return null;
      return _decode(launch.notificationResponse?.payload);
    } on Object {
      return null;
    }
  }

  static Map<String, String>? _decode(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(payload);
      if (decoded is! Map) return null;
      return {for (final MapEntry<Object?, Object?> entry in decoded.entries) '${entry.key}': '${entry.value ?? ''}'};
    } on FormatException {
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
