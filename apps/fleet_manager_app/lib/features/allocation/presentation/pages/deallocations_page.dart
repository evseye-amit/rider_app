import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/allocation_board.dart';
import '../../domain/entities/deallocation_request.dart';
import '../providers/allocation_board_provider.dart';
import '../widgets/allocation_widgets.dart';

const List<String> _priorityValues = ['', 'high', 'normal', 'low'];

class DeallocationsPage extends ConsumerStatefulWidget {
  const DeallocationsPage({super.key});

  @override
  ConsumerState<DeallocationsPage> createState() => _DeallocationsPageState();
}

class _DeallocationsPageState extends ConsumerState<DeallocationsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _priorityFilter = 0;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DeallocationRequest> _returns(AllocationBoard board) {
    final String query = _query.trim().toLowerCase();
    final String priority = _priorityValues[_priorityFilter];
    return board.returns
        .where((request) {
          final bool matchesQuery =
              query.isEmpty ||
              request.riderName.toLowerCase().contains(query) ||
              request.vehicleNumber.toLowerCase().contains(query) ||
              request.id.toLowerCase().contains(query);
          final bool matchesPriority = priority.isEmpty || request.priority.toLowerCase() == priority;
          return matchesQuery && matchesPriority;
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AllocationBoard> allocations = ref.watch(allocationBoardProvider);

    if (allocations.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.allocationCouldNotLoadReturns,
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
    final int waiting = board?.returns.length ?? 0;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(allocationBoardProvider),
      band: DeskBand(
        icon: Icons.assignment_return_rounded,
        title: context.l10n.commonDeAllocation,
        subtitle: context.l10n.allocationTakeVehicleBackPutShelf,
        stats: [
          DeskStat(
            label: context.l10n.allocationQueue,
            value: '$waiting',
            icon: Icons.assignment_return_rounded,
            alert: waiting > 0,
          ),
          DeskStat(
            label: context.l10n.allocationOutRoad,
            value: '${board?.active.length ?? 0}',
            icon: Icons.electric_scooter_rounded,
          ),
        ],
      ),
      children: board == null ? const [AllocationBoardSkeleton()] : [_content(context, board)],
    );
  }

  Widget _content(BuildContext context, AllocationBoard board) {
    final List<DeallocationRequest> items = _returns(board);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSearchField(
                hint: context.l10n.allocationSearchRiderVehicleNumber,
                controller: _searchController,
                onChanged: (q) => setState(() => _query = q),
              ),
              const Gap.md(),
              FilterChipBar(
                items: ['All', context.l10n.commonHigh, context.l10n.commonNormal, 'Low'],
                selectedIndex: _priorityFilter,
                onChanged: (i) => setState(() => _priorityFilter = i),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Gap.xl(),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 130,
              title: context.l10n.allocationNothingTakeBack,
              message: context.l10n.allocationEveryDeAllocationRequestHas,
            ),
          )
        else
          Column(
            children: [
              for (final DeallocationRequest request in items) ...[
                ReturnRequestTile(
                  request: request,
                  onOpen: () => context.push('${Routes.deallocationDetail}?id=${request.id}'),
                  onProcess: () => context.push('${Routes.deallocationFlow}?id=${request.id}'),
                ),
                if (request != items.last) const Gap.md(),
              ],
            ],
          ),
      ],
    );
  }
}
