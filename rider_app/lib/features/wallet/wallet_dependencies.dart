import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/wallet_repository_impl.dart';
import 'domain/usecases/get_wallet_overview.dart';
import 'domain/usecases/get_wallet_receipt.dart';
import 'domain/usecases/get_wallet_transaction.dart';
import 'domain/usecases/get_wallet_transactions.dart';
import 'domain/usecases/get_withdrawal_status.dart';
import 'domain/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepositoryImpl(ref.watch(walletApiProvider)),
);

final getWalletOverviewProvider = Provider<GetWalletOverview>(
  (ref) => GetWalletOverview(ref.watch(walletRepositoryProvider)),
);

final getWalletTransactionsProvider = Provider<GetWalletTransactions>(
  (ref) => GetWalletTransactions(ref.watch(walletRepositoryProvider)),
);

final getWalletTransactionProvider = Provider<GetWalletTransaction>(
  (ref) => GetWalletTransaction(ref.watch(walletRepositoryProvider)),
);

final getWithdrawalStatusProvider = Provider<GetWithdrawalStatus>(
  (ref) => GetWithdrawalStatus(ref.watch(walletRepositoryProvider)),
);

final getWalletReceiptProvider = Provider<GetWalletReceipt>(
  (ref) => GetWalletReceipt(ref.watch(walletRepositoryProvider)),
);
