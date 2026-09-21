import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/maintenance_board.dart';
import '../../domain/entities/maintenance_job.dart';
import '../../domain/entities/maintenance_summary.dart';
import '../../domain/usecases/get_maintenance_board.dart';
import '../cubit/maintenance_cubit.dart';
import '../widgets/maintenance_widgets.dart';

const List<String> _statusTabs = ['open', 'inProgress', 'overdue', 'closed'];
const List<String> _priorityFilters = ['All', 'High', 'Normal', 'Low'];

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MaintenanceCubit(GetMaintenanceBoard(sl()))..load(),
      child: const _MaintenanceView(),
    );
  }
}

class _MaintenanceView extends StatefulWidget {
  const _MaintenanceView();

  @override
  State<_MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<_MaintenanceView> {
  int _tab = 0;
  int _priorityFilter = 0;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceCubit, MaintenanceState>(
      builder: (context, state) {
        if (state.status == MaintenanceStatus.failure || (state.board == null && !state.isLoading)) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load the maintenance board',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<MaintenanceCubit>().refresh(),
              ),
            ),
          );
        }

        final MaintenanceBoard? board = state.board;

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<MaintenanceCubit>().refresh(),
          floatingAction: _RaiseJobFab(onTap: () => context.push(Routes.raiseMaintenance)),
          band: _Band(board: board),
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
      },
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.board});

  final MaintenanceBoard? board;

  @override
  Widget build(BuildContext context) {
    final MaintenanceSummary? summary = board?.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const IconTile(icon: Icons.build_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                'Maintenance board',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.sm(),
        Text(
          'Track every job from raised to closed',
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
                  label: 'Open',
                  value: '${summary?.open ?? 0}',
                  icon: Icons.build_circle_outlined,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Overdue',
                  value: '${summary?.overdue ?? 0}',
                  icon: Icons.warning_amber_rounded,
                  valueColor: (summary?.overdue ?? 0) > 0 ? AppColors.onInkCoral : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'In progress',
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
    final List<MaintenanceJob> jobs = board.jobs.where((j) {
      final String q = query.trim().toLowerCase();
      final bool matchesStatus = j.status == status;
      final bool matchesQuery = q.isEmpty ||
          j.vehicleNumber.toLowerCase().contains(q) ||
          j.id.toLowerCase().contains(q) ||
          j.issue.toLowerCase().contains(q);
      final bool matchesPriority = priorityFilter == 0 ||
          j.priority.toLowerCase() == _priorityFilters[priorityFilter].toLowerCase();
      return matchesStatus && matchesQuery && matchesPriority;
    }).toList(growable: false);

    final Map<int, int> counts = {
      for (int i = 0; i < _statusTabs.length; i++)
        i: board.jobs.where((j) => j.status == _statusTabs[i]).length,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: Corners.brXl,
            boxShadow: Shadows.floating,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PhotoPanel(
                photo: BrandPhoto.service,
                height: 132,
                title: 'Service bay',
                subtitle:
                    '${board.summary.closedThisWeek} closed this week · avg ${board.summary.averageCloseHours}h',
              ),
              const Gap.xl(),
              SegmentedTabs(
                items: const ['Open', 'Active', 'Overdue', 'Closed'],
                selectedIndex: tab,
                onChanged: onTabChanged,
                counts: counts,
              ),
              const Gap.lg(),
              AppSearchField(
                hint: 'Search vehicle, job ID or issue',
                controller: searchController,
                onChanged: onQueryChanged,
              ),
              const Gap.md(),
              FilterChipBar(
                items: _priorityFilters,
                selectedIndex: priorityFilter,
                onChanged: onPriorityChanged,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Gap.xl(),
        if (jobs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 130,
              title: 'No jobs here',
              message: 'Nothing matches this queue and filter right now.',
            ),
          )
        else
          Column(
            children: [
              for (final j in jobs) ...[
                JobRowTile(
                  job: j,
                  onTap: () => context.push('${Routes.maintenanceDetail}?id=${j.id}'),
                ),
                if (j != jobs.last) const Gap.md(),
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 20, color: Colors.white),
            SizedBox(width: Insets.sm),
            Text(
              'Raise job',
              style: TextStyle(
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.floating,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerBox(height: 132, borderRadius: Corners.brLg),
          const Gap.xl(),
          const ShimmerBox(height: 42, borderRadius: Corners.pill),
          const Gap.lg(),
          const ShimmerBox(height: 46, borderRadius: Corners.pill),
          const Gap.xl(),
          for (int i = 0; i < 3; i++) ...[
            const ShimmerBox(height: 170, borderRadius: Corners.brLg),
            const Gap.md(),
          ],
        ],
      ),
    );
  }
}
