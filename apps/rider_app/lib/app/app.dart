import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/payments/online_payments.dart';
import '../core/payments/payment_flow_provider.dart';
import '../core/payments/payment_refresh.dart';
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
        unawaited(_recoverPayments());
      },
    );
    _pushMessages = PushNotifications.messages.listen(_refreshInbox);
    _pushTaps = PushNotifications.taps.listen(_openPush);
  }

  Future<void> _recoverPayments() async {
    final List<OnlinePaymentOutcome> outcomes = await ref.read(onlinePaymentsProvider).recoverAll();
    if (outcomes.isEmpty || !mounted) return;
    refreshPaymentData(ref.invalidate);
    ref.invalidate(paymentFlowProvider);
    if (!outcomes.any((outcome) => outcome is OnlinePaymentPaid)) return;
    final BuildContext? navigator = ref.read(routerProvider).routerDelegate.navigatorKey.currentContext;
    if (navigator != null && navigator.mounted) AppSnack.success(navigator, navigator.l10n.onlinePaymentDone);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_pushMessages.cancel());
    unawaited(_pushTaps.cancel());
    super.dispose();
  }

  void _refreshInbox(PushMessage message) {
    ref
      ..invalidate(unreadNotificationsProvider)
      ..invalidate(notificationsInboxProvider);
  }

  void _openPush(Map<String, String> data) {
    ref.invalidate(unreadNotificationsProvider);
    unawaited(ref.read(routerProvider).push(pushLocation(data)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pendingReferralProvider, (_, _) {});
    ref.listen(riderSessionProvider.select((session) => session.user?.id), (previous, next) {
      if (next != previous) ref.read(appUpdateProvider.notifier).contextChanged();
      if (next != null && next != previous) unawaited(_recoverPayments());
    });
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
      localizationsDelegates: const [AppL10n.delegate, ...GlobalMaterialLocalizations.delegates],
      builder: (context, child) => MediaQuery.withNoTextScaling(child: AppUpdateGate(child: child ?? const SizedBox())),
    );
  }
}
