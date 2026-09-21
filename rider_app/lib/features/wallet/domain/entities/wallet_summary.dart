import 'package:equatable/equatable.dart';

enum TransactionType { credit, debit }

class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.at,
    required this.status,
  });

  final String id;
  final TransactionType type;

  final String category;
  final String title;
  final String subtitle;
  final num amount;
  final DateTime at;

  final String status;

  bool get isCredit => type == TransactionType.credit;

  @override
  List<Object?> get props => [
    id,
    type,
    category,
    title,
    subtitle,
    amount,
    at,
    status,
  ];
}

class WalletSummary extends Equatable {
  const WalletSummary({
    required this.balance,
    required this.pendingPayout,
    required this.lastPayoutAt,
    required this.lastPayoutAmount,
    required this.payoutAccount,
    required this.upiId,
    required this.creditedThisWeek,
    required this.deductedThisWeek,
    required this.incentivesThisWeek,
    required this.transactions,
  });

  final num balance;
  final num pendingPayout;
  final DateTime? lastPayoutAt;
  final num lastPayoutAmount;
  final String payoutAccount;
  final String upiId;
  final num creditedThisWeek;
  final num deductedThisWeek;
  final num incentivesThisWeek;
  final List<WalletTransaction> transactions;

  @override
  List<Object?> get props => [
    balance,
    pendingPayout,
    lastPayoutAt,
    lastPayoutAmount,
    payoutAccount,
    upiId,
    creditedThisWeek,
    deductedThisWeek,
    incentivesThisWeek,
    transactions,
  ];
}
