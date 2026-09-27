import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/rider.dart';
import '../providers/riders_provider.dart';

class TeamPage extends ConsumerStatefulWidget {
  const TeamPage({super.key});

  @override
  ConsumerState<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends ConsumerState<TeamPage> {
  final TextEditingController _search = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Rider> _filtered(List<Rider> all, RiderState state) {
    final String query = _search.text.trim().toLowerCase();
    return all.where((rider) => rider.state == state).where((rider) {
      if (query.isEmpty) return true;
      return rider.name.toLowerCase().contains(query) ||
          rider.riderCode.toLowerCase().contains(query) ||
          (rider.vehicleNumber ?? '').toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Rider>> riders = ref.watch(ridersProvider);

    if (riders.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.ridersCouldNotLoadTeam,
            message: riders.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(ridersProvider),
          ),
        ),
      );
    }

    final List<Rider>? all = riders.value;
    final List<Rider> active = _filtered(all ?? const [], RiderState.active);
    final List<Rider> onboarding = _filtered(all ?? const [], RiderState.onboarding);
    final List<Rider> exited = _filtered(all ?? const [], RiderState.exited);
    final List<Rider> shown = [active, onboarding, exited][_tab];

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(ridersProvider),
      band: _RidersBand(riders: all ?? const []),
      children: all == null
          ? const [_RidersSkeleton()]
          : [
              ModuleCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSearchField(
                      hint: context.l10n.ridersSearchNameCodeVehicle,
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                    ),
                    const Gap.md(),
                    SegmentedTabs(
                      items: [context.l10n.ridersActive, context.l10n.ridersOnboarding, context.l10n.ridersExited],
                      selectedIndex: _tab,
                      onChanged: (i) => setState(() => _tab = i),
                      counts: {0: active.length, 1: onboarding.length, 2: exited.length},
                    ),
                  ],
                ),
              ),
              const Gap.lg(),
              if (shown.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                  child: ArtBlock(
                    art: BrandArt.empty,
                    artSize: 130,
                    title: context.l10n.ridersNoRidersHere,
                    message: context.l10n.ridersNobodyMatchesSearchList,
                  ),
                )
              else
                ModuleCard(
                  child: Column(
                    children: [
                      for (final Rider rider in shown) ...[
                        _RiderRow(rider: rider, onTap: () => _openRiderSheet(rider)),
                        if (rider != shown.last) ...[
                          const Gap.md(),
                          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
                          const Gap.md(),
                        ],
                      ],
                    ],
                  ),
                ),
            ],
    );
  }

  Future<void> _openRiderSheet(Rider rider) async {
    await AppSheet.show(
      context,
      title: rider.name,
      subtitle: rider.riderCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: rider.name, size: 56, showRing: rider.state == RiderState.active),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip(label: rider.state.label, tone: _stateTone(rider.state), dense: true),
                    const SizedBox(height: Insets.sm),
                    Text(Fmt.phone(rider.mobile), style: AppText.bodyMedium.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const Gap.xl(),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const Gap.md(),
          KeyValueRow(
            label: context.l10n.commonTeamLead,
            value: rider.teamLead,
            icon: Icons.supervisor_account_rounded,
          ),
          KeyValueRow(label: context.l10n.ridersPlan, value: rider.plan, icon: Icons.workspace_premium_rounded),
          KeyValueRow(
            label: context.l10n.commonVehicle,
            value: rider.hasVehicle ? rider.vehicleNumber! : context.l10n.ridersAwaitingAllocation,
            icon: Icons.electric_scooter_rounded,
          ),
          if (rider.kycStatus != null)
            KeyValueRow(
              label: context.l10n.ridersKycStatus,
              value: rider.kycStatus == 'verified' ? context.l10n.ridersVerified : context.l10n.commonPending,
              icon: Icons.verified_user_rounded,
              valueColor: rider.kycStatus == 'verified' ? AppColors.success : AppColors.warning,
            ),
          if (rider.exitReason != null)
            KeyValueRow(
              label: context.l10n.ridersExitReason,
              value: rider.exitReason!,
              icon: Icons.logout_rounded,
              valueColor: AppColors.textMuted,
            ),
          if (rider.joinedOn != null)
            KeyValueRow(
              label: rider.state == RiderState.exited ? context.l10n.ridersJoined : context.l10n.ridersWithHubSince,
              value: Fmt.date(rider.joinedOn!),
              icon: Icons.calendar_today_rounded,
            ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            flex: 2,
            child: SecondaryButton(
              label: context.l10n.ridersCall,
              icon: Icons.call_rounded,
              size: AppButtonSize.medium,
              onPressed: () {
                Navigator.of(context).pop();
                AppSnack.info(context, 'Calling ${rider.name} · ${Fmt.phone(rider.mobile)}');
              },
            ),
          ),
          if (rider.hasVehicle) ...[
            const SizedBox(width: Insets.md),
            Expanded(
              flex: 3,
              child: PrimaryButton(
                label: context.l10n.ridersAllocations,
                icon: Icons.electric_scooter_rounded,
                size: AppButtonSize.medium,
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(Routes.allocations);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

StatusTone _stateTone(RiderState state) => switch (state) {
  RiderState.active => StatusTone.success,
  RiderState.onboarding => StatusTone.warning,
  RiderState.exited => StatusTone.neutral,
};

class _RidersBand extends StatelessWidget {
  const _RidersBand({required this.riders});

  final List<Rider> riders;

  @override
  Widget build(BuildContext context) {
    final int active = riders.where((rider) => rider.state == RiderState.active).length;
    final int onboarding = riders.where((rider) => rider.state == RiderState.onboarding).length;
    final int exited = riders.where((rider) => rider.state == RiderState.exited).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.groups_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.ridersTeam,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.ridersRidersRoster, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text(
          riders.isEmpty ? '—' : '${riders.length}',
          style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(label: context.l10n.ridersActive, value: '$active', icon: Icons.bolt_rounded),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.ridersOnboarding,
                  value: '$onboarding',
                  icon: Icons.hourglass_top_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(label: context.l10n.ridersExited, value: '$exited', icon: Icons.logout_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiderRow extends StatelessWidget {
  const _RiderRow({required this.rider, required this.onTap});

  final Rider rider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Row(
        children: [
          AppAvatar(name: rider.name, size: 46, showRing: rider.state == RiderState.active),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rider.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 2),
                Text(
                  '${rider.riderCode} · ${rider.teamLead}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      rider.hasVehicle ? Icons.electric_scooter_rounded : Icons.hourglass_empty_rounded,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        rider.hasVehicle ? rider.vehicleNumber! : context.l10n.ridersAwaitingAllocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 11.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 104),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusChip(label: rider.state.label, dense: true, tone: _stateTone(rider.state)),
                const SizedBox(height: 6),
                Text(
                  rider.plan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppText.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RidersSkeleton extends StatelessWidget {
  const _RidersSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 256, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 420, borderRadius: Corners.brXl),
      ],
    );
  }
}
