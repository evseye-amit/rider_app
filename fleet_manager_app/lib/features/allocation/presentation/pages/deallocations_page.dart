import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/allocation_board.dart';
import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/get_allocation_board.dart';
import '../cubit/allocations_cubit.dart';
import '../widgets/allocation_widgets.dart';

const List<String> _priorityFilters = ['All', 'High', 'Normal', 'Low'];

class DeallocationsPage extends StatelessWidget {
  const DeallocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllocationsCubit(GetAllocationBoard(sl()))..load(),
      child: const _DeallocationsView(),
    );
  }
}

class _DeallocationsView extends StatefulWidget {
  const _DeallocationsView();

  @override
  State<_DeallocationsView> createState() => _DeallocationsViewState();
}

class _DeallocationsViewState extends State<_DeallocationsView> {
  int _priorityFilter = 0;
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DeallocationRequest> _returns(AllocationBoard board) =>
      board.returns.where((r) {
        final String q = _query.trim().toLowerCase();
        final bool matchesQuery = q.isEmpty ||
            r.riderName.toLowerCase().contains(q) ||
            r.vehicleNumber.toLowerCase().contains(q) ||
            r.id.toLowerCase().contains(q);
        final bool matchesPriority = _priorityFilter == 0 ||
            r.priority.toLowerCase() ==
                _priorityFilters[_priorityFilter].toLowerCase();
        return matchesQuery && matchesPriority;
      }).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllocationsCubit, AllocationsState>(
      builder: (context, state) {
        if (state.status == AllocationsStatus.failure ||
            (state.board == null && !state.isLoading)) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load returns',
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
        final int waiting = board?.returns.length ?? 0;

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<AllocationsCubit>().refresh(),
          band: DeskBand(
            icon: Icons.assignment_return_rounded,
            title: 'De-allocation',
            subtitle: 'Take a vehicle back and put it on the shelf',
            stats: [
              DeskStat(
                label: 'In the queue',
                value: '$waiting',
                icon: Icons.assignment_return_rounded,
                alert: waiting > 0,
              ),
              DeskStat(
                label: 'Out on road',
                value: '${board?.active.length ?? 0}',
                icon: Icons.electric_scooter_rounded,
              ),
            ],
          ),
          children: board == null
              ? const [AllocationBoardSkeleton()]
              : [_content(context, board)],
        );
      },
    );
  }

  Widget _content(BuildContext context, AllocationBoard board) {
    final List<DeallocationRequest> items = _returns(board);

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
              AppSearchField(
                hint: 'Search rider or vehicle number',
                controller: _searchController,
                onChanged: (q) => setState(() => _query = q),
              ),
              const Gap.md(),
              FilterChipBar(
                items: _priorityFilters,
                selectedIndex: _priorityFilter,
                onChanged: (i) => setState(() => _priorityFilter = i),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Gap.xl(),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 130,
              title: 'Nothing to take back',
              message: 'Every de-allocation request has been processed.',
            ),
          )
        else
          Column(
            children: [
              for (final r in items) ...[
                ReturnRequestTile(
                  request: r,
                  onOpen: () => context.push('${Routes.deallocationDetail}?id=${r.id}'),
                  onProcess: () => context.push('${Routes.deallocationFlow}?id=${r.id}'),
                ),
                if (r != items.last) const Gap.md(),
              ],
            ],
          ),
      ],
    );
  }
}
