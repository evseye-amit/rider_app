import 'package:equatable/equatable.dart';

enum ReferralStatus {
  invited,
  registered,
  kycVerified,
  activated,
  inProgress,
  qualified,
  rewardPending,
  rewardApproved,
  paid,
  expired,
  rejected,
  underReview,
  disqualified,
  cancelled;

  static ReferralStatus parse(String wire) => switch (wire.toUpperCase()) {
    'INVITED' => invited,
    'REGISTERED' => registered,
    'KYC_VERIFIED' => kycVerified,
    'ACTIVATED' => activated,
    'QUALIFIED' => qualified,
    'REWARD_PENDING' => rewardPending,
    'REWARD_APPROVED' => rewardApproved,
    'PAID' => paid,
    'EXPIRED' => expired,
    'REJECTED' => rejected,
    'FRAUD_SUSPECTED' => underReview,
    'DISQUALIFIED' => disqualified,
    'CANCELLED' => cancelled,
    _ => inProgress,
  };
}

enum MilestoneKind {
  kycVerified,
  activated,
  vehicleAllocated,
  activeDays,
  rides,
  deliveries,
  attendanceDays,
  training,
  firstPayment,
  other;

  static MilestoneKind parse(String wire) => switch (wire.toUpperCase()) {
    'KYC_VERIFIED' => kycVerified,
    'RIDER_ACTIVATED' => activated,
    'VEHICLE_ALLOCATED' => vehicleAllocated,
    'ACTIVE_DAYS' => activeDays,
    'COMPLETED_RIDES' => rides,
    'COMPLETED_DELIVERIES' => deliveries,
    'ATTENDANCE_DAYS' => attendanceDays,
    'TRAINING_COMPLETED' => training,
    'FIRST_PAYMENT' => firstPayment,
    _ => other,
  };

  bool get counted => this == activeDays || this == rides || this == deliveries || this == attendanceDays;
}

class ReferralMilestone extends Equatable {
  const ReferralMilestone({required this.kind, required this.target, this.current, this.done = false});

  final MilestoneKind kind;
  final num target;
  final num? current;
  final bool done;

  double get progress {
    final num? value = current;
    if (done) return 1;
    if (value == null || target <= 0) return 0;
    return (value / target).clamp(0, 1).toDouble();
  }

  @override
  List<Object?> get props => [kind, target, current, done];
}

enum RewardStatus {
  pending,
  earned,
  underReview,
  approved,
  processing,
  paid,
  rejected,
  cancelled,
  reversed;

  static RewardStatus parse(String wire) => switch (wire.toUpperCase()) {
    'EARNED' => earned,
    'UNDER_REVIEW' => underReview,
    'APPROVED' => approved,
    'PROCESSING' => processing,
    'PAID' => paid,
    'REJECTED' => rejected,
    'CANCELLED' => cancelled,
    'REVERSED' => reversed,
    _ => pending,
  };
}

class ReferralReward extends Equatable {
  const ReferralReward({required this.forYou, required this.amount, required this.status, this.paidAt});

  final bool forYou;
  final num amount;
  final RewardStatus status;
  final DateTime? paidAt;

  @override
  List<Object?> get props => [forYou, amount, status, paidAt];
}

class Referral extends Equatable {
  const Referral({
    required this.id,
    required this.status,
    this.name,
    this.mobile,
    this.invitedAt,
    this.milestones = const [],
  });

  final String id;
  final ReferralStatus status;
  final String? name;
  final String? mobile;
  final DateTime? invitedAt;
  final List<ReferralMilestone> milestones;

  int get milestonesDone => milestones.where((milestone) => milestone.done).length;

  @override
  List<Object?> get props => [id, status, name, mobile, invitedAt, milestones];
}

class ReferralDetail extends Equatable {
  const ReferralDetail({
    required this.id,
    required this.status,
    required this.milestones,
    required this.rewards,
    this.name,
    this.mobile,
    this.campaignTitle,
    this.invitedAt,
    this.registeredAt,
    this.kycVerifiedAt,
    this.activatedAt,
    this.qualifiedAt,
    this.deadline,
  });

  final String id;
  final ReferralStatus status;
  final List<ReferralMilestone> milestones;
  final List<ReferralReward> rewards;
  final String? name;
  final String? mobile;
  final String? campaignTitle;
  final DateTime? invitedAt;
  final DateTime? registeredAt;
  final DateTime? kycVerifiedAt;
  final DateTime? activatedAt;
  final DateTime? qualifiedAt;
  final DateTime? deadline;

  @override
  List<Object?> get props => [
    id,
    status,
    milestones,
    rewards,
    name,
    mobile,
    campaignTitle,
    invitedAt,
    registeredAt,
    kycVerifiedAt,
    activatedAt,
    qualifiedAt,
    deadline,
  ];
}

enum ReferralEvent {
  registered,
  progress,
  qualified,
  expired,
  rewardPaid,
  other;

  static ReferralEvent parse(String wire) => switch (wire.toUpperCase()) {
    'REFERRAL_REGISTERED' => registered,
    'REFERRAL_PROGRESS_UPDATED' => progress,
    'REFERRAL_QUALIFIED' => qualified,
    'REFERRAL_EXPIRED' => expired,
    'REFERRAL_REWARD_PAID' => rewardPaid,
    _ => other,
  };
}

class ReferralActivity extends Equatable {
  const ReferralActivity({required this.id, required this.event, this.referralId, this.at});

  final String id;
  final ReferralEvent event;
  final String? referralId;
  final DateTime? at;

  @override
  List<Object?> get props => [id, event, referralId, at];
}
