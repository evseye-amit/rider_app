import 'package:evseye_core/evseye_core.dart';

import 'entities/ledger_overview.dart';

abstract interface class LedgerRepository {
  Future<Result<LedgerOverview>> getOverview();

  Future<Result<List<LedgerEntry>>> getTransactions({int page, int pageSize});

  Future<Result<WalletReceipt>> getReceipt(WalletReceiptKind kind, String id);

  Future<Result<LedgerStatementView>> getStatement({required DateTime month, int page, int pageSize});

  Future<Result<LedgerDeposit>> getDeposit(String id);
}
