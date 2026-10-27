import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/payments_repository_impl.dart';
import 'domain/payments_repository.dart';
import 'domain/usecases/auto_pay_usecases.dart';
import 'domain/usecases/get_payment_history.dart';
import 'domain/usecases/get_payments_overview.dart';

final paymentsRepositoryProvider = Provider<PaymentsRepository>(
  (ref) => PaymentsRepositoryImpl(ref.watch(riderPaymentsApiProvider), ref.watch(submissionPenaltyApiProvider)),
);

final getPaymentsOverviewProvider = Provider<GetPaymentsOverview>(
  (ref) => GetPaymentsOverview(ref.watch(paymentsRepositoryProvider)),
);

final getPaymentHistoryProvider = Provider<GetPaymentHistory>(
  (ref) => GetPaymentHistory(ref.watch(paymentsRepositoryProvider)),
);

final getAutoPayProvider = Provider<GetAutoPay>((ref) => GetAutoPay(ref.watch(paymentsRepositoryProvider)));

final setUpAutoPayProvider = Provider<SetUpAutoPay>((ref) => SetUpAutoPay(ref.watch(paymentsRepositoryProvider)));

final verifyAutoPayProvider = Provider<VerifyAutoPay>((ref) => VerifyAutoPay(ref.watch(paymentsRepositoryProvider)));

final cancelAutoPayProvider = Provider<CancelAutoPay>((ref) => CancelAutoPay(ref.watch(paymentsRepositoryProvider)));

final pauseAutoPayProvider = Provider<PauseAutoPay>((ref) => PauseAutoPay(ref.watch(paymentsRepositoryProvider)));

final setAutoDebitProvider = Provider<SetAutoDebit>((ref) => SetAutoDebit(ref.watch(paymentsRepositoryProvider)));
