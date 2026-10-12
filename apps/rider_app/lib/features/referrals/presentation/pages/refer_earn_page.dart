import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/referral_invite.dart';
import '../../domain/entities/referral_overview.dart';
import '../../referrals_dependencies.dart';
import '../providers/referral_providers.dart';
import '../widgets/referral_widgets.dart';

class ReferEarnPage extends ConsumerStatefulWidget {
  const ReferEarnPage({super.key});

  @override
  ConsumerState<ReferEarnPage> createState() => _ReferEarnPageState();
}

class _ReferEarnPageState extends ConsumerState<ReferEarnPage> {
  bool _sharing = false;

  Future<void> _refresh() async {
    ref.invalidate(referralsProvider);
    await ref.refreshQuietly(referralOverviewProvider);
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (mounted) AppSnack.success(context, context.l10n.referCodeCopied);
  }

  Future<void> _share(BuildContext anchor, ReferralOverview overview) async {
    final RenderBox? box = anchor.findRenderObject() as RenderBox?;
    final Rect? origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    setState(() => _sharing = true);
    final Result<ReferralInvite> result = await ref.read(createReferralInviteProvider)(const NoParams());
    if (!mounted) return;
    setState(() => _sharing = false);

    switch (result) {
      case Ok<ReferralInvite>(:final value):
        await SharePlus.instance.share(
          ShareParams(
            text: overview.inviteMessage(value.shareLink),
            subject: overview.campaign?.title,
            sharePositionOrigin: origin,
          ),
        );
        if (mounted) unawaited(_refresh());
      case Err<ReferralInvite>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ReferralOverview> overview = ref.watch(referralOverviewProvider);
    final ReferralOverview? data = overview.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: _refresh,
      band: const ReferBand(),
      children: switch (data) {
        final ReferralOverview loaded => _content(context, loaded),
        null when overview.hasError => [
          ModuleCard(
            child: EmptyState(
              title: context.l10n.referCouldNotLoad,
              message: overview.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(referralOverviewProvider),
              compact: true,
            ),
          ),
        ],
        null => const [ReferSkeleton()],
      },
    );
  }

  List<Widget> _content(BuildContext context, ReferralOverview overview) {
    final ReferralCampaign? campaign = overview.campaign;
    final String? code = overview.code;

    return [
      if (campaign != null && code != null) ...[
        RewardCard(campaign: campaign, overview: overview),
        const Gap.lg(),
        ReferralCodeCard(
          code: code,
          sharing: _sharing,
          onCopy: () => _copy(code),
          onShare: (anchor) => _share(anchor, overview),
        ),
      ] else
        ModuleCard(
          child: EmptyState(
            title: context.l10n.referNoCampaignTitle,
            message: context.l10n.referNoCampaignBody,
            icon: Icons.card_giftcard_rounded,
            compact: true,
          ),
        ),
      const Gap.lg(),
      ReferralSummaryCard(summary: overview.summary),
      const Gap.lg(),
      const ReferralsCard(),
    ];
  }
}
