import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';

class FleetManagerApp extends ConsumerStatefulWidget {
  const FleetManagerApp({super.key});

  @override
  ConsumerState<FleetManagerApp> createState() => _FleetManagerAppState();
}

class _FleetManagerAppState extends ConsumerState<FleetManagerApp> {
  late final StreamSubscription<PushMessage> _pushMessages;
  late final StreamSubscription<Map<String, String>> _pushTaps;

  @override
  void initState() {
    super.initState();
    _pushMessages = PushNotifications.messages.listen(_showPush);
    _pushTaps = PushNotifications.taps.listen((_) => _openPush());
  }

  @override
  void dispose() {
    unawaited(_pushMessages.cancel());
    unawaited(_pushTaps.cancel());
    super.dispose();
  }

  void _showPush(PushMessage message) {
    ref
      ..invalidate(unreadNotificationsProvider)
      ..invalidate(notificationsInboxProvider);
    final BuildContext? context = ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
    if (context == null || message.title.isEmpty) return;
    AppSnack.show(
      context,
      message.title,
      icon: Icons.notifications_rounded,
      actionLabel: context.l10n.commonOpen,
      onAction: _openPush,
    );
  }

  void _openPush() {
    ref.invalidate(unreadNotificationsProvider);
    unawaited(ref.read(routerProvider).push(Routes.notifications));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));

    return MaterialApp.router(
      title: FlavorConfig.fleetAppName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
      locale: locale.locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
      builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
    );
  }
}
