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

class Referral extends Equatable {
  const Referral({required this.id, required this.status, this.name, this.mobile, this.invitedAt});

  final String id;
  final ReferralStatus status;
  final String? name;
  final String? mobile;
  final DateTime? invitedAt;

  @override
  List<Object?> get props => [id, status, name, mobile, invitedAt];
}
