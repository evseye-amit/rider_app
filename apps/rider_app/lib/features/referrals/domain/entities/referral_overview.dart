import 'package:equatable/equatable.dart';

import 'referral.dart';

class ReferralCampaign extends Equatable {
  const ReferralCampaign({required this.title, this.code, this.description, this.endsAt, this.milestones = const []});

  final String title;
  final String? code;
  final String? description;
  final DateTime? endsAt;
  final List<ReferralMilestone> milestones;

  @override
  List<Object?> get props => [title, code, description, endsAt, milestones];
}

class ReferralSummary extends Equatable {
  const ReferralSummary({
    required this.invited,
    required this.registered,
    required this.qualified,
    required this.totalEarned,
    required this.pending,
    required this.paid,
  });

  final int invited;
  final int registered;
  final int qualified;
  final num totalEarned;
  final num pending;
  final num paid;

  @override
  List<Object?> get props => [invited, registered, qualified, totalEarned, pending, paid];
}

class ReferralOverview extends Equatable {
  const ReferralOverview({
    required this.summary,
    this.campaign,
    this.code,
    this.shareLink,
    this.qrPayload,
    this.shareMessage,
    this.referrerReward,
    this.refereeReward,
  });

  final ReferralSummary summary;
  final ReferralCampaign? campaign;
  final String? code;
  final String? shareLink;
  final String? qrPayload;
  final String? shareMessage;
  final num? referrerReward;
  final num? refereeReward;

  @override
  List<Object?> get props => [
    summary,
    campaign,
    code,
    shareLink,
    qrPayload,
    shareMessage,
    referrerReward,
    refereeReward,
  ];
}
