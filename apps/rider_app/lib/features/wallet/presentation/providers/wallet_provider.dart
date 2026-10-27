import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_overview.dart';
import '../../domain/usecases/get_wallet_receipt.dart';
import '../../domain/usecases/get_wallet_statement.dart';
import '../../domain/usecases/get_wallet_transactions.dart';
import '../../wallet_dependencies.dart';

final walletOverviewProvider = FutureProvider.autoDispose<WalletOverview>(
  (ref) async => (await ref.watch(getWalletOverviewProvider)(const NoParams())).getOrThrow(),
);

final walletTransactionsProvider = FutureProvider.autoDispose<List<WalletEntry>>(
  (ref) async => (await ref.watch(getWalletTransactionsProvider)(const WalletPage(pageSize: 50))).getOrThrow(),
);

class WalletStatementNotifier extends AsyncNotifier<WalletStatementView> {
  WalletStatementNotifier(this._month);

  final DateTime _month;
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<WalletStatementView> build() async {
    _page = 1;
    return (await ref.read(getWalletStatementProvider)(StatementQuery(month: _month))).getOrThrow();
  }

  Future<bool> loadMore() async {
    final WalletStatementView? current = state.value;
    if (current == null || !current.hasMore || _loadingMore) return true;
    _loadingMore = true;
    final Result<WalletStatementView> next = await ref.read(getWalletStatementProvider)(
      StatementQuery(month: _month, page: _page + 1),
    );
    _loadingMore = false;
    if (!ref.mounted) return false;
    if (next case Ok<WalletStatementView>(:final value)) {
      _page++;
      final Set<String> seen = {for (final StatementLine line in current.lines) line.id};
      state = AsyncData(
        WalletStatementView(
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

final walletStatementProvider = AsyncNotifierProvider.autoDispose
    .family<WalletStatementNotifier, WalletStatementView, DateTime>(WalletStatementNotifier.new);

final securityDepositProvider = FutureProvider.autoDispose.family<WalletDeposit, String>(
  (ref, id) async => (await ref.watch(getSecurityDepositProvider)(id)).getOrThrow(),
);

final walletReceiptProvider = FutureProvider.autoDispose.family<WalletReceipt, ReceiptParams>(
  (ref, params) async => (await ref.watch(getWalletReceiptProvider)(params)).getOrThrow(),
);
