import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      children: payments == null ? const [_PaymentsSkeleton()] : _content(context, payments),
    );
  }

  List<Widget> _content(BuildContext context, PaymentsOverview payments) {
    return [
      if (payments.isSettled)
        ArtBlock(
          art: BrandArt.success,
          artSize: 130,
          title: context.l10n.paymentsAllClear,
          message: context.l10n.paymentsAllClearMessage,
        )
      else
        ModuleCard(
          title: context.l10n.paymentsAmountDue,
          leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Fmt.money(payments.amountDue), style: AppText.numericLarge.copyWith(color: AppColors.primary)),
              const Gap.md(),
              if (payments.isOverdue)
                KeyValueRow(
                  label: context.l10n.paymentsOverdue,
                  value: Fmt.money(payments.overdueAmount),
                  valueColor: AppColors.danger,
                  icon: Icons.warning_amber_rounded,
                ),
              if (payments.dueDate != null)
                KeyValueRow(
                  label: context.l10n.paymentsDueOn,
                  value: Fmt.date(payments.dueDate!),
                  icon: Icons.event_rounded,
                ),
              const Gap.md(),
              Text(context.l10n.paymentsPayAtHub, style: AppText.bodySmall.copyWith(height: 1.5)),
            ],
          ),
        ),
      const Gap.lg(),
      ModuleCard(
        title: context.l10n.paymentsAutoPay,
        leading: const IconTile(icon: Icons.autorenew_rounded, solid: true, size: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    autoPayLabel(context.l10n, payments.autoPay),
                    style: AppText.titleSmall.copyWith(fontSize: 14),
                  ),
                ),
                StatusChip(
                  label: autoPayLabel(context.l10n, payments.autoPay),
                  tone: autoPayTone(payments.autoPay),
                  dense: true,
                ),
              ],
            ),
            const Gap.md(),
            if (payments.paymentMethod != null)
              KeyValueRow(
                label: context.l10n.paymentsMethod,
                value: payments.paymentMethod!,
                icon: Icons.payments_rounded,
              ),
            if (payments.mandateMaxAmount != null)
              KeyValueRow(
                label: context.l10n.paymentsMandateLimit,
                value: Fmt.money(payments.mandateMaxAmount!),
                icon: Icons.speed_rounded,
              ),
            if (payments.nextAutoPayDate != null)
              KeyValueRow(
                label: context.l10n.paymentsNextDebit,
                value: Fmt.dateTime(payments.nextAutoPayDate!),
                icon: Icons.schedule_rounded,
              ),
            if (payments.mandateExpiresAt != null)
              KeyValueRow(
                label: context.l10n.paymentsMandateExpires,
                value: Fmt.date(payments.mandateExpiresAt!),
                icon: Icons.event_busy_rounded,
              ),
            if (payments.autoPayNeedsAttention) ...[
              const Gap.md(),
              AccentCard(
                accent: AppColors.warning,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.warning),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Text(
                        context.l10n.paymentsAutoPayAttention,
                        style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      const Gap.lg(),
      const _History(),
    ];
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
          ? const ShimmerBox(height: 140, borderRadius: Corners.brLg)
          : records.isEmpty
          ? EmptyState(
              compact: true,
              title: context.l10n.paymentsNoPayments,
              message: context.l10n.paymentsNoPaymentsMessage,
              icon: Icons.receipt_long_rounded,
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
        ShimmerBox(height: 150, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 180, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 160, borderRadius: Corners.brXl),
      ],
    );
  }
}
