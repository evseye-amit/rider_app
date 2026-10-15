import 'package:equatable/equatable.dart';

enum WalletEntryDirection { credit, debit, unknown }

enum WalletEntryKind {
  topUp('TOP_UP', WalletEntryDirection.credit),
  reward('REWARD', WalletEntryDirection.credit),
  referralReward('REFERRAL_REWARD', WalletEntryDirection.credit),
  selfSubmissionReward('SELF_SUBMISSION_REWARD', WalletEntryDirection.credit),
  refund('REFUND', WalletEntryDirection.credit),
  securityDepositRefund('SECURITY_DEPOSIT_REFUND', WalletEntryDirection.credit),
  reversal('REVERSAL', WalletEntryDirection.credit),
  payment('PAYMENT', WalletEntryDirection.debit),
  rental('RENTAL', WalletEntryDirection.debit),
  onboardingFee('ONBOARDING_FEE', WalletEntryDirection.debit),
  securityDeposit('SECURITY_DEPOSIT', WalletEntryDirection.debit),
  securityDepositDeduction('SECURITY_DEPOSIT_DEDUCTION', WalletEntryDirection.debit),
  securityDepositForfeiture('SECURITY_DEPOSIT_FORFEITURE', WalletEntryDirection.debit),
  penalty('PENALTY', WalletEntryDirection.debit),
  repairCharge('REPAIR_CHARGE', WalletEntryDirection.debit),
  serviceCharge('SERVICE_CHARGE', WalletEntryDirection.debit),
  batteryCharge('BATTERY_CHARGE', WalletEntryDirection.debit),
  swapCharge('SWAP_CHARGE', WalletEntryDirection.debit),
  exchangeFee('EXCHANGE_FEE', WalletEntryDirection.debit),
  trafficChallan('TRAFFIC_CHALLAN', WalletEntryDirection.debit),
  accessoryCharge('ACCESSORY_CHARGE', WalletEntryDirection.debit),
  lostEquipmentCharge('LOST_EQUIPMENT_CHARGE', WalletEntryDirection.debit),
  adjustment('ADJUSTMENT', WalletEntryDirection.unknown),
  unknown('', WalletEntryDirection.unknown);

  const WalletEntryKind(this.wire, this.direction);

  final String wire;
  final WalletEntryDirection direction;

  static WalletEntryKind parse(String? value) =>
      WalletEntryKind.values.firstWhere((kind) => kind.wire == value, orElse: () => WalletEntryKind.unknown);
}

enum WalletEntryState { settled, pending, failed, reversed }

class WalletMoney extends Equatable {
  const WalletMoney({required this.total, required this.held, required this.available});

  static const WalletMoney zero = WalletMoney(total: 0, held: 0, available: 0);

  final num total;
  final num held;
  final num available;

  @override
  List<Object?> get props => [total, held, available];
}

enum WalletEntryOrigin { rewardExpiry, rewardReversal, other }

class WalletEntry extends Equatable {
  const WalletEntry({
    required this.id,
    required this.reference,
    required this.kind,
    required this.state,
    required this.amount,
    required this.at,
    this.description,
    this.referenceType,
    this.referenceId,
  });

  final String id;
  final String reference;
  final WalletEntryKind kind;
  final WalletEntryState state;
  final num amount;
  final DateTime at;
  final String? description;
  final String? referenceType;
  final String? referenceId;

  WalletEntryOrigin get origin => switch (referenceType) {
    'REWARD_EXPIRY' => WalletEntryOrigin.rewardExpiry,
    'REWARD_REVERSAL' => WalletEntryOrigin.rewardReversal,
    _ => WalletEntryOrigin.other,
  };

  WalletEntryDirection get direction => origin == WalletEntryOrigin.other ? kind.direction : WalletEntryDirection.debit;

  bool get isCredit => direction == WalletEntryDirection.credit;

  bool get isDebit => direction == WalletEntryDirection.debit;

