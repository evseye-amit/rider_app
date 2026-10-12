import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_overview.dart';
import '../providers/referral_providers.dart';

extension ReferralStatusX on ReferralStatus {
  String label(AppL10n l10n) => switch (this) {
    ReferralStatus.invited => l10n.referInvited,
    ReferralStatus.registered => l10n.referRegistered,
    ReferralStatus.kycVerified => l10n.referStatusKycVerified,
    ReferralStatus.activated => l10n.referStatusActivated,
    ReferralStatus.inProgress => l10n.referStatusInProgress,
    ReferralStatus.qualified => l10n.referQualified,
    ReferralStatus.rewardPending => l10n.referStatusRewardPending,
    ReferralStatus.rewardApproved => l10n.referStatusRewardApproved,
    ReferralStatus.paid => l10n.referStatusPaid,
    ReferralStatus.expired => l10n.referStatusExpired,
    ReferralStatus.rejected => l10n.referStatusRejected,
    ReferralStatus.underReview => l10n.referStatusUnderReview,
    ReferralStatus.disqualified => l10n.referStatusDisqualified,
    ReferralStatus.cancelled => l10n.referStatusCancelled,
  };

  StatusTone get tone => switch (this) {
    ReferralStatus.qualified ||
    ReferralStatus.rewardPending ||
    ReferralStatus.rewardApproved ||
    ReferralStatus.paid => StatusTone.success,
    ReferralStatus.expired ||
    ReferralStatus.rejected ||
    ReferralStatus.disqualified ||
    ReferralStatus.cancelled => StatusTone.danger,
    ReferralStatus.underReview => StatusTone.warning,
    _ => StatusTone.brand,
  };
}

class ReferBand extends StatelessWidget {
  const ReferBand({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconTile(icon: Icons.card_giftcard_rounded, size: 44, solid: true),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.referSubtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
              ),
              const SizedBox(height: 1),
              Text(
                context.l10n.navReferEarn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RewardCard extends StatelessWidget {
  const RewardCard({required this.campaign, required this.overview, super.key});

  final ReferralCampaign campaign;
  final ReferralOverview overview;

  @override
  Widget build(BuildContext context) {
    final String? description = campaign.description;
    final DateTime? endsAt = campaign.endsAt;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(campaign.title, style: AppText.titleLarge.copyWith(fontSize: 17)),
          if (description != null) ...[
            const Gap.xs(),
            Text(description, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          ],
          const Gap.lg(),
          Row(
            children: [
              Expanded(
                child: _RewardFigure(label: context.l10n.referYouGet, amount: overview.referrerReward),
              ),
              Container(width: 1, height: 40, color: AppColors.stroke),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: _RewardFigure(label: context.l10n.referFriendGets, amount: overview.refereeReward),
              ),
            ],
          ),
          if (endsAt != null) ...[
            const Gap.md(),
            Text(
              context.l10n.referValidTill(Fmt.date(endsAt)),
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _RewardFigure extends StatelessWidget {
  const _RewardFigure({required this.label, required this.amount});

  final String label;
  final num? amount;

  @override
  Widget build(BuildContext context) {
    final num? value = amount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: Insets.xs),
        Text(
          value == null ? '—' : Fmt.money(value),
          style: AppText.numeric.copyWith(fontSize: 22, color: AppColors.primary),
        ),
      ],
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({
    required this.code,
    required this.sharing,
    required this.onCopy,
    required this.onShare,
    super.key,
  });

  final String code;
  final bool sharing;
  final VoidCallback onCopy;
  final ValueChanged<BuildContext> onShare;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.referYourCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.sm, Insets.sm, Insets.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryWash,
              borderRadius: Corners.brMd,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    code,
                    maxLines: 1,
                    style: AppText.titleMedium.copyWith(letterSpacing: 1, color: AppColors.primaryInk),
                  ),
                ),
                GhostButton(
                  label: context.l10n.referCopyCode,
                  icon: Icons.content_copy_rounded,
                  dense: true,
                  onPressed: onCopy,
                ),
              ],
            ),
          ),
          const Gap.md(),
          Builder(
            builder: (anchor) => PrimaryButton(
              label: context.l10n.referShareInvite,
              icon: Icons.share_rounded,
              size: AppButtonSize.medium,
              loading: sharing,
              onPressed: () => onShare(anchor),
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralSummaryCard extends StatelessWidget {
  const ReferralSummaryCard({required this.summary, super.key});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Figure(value: '${summary.invited}', label: context.l10n.referInvited),
              _Figure(value: '${summary.registered}', label: context.l10n.referRegistered),
              _Figure(value: '${summary.qualified}', label: context.l10n.referQualified),
            ],
          ),
          const Divider(height: Insets.xxl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Figure(value: Fmt.money(summary.totalEarned), label: context.l10n.referTotalEarned),
              _Figure(value: Fmt.money(summary.pending), label: context.l10n.referPending),
              _Figure(value: Fmt.money(summary.paid), label: context.l10n.referPaid),
            ],
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.numericSmall.copyWith(fontSize: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class ReferralsCard extends ConsumerWidget {
  const ReferralsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Referral>> referrals = ref.watch(referralsProvider);
    final List<Referral>? items = referrals.value;

    return ModuleCard(
      title: context.l10n.referYourReferrals,
      child: switch (items) {
        null when referrals.hasError => EmptyState(
          title: context.l10n.referCouldNotLoad,
          message: referrals.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(referralsProvider),
          compact: true,
        ),
        null => const ShimmerBox(height: 64, borderRadius: Corners.brMd),
        [] => EmptyState(
          title: context.l10n.referNoReferralsTitle,
          message: context.l10n.referNoReferralsBody,
          icon: Icons.group_add_rounded,
          compact: true,
        ),
        _ => Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              if (i > 0) const Divider(height: Insets.xl),
              _ReferralRow(referral: items[i]),
            ],
          ],
        ),
      },
    );
  }
}

class _ReferralRow extends StatelessWidget {
  const _ReferralRow({required this.referral});

  final Referral referral;

  @override
  Widget build(BuildContext context) {
    final String title = referral.name ?? referral.mobile ?? '—';
    final DateTime? invitedAt = referral.invitedAt;
    final String details = [
      if (referral.name != null) ?referral.mobile,
      if (invitedAt != null) Fmt.date(invitedAt),
    ].join(' · ');

    return Row(
      children: [
        AppAvatar(name: title, size: 40),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.titleSmall),
              if (details.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: Insets.sm),
        StatusChip(label: referral.status.label(context.l10n), tone: referral.status.tone, dense: true),
      ],
    );
  }
}

class ReferSkeleton extends StatelessWidget {
  const ReferSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 150, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 140, borderRadius: Corners.brLg),
        Gap.lg(),
        ShimmerBox(height: 120, borderRadius: Corners.brLg),
      ],
    );
  }
}
