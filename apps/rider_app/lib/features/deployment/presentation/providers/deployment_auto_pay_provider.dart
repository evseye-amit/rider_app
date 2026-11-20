import 'dart:math' as math;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/payments/payment_capabilities_provider.dart';
import '../../../payments/domain/entities/auto_pay_setup.dart';
import '../../../payments/presentation/providers/payments_provider.dart';

typedef DeploymentAutoPayTerms = ({num limit, int validityDays});

const num _mandateCap = 15000;

final deploymentAutoPayTermsProvider = Provider.autoDispose<DeploymentAutoPayTerms?>((ref) {
  if (!ref.watch(canSetUpAutoPayWithPaymentProvider(PaymentPurposes.deployment))) return null;
  return switch (ref.watch(autoPaySetupProvider).value) {
    AutoPaySetup(canSetUp: true, :final num maxAmount, :final int validityDays)
        when maxAmount > 0 && validityDays > 0 =>
      (limit: math.min(maxAmount, _mandateCap), validityDays: validityDays),
    _ => null,
  };
});
