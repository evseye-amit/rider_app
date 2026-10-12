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
  Future<Result<WalletEntry>> getTransaction(String id) async => (await _api.transaction(id)).map(_entry);

  @override
  Future<Result<WithdrawalStatus>> getWithdrawalStatus() async => (await _api.withdrawalEligibility()).map(
    (eligibility) => WithdrawalStatus(
      eligible: eligibility.eligible,
      cashAvailable: eligibility.cashAvailable,
      depositReturnedSeparately: eligibility.securityDepositReturnSeparate,
      reason: eligibility.reason,
    ),
  );

  @override
  Future<Result<WalletReceipt>> getReceipt(WalletReceiptKind kind, String id) => _api.receipt(kind, id);

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
      deposits: [
        for (final WalletSecurityDeposit deposit in summary.securityDeposits)
          WalletDeposit(
            id: deposit.id,
            status: deposit.status,
            required_: deposit.requiredAmount,
            funded: deposit.fundedAmount,
            held: deposit.heldAmount,
            refundable: deposit.refundableAmount,
          ),
      ],
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
  );

  static WalletEntryState _state(String status) => switch (status) {
    'POSTED' => WalletEntryState.settled,
    'FAILED' || 'CANCELLED' => WalletEntryState.failed,
    'REVERSED' || 'PARTIALLY_REVERSED' => WalletEntryState.reversed,
    _ => WalletEntryState.pending,
  };
}
