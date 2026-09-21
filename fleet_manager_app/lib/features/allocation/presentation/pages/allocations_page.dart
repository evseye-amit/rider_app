import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/active_allocation.dart';
import '../../domain/entities/allocation_board.dart';
import '../../domain/usecases/get_allocation_board.dart';
import '../cubit/allocations_cubit.dart';
import '../widgets/allocation_widgets.dart';

class AllocationsPage extends StatelessWidget {
  const AllocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllocationsCubit(GetAllocationBoard(sl()))..load(),
      child: const _AllocationsView(),
    );
  }
}

class _AllocationsView extends StatefulWidget {
  const _AllocationsView();

  @override
  State<_AllocationsView> createState() => _AllocationsViewState();
}

class _AllocationsViewState extends State<_AllocationsView> {
  int _tab = 0;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(String q, Iterable<String?> fields) =>
      q.isEmpty || fields.any((f) => (f ?? '').toLowerCase().contains(q));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllocationsCubit, AllocationsState>(
      builder: (context, state) {
        if (state.status == AllocationsStatus.failure || (state.board == null && !state.isLoading)) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load allocations',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<AllocationsCubit>().refresh(),
              ),
            ),
          );
        }

        final AllocationBoard? board = state.board;

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<AllocationsCubit>().refresh(),
          band: DeskBand(
            icon: Icons.swap_horiz_rounded,
            title: 'Allocation',
            subtitle: 'Match a waiting rider with a vehicle, then walk the handover through',
            stats: [
              DeskStat(
                label: 'Waiting',
                value: '${board?.pending.length ?? 0}',
                icon: Icons.hourglass_top_rounded,
                alert: (board?.pending.length ?? 0) > 0,
              ),
              DeskStat(
                label: 'Your move',
                value: '${board?.needingAction ?? 0}',
                icon: Icons.touch_app_rounded,
                alert: (board?.needingAction ?? 0) > 0,
              ),
              DeskStat(
                label: 'On road',
                value: '${board?.active.length ?? 0}',
                icon: Icons.electric_scooter_rounded,
              ),
            ],
          ),
          children: board == null ? const [AllocationBoardSkeleton()] : [_content(context, board)],
        );
      },
    );
  }

  Widget _content(BuildContext context, AllocationBoard board) {
    final String q = _query.trim().toLowerCase();
    final List<PendingRider> pending =
        board.pending.where((r) => _matches(q, [r.name, r.riderCode, r.mobile])).toList(growable: false);
    final List<DeploymentAllocation> inProgress = board.inProgress
        .where((a) => _matches(q, [a.rider?.name, a.fleet?.vehicleNumber, a.fleet?.modelName]))
        .toList(growable: false);
    final List<ActiveAllocation> active =
        board.active.where((r) => _matches(q, [r.riderName, r.vehicleNumber, r.model])).toList(growable: false);

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
              SegmentedTabs(
                items: const ['Waiting', 'In progress', 'On road'],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
                counts: {0: board.pending.length, 1: board.inProgress.length, 2: board.active.length},
              ),
              const Gap.lg(),
              AppSearchField(
                hint: switch (_tab) {
                  0 => 'Search rider name, code or mobile',
                  1 => 'Search rider or vehicle',
                  _ => 'Search rider or vehicle number',
                },
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
              ),
            ],
          ),
        ),
        const Gap.xl(),
        switch (_tab) {
          0 => _PendingList(items: pending),
          1 => _InProgressList(items: inProgress),
          _ => _ActiveList(items: active),
        },
      ],
    );
  }
}

class _PendingList extends StatelessWidget {
  const _PendingList({required this.items});

  final List<PendingRider> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: 'Nobody waiting',
          message: 'Every onboarded rider in your hubs has a vehicle or a handover under way.',
        ),
      );
    }
    return Column(
      children: [
        for (final r in items) ...[
          PendingRiderTile(
            rider: r,
            onAssign: () => context.push('${Routes.assignVehicle}?rider=${r.id}'),
          ),
          if (r != items.last) const Gap.md(),
        ],
      ],
    );
  }
}

class _InProgressList extends StatelessWidget {
  const _InProgressList({required this.items});

  final List<DeploymentAllocation> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: 'No handovers in progress',
          message: 'Allocate a vehicle to a waiting rider to start one.',
        ),
      );
    }
    return Column(
      children: [
        for (final a in items) ...[
          DeploymentRequestTile(
            allocation: a,
            onOpen: () => context.push('${Routes.allocationDetail}?id=${a.id}'),
          ),
          if (a != items.last) const Gap.md(),
        ],
      ],
    );
  }
}

class _ActiveList extends StatelessWidget {
  const _ActiveList({required this.items});

  final List<ActiveAllocation> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: 'No vehicles out',
          message: 'Nothing is currently allocated to a rider.',
        ),
      );
    }
    return Column(
      children: [
        for (final r in items) ...[
          ActiveAllocationTile(allocation: r, onOpen: () => _quickView(context, r)),
          if (r != items.last) const Gap.md(),
        ],
      ],
    );
  }

  void _quickView(BuildContext context, ActiveAllocation r) {
    AppSheet.show<void>(
      context,
      title: r.riderName,
      subtitle: r.riderCode.isEmpty ? Fmt.phone(r.mobile) : r.riderCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyValueRow(label: 'Vehicle', value: '${r.vehicleNumber} · ${r.model}'),
          KeyValueRow(label: 'Allocated on', value: Fmt.date(r.allocatedOn)),
          KeyValueRow(label: 'Status', value: r.status == 'riding' ? 'Riding' : 'Idle'),
          const Gap.lg(),
        ],
      ),
      footer: SecondaryButton(
        label: 'Start a return',
        icon: Icons.assignment_return_rounded,
        onPressed: () {
          Navigator.of(context).pop();
          context.push('${Routes.deallocationFlow}?id=${r.id}');
        },
      ),
    );
  }
}
