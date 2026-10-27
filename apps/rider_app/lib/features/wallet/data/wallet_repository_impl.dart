import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/wallet_overview.dart';
import '../domain/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._api);

  final WalletApi _api;

  @override
  Future<Result<WalletOverview>> getOverview() async => (await _api.summary()).map(_overview);

  @override
  Future<Result<List<WalletEntry>>> getTransactions({int page = 1, int pageSize = 20}) async =>
      (await _api.transactions(
        page: page,
        pageSize: pageSize,
      )).map((entries) => [for (final WalletLedgerEntry entry in entries) _entry(entry)]);

  @override
  Future<Result<WalletReceipt>> getReceipt(WalletReceiptKind kind, String id) => _api.receipt(kind, id);

  @override
  Future<Result<WalletStatementView>> getStatement({required DateTime month, int page = 1, int pageSize = 50}) async {
    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime.utc(now.year, now.month, now.day);
    final DateTime from = DateTime.utc(month.year, month.month);
    final DateTime end = DateTime.utc(month.year, month.month + 1, 0);
    return (await _api.statement(
      from: from,
      to: end.isAfter(today) ? today : end,
      page: page,
      pageSize: pageSize,
    )).map(_statement);
  }

  @override
  Future<Result<WalletDeposit>> getDeposit(String id) async => (await _api.securityDeposit(id)).map(_deposit);

  static WalletOverview _overview(RiderWalletSummary summary) {
    final WalletBalance balance = summary.balance;
    return WalletOverview(
      currency: balance.currency,
      spendable: WalletMoney(
        total: balance.totalBalance,
        held: balance.heldBalance,
        available: balance.availableBalance,
      ),
      cash: _money(balance.cash),
      rewards: _money(balance.rewards),
      depositBucket: _money(balance.securityDepositBucket),
      rewardsEarned: summary.rewardsEarned,
      rewardsExpiringSoon: summary.rewardsExpiringWithinSevenDays,
      deposits: [for (final WalletSecurityDeposit deposit in summary.securityDeposits) _deposit(deposit)],
      recentEntries: [for (final WalletLedgerEntry entry in summary.recentTransactions) _entry(entry)],
    );
  }

  static WalletMoney _money(WalletBucket bucket) =>
      WalletMoney(total: bucket.totalBalance, held: bucket.heldBalance, available: bucket.availableBalance);

  static WalletEntry _entry(WalletLedgerEntry entry) => WalletEntry(
    id: entry.id,
    reference: entry.transactionNumber,
    kind: WalletEntryKind.parse(entry.transactionType),
    state: _state(entry.status),
    amount: entry.amount,
    at: entry.postedAt ?? entry.createdAt,
    description: entry.description,
    referenceType: entry.referenceType,
    referenceId: entry.referenceId,
  );

  static WalletDeposit _deposit(WalletSecurityDeposit deposit) => WalletDeposit(
    id: deposit.id,
    status: deposit.status,
    required_: deposit.requiredAmount,
    funded: deposit.fundedAmount,
    held: deposit.heldAmount,
    refundable: deposit.refundableAmount,
    outstanding: deposit.outstandingAmount,
    locked: deposit.lockedAmount,
    deducted: deposit.deductedAmount,
    refunded: deposit.refundedAmount,
    returns: [
      for (final WalletDepositReturn item in deposit.returns)
        DepositReturn(
          id: item.id,
          amount: item.amount,
          status: item.status,
          toWallet: item.toWallet,
          requestedAt: item.requestedAt,
          returned: item.isReturned,
          completedAt: item.completedAt,
        ),
    ],
  );

  static WalletStatementView _statement(WalletStatement statement) => WalletStatementView(
    reference: statement.reference,
    opening: statement.spendable.opening,
    moneyIn: statement.spendable.credits,
    moneyOut: statement.spendable.debits,
    closing: statement.spendable.closing,
    depositClosing: statement.deposit.closing,
    lines: [
      for (final WalletStatementEntry entry in statement.entries)
        StatementLine(
          id: entry.id,
          number: entry.number,
          kind: WalletEntryKind.parse(entry.type),
          description: entry.description,
          at: entry.postedAt,
          change: entry.spendableChange,
          depositChange: entry.depositChange,
          reversed: entry.reversed,
        ),
    ],
    total: statement.total,
  );

  static WalletEntryState _state(String status) => switch (status) {
    'POSTED' => WalletEntryState.settled,
    'FAILED' || 'CANCELLED' => WalletEntryState.failed,
    'REVERSED' || 'PARTIALLY_REVERSED' => WalletEntryState.reversed,
    _ => WalletEntryState.pending,
  };
}