  @override
  List<Object?> get props => [id, reference, kind, state, amount, at, description, referenceType, referenceId];
}

class DepositReturn extends Equatable {
  const DepositReturn({
    required this.id,
    required this.amount,
    required this.status,
    required this.toWallet,
    required this.requestedAt,
    required this.returned,
    this.completedAt,
  });

  final String id;
  final num amount;
  final String status;
  final bool toWallet;
  final DateTime requestedAt;
  final bool returned;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [id, amount, status, toWallet, requestedAt, returned, completedAt];
}

class WalletDeposit extends Equatable {
  const WalletDeposit({
    required this.id,
    required this.status,
    required this.required_,
    required this.funded,
    required this.held,
    required this.refundable,
    this.outstanding = 0,
    this.locked = 0,
    this.deducted = 0,
    this.refunded = 0,
    this.returns = const [],
  });

  final String id;
  final String status;
  final num required_;
  final num funded;
  final num held;
  final num refundable;
  final num outstanding;
  final num locked;
  final num deducted;
  final num refunded;
  final List<DepositReturn> returns;

  double get fundedProgress => required_ <= 0 ? 0 : (funded / required_).clamp(0, 1).toDouble();

  @override
  List<Object?> get props => [
    id,
    status,
    required_,
    funded,
    held,
    refundable,
    outstanding,
    locked,
    deducted,
    refunded,
    returns,
  ];
}

class StatementLine extends Equatable {
  const StatementLine({
    required this.id,
    required this.number,
    required this.kind,
    required this.description,
    required this.at,
    required this.change,
    required this.depositChange,
    required this.reversed,
  });

  final String id;
  final String number;
  final WalletEntryKind kind;
  final String description;
  final DateTime at;
  final num change;
  final num depositChange;
  final bool reversed;

  @override
  List<Object?> get props => [id, number, kind, description, at, change, depositChange, reversed];
}

class WalletStatementView extends Equatable {
  const WalletStatementView({
    required this.reference,
    required this.opening,
    required this.moneyIn,
    required this.moneyOut,
    required this.closing,
    required this.depositClosing,
    required this.lines,
    required this.total,
  });

  final String reference;
  final num opening;
  final num moneyIn;
  final num moneyOut;
  final num closing;
  final num depositClosing;
  final List<StatementLine> lines;
  final int total;

  bool get hasMore => lines.length < total;

  @override
  List<Object?> get props => [reference, opening, moneyIn, moneyOut, closing, depositClosing, lines, total];
}

class WalletOverview extends Equatable {
  const WalletOverview({
    required this.currency,
    required this.spendable,
    required this.cash,
    required this.rewards,
    required this.depositBucket,
    required this.rewardsEarned,
    required this.rewardsExpiringSoon,
    required this.deposits,
    required this.recentEntries,
  });

  final String currency;
  final WalletMoney spendable;
  final WalletMoney cash;
  final WalletMoney rewards;
  final WalletMoney depositBucket;
  final num rewardsEarned;
  final num rewardsExpiringSoon;
  final List<WalletDeposit> deposits;
  final List<WalletEntry> recentEntries;

  bool get hasRewards => rewards.total > 0 || rewardsEarned > 0;

  bool get hasDeposits => deposits.isNotEmpty || depositBucket.total > 0;

  @override
  List<Object?> get props => [
    currency,
    spendable,
    cash,
    rewards,
    depositBucket,
    rewardsEarned,
    rewardsExpiringSoon,
    deposits,
    recentEntries,
  ];
}

class WithdrawalStatus extends Equatable {
  const WithdrawalStatus({
    required this.eligible,
    required this.cashAvailable,
    required this.depositReturnedSeparately,
    this.reason,
  });

  final bool eligible;
  final num cashAvailable;
  final bool depositReturnedSeparately;
  final String? reason;

  @override
  List<Object?> get props => [eligible, cashAvailable, depositReturnedSeparately, reason];
}
