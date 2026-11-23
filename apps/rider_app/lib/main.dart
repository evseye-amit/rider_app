import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/push_routes.dart';
import 'core/session/rider_session_provider.dart';

Future<void> main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.canvas,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  registerDefaultWidgets();

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  await ActiveLocale.initializeFormatting();
  await PushNotifications.initialize(PushApp.rider);
  final AppRelease? release = await AppRelease.load(PushApp.rider);

  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      pushAppProvider.overrideWithValue(PushApp.rider),
      appReleaseProvider.overrideWithValue(release),
    ],
    retry: noProviderRetry,
  );
  final Future<void> updateCheck = container.read(appUpdateProvider.notifier).check();
  if (container.read(companyProvider) != null) {
    try {
      await container.read(riderSessionProvider.notifier).bootstrap();
    } catch (_) {
      // A failed session restore falls through to the signed-out first-run flow.
    }
  }

  await updateCheck.timeout(const Duration(seconds: 4), onTimeout: () {});
  runApp(UncontrolledProviderScope(container: container, child: const RiderApp()));
  FlutterNativeSplash.remove();
  binding.addPostFrameCallback((_) => unawaited(_openInitialPush(container)));
}

Future<void> _openInitialPush(ProviderContainer container) async {
  if (!container.read(riderSessionProvider).isSignedIn) return;
  final Map<String, String>? tap = await PushNotifications.initialTap();
  if (tap != null) openPushLocation(container.read(routerProvider), pushLocation(tap));
}
