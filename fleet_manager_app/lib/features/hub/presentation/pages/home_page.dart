import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/entities/hub_profile.dart';
import '../../domain/entities/hub_summary.dart';
import '../../domain/usecases/get_hub_profile.dart';
import '../../domain/usecases/get_hub_summary.dart';
import '../cubit/hub_cubit.dart';
import '../widgets/fleet_drawer.dart';
import '../widgets/hub_home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();
    return BlocProvider(
      create: (_) =>
          HubCubit(GetHubSummary(sl()), GetHubProfile(sl()))..load(session.hubCode),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();

    return BlocBuilder<HubCubit, HubState>(
      builder: (context, state) {
        if (state.status == HubStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            drawer: const FleetDrawer(),
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load your hub',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<HubCubit>().refresh(),
              ),
            ),
          );
        }

        final HubSummary? summary = state.summary;
        final HubProfile? profile = state.profile;

        return HeroScaffold(
          drawer: const FleetDrawer(),
          bottomPadding: 120,
          onRefresh: () => context.read<HubCubit>().refresh(),
          band: _Band(session: session, summary: summary),
          children: summary == null || profile == null
              ? const [_HomeSkeleton()]
              : _content(context, session, summary, profile),
        );
      },
    );
  }

  List<Widget> _content(
    BuildContext context,
    SessionController session,
    HubSummary summary,
    HubProfile profile,
  ) {
    return [
      HubCard(
        profile: profile,
        summary: summary,
        hubs: session.hubs,
        selectedIndex: session.hubIndex,
        onHubChanged: (index) {
          session.selectHub(index);
          context.read<HubCubit>().load(session.hubCode);
        },
      ),
      const Gap.lg(),

      ModuleCard(
        title: 'Today at a glance',
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
            StatCard(
              label: 'Waiting to allocate',
              value: '${summary.pendingAllocations}',
              caption: '${summary.todayAllocations} done today',
              icon: Icons.swap_horiz_rounded,
              compact: true,
              onTap: () => context.go(Routes.allocations),
            ),
            StatCard(
              label: 'Returns to clear',
              value: '${summary.pendingDeallocations}',
              caption: '${summary.todayDeallocations} done today',
              icon: Icons.assignment_return_rounded,
              compact: true,
              onTap: () => context.go(Routes.deallocations),
            ),
            StatCard(
              label: 'Riders present',
              value: '${summary.ridersPresent}',
              caption: 'of ${summary.ridersActive} active',
              icon: Icons.groups_rounded,
              compact: true,
              onTap: () => context.go(Routes.team),
            ),
            StatCard(
              label: 'Open jobs',
              value: '${summary.openMaintenance}',
              caption: summary.overdueMaintenance > 0
                  ? '${summary.overdueMaintenance} overdue'
                  : 'all on schedule',
              icon: Icons.build_rounded,
              compact: true,
              onTap: () => context.go(Routes.maintenance),
            ),
          ],
        ),
      ),
    ];
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.session, required this.summary});

  final SessionController session;
  final HubSummary? summary;

  String get _greeting {
    final int h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    if (h < 21) return 'Good evening';
    return 'Working late';
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = session.managerName.split(' ').first;
    final int baysFree = summary == null
        ? 0
        : (summary!.chargingBaysTotal - summary!.chargingBaysBusy)
            .clamp(0, summary!.chargingBaysTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.menu_rounded,
                onTap: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_greeting, $firstName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),

                  Text(
                    summary?.hubName ?? session.hubName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(
                      fontSize: 20,
                      color: AppColors.onInk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(
          'Fleet utilisation',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          summary == null ? '—' : Fmt.percent(summary!.utilisation),
          style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Uptime',
                  value: summary == null ? '—' : Fmt.percent(summary!.uptime),
                  icon: Icons.bolt_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'On shift',
                  value: summary == null
                      ? '—'
                      : '${summary!.ridersPresent}/${summary!.ridersActive}',
                  icon: Icons.groups_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Bays free',
                  value: summary == null ? '—' : '$baysFree',
                  icon: Icons.ev_station_rounded,
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
