import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/wallet_summary.dart';
import '../domain/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._api);

  final DeploymentApi _api;

  @override
  Future<Result<WalletSummary>> getWallet() async {
    final Result<RiderWallet> result = await _api.riderWallet();
    return result.map(_summary);
  }

  static WalletSummary _summary(RiderWallet w) {
    final DateTime weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final List<WalletTransaction> transactions = [
      for (final p in w.payments) _transaction(p),
    ]..sort((a, b) => b.at.compareTo(a.at));

    final Iterable<DeploymentPayment> paidThisWeek =
        w.payments.where((p) => p.isPaid && (p.paidAt ?? p.createdAt ?? weekAgo).isAfter(weekAgo));
    final DeploymentPayment? lastPaid = w.payments.where((p) => p.isPaid).fold<DeploymentPayment?>(
      null,
      (best, p) => best == null || (p.paidAt ?? p.createdAt ?? DateTime(0)).isAfter(best.paidAt ?? best.createdAt ?? DateTime(0)) ? p : best,
    );

    return WalletSummary(
      balance: w.totalPaid,
      pendingPayout: w.amountDue,
      lastPayoutAt: lastPaid?.paidAt,
      lastPayoutAmount: lastPaid?.amount ?? 0,
      payoutAccount: '',
      upiId: w.currentPayment?.provider == 'UPI' ? (w.currentPayment?.providerReference ?? '') : '',
      creditedThisWeek: 0,
      deductedThisWeek: paidThisWeek.fold<num>(0, (sum, p) => sum + p.amount),
      incentivesThisWeek: 0,
      transactions: transactions,
    );
  }

  static WalletTransaction _transaction(DeploymentPayment p) {
    final String items = p.items.map((i) => i.label).join(', ');
    final String vehicle = p.vehicleNumber == null ? '' : ' · ${p.vehicleNumber}';
    return WalletTransaction(
      id: p.id,
      type: TransactionType.debit,
      category: 'deposit',
      title: items.isEmpty ? 'Deployment payment' : items,
      subtitle: switch (p.status) {
        'PAID' => 'Verified by your fleet manager$vehicle',
        'SUBMITTED' => 'Reference ${p.providerReference ?? ''} awaiting verification$vehicle',
        'PENDING' => 'Requested by your fleet manager$vehicle',
        _ => '${p.status.toLowerCase()}$vehicle',
      },
      amount: p.amount,
      at: p.paidAt ?? p.submittedAt ?? p.createdAt ?? DateTime.now(),
      status: switch (p.status) {
        'PAID' => 'settled',
        'SUBMITTED' || 'PENDING' => 'pending',
        'FAILED' => 'failed',
        _ => 'held',
      },
    );
  }
}
