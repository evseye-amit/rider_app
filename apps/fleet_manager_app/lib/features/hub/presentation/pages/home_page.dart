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
      onRefresh: () {
        ref.invalidate(unreadNotificationsProvider);
        return ref.refreshQuietly(hubOverviewProvider);
      },
      pinnedBar: const _TopBar(),
      band: _Band(summary: overview?.summary),
      children: overview == null ? const [_HomeSkeleton()] : _content(context, ref, overview),
    );
  }

  List<Widget> _content(BuildContext context, WidgetRef ref, HubOverview overview) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final HubSummary summary = overview.summary;
    final HubQueue? queue = summary.queue;

    return [
      HubCard(
        profile: overview.profile,
        summary: summary,
        hubs: session.hubs,
        selectedIndex: session.selectedHubIndex,
        onSelected: ref.read(fleetSessionProvider.notifier).selectHub,
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.hubQuickView,
        onInfo: () => AppSheet.show<void>(
          context,
          title: context.l10n.hubQuickView,
          subtitle: context.l10n.hubQuickViewInfo,
          child: const _QueueInfo(),
        ),
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
            for (final _QueueCard card in _QueueCard.values)
              StatCard(
                label: card.label(context.l10n),
                value: queue == null ? '—' : '${card.count(queue)}',
                icon: card.icon,
                compact: true,
                labelMaxLines: 2,
                onTap: () => card.open(context),
              ),
          ],
        ),
      ),
    ];
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
          boxShadow: Shadows.lift(AppColors.primary, opacity: 0.16),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.fleetSearchHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _QueueCard {
  allotments(Icons.swap_horiz_rounded),
  submissions(Icons.assignment_return_rounded),
  readyForDeployment(Icons.electric_scooter_rounded),
  underMaintenance(Icons.build_rounded);

  const _QueueCard(this.icon);

  final IconData icon;

  String label(AppL10n l10n) => switch (this) {
    _QueueCard.allotments => l10n.hubAllotmentsInQueue,
    _QueueCard.submissions => l10n.hubSubmissionsInQueue,
    _QueueCard.readyForDeployment => l10n.hubRfdsAvailable,
    _QueueCard.underMaintenance => l10n.hubUnderMaintenanceFleet,
  };

  String info(AppL10n l10n) => switch (this) {
    _QueueCard.allotments => l10n.hubAllotmentsInQueueInfo,
    _QueueCard.submissions => l10n.hubSubmissionsInQueueInfo,
    _QueueCard.readyForDeployment => l10n.hubRfdsAvailableInfo,
    _QueueCard.underMaintenance => l10n.hubUnderMaintenanceFleetInfo,
  };

  int count(HubQueue queue) => switch (this) {
    _QueueCard.allotments => queue.allotments,
    _QueueCard.submissions => queue.submissions,
    _QueueCard.readyForDeployment => queue.readyForDeployment,
    _QueueCard.underMaintenance => queue.underMaintenance,
  };

  void open(BuildContext context) {
    switch (this) {
      case _QueueCard.allotments || _QueueCard.readyForDeployment:
        context.go(Routes.allocations);
      case _QueueCard.submissions:
        context.go(Routes.submissions);
      case _QueueCard.underMaintenance:
        context.go(Routes.maintenance);
    }
  }
}

class _QueueInfo extends StatelessWidget {
  const _QueueInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final _QueueCard card in _QueueCard.values) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(icon: card.icon, size: 38),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.label(context.l10n), style: AppText.titleSmall),
                    const SizedBox(height: 2),
                    Text(card.info(context.l10n), style: AppText.bodySmall.copyWith(height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          if (card != _QueueCard.values.last) const Gap.lg(),
        ],
      ],
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  Future<void> _markAttendance(BuildContext context, WidgetRef ref, bool next) async {
    final Result<bool> result = await ref.read(fleetSessionProvider.notifier).setAttendance(next);
    if (!context.mounted) return;
    switch (result) {
      case Ok<bool>(:final value):
        value
            ? AppSnack.success(context, context.l10n.commonMarkedPresentShiftHasStarted)
            : AppSnack.info(context, context.l10n.hubMarkedAbsentShiftClosed);
      case Err<bool>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final int unread = ref.watch(unreadNotificationsProvider).value ?? 0;

    return Row(
      children: [
        Builder(
          builder: (context) =>
              InkCircleButton(icon: Icons.menu_rounded, onTap: () => Scaffold.of(context).openDrawer()),
        ),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Text(
            session.managerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
          ),
        ),
        const SizedBox(width: Insets.sm),
        AttendanceToggle(present: session.present, onChanged: (next) => _markAttendance(context, ref, next)),
        const SizedBox(width: Insets.sm),
        InkCircleButton(
          icon: Icons.notifications_none_rounded,
          badgeCount: unread,
          onTap: () => context.push(Routes.notifications),
        ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.summary});

  final HubSummary? summary;

  @override
  Widget build(BuildContext context) {
    final HubSummary? current = summary;
    final double? utilisation = current?.utilisation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SearchBar(onTap: () => context.push(Routes.fleetSearch)),
        const Gap.xxl(),
        Text(context.l10n.hubFleetUtilisation, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text(
          utilisation == null ? '—' : Fmt.percent(utilisation),
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
                  label: context.l10n.hubFleetMapped,
                  value: current == null ? '—' : '${current.fleetTotal}',
                  icon: Icons.electric_scooter_rounded,
                  centered: true,
                ),
              ),
              const InkDivider(),
              Expanded(
                child: InkStat(
                  label: context.l10n.hubFleetOnField,
                  value: current == null ? '—' : '${current.fleetAllocated}',
                  icon: Icons.route_rounded,
                  centered: true,
                ),
              ),
              const InkDivider(),
              Expanded(
                child: InkStat(
                  label: context.l10n.hubFleetAtHub,
                  value: current == null ? '—' : '${current.fleetAtHub}',
                  icon: Icons.warehouse_rounded,
                  centered: true,
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
