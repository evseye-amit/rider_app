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
  Future<Result<ReferralInvite>> invite() async => (await _api.invite()).map(
    (dto) => ReferralInvite(code: dto.referralCode, shareLink: dto.shareLink, expiresAt: dto.expiresAt),
  );

  ReferralOverview _overview(ReferralHomeDto dto) => ReferralOverview(
    campaign: switch (dto.campaign) {
      final ReferralCampaignDto campaign => ReferralCampaign(
        title: campaign.title,
        description: campaign.description,
        endsAt: campaign.endAt,
      ),
      null => null,
    },
    code: dto.code,
    shareLink: dto.shareLink,
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
  );
}
