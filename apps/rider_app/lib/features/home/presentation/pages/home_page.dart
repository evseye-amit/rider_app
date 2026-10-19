import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../../damage_charges/presentation/widgets/damage_charge_widgets.dart';
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
      bottomPadding: 190,
      onRefresh: () {
        ref.invalidate(unreadNotificationsProvider);
        unawaited(ref.read(riderSessionProvider.notifier).refreshState());
        return ref.refreshQuietly(homeSummaryProvider);
      },
      floatingAction: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: FloatingActionButton(
          onPressed: () => context.push(Routes.support),
          tooltip: context.l10n.commonSupport,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: const Icon(Icons.support_agent_rounded),
        ),
      ),
      band: _Band(summary: data),
      children: data == null ? const [_HomeSkeleton()] : _content(context, data),
    );
  }

  List<Widget> _content(BuildContext context, HomeSummary summary) {
    final AutoPayStatus? autoPay = summary.autoPay;
    return [
      BalanceStrip(
        label: context.l10n.commonPaidDate,
        amount: switch (summary.paidToDate) {
          final num paid => Fmt.money(paid),
          null => '—',
        },
        caption: context.l10n.homeDepositsHandoverFees,
        onTapBalance: () => context.push(Routes.wallet),
        actions: [
          StripAction(
            label: context.l10n.homeWithdraw,
            icon: Icons.south_west_rounded,
            onTap: () => context.push(Routes.wallet),
          ),
          StripAction(
            label: context.l10n.homeHistory,
            icon: Icons.receipt_long_rounded,
            onTap: () => context.push(Routes.wallet),
          ),
        ],
      ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.paymentsTitle,
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              children: [
                StatCard(
                  label: context.l10n.paymentsAutoPay,
                  value: autoPay == null ? '—' : _autoPayLabel(context.l10n, autoPay),
                  caption: switch (summary.nextDebitDate) {
                    final DateTime date => context.l10n.homeNextDebitOn(Fmt.date(date)),
                    null => null,
                  },
                  icon: Icons.autorenew_rounded,
                  accent: switch (autoPay) {
                    AutoPayStatus.active => AppColors.success,
                    final AutoPayStatus status when status.needsAttention => AppColors.warning,
                    _ => AppColors.primary,
                  },
                  compact: true,
                  onTap: () => context.push(Routes.payments),
                ),
                StatCard(
                  label: context.l10n.homeLastPayment,
                  value: switch (summary.lastPaymentAmount) {
                    final num amount => Fmt.money(amount),
                    null => '—',
                  },
                  caption: switch (summary) {
                    HomeSummary(:final DateTime lastPaymentAt) => Fmt.relative(lastPaymentAt),
                    HomeSummary(lastPaymentAmount: null, rentDue: != null) => context.l10n.paymentsNoPayments,
                    _ => null,
                  },
                  icon: Icons.receipt_long_rounded,
                  accent: AppColors.primary,
                  compact: true,
                  onTap: () => context.push(Routes.payments),
                ),
              ],
            ),
            if (summary.damageCount > 0) ...[
              const Gap.sm(),
              DamageChargesNotice(
                amount: summary.damageDue,
                count: summary.damageCount,
                onTap: () => context.push(Routes.damageCharges),
              ),
            ],
          ],
        ),
      ),
    ];
  }

  static String _autoPayLabel(AppL10n l10n, AutoPayStatus status) => switch (status) {
    AutoPayStatus.active => l10n.paymentsAutoPayActive,
    AutoPayStatus.paused => l10n.paymentsAutoPayPaused,
    AutoPayStatus.setupRequired => l10n.paymentsAutoPaySetupRequired,
    AutoPayStatus.authenticationPending => l10n.paymentsAutoPayAuthPending,
    AutoPayStatus.failed => l10n.paymentsAutoPayFailed,
    AutoPayStatus.revoked => l10n.paymentsAutoPayRevoked,
    AutoPayStatus.expired => l10n.paymentsAutoPayExpired,
    AutoPayStatus.notEnabled => l10n.paymentsAutoPayNotEnabled,
  };
}

class _Band extends ConsumerWidget {
  const _Band({required this.summary});

  final HomeSummary? summary;

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

    final Result<bool> result = await ref.read(riderSessionProvider.notifier).setAttendance(next);
    if (!context.mounted) return;
    switch (result) {
      case Ok<bool>(:final value):
        value
            ? AppSnack.success(context, context.l10n.commonMarkedPresentShiftHasStarted)
            : AppSnack.warning(context, context.l10n.homeMarkedAbsentScooterNowDisabled);
      case Err<bool>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  static (String, IconData, Color)? _rentStatus(AppL10n l10n, HomeSummary? summary) => switch (summary) {
    HomeSummary(rentDue: final num due) when due <= 0 => (
      l10n.paymentsNothingDue,
      Icons.check_circle_rounded,
      AppColors.onInkMint,
    ),
    HomeSummary(isOverdue: true, :final num rentOverdue) => (
      l10n.homeRentOverdue(Fmt.money(rentOverdue)),
      Icons.warning_amber_rounded,
      AppColors.onInkCoral,
    ),
    HomeSummary(rentDue: != null, :final DateTime rentDueDate) => (
      l10n.homeRentDueOn(Fmt.date(rentDueDate)),
      Icons.event_rounded,
      AppColors.onInkAmber,
    ),
    _ => null,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String name =
        ref.watch(riderSessionProvider.select((s) => s.profile['shortName']?.toString())) ??
        context.l10n.allocationRider;
    final bool present = ref.watch(riderSessionProvider.select((s) => s.present));
    final int unread = ref.watch(unreadNotificationsProvider).value ?? 0;

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
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
              ),
            ),
            const SizedBox(width: Insets.sm),
            AttendanceToggle(present: present, onChanged: (next) => _confirmAttendance(context, ref, next)),
            const SizedBox(width: Insets.sm),
            InkCircleButton(
              icon: Icons.notifications_none_rounded,
              badgeCount: unread,
              onTap: () => context.push(Routes.notifications),
            ),
          ],
        ),
        const Gap.xxl(),
        Pressable(
          onTap: () => context.push(Routes.payments),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(context.l10n.homeRentDue, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.onInkSecondary),
                ],
              ),
              const Gap.sm(),
              Wrap(
                spacing: Insets.md,
                runSpacing: Insets.xs,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    switch (summary?.rentDue) {
                      final num due => Fmt.money(due),
                      null => '—',
                    },
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
                  ),
                  if (_rentStatus(context.l10n, summary) case (
                    final String label,
                    final IconData icon,
                    final Color tone,
                  ))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: tone.withValues(alpha: 0.16), borderRadius: Corners.pill),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 12, color: tone),
                            const SizedBox(width: 3),
                            Text(
                              label,
                              style: AppText.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w800, color: tone),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
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
                  label: context.l10n.allocationWorkPartner,
                  value: summary?.workPartner ?? '—',
                  icon: Icons.storefront_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.homeDailyRental,
                  value: switch (summary?.dailyRent) {
                    final num rent => Fmt.money(rent),
                    null => '—',
                  },
                  icon: Icons.currency_rupee_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.homeWorkingDays,
                  value: switch (summary?.workingDays) {
                    final int days => '$days',
                    null => '—',
                  },
                  icon: Icons.calendar_month_rounded,
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
      ],
    );
  }
}
