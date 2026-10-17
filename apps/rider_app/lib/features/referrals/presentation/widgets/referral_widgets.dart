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

String milestoneLabel(AppL10n l10n, ReferralMilestone milestone) {
  final String target = Fmt.number(milestone.target);
  return switch (milestone.kind) {
    MilestoneKind.kycVerified => l10n.referMilestoneKyc,
    MilestoneKind.activated => l10n.referMilestoneActivated,
    MilestoneKind.vehicleAllocated => l10n.referMilestoneVehicle,
    MilestoneKind.activeDays => l10n.referMilestoneActiveDays(target),
    MilestoneKind.rides => l10n.referMilestoneRides(target),
    MilestoneKind.deliveries => l10n.referMilestoneDeliveries(target),
    MilestoneKind.attendanceDays => l10n.referMilestoneAttendance(target),
    MilestoneKind.training => l10n.referMilestoneTraining,
    MilestoneKind.firstPayment => l10n.referMilestonePayment,
    MilestoneKind.other => l10n.referMilestoneOther,
  };
}

IconData milestoneIcon(MilestoneKind kind) => switch (kind) {
  MilestoneKind.kycVerified => Icons.verified_user_rounded,
  MilestoneKind.activated => Icons.how_to_reg_rounded,
  MilestoneKind.vehicleAllocated => Icons.electric_moped_rounded,
  MilestoneKind.activeDays => Icons.event_available_rounded,
  MilestoneKind.rides => Icons.route_rounded,
  MilestoneKind.deliveries => Icons.local_shipping_rounded,
  MilestoneKind.attendanceDays => Icons.fact_check_rounded,
  MilestoneKind.training => Icons.school_rounded,
  MilestoneKind.firstPayment => Icons.payments_rounded,
  MilestoneKind.other => Icons.flag_rounded,
};

String rewardStatusLabel(AppL10n l10n, RewardStatus status) => switch (status) {
  RewardStatus.pending => l10n.referRewardPending,
  RewardStatus.earned => l10n.referRewardEarned,
  RewardStatus.underReview => l10n.referStatusUnderReview,
  RewardStatus.approved => l10n.referStatusRewardApproved,
  RewardStatus.processing => l10n.referRewardProcessing,
  RewardStatus.paid => l10n.referStatusPaid,
  RewardStatus.rejected => l10n.referStatusRejected,
  RewardStatus.cancelled => l10n.referStatusCancelled,
  RewardStatus.reversed => l10n.referRewardReversed,
};

