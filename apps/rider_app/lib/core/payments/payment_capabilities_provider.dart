import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'online_payments.dart';

final paymentCapabilitiesProvider = FutureProvider.autoDispose<PaymentCapabilitiesDto?>(
  (ref) async => (await ref.watch(paymentOrdersApiProvider).capabilities()).valueOrNull,
);

String get _platform => defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'ANDROID';

final canPayOnlineProvider = Provider.autoDispose.family<bool, String>(
  (ref, purpose) =>
      ref
          .watch(paymentCapabilitiesProvider)
          .value
          ?.allows(purpose, platform: _platform, providers: OnlinePayments.supportedProviders) ??
      false,
);

final canSetUpAutoPayWithPaymentProvider = Provider.autoDispose.family<bool, String>(
  (ref, purpose) =>
      ref
          .watch(paymentCapabilitiesProvider)
          .value
          ?.allowsAutoPaySetup(purpose, platform: _platform, providers: OnlinePayments.supportedProviders) ??
      false,
);
