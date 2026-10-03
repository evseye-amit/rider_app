import 'package:evseye_core/evseye_core.dart';

import 'entities/wallet_overview.dart';

abstract interface class WalletRepository {
  Future<Result<WalletOverview>> getOverview();

  Future<Result<List<WalletEntry>>> getTransactions({int page, int pageSize});

  Future<Result<WalletEntry>> getTransaction(String id);

  Future<Result<WithdrawalStatus>> getWithdrawalStatus();

  Future<Result<WalletReceipt>> getReceipt(WalletReceiptKind kind, String id);
}
