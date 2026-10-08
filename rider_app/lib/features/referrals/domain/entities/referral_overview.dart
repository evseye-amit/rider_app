import 'package:equatable/equatable.dart';

class ReferralCampaign extends Equatable {
  const ReferralCampaign({required this.title, this.description, this.endsAt});

  final String title;
  final String? description;
  final DateTime? endsAt;

  @override
  List<Object?> get props => [title, description, endsAt];
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
    this.shareMessage,
    this.referrerReward,
    this.refereeReward,
  });

  final ReferralSummary summary;
  final ReferralCampaign? campaign;
  final String? code;
  final String? shareLink;
  final String? shareMessage;
  final num? referrerReward;
  final num? refereeReward;

  String inviteMessage(String inviteLink) {
    final String? message = shareMessage;
    final String? link = shareLink;
    if (message == null) return [?code, inviteLink].join(' ');
    if (link != null && message.contains(link)) return message.replaceAll(link, inviteLink);
    return '$message\n$inviteLink';
  }

  @override
  List<Object?> get props => [summary, campaign, code, shareLink, shareMessage, referrerReward, refereeReward];
}
