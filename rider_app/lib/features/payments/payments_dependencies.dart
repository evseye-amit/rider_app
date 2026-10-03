import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/payments_repository_impl.dart';
import 'domain/payments_repository.dart';
import 'domain/usecases/get_payment_attempt.dart';
import 'domain/usecases/get_payment_history.dart';
import 'domain/usecases/get_payment_refunds.dart';
import 'domain/usecases/get_payments_overview.dart';

final paymentsRepositoryProvider = Provider<PaymentsRepository>(
  (ref) => PaymentsRepositoryImpl(ref.watch(riderPaymentsApiProvider)),
);

final getPaymentsOverviewProvider = Provider<GetPaymentsOverview>(
  (ref) => GetPaymentsOverview(ref.watch(paymentsRepositoryProvider)),
);

final getPaymentHistoryProvider = Provider<GetPaymentHistory>(
  (ref) => GetPaymentHistory(ref.watch(paymentsRepositoryProvider)),
);

final getPaymentAttemptProvider = Provider<GetPaymentAttempt>(
  (ref) => GetPaymentAttempt(ref.watch(paymentsRepositoryProvider)),
);

final getPaymentRefundsProvider = Provider<GetPaymentRefunds>(
  (ref) => GetPaymentRefunds(ref.watch(paymentsRepositoryProvider)),
);
