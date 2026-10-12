import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../domain/entities/hub_summary.dart';
import '../providers/hub_overview_provider.dart';
import '../widgets/fleet_drawer.dart';
import '../widgets/hub_home_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HubOverview> hub = ref.watch(hubOverviewProvider);

    if (hub.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        drawer: const FleetDrawer(),
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.hubCouldNotLoadHub,
            message: hub.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(hubOverviewProvider),
          ),
        ),
      );
    }

    final HubOverview? overview = hub.value;

    return HeroScaffold(
      drawer: const FleetDrawer(),
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(hubOverviewProvider),
      band: _Band(summary: overview?.summary),
      children: overview == null ? const [_HomeSkeleton()] : _content(context, ref, overview),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, HubOverview overview) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final HubSummary summary = overview.summary;

    return [
      HubCard(
        profile: overview.profile,
        summary: summary,
        hubs: session.hubs,
        selectedIndexes: session.activeHubIndexes,
        onSelectionChanged: ref.read(fleetSessionProvider.notifier).setHubSelection,
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.commonYesterdayGlance,
        padding: const EdgeInsets.all(Insets.md),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: Insets.md,
            mainAxisSpacing: Insets.sm,
            mainAxisExtent: 118,
          ),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              label: context.l10n.hubWaitingAllocate,
              value: '${summary.pendingAllocations}',
              caption: '${summary.todayAllocations} done today',
              icon: Icons.swap_horiz_rounded,
              compact: true,
              onTap: () => context.go(Routes.allocations),
            ),
            StatCard(
              label: context.l10n.hubReturnsClear,
              value: '${summary.pendingDeallocations}',
              caption: '${summary.todayDeallocations} done today',
              icon: Icons.assignment_return_rounded,
              compact: true,
              onTap: () => context.go(Routes.deallocations),
            ),
            StatCard(
              label: context.l10n.hubRidersPresent,
              value: '${summary.ridersPresent}',
              caption: 'of ${summary.ridersActive} active',
              icon: Icons.groups_rounded,
              compact: true,
              onTap: () => context.go(Routes.team),
            ),
            StatCard(
              label: context.l10n.hubOpenJobs,
              value: '${summary.openMaintenance}',
              caption: summary.overdueMaintenance > 0 ? '${summary.overdueMaintenance} overdue' : 'all on schedule',
              icon: Icons.build_rounded,
              compact: true,
              onTap: () => context.go(Routes.maintenance),
            ),
          ],
        ),
      ),
    ];
  }
}

class _Band extends ConsumerWidget {
  const _Band({required this.summary});

  final HubSummary? summary;

  String _greeting(AppL10n l10n) {
    final int hour = DateTime.now().hour;
    if (hour < 12) return l10n.commonGoodMorning;
    if (hour < 17) return l10n.commonGoodAfternoon;
    if (hour < 21) return l10n.commonGoodEvening;
    return l10n.hubWorkingLate;
  }

  void _markAttendance(BuildContext context, WidgetRef ref, bool next) {
    ref.read(fleetSessionProvider.notifier).setAttendance(next);
    next
        ? AppSnack.success(context, context.l10n.commonMarkedPresentShiftHasStarted)
        : AppSnack.info(context, context.l10n.hubMarkedAbsentShiftClosed);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final HubSummary? current = summary;
    final String firstName = session.managerName.split(' ').first;
    final int baysFree = current == null
        ? 0
        : (current.chargingBaysTotal - current.chargingBaysBusy).clamp(0, current.chargingBaysTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) =>
                  InkCircleButton(icon: Icons.menu_rounded, onTap: () => Scaffold.of(context).openDrawer()),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_greeting(context.l10n)}, $firstName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    current?.hubName ?? session.hubName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            AttendanceToggle(present: session.present, onChanged: (next) => _markAttendance(context, ref, next)),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.hubFleetUtilisation, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text(
          current == null ? '—' : Fmt.percent(current.utilisation),
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
                child: InkStat(
                  label: context.l10n.hubUptime,
                  value: current == null ? '—' : Fmt.percent(current.uptime),
                  icon: Icons.bolt_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.hubShift,
                  value: current == null ? '—' : '${current.ridersPresent}/${current.ridersActive}',
                  icon: Icons.groups_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.hubBaysFree,
                  value: current == null ? '—' : '$baysFree',
                  icon: Icons.ev_station_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 210, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 300, borderRadius: Corners.brXl),
      ],
    );
  }
}
