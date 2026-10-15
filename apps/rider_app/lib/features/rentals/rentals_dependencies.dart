import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/rentals_repository_impl.dart';
import 'domain/rentals_repository.dart';
import 'domain/usecases/get_rentals_overview.dart';

final rentalsRepositoryProvider = Provider<RentalsRepository>(
  (ref) => RentalsRepositoryImpl(ref.watch(riderBillingApiProvider), ref.watch(rentalAgreementsApiProvider)),
);

final getRentalsOverviewProvider = Provider<GetRentalsOverview>(
  (ref) => GetRentalsOverview(ref.watch(rentalsRepositoryProvider)),
);

final getBillProvider = Provider<GetBill>((ref) => GetBill(ref.watch(rentalsRepositoryProvider)));

final getLedgerProvider = Provider<GetLedger>((ref) => GetLedger(ref.watch(rentalsRepositoryProvider)));

final getPaymentReceiptsProvider = Provider<GetPaymentReceipts>(
  (ref) => GetPaymentReceipts(ref.watch(rentalsRepositoryProvider)),
);
