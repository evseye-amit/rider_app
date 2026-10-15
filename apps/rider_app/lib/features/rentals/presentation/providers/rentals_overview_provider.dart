import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rental.dart';
import '../../rentals_dependencies.dart';

final rentalsOverviewProvider = FutureProvider.autoDispose<RentalsOverview>(
  (ref) async => (await ref.watch(getRentalsOverviewProvider)(const NoParams())).getOrThrow(),
);

final billProvider = FutureProvider.autoDispose.family<BillDetail, String>(
  (ref, id) async => (await ref.watch(getBillProvider)(id)).getOrThrow(),
);

final ledgerProvider = FutureProvider.autoDispose<List<LedgerLine>>(
  (ref) async => (await ref.watch(getLedgerProvider)(const NoParams())).getOrThrow(),
);

final paymentReceiptsProvider = FutureProvider.autoDispose<List<PaymentReceipt>>(
  (ref) async => (await ref.watch(getPaymentReceiptsProvider)(const NoParams())).getOrThrow(),
);
