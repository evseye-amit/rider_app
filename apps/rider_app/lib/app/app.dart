import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/referral/pending_referral.dart';
import '../core/session/rider_session_provider.dart';
import 'router/app_router.dart';
import 'router/push_routes.dart';

class RiderApp extends ConsumerStatefulWidget {
  const RiderApp({super.key});

  @override
  ConsumerState<RiderApp> createState() => _RiderAppState();
}

class _RiderAppState extends ConsumerState<RiderApp> {
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<PushMessage> _pushMessages;
  late final StreamSubscription<Map<String, String>> _pushTaps;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () {
        final RiderSessionNotifier session = ref.read(riderSessionProvider.notifier);
        unawaited(session.verifyConsent());
        unawaited(session.refreshOnResume());
      },
    );
    _pushMessages = PushNotifications.messages.listen(_showPush);
    _pushTaps = PushNotifications.taps.listen(_openPush);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
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
      onAction: () => _openPush(message.data),
    );
  }

  void _openPush(Map<String, String> data) {
    ref.invalidate(unreadNotificationsProvider);
    unawaited(ref.read(routerProvider).push(pushLocation(data)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pendingReferralProvider, (_, _) {});
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));

    return MaterialApp.router(
      title: FlavorConfig.riderAppName,
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
