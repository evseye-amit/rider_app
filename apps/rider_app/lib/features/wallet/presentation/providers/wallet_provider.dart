import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_overview.dart';
import '../../domain/usecases/get_wallet_transactions.dart';
import '../../wallet_dependencies.dart';

final walletOverviewProvider = FutureProvider.autoDispose<WalletOverview>(
  (ref) async => (await ref.watch(getWalletOverviewProvider)(const NoParams())).getOrThrow(),
);

final walletTransactionsProvider = FutureProvider.autoDispose<List<WalletEntry>>(
  (ref) async => (await ref.watch(getWalletTransactionsProvider)(const WalletPage(pageSize: 50))).getOrThrow(),
);

final withdrawalStatusProvider = FutureProvider.autoDispose<WithdrawalStatus>(
  (ref) async => (await ref.watch(getWithdrawalStatusProvider)(const NoParams())).getOrThrow(),
);