String referralEventLabel(AppL10n l10n, ReferralEvent event) => switch (event) {
  ReferralEvent.registered => l10n.referEventRegistered,
  ReferralEvent.progress => l10n.referEventProgress,
  ReferralEvent.qualified => l10n.referEventQualified,
  ReferralEvent.expired => l10n.referEventExpired,
  ReferralEvent.rewardPaid => l10n.referEventRewardPaid,
  ReferralEvent.other => l10n.referEventOther,
};

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({
    required this.code,
    required this.sharing,
    required this.onCopy,
    required this.onShare,
    required this.onShowQr,
    super.key,
  });

  final String code;
  final bool sharing;
  final VoidCallback onCopy;
  final ValueChanged<BuildContext> onShare;
  final VoidCallback onShowQr;

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
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: context.l10n.referShowQr,
                  icon: Icons.qr_code_2_rounded,
                  size: AppButtonSize.medium,
                  onPressed: onShowQr,
                ),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Builder(
                  builder: (anchor) => PrimaryButton(
                    label: context.l10n.referShareInvite,
                    icon: Icons.share_rounded,
                    size: AppButtonSize.medium,
                    loading: sharing,
                    onPressed: sharing ? null : () => onShare(anchor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HowItWorksCard extends StatelessWidget {
  const HowItWorksCard({required this.campaign, super.key});

  final ReferralCampaign campaign;

  void _showTerms(BuildContext context, String terms) => AppSheet.show<void>(
    context,
    title: context.l10n.referTerms,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Text(terms, style: AppText.bodyMedium.copyWith(height: 1.5)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final String? terms = campaign.terms;
    return ModuleCard(
      title: context.l10n.referHowItWorks,
      leading: const IconTile(icon: Icons.route_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.referHowItWorksBody, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          if (campaign.milestones.isNotEmpty) ...[
            const Gap.md(),
            for (final (int i, ReferralMilestone milestone) in campaign.milestones.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Row(
                  children: [
                    IconTile(icon: milestoneIcon(milestone.kind), size: 32),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Text(
                        '${i + 1}. ${milestoneLabel(context.l10n, milestone)}',
                        style: AppText.titleSmall.copyWith(fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (terms != null) ...[
            const Gap.xs(),
            Align(
              alignment: Alignment.centerLeft,
              child: GhostButton(
                label: context.l10n.referTerms,
                icon: Icons.description_outlined,
                dense: true,
                onPressed: () => _showTerms(context, terms),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReferralActivityCard extends ConsumerWidget {
  const ReferralActivityCard({super.key});

  static const int _shown = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ReferralActivity>? items = ref.watch(referralActivityProvider).value;
    final Set<String> mine = {
      for (final Referral referral in ref.watch(referralsProvider).value ?? const []) referral.id,
    };
    if (items == null || items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: Insets.lg),
      child: ModuleCard(
        title: context.l10n.referActivity,
        leading: const IconTile(icon: Icons.notifications_active_rounded, solid: true, size: 28),
        child: Column(
          children: [
            for (final ReferralActivity item in items.take(_shown))
              AppNavTile(
                title: referralEventLabel(context.l10n, item.event),
                subtitle: item.at == null ? null : Fmt.dateTime(item.at!),
                icon: switch (item.event) {
                  ReferralEvent.registered => Icons.person_add_alt_1_rounded,
                  ReferralEvent.progress => Icons.trending_up_rounded,
                  ReferralEvent.qualified => Icons.emoji_events_rounded,
                  ReferralEvent.expired => Icons.timer_off_rounded,
                  ReferralEvent.rewardPaid => Icons.payments_rounded,
                  ReferralEvent.other => Icons.info_outline_rounded,
                },
                showChevron: mine.contains(item.referralId),
                padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                onTap: mine.contains(item.referralId)
                    ? () => ReferralDetailSheet.show(context, item.referralId!)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

class ReferralDetailSheet extends ConsumerWidget {
  const ReferralDetailSheet({required this.referralId, super.key});

  final String referralId;

  static Future<void> show(BuildContext context, String referralId) => AppSheet.show<void>(
    context,
    title: context.l10n.referDetailTitle,
    maxHeightFactor: 0.9,
    child: ReferralDetailSheet(referralId: referralId),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReferralDetail> detail = ref.watch(referralDetailProvider(referralId));
    final ReferralDetail? value = detail.value;
    if (value == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Insets.xl),
        child: detail.hasError
            ? EmptyState(
                compact: true,
                title: context.l10n.referCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(referralDetailProvider(referralId)),
              )
            : const ShimmerBox(height: 220, borderRadius: Corners.brLg),
      );
    }
    final String title = value.name ?? value.mobile ?? '—';
    final List<(String, DateTime?)> dates = [
      (context.l10n.referInvited, value.invitedAt),
      (context.l10n.referRegistered, value.registeredAt),
      (context.l10n.referStatusKycVerified, value.kycVerifiedAt),
      (context.l10n.referStatusActivated, value.activatedAt),
      (context.l10n.referQualified, value.qualifiedAt),
    ];
    final DateTime? deadline = value.deadline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppAvatar(name: title, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.titleMedium),
                  if (value.name != null && value.mobile != null)
                    Text(value.mobile!, style: AppText.bodySmall.copyWith(fontSize: 12)),
                ],
              ),
            ),
            StatusChip(label: value.status.label(context.l10n), tone: value.status.tone, dense: true),
          ],
        ),
        if (value.campaignTitle != null) ...[
          const Gap.sm(),
          Text(value.campaignTitle!, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted)),
        ],
        if (value.milestones.isNotEmpty) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.referProgress),
          const Gap.sm(),
          for (final ReferralMilestone milestone in value.milestones) _MilestoneProgress(milestone: milestone),
          if (deadline != null)
            Text(
              context.l10n.referCompleteBy(Fmt.date(deadline)),
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
        ],
        if (value.rewards.isNotEmpty) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.referRewards),
          const Gap.sm(),
          for (final ReferralReward reward in value.rewards)
            KeyValueRow(
              label: reward.forYou ? context.l10n.referYouGet : context.l10n.referFriendGets,
              value: '${Fmt.money(reward.amount)} · ${rewardStatusLabel(context.l10n, reward.status)}',
              icon: reward.status == RewardStatus.paid ? Icons.check_circle_rounded : Icons.card_giftcard_rounded,
            ),
        ],
        const Gap.lg(),
        GroupLabel(context.l10n.referTimeline),
        const Gap.sm(),
        for (final (String label, DateTime? at) in dates)
          if (at != null) KeyValueRow(label: label, value: Fmt.dateTime(at), icon: Icons.schedule_rounded, dense: true),
        const Gap.lg(),
      ],
    );
  }
}

class _MilestoneProgress extends StatelessWidget {
  const _MilestoneProgress({required this.milestone});

  final ReferralMilestone milestone;

  @override
  Widget build(BuildContext context) {
    final num? current = milestone.current;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                milestone.done ? Icons.check_circle_rounded : milestoneIcon(milestone.kind),
                size: 18,
                color: milestone.done ? AppColors.success : AppColors.primary,
              ),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(milestoneLabel(context.l10n, milestone), style: AppText.titleSmall.copyWith(fontSize: 13)),
              ),
              if (milestone.kind.counted && current != null)
                Text(
                  '${Fmt.number(current)}/${Fmt.number(milestone.target)}',
                  style: AppText.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
                ),
            ],
          ),
          const SizedBox(height: Insets.xs),
          ClipRRect(
            borderRadius: Corners.pill,
            child: LinearProgressIndicator(
              value: milestone.progress,
              minHeight: 6,
              backgroundColor: AppColors.surfaceMuted,
              color: milestone.done ? AppColors.success : AppColors.primary,
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
      if (referral.milestones.isNotEmpty)
        context.l10n.referStepsDone(referral.milestonesDone, referral.milestones.length),
    ].join(' · ');

    return Pressable(
      onTap: () => ReferralDetailSheet.show(context, referral.id),
      scale: 0.99,
      child: Row(
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
          const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
        ],
      ),
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
