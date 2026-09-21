import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/earnings_overview.dart';
import '../../domain/usecases/get_earnings_overview.dart';
import '../cubit/earnings_cubit.dart';
import '../widgets/earnings_widgets.dart';

/// A pushed route — how much the rider has earned, broken down, day by day.
/// The ink band carries the period total the way home carries today's
/// earnings, with the period selector living in the band itself.
class EarningsPage extends StatelessWidget {
  const EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarningsCubit(GetEarningsOverview(sl()))..load(),
      child: const _EarningsView(),
    );
  }
}

class _EarningsView extends StatelessWidget {
  const _EarningsView();

  static const List<EarningsPeriod> _periods = [
    EarningsPeriod.daily,
    EarningsPeriod.weekly,
    EarningsPeriod.monthly,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningsCubit, EarningsState>(
      builder: (context, state) {
        final EarningsOverview? overview = state.overview;
        final EarningsBreakdown breakdown =
            overview?.breakdownFor(state.period) ??
            const EarningsBreakdown(
              baseFare: 0,
              distancePay: 0,
              surge: 0,
              incentives: 0,
              deductions: 0,
            );

        return HeroScaffold(
          onRefresh: () => context.read<EarningsCubit>().refresh(),
          band: EarningsBand(
            breakdown: breakdown,
            periods: [for (final p in _periods) p.label],
            selectedIndex: _periods.indexOf(state.period),
            onChanged: (i) =>
                context.read<EarningsCubit>().selectPeriod(_periods[i]),
          ),
          children: state.status == EarningsStatus.failure
              ? [
                  EmptyState(
                    title: 'Could not load your earnings',
                    message: state.message,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: 'Try again',
                    onAction: () => context.read<EarningsCubit>().refresh(),
                  ),
                ]
              : overview == null
              ? const [_EarningsSkeleton()]
              : _content(context, state, overview, breakdown),
        );
      },
    );
  }

  List<Widget> _content(
    BuildContext context,
    EarningsState state,
    EarningsOverview overview,
    EarningsBreakdown breakdown,
  ) {
    final List<EarningsBar> bars = overview.barsFor(state.period);

    return [
      // The chart module rides up over the band, the way home's wallet strip
      // does — the first thing worth a closer look.
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brXl,
          boxShadow: Shadows.floating,
        ),
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EarningsBarDetail(bar: state.selectedBar),
            const Gap.xl(),
            EarningsBarChart(
              bars: bars,
              selectedIndex: state.selectedBarIndex,
              onSelect: (i) => context.read<EarningsCubit>().selectBar(i),
            ),
          ],
        ),
      ),
      const Gap.lg(),

      ModuleCard(
        title: 'Breakdown',
        child: EarningsBreakdownCard(breakdown: breakdown),
      ),
      const Gap.lg(),

      const PhotoPanel(
        photo: BrandPhoto.money,
        height: 130,
        title: 'Every rupee, tracked',
        subtitle: 'Your full earnings land in the wallet the moment a trip closes',
      ),
      const Gap.lg(),

      ModuleCard(
        title: 'Day by day',
        child: DailyEarningsList(entries: overview.dailyEntries),
      ),
    ];
  }
}

class _EarningsSkeleton extends StatelessWidget {
  const _EarningsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        ShimmerBox(height: 200, borderRadius: Corners.brLg),
        Gap.xxl(),
        ShimmerBox(height: 220, borderRadius: Corners.brLg),
        Gap.xxl(),
        ShimmerBox(height: 180, borderRadius: Corners.brLg),
      ],
    );
  }
}
