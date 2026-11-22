import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ledger_overview.dart';
import '../../domain/usecases/get_ledger_receipt.dart';
import '../../domain/usecases/get_ledger_statement.dart';
import '../../domain/usecases/get_ledger_transactions.dart';
import '../../ledger_dependencies.dart';

final ledgerOverviewProvider = FutureProvider.autoDispose<LedgerOverview>(
  (ref) async => (await ref.watch(getLedgerOverviewProvider)(const NoParams())).getOrThrow(),
);

final ledgerTransactionsProvider = FutureProvider.autoDispose<List<LedgerEntry>>(
  (ref) async => (await ref.watch(getLedgerTransactionsProvider)(const LedgerPage(pageSize: 50))).getOrThrow(),
);

class LedgerStatementNotifier extends AsyncNotifier<LedgerStatementView> {
  LedgerStatementNotifier(this._month);

  final DateTime _month;
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<LedgerStatementView> build() async {
    _page = 1;
    return (await ref.read(getLedgerStatementProvider)(StatementQuery(month: _month))).getOrThrow();
  }

  Future<bool> loadMore() async {
    final LedgerStatementView? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<LedgerStatementView> next = await ref.read(getLedgerStatementProvider)(
      StatementQuery(month: _month, page: _page + 1),
    );
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<LedgerStatementView>(:final value)) {
      _page++;
      final Set<String> seen = {for (final StatementLine line in current.lines) line.id};
      state = AsyncData(
        LedgerStatementView(
          reference: current.reference,
          opening: current.opening,
          moneyIn: current.moneyIn,
          moneyOut: current.moneyOut,
          closing: current.closing,
          depositClosing: current.depositClosing,
          lines: [
            ...current.lines,
            for (final StatementLine line in value.lines)
              if (!seen.contains(line.id)) line,
          ],
          total: value.total,
        ),
      );
    }
    return next.isOk;
  }
}

final ledgerStatementProvider = AsyncNotifierProvider.autoDispose
    .family<LedgerStatementNotifier, LedgerStatementView, DateTime>(LedgerStatementNotifier.new);

final securityDepositProvider = FutureProvider.autoDispose.family<LedgerDeposit, String>(
  (ref, id) async => (await ref.watch(getSecurityDepositProvider)(id)).getOrThrow(),
);

final ledgerReceiptProvider = FutureProvider.autoDispose.family<WalletReceipt, ReceiptParams>(
  (ref, params) async => (await ref.watch(getLedgerReceiptProvider)(params)).getOrThrow(),
);
