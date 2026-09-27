import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../domain/entities/home_summary.dart';
import '../providers/home_summary_provider.dart';
import '../widgets/rider_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<HomeSummary> summary = ref.watch(homeSummaryProvider);

    if (summary.hasError) {
      return Scaffold(
        drawer: const RiderDrawer(),
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.homeCouldNotLoadDashboard,
            message: summary.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(homeSummaryProvider),
          ),
        ),
      );
    }

    final HomeSummary? data = summary.value;

    return HeroScaffold(
      drawer: const RiderDrawer(),
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(homeSummaryProvider),
      band: _Band(summary: data),
      children: data == null ? const [_HomeSkeleton()] : _content(context, data),
    );
  }

  List<Widget> _content(BuildContext context, HomeSummary summary) {
    return [
      BalanceStrip(
        label: context.l10n.commonPaidDate,
        amount: Fmt.money(summary.walletBalance),
        caption: context.l10n.homeDepositsHandoverFees,
        onTapBalance: () => context.go(Routes.wallet),
        actions: [
          StripAction(
            label: context.l10n.homeWithdraw,
            icon: Icons.south_west_rounded,
            onTap: () => context.go(Routes.wallet),
          ),
          StripAction(
            label: context.l10n.homeHistory,
            icon: Icons.receipt_long_rounded,
            onTap: () => context.go(Routes.wallet),
          ),
        ],
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.commonYesterdayGlance,
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
              label: context.l10n.homeIncentiveEarned,
              value: Fmt.money(summary.incentiveEarned),
              caption: 'of ${Fmt.money(summary.incentiveTarget)} target',
              icon: Icons.emoji_events_rounded,
              accent: AppColors.primary,
              compact: true,
              onTap: () => context.push(Routes.incentives),
            ),
            StatCard(
              label: context.l10n.homeRentDue,
              value: Fmt.money(summary.rentDue),
              caption: summary.rentDueDate == null ? summary.rentPlan : 'due ${Fmt.date(summary.rentDueDate!)}',
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

class _Band extends ConsumerWidget {
  const _Band({required this.summary});

  final HomeSummary? summary;

  String _greeting(AppL10n l10n) {
    final int hour = DateTime.now().hour;
    if (hour < 12) return l10n.commonGoodMorning;
    if (hour < 17) return l10n.commonGoodAfternoon;
    if (hour < 21) return l10n.commonGoodEvening;
    return l10n.homeRidingLate;
  }

  Future<void> _confirmAttendance(BuildContext context, WidgetRef ref, bool next) async {
    if (!next) {
      final bool confirmed = await AppDialog.confirm(
        context,
        title: context.l10n.homeMarkYourselfAbsent,
        message: context.l10n.homeShiftWillEndScooterWill,
        confirmLabel: context.l10n.homeMarkAbsent,
        icon: Icons.person_off_rounded,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
    }

    ref.read(riderSessionProvider.notifier).setAttendance(next);
    next
        ? AppSnack.success(context, context.l10n.commonMarkedPresentShiftHasStarted)
        : AppSnack.warning(context, context.l10n.homeMarkedAbsentScooterNowDisabled);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name =
        ref.watch(riderSessionProvider.select((s) => s.profile['shortName']?.toString())) ??
        context.l10n.allocationRider;
    final bool present = ref.watch(riderSessionProvider.select((s) => s.present));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) =>
                  InkCircleButton(icon: Icons.menu_rounded, onTap: () => Scaffold.of(context).openDrawer()),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(context.l10n),
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            AttendanceToggle(present: present, onChanged: (next) => _confirmAttendance(context, ref, next)),
            const SizedBox(width: Insets.sm),
            InkCircleButton(
              icon: Icons.notifications_none_rounded,
              badgeCount: 2,
              onTap: () => context.push(Routes.notifications),
            ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.homeTodaysEarnings, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
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
                  label: context.l10n.homeTrips,
                  value: '${summary?.tripsToday ?? 0}',
                  icon: Icons.route_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.homeDistance,
                  value: Fmt.distanceKm(summary?.distanceTodayKm ?? 0),
                  icon: Icons.near_me_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.homeOnline,
                  value: Fmt.duration(Duration(minutes: present ? (summary?.onlineMinutes ?? 0) : 0)),
                  icon: Icons.schedule_rounded,
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
          children: List.generate(2, (_) => const ShimmerBox(height: 114, borderRadius: Corners.brLg)),
        ),
        const Gap.xxl(),
        const ShimmerBox(height: 104, borderRadius: Corners.brLg),
      ],
    );
  }
}
