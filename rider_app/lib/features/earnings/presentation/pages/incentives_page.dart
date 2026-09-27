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
                    title: context.l10n.earningsCouldNotLoadIncentives,
                    message: state.message,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: context.l10n.commonTryAgain,
                    onAction: () => context.read<IncentivesCubit>().refresh(),
                  ),
                ]
              : overview == null
              ? const [_IncentivesSkeleton()]
              : _content(context, overview),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, IncentivesOverview overview) {
    final List<IncentiveScheme> active = overview.active;
    final List<IncentiveScheme> achieved = overview.achieved;

    return [
      PhotoPanel(
        photo: BrandPhoto.money,
        height: 130,
        title: context.l10n.earningsTurnExtraTripsIntoExtra,
        subtitle: context.l10n.earningsClearSchemeWeekLandsWallet,
      ),
      const Gap.lg(),

      if (active.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: Insets.xl),
          child: ArtBlock(
            art: BrandArt.success,
            title: context.l10n.earningsNoActiveSchemesRightNow,
            message: context.l10n.earningsCheckBackTomorrowNewIncentives,
          ),
        )
      else ...[
        SectionHeader(title: context.l10n.earningsActiveSchemes),
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
        SectionHeader(
          title: context.l10n.earningsAchieved,
          subtitle: context.l10n.earningsAlreadyClearedCredited,
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
