import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/payments_overview.dart';
import '../providers/payments_provider.dart';
import '../widgets/payments_widgets.dart';

class PaymentsPage extends ConsumerWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PaymentsOverview> overview = ref.watch(paymentsOverviewProvider);

    if (overview.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.paymentsCouldNotLoad,
            message: overview.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(paymentsOverviewProvider),
          ),
        ),
      );
    }

    final PaymentsOverview? payments = overview.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () async {
        ref.invalidate(paymentHistoryProvider);
        await ref.refreshQuietly(paymentsOverviewProvider);
      },
      band: PaymentsBand(overview: payments),
      children: payments == null
          ? const [_PaymentsSkeleton()]
          : [
              if (payments.isSettled) const _AllClear() else _Breakdown(payments: payments),
              const Gap.lg(),
              _DamageChargesTile(count: payments.damageCount, amount: payments.damageDue),
              const Gap.lg(),
              _AutoPayCard(payments: payments),
              const Gap.lg(),
              const _History(),
            ],
    );
  }
}

class _AllClear extends StatelessWidget {
  const _AllClear();

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Row(
        children: [
          const IconTile(icon: Icons.check_circle_rounded, tone: AppColors.success, size: 40),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.paymentsAllClear, style: AppText.titleSmall.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  context.l10n.paymentsAllClearMessage,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.payments});

  final PaymentsOverview payments;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    return ModuleCard(
      title: l10n.paymentsBreakdown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyValueRow(label: l10n.paymentRentAndFees, value: Fmt.money(payments.rentDue), dense: true),
          if (payments.damageDue > 0)
            KeyValueRow(
              label: l10n.damageChargesTitle,
              value: Fmt.money(payments.damageDue),
              valueColor: AppColors.danger,
              dense: true,
            ),
          if (payments.isOverdue)
            KeyValueRow(
              label: l10n.paymentsOverdue,
              value: Fmt.money(payments.rentOverdue),
              valueColor: AppColors.danger,
              dense: true,
            ),
          const Gap.sm(),
          Text(
            l10n.paymentsPayAtHub,
            style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _DamageChargesTile extends StatelessWidget {
  const _DamageChargesTile({required this.count, required this.amount});

  final int count;
  final num amount;

  @override
  Widget build(BuildContext context) {
    final bool unpaid = count > 0;
    return Pressable(
      onTap: () => context.push(Routes.damageCharges),
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.card),
        child: Row(
          children: [
            IconTile(icon: Icons.car_crash_rounded, tone: unpaid ? AppColors.danger : AppColors.textMuted, size: 40),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.damageChargesTitle, style: AppText.titleSmall.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    unpaid ? context.l10n.damageChargesToPay(count) : context.l10n.damageChargesNoUnpaid,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
            if (unpaid) ...[
              Text(Fmt.money(amount), style: AppText.numericSmall.copyWith(fontSize: 14, color: AppColors.danger)),
              const SizedBox(width: Insets.xs),
            ],
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _AutoPayCard extends StatelessWidget {
  const _AutoPayCard({required this.payments});

  final PaymentsOverview payments;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? method = payments.paymentMethod;
    final num? limit = payments.mandateMaxAmount;
    final DateTime? next = payments.nextAutoPayDate;
    final DateTime? expires = payments.mandateExpiresAt;
    final bool hasDetails = method != null || limit != null || next != null || expires != null;

    return ModuleCard(
      title: l10n.paymentsAutoPay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(label: autoPayLabel(l10n, payments.autoPay), tone: autoPayTone(payments.autoPay), dense: true),
          if (hasDetails) const Gap.sm(),
          if (method != null) KeyValueRow(label: l10n.paymentsMethod, value: method, dense: true),
          if (limit != null) KeyValueRow(label: l10n.paymentsMandateLimit, value: Fmt.money(limit), dense: true),
          if (next != null) KeyValueRow(label: l10n.paymentsNextDebit, value: Fmt.dateTime(next), dense: true),
          if (expires != null) KeyValueRow(label: l10n.paymentsMandateExpires, value: Fmt.date(expires), dense: true),
          if (payments.autoPayNeedsAttention) ...[
            const Gap.sm(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    l10n.paymentsAutoPayAttention,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _History extends ConsumerWidget {
  const _History();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PaymentRecord>> history = ref.watch(paymentHistoryProvider);
    final List<PaymentRecord> records = history.value ?? const [];

    return ModuleCard(
      title: context.l10n.paymentsHistory,
      child: history.isLoading && !history.hasValue
          ? const ShimmerBox(height: 120, borderRadius: Corners.brLg)
          : records.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.paymentsNoPayments, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(
                  context.l10n.paymentsNoPaymentsMessage,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
                ),
              ],
            )
          : Column(
              children: [
                for (final PaymentRecord record in records) ...[
                  PaymentRecordTile(record: record),
                  if (record != records.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
    );
  }
}

class _PaymentsSkeleton extends StatelessWidget {
  const _PaymentsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 120, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 72, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 140, borderRadius: Corners.brXl),
      ],
    );
  }
}
