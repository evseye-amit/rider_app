import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/active_allocation.dart';
import '../../domain/entities/allocation_board.dart';
import '../providers/allocation_board_provider.dart';
import '../widgets/allocation_widgets.dart';

class AllocationsPage extends ConsumerStatefulWidget {
  const AllocationsPage({super.key});

  @override
  ConsumerState<AllocationsPage> createState() => _AllocationsPageState();
}

class _AllocationsPageState extends ConsumerState<AllocationsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _tab = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(String query, Iterable<String?> fields) =>
      query.isEmpty || fields.any((field) => (field ?? '').toLowerCase().contains(query));

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AllocationBoard> allocations = ref.watch(allocationBoardProvider);

    if (allocations.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.allocationCouldNotLoadAllocations,
            message: allocations.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(allocationBoardProvider),
          ),
        ),
      );
    }

    final AllocationBoard? board = allocations.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(allocationBoardProvider),
      band: DeskBand(
        icon: Icons.swap_horiz_rounded,
        title: context.l10n.commonAllocation,
        subtitle: context.l10n.allocationMatchWaitingRiderWithVehicle,
        stats: [
          DeskStat(
            label: context.l10n.allocationWaiting,
            value: '${board?.pending.length ?? 0}',
            icon: Icons.hourglass_top_rounded,
            alert: (board?.pending.length ?? 0) > 0,
          ),
          DeskStat(
            label: context.l10n.allocationMove,
            value: '${board?.needingAction ?? 0}',
            icon: Icons.touch_app_rounded,
            alert: (board?.needingAction ?? 0) > 0,
          ),
          DeskStat(
            label: context.l10n.allocationRoad,
            value: '${board?.active.length ?? 0}',
            icon: Icons.electric_scooter_rounded,
          ),
        ],
      ),
      children: board == null ? const [AllocationBoardSkeleton()] : [_content(context, board)],
    );
  }

  Widget _content(BuildContext context, AllocationBoard board) {
    final String query = _query.trim().toLowerCase();
    final List<PendingRider> pending = board.pending
        .where((r) => _matches(query, [r.name, r.riderCode, r.mobile]))
        .toList(growable: false);
    final List<DeploymentAllocation> inProgress = board.inProgress
        .where((a) => _matches(query, [a.rider?.name, a.fleet?.vehicleNumber, a.fleet?.modelName]))
        .toList(growable: false);
    final List<ActiveAllocation> active = board.active
        .where((r) => _matches(query, [r.riderName, r.vehicleNumber, r.model]))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedTabs(
                items: [context.l10n.allocationWaiting, context.l10n.maintenanceProgress, context.l10n.allocationRoad],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
                counts: {0: board.pending.length, 1: board.inProgress.length, 2: board.active.length},
              ),
              const Gap.lg(),
              AppSearchField(
                hint: switch (_tab) {
                  0 => context.l10n.allocationSearchRiderNameCodeMobile,
                  1 => context.l10n.allocationSearchRiderVehicle,
                  _ => context.l10n.allocationSearchRiderVehicleNumber,
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: context.l10n.allocationNobodyWaiting,
          message: context.l10n.allocationEveryOnboardedRiderHubsHas,
        ),
      );
    }
    return Column(
      children: [
        for (final PendingRider rider in items) ...[
          PendingRiderTile(rider: rider, onAssign: () => context.push('${Routes.assignVehicle}?rider=${rider.id}')),
          if (rider != items.last) const Gap.md(),
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: context.l10n.allocationNoHandoversProgress,
          message: context.l10n.allocationAllocateVehicleWaitingRiderStart,
        ),
      );
    }
    return Column(
      children: [
        for (final DeploymentAllocation allocation in items) ...[
          DeploymentRequestTile(
            allocation: allocation,
            onOpen: () => context.push('${Routes.allocationDetail}?id=${allocation.id}'),
          ),
          if (allocation != items.last) const Gap.md(),
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
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 130,
          title: context.l10n.allocationNoVehiclesOut,
          message: context.l10n.allocationNothingCurrentlyAllocatedRider,
        ),
      );
    }
    return Column(
      children: [
        for (final ActiveAllocation allocation in items) ...[
          ActiveAllocationTile(allocation: allocation, onOpen: () => _quickView(context, allocation)),
          if (allocation != items.last) const Gap.md(),
        ],
      ],
    );
  }

  void _quickView(BuildContext context, ActiveAllocation allocation) {
    AppSheet.show<void>(
      context,
      title: allocation.riderName,
      subtitle: allocation.riderCode.isEmpty ? Fmt.phone(allocation.mobile) : allocation.riderCode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KeyValueRow(label: context.l10n.commonVehicle, value: '${allocation.vehicleNumber} · ${allocation.model}'),
          KeyValueRow(label: context.l10n.commonAllocated, value: Fmt.date(allocation.allocatedOn)),
          KeyValueRow(
            label: context.l10n.commonStatus,
            value: allocation.status == 'riding' ? context.l10n.allocationRiding : context.l10n.allocationIdle,
          ),
          const Gap.lg(),
        ],
      ),
      footer: SecondaryButton(
        label: context.l10n.allocationStartReturn,
        icon: Icons.assignment_return_rounded,
        onPressed: () {
          Navigator.of(context).pop();
          context.push('${Routes.deallocationFlow}?id=${allocation.id}');
        },
      ),
    );
  }
}
