import 'package:flutter_riverpod/misc.dart';

import '../../features/damage_charges/presentation/providers/damage_charges_providers.dart';
import '../../features/deployment/presentation/providers/deployment_payment_provider.dart';
import '../../features/home/presentation/providers/home_summary_provider.dart';
import '../../features/payments/presentation/providers/auto_pay_provider.dart';
import '../../features/payments/presentation/providers/payments_provider.dart';
import '../../features/rentals/presentation/providers/rentals_overview_provider.dart';
import '../../features/wallet/presentation/providers/wallet_provider.dart';

void refreshPaymentData(void Function(ProviderOrFamily provider) invalidate) {
  for (final ProviderOrFamily provider in <ProviderOrFamily>[
    walletOverviewProvider,
    walletTransactionsProvider,
    homeSummaryProvider,
    paymentsOverviewProvider,
    paymentHistoryProvider,
    autoPayProvider,
    rentalsOverviewProvider,
    billProvider,
    ledgerProvider,
    paymentReceiptsProvider,
    damageChargesSummaryProvider,
    damageChargesProvider,
    damageChargeProvider,
    deploymentPaymentProvider,
  ]) {
    invalidate(provider);
  }
}
