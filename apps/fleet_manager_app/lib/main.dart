import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'core/session/fleet_session_provider.dart';

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
  await PushNotifications.initialize(PushApp.fleetManager);

  final ProviderContainer container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(preferences),
      pushAppProvider.overrideWithValue(PushApp.fleetManager),
    ],
    retry: noProviderRetry,
  );
  if (container.read(companyProvider) != null) {
    try {
      await container.read(fleetSessionProvider.notifier).bootstrap();
    } catch (_) {
      // A failed session restore falls through to the signed-out first-run flow.
    }
  }

  runApp(UncontrolledProviderScope(container: container, child: const FleetManagerApp()));
  FlutterNativeSplash.remove();
  binding.addPostFrameCallback((_) => unawaited(_openInitialPush(container)));
}

Future<void> _openInitialPush(ProviderContainer container) async {
  if (!container.read(fleetSessionProvider).isSignedIn) return;
  if (await PushNotifications.initialTap() != null) {
    unawaited(container.read(routerProvider).push(Routes.notifications));
  }
}
