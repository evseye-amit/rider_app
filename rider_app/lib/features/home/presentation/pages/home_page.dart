import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/entities/home_summary.dart';
import '../../domain/usecases/get_home_summary.dart';
import '../cubit/home_cubit.dart';
import '../widgets/rider_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(GetHomeSummary(sl()))..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();

    return ListenableBuilder(
      listenable: session,
      builder: (context, _) => BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.failure) {
            return Scaffold(
              drawer: const RiderDrawer(),
              body: SafeArea(
                child: EmptyState(
                  title: 'Could not load your dashboard',
                  message: state.message,
                  icon: Icons.cloud_off_rounded,
                  tone: AppColors.danger,
                  actionLabel: 'Try again',
                  onAction: () => context.read<HomeCubit>().refresh(),
                ),
              ),
            );
          }

          final HomeSummary? summary = state.summary;

          return HeroScaffold(
            drawer: const RiderDrawer(),
            bottomPadding: 120,
            onRefresh: () => context.read<HomeCubit>().refresh(),
            band: _Band(session: session, summary: summary),
            children: summary == null
                ? const [_HomeSkeleton()]
                : _content(context, summary),
          );
        },
      ),
    );
  }

  List<Widget> _content(BuildContext context, HomeSummary summary) {
    return [
      BalanceStrip(
        label: 'Paid to date',
        amount: Fmt.money(summary.walletBalance),
        caption: 'Deposits and handover fees',
        onTapBalance: () => context.go(Routes.wallet),
        actions: [
          StripAction(
            label: 'Withdraw',
            icon: Icons.south_west_rounded,
            onTap: () => context.go(Routes.wallet),
          ),
          StripAction(
            label: 'History',
            icon: Icons.receipt_long_rounded,
            onTap: () => context.go(Routes.wallet),
          ),
        ],
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
            mainAxisExtent: 114,
          ),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            StatCard(
              label: 'Incentive earned',
              value: Fmt.money(summary.incentiveEarned),
              caption: 'of ${Fmt.money(summary.incentiveTarget)} target',
              icon: Icons.emoji_events_rounded,
              accent: AppColors.primary,
              compact: true,
              onTap: () => context.push(Routes.incentives),
            ),
            StatCard(
              label: 'Rent due',
              value: Fmt.money(summary.rentDue),
              caption: summary.rentDueDate == null
                  ? summary.rentPlan
                  : 'due ${Fmt.date(summary.rentDueDate!)}',
              icon: Icons.receipt_long_rounded,
              accent: AppColors.primary,
              compact: true,
              onTap: () => context.push(Routes.rentals),
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
  final HomeSummary? summary;

  String get _greeting {
    final int h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    if (h < 21) return 'Good evening';
    return 'Riding late';
  }

  @override
  Widget build(BuildContext context) {
    final String name = session.profile['shortName']?.toString() ?? 'Rider';

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
                    _greeting,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    name,
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
            const SizedBox(width: Insets.sm),
            AttendanceToggle(
              present: session.present,
              onChanged: (next) => _confirmAttendance(context, next),
            ),
            const SizedBox(width: Insets.sm),
            InkCircleButton(
              icon: Icons.notifications_none_rounded,
              badgeCount: 2,
              onTap: () => context.push(Routes.notifications),
            ),
          ],
        ),
        const Gap.xxl(),

        Text(
          "Today's earnings",
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                summary == null ? '—' : Fmt.money(summary!.todayEarnings),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
              ),
            ),
            const SizedBox(width: Insets.md),
            if (summary != null && summary!.earningsDelta.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.onInkMint.withValues(alpha: 0.16),
                    borderRadius: Corners.pill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.trending_up_rounded, size: 12, color: AppColors.onInkMint),
                      const SizedBox(width: 3),
                      Text(
                        summary!.earningsDelta,
                        style: AppText.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onInkMint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
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
                  label: 'Trips',
                  value: '${summary?.tripsToday ?? 0}',
                  icon: Icons.route_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Distance',
                  value: Fmt.distanceKm(summary?.distanceTodayKm ?? 0),
                  icon: Icons.near_me_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Online',
                  value: Fmt.duration(
                    Duration(minutes: session.present ? (summary?.onlineMinutes ?? 0) : 0),
                  ),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmAttendance(BuildContext context, bool next) async {
    if (!next) {
      final bool confirmed = await AppDialog.confirm(
        context,
        title: 'Mark yourself absent?',
        message:
            'Your shift will end and the scooter will switch off. Rent still applies on weekly and monthly plans.',
        confirmLabel: 'Mark absent',
        icon: Icons.person_off_rounded,
        destructive: true,
      );
      if (!confirmed) return;
    }

    session.setAttendance(next);
    if (!context.mounted) return;
    next
        ? AppSnack.success(context, 'Marked present. Your shift has started.')
        : AppSnack.warning(context, 'Marked absent. The scooter is now disabled.');
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShimmerBox(height: 116, borderRadius: Corners.brLg),
        const Gap.xxl(),
        const ShimmerBox(width: 130, height: 20),
        const Gap.lg(),

        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: Insets.md,
            mainAxisSpacing: Insets.sm,
            mainAxisExtent: 114,
          ),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            2,
            (_) => const ShimmerBox(height: 114, borderRadius: Corners.brLg),
          ),
        ),
        const Gap.xxl(),
        const ShimmerBox(height: 104, borderRadius: Corners.brLg),
      ],
    );
  }
}
