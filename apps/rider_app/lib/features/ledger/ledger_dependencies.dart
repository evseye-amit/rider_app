import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/ledger_repository_impl.dart';
import 'domain/ledger_repository.dart';
import 'domain/usecases/get_ledger_overview.dart';
import 'domain/usecases/get_ledger_receipt.dart';
import 'domain/usecases/get_ledger_statement.dart';
import 'domain/usecases/get_ledger_transactions.dart';

final ledgerRepositoryProvider = Provider<LedgerRepository>(
  (ref) => LedgerRepositoryImpl(ref.watch(walletApiProvider)),
);

final getLedgerOverviewProvider = Provider<GetLedgerOverview>(
  (ref) => GetLedgerOverview(ref.watch(ledgerRepositoryProvider)),
);

final getLedgerTransactionsProvider = Provider<GetLedgerTransactions>(
  (ref) => GetLedgerTransactions(ref.watch(ledgerRepositoryProvider)),
);

final getLedgerReceiptProvider = Provider<GetLedgerReceipt>(
  (ref) => GetLedgerReceipt(ref.watch(ledgerRepositoryProvider)),
);

final getLedgerStatementProvider = Provider<GetLedgerStatement>(
  (ref) => GetLedgerStatement(ref.watch(ledgerRepositoryProvider)),
);

final getSecurityDepositProvider = Provider<GetSecurityDeposit>(
  (ref) => GetSecurityDeposit(ref.watch(ledgerRepositoryProvider)),
);
