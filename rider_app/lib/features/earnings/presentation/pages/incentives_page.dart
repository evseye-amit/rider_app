import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/incentive_scheme.dart';
import '../../domain/usecases/get_incentives_overview.dart';
import '../cubit/incentives_cubit.dart';
import '../widgets/incentives_widgets.dart';

class IncentivesPage extends StatelessWidget {
  const IncentivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IncentivesCubit(GetIncentivesOverview(sl()))..load(),
      child: const _IncentivesView(),
    );
  }
}

class _IncentivesView extends StatelessWidget {
  const _IncentivesView();

  static const Set<String> _ringSchemes = {'streak'};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncentivesCubit, IncentivesState>(
      builder: (context, state) {
        final IncentivesOverview? overview = state.overview;

        return HeroScaffold(
          overlap: 0,
          onRefresh: () => context.read<IncentivesCubit>().refresh(),
          band: IncentivesBand(
            earnedThisWeek: overview?.earnedThisWeek ?? 0,
            activeCount: overview?.active.length ?? 0,
            achievedCount: overview?.achieved.length ?? 0,
          ),
          children: state.status == IncentivesStatus.failure
              ? [
                  EmptyState(
                    title: 'Could not load your incentives',
                    message: state.message,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: 'Try again',
                    onAction: () => context.read<IncentivesCubit>().refresh(),
                  ),
                ]
              : overview == null
              ? const [_IncentivesSkeleton()]
              : _content(overview),
        );
      },
    );
  }

  List<Widget> _content(IncentivesOverview overview) {
    final List<IncentiveScheme> active = overview.active;
    final List<IncentiveScheme> achieved = overview.achieved;

    return [
      const PhotoPanel(
        photo: BrandPhoto.money,
        height: 130,
        title: 'Turn extra trips into extra pay',
        subtitle: 'Clear a scheme this week and it lands in your wallet instantly',
      ),
      const Gap.lg(),

      if (active.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.xl),
          child: ArtBlock(
            art: BrandArt.success,
            title: 'No active schemes right now',
            message: 'Check back tomorrow for new incentives.',
          ),
        )
      else ...[
        const SectionHeader(title: 'Active schemes'),
        const Gap.lg(),
        for (final scheme in active) ...[
          IncentiveSchemeCard(
            scheme: scheme,
            progressStyle: _ringSchemes.contains(scheme.id)
                ? IncentiveProgressStyle.ring
                : IncentiveProgressStyle.bar,
          ),
          if (scheme != active.last) const Gap.lg(),
        ],
      ],
      if (achieved.isNotEmpty) ...[
        const Gap.xxl(),
        const SectionHeader(
          title: 'Achieved',
          subtitle: 'Already cleared and credited',
        ),
        const Gap.lg(),
        for (final scheme in achieved) ...[
          IncentiveSchemeCard(scheme: scheme, dimmed: true),
          if (scheme != achieved.last) const Gap.lg(),
        ],
      ],
    ];
  }
}

class _IncentivesSkeleton extends StatelessWidget {
  const _IncentivesSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        ShimmerBox(width: 140, height: 20),
        Gap.lg(),
        ShimmerBox(height: 160, borderRadius: Corners.brLg),
        Gap.lg(),
        ShimmerBox(height: 160, borderRadius: Corners.brLg),
      ],
    );
  }
}
