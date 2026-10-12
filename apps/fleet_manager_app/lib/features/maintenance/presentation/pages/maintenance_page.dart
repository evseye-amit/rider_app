import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/maintenance_board.dart';
import '../../domain/entities/maintenance_job.dart';
import '../../domain/entities/maintenance_summary.dart';
import '../providers/maintenance_board_provider.dart';
import '../widgets/maintenance_widgets.dart';

const List<String> _statusTabs = ['open', 'inProgress', 'overdue', 'closed'];
const List<String> _priorityValues = ['', 'high', 'normal', 'low'];

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  final TextEditingController _searchController = TextEditingController();
  int _tab = 0;
  int _priorityFilter = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<MaintenanceBoard> maintenance = ref.watch(maintenanceBoardProvider);

    if (maintenance.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.maintenanceCouldNotLoadMaintenanceBoard,
            message: maintenance.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(maintenanceBoardProvider),
          ),
        ),
      );
    }

    final MaintenanceBoard? board = maintenance.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(maintenanceBoardProvider),
      floatingAction: _RaiseJobFab(onTap: () => context.push(Routes.raiseMaintenance)),
      band: _Band(summary: board?.summary),
      children: board == null
          ? const [_MaintenanceSkeleton()]
          : [
              _Content(
                board: board,
                tab: _tab,
                onTabChanged: (i) => setState(() => _tab = i),
                query: _query,
                onQueryChanged: (q) => setState(() => _query = q),
                searchController: _searchController,
                priorityFilter: _priorityFilter,
                onPriorityChanged: (i) => setState(() => _priorityFilter = i),
              ),
            ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.summary});

  final MaintenanceSummary? summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.build_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                context.l10n.maintenanceMaintenanceBoard,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.sm(),
        Text(
          context.l10n.maintenanceTrackEveryJobFromRaised,
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.4),
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
                  label: context.l10n.commonOpen,
                  value: '${summary?.open ?? 0}',
                  icon: Icons.build_circle_outlined,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.maintenanceOverdue,
                  value: '${summary?.overdue ?? 0}',
                  icon: Icons.warning_amber_rounded,
                  valueColor: (summary?.overdue ?? 0) > 0 ? AppColors.onInkCoral : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.maintenanceProgress,
                  value: '${summary?.inProgress ?? 0}',
                  icon: Icons.sync_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.board,
    required this.tab,
    required this.onTabChanged,
    required this.query,
    required this.onQueryChanged,
    required this.searchController,
    required this.priorityFilter,
    required this.onPriorityChanged,
  });

  final MaintenanceBoard board;
  final int tab;
  final ValueChanged<int> onTabChanged;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final TextEditingController searchController;
  final int priorityFilter;
  final ValueChanged<int> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    final String status = _statusTabs[tab];
    final String priority = _priorityValues[priorityFilter];
    final String needle = query.trim().toLowerCase();
    final List<MaintenanceJob> jobs = board.jobs
        .where((job) {
          final bool matchesStatus = job.status == status;
          final bool matchesQuery =
              needle.isEmpty ||
              job.vehicleNumber.toLowerCase().contains(needle) ||
              job.id.toLowerCase().contains(needle) ||
              job.issue.toLowerCase().contains(needle);
          final bool matchesPriority = priority.isEmpty || job.priority.toLowerCase() == priority;
          return matchesStatus && matchesQuery && matchesPriority;
        })
        .toList(growable: false);

    final Map<int, int> counts = {
      for (int i = 0; i < _statusTabs.length; i++) i: board.jobs.where((job) => job.status == _statusTabs[i]).length,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PhotoPanel(
                photo: BrandPhoto.service,
                height: 132,
                title: context.l10n.maintenanceServiceBay,
                subtitle: '${board.summary.closedThisWeek} closed this week · avg ${board.summary.averageCloseHours}h',
              ),
              const Gap.xl(),
              SegmentedTabs(
                items: [
                  context.l10n.commonOpen,
                  context.l10n.ridersActive,
                  context.l10n.maintenanceOverdue,
                  context.l10n.maintenanceClosed,
                ],
                selectedIndex: tab,
                onChanged: onTabChanged,
                counts: counts,
              ),
              const Gap.lg(),
              AppSearchField(
                hint: context.l10n.maintenanceSearchVehicleJobIdIssue,
                controller: searchController,
                onChanged: onQueryChanged,
              ),
              const Gap.md(),
              FilterChipBar(
                items: ['All', context.l10n.commonHigh, context.l10n.commonNormal, 'Low'],
                selectedIndex: priorityFilter,
                onChanged: onPriorityChanged,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Gap.xl(),
        if (jobs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 130,
              title: context.l10n.maintenanceNoJobsHere,
              message: context.l10n.maintenanceNothingMatchesQueueFilterRight,
            ),
          )
        else
          Column(
            children: [
              for (final MaintenanceJob job in jobs) ...[
                JobRowTile(job: job, onTap: () => context.push('${Routes.maintenanceDetail}?id=${job.id}')),
                if (job != jobs.last) const Gap.md(),
              ],
            ],
          ),
      ],
    );
  }
}

class _RaiseJobFab extends StatelessWidget {
  const _RaiseJobFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.94,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: Corners.pill,
          boxShadow: Shadows.lift(AppColors.primary, opacity: 0.4, blur: 22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 20, color: Colors.white),
            const SizedBox(width: Insets.sm),
            Text(
              context.l10n.maintenanceRaiseJob2,
              style: const TextStyle(
                fontFamily: AppFonts.body,
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceSkeleton extends StatelessWidget {
  const _MaintenanceSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerBox(height: 132, borderRadius: Corners.brLg),
          const Gap.xl(),
          const ShimmerBox(height: 42, borderRadius: Corners.pill),
          const Gap.lg(),
          const ShimmerBox(height: 46, borderRadius: Corners.pill),
          const Gap.xl(),
          for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 170, borderRadius: Corners.brLg), const Gap.md()],
        ],
      ),
    );
  }
}
