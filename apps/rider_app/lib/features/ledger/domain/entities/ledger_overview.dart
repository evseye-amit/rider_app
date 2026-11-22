import 'package:equatable/equatable.dart';

enum LedgerEntryDirection { credit, debit, unknown }

enum LedgerEntryKind {
  topUp('TOP_UP', LedgerEntryDirection.credit),
  reward('REWARD', LedgerEntryDirection.credit),
  referralReward('REFERRAL_REWARD', LedgerEntryDirection.credit),
  selfSubmissionReward('SELF_SUBMISSION_REWARD', LedgerEntryDirection.credit),
  refund('REFUND', LedgerEntryDirection.credit),
  securityDepositRefund('SECURITY_DEPOSIT_REFUND', LedgerEntryDirection.credit),
  reversal('REVERSAL', LedgerEntryDirection.credit),
  payment('PAYMENT', LedgerEntryDirection.debit),
  rental('RENTAL', LedgerEntryDirection.debit),
  onboardingFee('ONBOARDING_FEE', LedgerEntryDirection.debit),
  securityDeposit('SECURITY_DEPOSIT', LedgerEntryDirection.debit),
  securityDepositDeduction('SECURITY_DEPOSIT_DEDUCTION', LedgerEntryDirection.debit),
  securityDepositForfeiture('SECURITY_DEPOSIT_FORFEITURE', LedgerEntryDirection.debit),
  penalty('PENALTY', LedgerEntryDirection.debit),
  repairCharge('REPAIR_CHARGE', LedgerEntryDirection.debit),
  serviceCharge('SERVICE_CHARGE', LedgerEntryDirection.debit),
  batteryCharge('BATTERY_CHARGE', LedgerEntryDirection.debit),
  swapCharge('SWAP_CHARGE', LedgerEntryDirection.debit),
  exchangeFee('EXCHANGE_FEE', LedgerEntryDirection.debit),
  trafficChallan('TRAFFIC_CHALLAN', LedgerEntryDirection.debit),
  accessoryCharge('ACCESSORY_CHARGE', LedgerEntryDirection.debit),
  lostEquipmentCharge('LOST_EQUIPMENT_CHARGE', LedgerEntryDirection.debit),
  adjustment('ADJUSTMENT', LedgerEntryDirection.unknown),
  unknown('', LedgerEntryDirection.unknown);

  const LedgerEntryKind(this.wire, this.direction);

  final String wire;
  final LedgerEntryDirection direction;

  static LedgerEntryKind parse(String? value) =>
      LedgerEntryKind.values.firstWhere((kind) => kind.wire == value, orElse: () => LedgerEntryKind.unknown);
}

enum LedgerEntryState { settled, pending, failed, reversed }

class LedgerMoney extends Equatable {
  const LedgerMoney({required this.total, required this.held, required this.available});

  static const LedgerMoney zero = LedgerMoney(total: 0, held: 0, available: 0);

  final num total;
  final num held;
  final num available;

  @override
  List<Object?> get props => [total, held, available];
}

enum LedgerEntryOrigin { rewardExpiry, rewardReversal, other }

class LedgerEntry extends Equatable {
  const LedgerEntry({
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
  final LedgerEntryKind kind;
  final LedgerEntryState state;
  final num amount;
  final DateTime at;
  final String? description;
  final String? referenceType;
  final String? referenceId;

  LedgerEntryOrigin get origin => switch (referenceType) {
    'REWARD_EXPIRY' => LedgerEntryOrigin.rewardExpiry,
    'REWARD_REVERSAL' => LedgerEntryOrigin.rewardReversal,
    _ => LedgerEntryOrigin.other,
  };

  LedgerEntryDirection get direction => origin == LedgerEntryOrigin.other ? kind.direction : LedgerEntryDirection.debit;

  bool get isCredit => direction == LedgerEntryDirection.credit;

  bool get isDebit => direction == LedgerEntryDirection.debit;

  @override
  List<Object?> get props => [id, reference, kind, state, amount, at, description, referenceType, referenceId];
}

class DepositReturn extends Equatable {
  const DepositReturn({
    required this.id,
    required this.amount,
    required this.status,
    required this.toLedger,
    required this.requestedAt,
    required this.returned,
    this.completedAt,
  });

  final String id;
  final num amount;
  final String status;
  final bool toLedger;
  final DateTime requestedAt;
  final bool returned;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [id, amount, status, toLedger, requestedAt, returned, completedAt];
}

class LedgerDeposit extends Equatable {
  const LedgerDeposit({
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
  final LedgerEntryKind kind;
  final String description;
  final DateTime at;
  final num change;
  final num depositChange;
  final bool reversed;

  @override
  List<Object?> get props => [id, number, kind, description, at, change, depositChange, reversed];
}

class LedgerStatementView extends Equatable {
  const LedgerStatementView({
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

class LedgerOverview extends Equatable {
  const LedgerOverview({
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
  final LedgerMoney spendable;
  final LedgerMoney cash;
  final LedgerMoney rewards;
  final LedgerMoney depositBucket;
  final num rewardsEarned;
  final num rewardsExpiringSoon;
  final List<LedgerDeposit> deposits;
  final List<LedgerEntry> recentEntries;

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
