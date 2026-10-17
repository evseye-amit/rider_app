import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/referral.dart';
import '../domain/entities/referral_invite.dart';
import '../domain/entities/referral_overview.dart';
import '../domain/referral_repository.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  const ReferralRepositoryImpl(this._api);

  final ReferralApi _api;

  @override
  Future<Result<ReferralOverview>> overview() async => (await _api.home()).map(_overview);

  @override
  Future<Result<List<Referral>>> referrals() async =>
      (await _api.mine()).map((items) => [for (final ReferralDto item in items) _referral(item)]);

  @override
  Future<Result<ReferralDetail>> detail(String id) async => (await _api.detail(id)).map(
    (dto) => ReferralDetail(
      id: dto.id,
      status: ReferralStatus.parse(dto.status),
      milestones: [for (final ReferralMilestoneDto item in dto.milestones) _milestone(item)],
      rewards: [
        for (final ReferralRewardDto reward in dto.rewards)
          ReferralReward(
            forYou: reward.beneficiary == 'REFERRER',
            amount: reward.amount,
            status: RewardStatus.parse(reward.status),
            paidAt: reward.paidAt,
          ),
      ],
      name: dto.refereeName,
      mobile: dto.refereeMobile,
      campaignTitle: dto.campaignTitle,
      invitedAt: dto.invitedAt,
      registeredAt: dto.registeredAt,
      kycVerifiedAt: dto.kycVerifiedAt,
      activatedAt: dto.activatedAt,
      qualifiedAt: dto.qualifiedAt,
      deadline: dto.qualificationDeadlineAt,
    ),
  );

  @override
  Future<Result<List<ReferralActivity>>> activity() async => (await _api.activity()).map(
    (items) => [
      for (final ReferralActivityDto item in items)
        ReferralActivity(
          id: item.id,
          event: ReferralEvent.parse(item.eventType),
          referralId: item.referralId,
          at: item.createdAt,
        ),
    ],
  );

  @override
  Future<Result<ReferralInvite>> invite() async => (await _api.invite()).map(
    (dto) => ReferralInvite(
      code: dto.referralCode,
      shareLink: dto.shareLink,
      inviteToken: dto.inviteToken,
      qrPayload: dto.qrPayload,
      expiresAt: dto.expiresAt,
    ),
  );

  ReferralOverview _overview(ReferralHomeDto dto) => ReferralOverview(
    campaign: switch (dto.campaign) {
      final ReferralCampaignDto campaign => ReferralCampaign(
        title: campaign.title,
        code: campaign.code,
        description: campaign.description,
        terms: campaign.terms,
        endsAt: campaign.endAt,
        milestones: [for (final ReferralMilestoneDto item in campaign.milestones) _milestone(item)],
      ),
      null => null,
    },
    code: dto.code,
    shareLink: dto.shareLink,
    qrPayload: dto.qrPayload,
    shareMessage: dto.shareMessage,
    referrerReward: dto.referrerReward?.value,
    refereeReward: dto.refereeReward?.value,
    summary: ReferralSummary(
      invited: dto.summary.totalInvited,
      registered: dto.summary.registered,
      qualified: dto.summary.qualified,
      totalEarned: dto.summary.totalEarned,
      pending: dto.summary.pendingReward,
      paid: dto.summary.paidReward,
    ),
  );

  Referral _referral(ReferralDto dto) => Referral(
    id: dto.id,
    status: ReferralStatus.parse(dto.status),
    name: dto.refereeName,
    mobile: dto.refereeMobile,
    invitedAt: dto.invitedAt,
    milestones: [for (final ReferralMilestoneDto item in dto.milestones) _milestone(item)],
  );

  static ReferralMilestone _milestone(ReferralMilestoneDto dto) => ReferralMilestone(
    kind: MilestoneKind.parse(dto.type),
    target: dto.target,
    current: dto.current,
    done: dto.isDone,
  );
}
