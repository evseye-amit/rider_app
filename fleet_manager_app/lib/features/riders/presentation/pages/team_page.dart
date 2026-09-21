import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/rider.dart';
import '../../domain/usecases/get_riders.dart';
import '../cubit/riders_cubit.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RidersCubit(GetRiders(sl()))..load(),
      child: const _RidersView(),
    );
  }
}

class _RidersView extends StatefulWidget {
  const _RidersView();

  @override
  State<_RidersView> createState() => _RidersViewState();
}

class _RidersViewState extends State<_RidersView> {
  final TextEditingController _search = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Rider> _filtered(List<Rider> all, RiderState state) {
    final String q = _search.text.trim().toLowerCase();
    return all.where((r) => r.state == state).where((r) {
      if (q.isEmpty) return true;
      return r.name.toLowerCase().contains(q) ||
          r.riderCode.toLowerCase().contains(q) ||
          (r.vehicleNumber ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RidersCubit, RidersState>(
      builder: (context, state) {
        if (state.status == RidersStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: EmptyState(
                      title: 'Could not load the team',
                      message: state.message,
                      icon: Icons.cloud_off_rounded,
                      tone: AppColors.danger,
                      actionLabel: 'Try again',
                      onAction: () => context.read<RidersCubit>().refresh(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final List<Rider> active = _filtered(state.riders, RiderState.active);
        final List<Rider> onboarding = _filtered(
          state.riders,
          RiderState.onboarding,
        );
        final List<Rider> exited = _filtered(state.riders, RiderState.exited);
        final List<List<Rider>> byTab = [active, onboarding, exited];
        final List<Rider> shown = state.isLoading ? const [] : byTab[_tab];

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<RidersCubit>().refresh(),
          band: _RidersBand(riders: state.riders, loading: state.isLoading),
          children: state.isLoading
              ? const [_RidersSkeleton()]
              : [
                  ModuleCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppSearchField(
                          hint: 'Search name, code or vehicle',
                          controller: _search,
                          onChanged: (_) => setState(() {}),
                        ),
                        const Gap.md(),
                        SegmentedTabs(
                          items: const ['Active', 'Onboarding', 'Exited'],
                          selectedIndex: _tab,
                          onChanged: (i) => setState(() => _tab = i),
                          counts: {
                            0: active.length,
                            1: onboarding.length,
                            2: exited.length,
                          },
                        ),
                      ],
                    ),
                  ),
                  const Gap.lg(),
                  if (shown.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: Insets.lg),
                      child: ArtBlock(
                        art: BrandArt.empty,
                        artSize: 130,
                        title: 'No riders here',
                        message: 'Nobody matches this search in this list.',
                      ),
                    )
                  else
                    ModuleCard(
                      child: Column(
                        children: [
                          for (final r in shown) ...[
                            _RiderRow(
                              rider: r,
                              onTap: () => _openRiderSheet(context, r),
                            ),
                            if (r != shown.last) ...[
                              const Gap.md(),
                              Divider(
                                color: AppColors.stroke.withValues(alpha: 0.6),
                                height: 1,
                              ),
                              const Gap.md(),
                            ],
                          ],
                        ],
                      ),
                    ),
                ],
        );
      },
    );
  }

  Future<void> _openRiderSheet(BuildContext context, Rider rider) async {
    await AppSheet.show(
      context,
      title: rider.name,
      subtitle: rider.riderCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: rider.name,
                size: 56,
                showRing: rider.state == RiderState.active,
              ),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip(
                      label: rider.state.label,
                      tone: switch (rider.state) {
                        RiderState.active => StatusTone.success,
                        RiderState.onboarding => StatusTone.warning,
                        RiderState.exited => StatusTone.neutral,
                      },
                      dense: true,
                    ),
                    const SizedBox(height: Insets.sm),
                    Text(
                      Fmt.phone(rider.mobile),
                      style: AppText.bodyMedium.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap.xl(),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const Gap.md(),
          KeyValueRow(
            label: 'Team lead',
            value: rider.teamLead,
            icon: Icons.supervisor_account_rounded,
          ),
          KeyValueRow(
            label: 'Plan',
            value: rider.plan,
            icon: Icons.workspace_premium_rounded,
          ),
          KeyValueRow(
            label: 'Vehicle',
            value: rider.hasVehicle
                ? rider.vehicleNumber!
                : 'Awaiting allocation',
            icon: Icons.electric_scooter_rounded,
          ),
          if (rider.kycStatus != null)
            KeyValueRow(
              label: 'KYC status',
              value: rider.kycStatus == 'verified' ? 'Verified' : 'Pending',
              icon: Icons.verified_user_rounded,
              valueColor: rider.kycStatus == 'verified'
                  ? AppColors.success
                  : AppColors.warning,
            ),
          if (rider.exitReason != null)
            KeyValueRow(
              label: 'Exit reason',
              value: rider.exitReason!,
              icon: Icons.logout_rounded,
              valueColor: AppColors.textMuted,
            ),
          if (rider.joinedOn != null)
            KeyValueRow(
              label: rider.state == RiderState.exited
                  ? 'Joined'
                  : 'With the hub since',
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
              label: 'Call',
              icon: Icons.call_rounded,
              size: AppButtonSize.medium,
              onPressed: () {
                Navigator.of(context).pop();
                AppSnack.info(
                  context,
                  'Calling ${rider.name} · ${Fmt.phone(rider.mobile)}',
                );
              },
            ),
          ),
          if (rider.hasVehicle) ...[
            const SizedBox(width: Insets.md),
            Expanded(
              flex: 3,
              child: PrimaryButton(
                label: 'Allocations',
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

class _RidersBand extends StatelessWidget {
  const _RidersBand({required this.riders, required this.loading});

  final List<Rider> riders;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final int active = riders.where((r) => r.state == RiderState.active).length;
    final int onboarding = riders
        .where((r) => r.state == RiderState.onboarding)
        .length;
    final int exited = riders.where((r) => r.state == RiderState.exited).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(
              icon: Icons.groups_rounded,
              tone: AppColors.primaryBright,
              solid: true,
              size: 46,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                'Team',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(
                  fontSize: 24,
                  color: AppColors.onInk,
                ),
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(
          'Riders on the roster',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          loading ? '—' : '${riders.length}',
          style: AppText.numericLarge.copyWith(
            fontSize: 38,
            color: AppColors.onInk,
          ),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Active',
                  value: '$active',
                  icon: Icons.bolt_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Onboarding',
                  value: '$onboarding',
                  icon: Icons.hourglass_top_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Exited',
                  value: '$exited',
                  icon: Icons.logout_rounded,
                ),
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
          AppAvatar(
            name: rider.name,
            size: 46,
            showRing: rider.state == RiderState.active,
          ),
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
                      rider.hasVehicle
                          ? Icons.electric_scooter_rounded
                          : Icons.hourglass_empty_rounded,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        rider.hasVehicle
                            ? rider.vehicleNumber!
                            : 'Awaiting allocation',
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
                StatusChip(
                  label: rider.state.label,
                  dense: true,

                  tone: switch (rider.state) {
                    RiderState.active => StatusTone.success,
                    RiderState.onboarding => StatusTone.warning,
                    RiderState.exited => StatusTone.neutral,
                  },
                ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShimmerBox(height: 256, borderRadius: Corners.brXl),
        const Gap.lg(),
        const ShimmerBox(height: 420, borderRadius: Corners.brXl),
      ],
    );
  }
}
