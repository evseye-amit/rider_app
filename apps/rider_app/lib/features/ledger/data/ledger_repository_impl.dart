import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/ledger_overview.dart';
import '../domain/ledger_repository.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  const LedgerRepositoryImpl(this._api);

  final WalletApi _api;

  @override
  Future<Result<LedgerOverview>> getOverview() async => (await _api.summary()).map(_overview);

  @override
  Future<Result<List<LedgerEntry>>> getTransactions({int page = 1, int pageSize = 20}) async =>
      (await _api.transactions(
        page: page,
        pageSize: pageSize,
      )).map((entries) => [for (final WalletLedgerEntry entry in entries) _entry(entry)]);

  @override
  Future<Result<WalletReceipt>> getReceipt(WalletReceiptKind kind, String id) => _api.receipt(kind, id);

  @override
  Future<Result<LedgerStatementView>> getStatement({required DateTime month, int page = 1, int pageSize = 50}) async {
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
  Future<Result<LedgerDeposit>> getDeposit(String id) async => (await _api.securityDeposit(id)).map(_deposit);

  static LedgerOverview _overview(RiderWalletSummary summary) {
    final WalletBalance balance = summary.balance;
    return LedgerOverview(
      currency: balance.currency,
      spendable: LedgerMoney(
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

  static LedgerMoney _money(WalletBucket bucket) =>
      LedgerMoney(total: bucket.totalBalance, held: bucket.heldBalance, available: bucket.availableBalance);

  static LedgerEntry _entry(WalletLedgerEntry entry) => LedgerEntry(
    id: entry.id,
    reference: entry.transactionNumber,
    kind: LedgerEntryKind.parse(entry.transactionType),
    state: _state(entry.status),
    amount: entry.amount,
    at: entry.postedAt ?? entry.createdAt,
    description: entry.description,
    referenceType: entry.referenceType,
    referenceId: entry.referenceId,
  );

  static LedgerDeposit _deposit(WalletSecurityDeposit deposit) => LedgerDeposit(
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
          toLedger: item.toWallet,
          requestedAt: item.requestedAt,
          returned: item.isReturned,
          completedAt: item.completedAt,
        ),
    ],
  );

  static LedgerStatementView _statement(WalletStatement statement) => LedgerStatementView(
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
          kind: LedgerEntryKind.parse(entry.type),
          description: entry.description,
          at: entry.postedAt,
          change: entry.spendableChange,
          depositChange: entry.depositChange,
          reversed: entry.reversed,
        ),
    ],
    total: statement.total,
  );

  static LedgerEntryState _state(String status) => switch (status) {
    'POSTED' => LedgerEntryState.settled,
    'FAILED' || 'CANCELLED' || 'EXPIRED' => LedgerEntryState.failed,
    'REVERSED' || 'PARTIALLY_REVERSED' => LedgerEntryState.reversed,
    _ => LedgerEntryState.pending,
  };
}
