import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payments_overview.dart';
import '../../payments_dependencies.dart';

final paymentsOverviewProvider = FutureProvider.autoDispose<PaymentsOverview>(
  (ref) async => (await ref.watch(getPaymentsOverviewProvider)(const NoParams())).getOrThrow(),
);

final paymentHistoryProvider = FutureProvider.autoDispose<List<PaymentRecord>>(
  (ref) async => (await ref.watch(getPaymentHistoryProvider)(const NoParams())).getOrThrow(),
);

final paymentRefundsProvider = FutureProvider.autoDispose<List<PaymentAttemptDetail>>(
  (ref) async => (await ref.watch(getPaymentRefundsProvider)(const NoParams())).getOrThrow(),
);
