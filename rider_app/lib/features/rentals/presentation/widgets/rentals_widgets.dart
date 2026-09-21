import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/rental.dart';

String countdownLabel(Duration d) {
  if (d.isNegative) return 'overdue';
  final int days = d.inDays;
  final int hours = d.inHours.remainder(24);
  if (days > 0) return '${days}d ${hours}h';
  return Fmt.duration(d);
}

StatusTone invoiceTone(InvoiceStatus status) => switch (status) {
  InvoiceStatus.paid => StatusTone.success,
  InvoiceStatus.due => StatusTone.warning,
  InvoiceStatus.failed => StatusTone.danger,
};

String invoiceLabel(InvoiceStatus status) => switch (status) {
  InvoiceStatus.paid => 'Paid',
  InvoiceStatus.due => 'Due',
  InvoiceStatus.failed => 'Failed',
};

class RentalsBand extends StatelessWidget {
  const RentalsBand({required this.plan, super.key});

  final RentalPlan? plan;

  @override
  Widget build(BuildContext context) {
    final RentalPlan? p = plan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroBandBar(
          leading: Builder(
            builder: (context) => InkCircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          subtitle: 'Your plan, auto-debit and rent receipts',
          title: 'Rentals',
        ),
        const Gap.xxl(),
        Text(
          p?.name ?? 'Current plan',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                p == null ? '—' : Fmt.money(p.weeklyRent),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.numericLarge.copyWith(
                  fontSize: 38,
                  color: AppColors.onInk,
                ),
              ),
            ),
            const SizedBox(width: Insets.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '/ week',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.onInkSecondary,
                ),
              ),
            ),
          ],
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
                flex: 6,
                child: InkStat(
                  label: 'Next debit',
                  value: p == null ? '—' : Fmt.date(p.nextDebitDate),
                  icon: Icons.event_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 4,
                child: InkStat(
                  label: 'Debits in',
                  value: p == null ? '—' : countdownLabel(p.timeToDebit),
                  icon: Icons.timer_outlined,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 4,
                child: InkStat(
                  label: 'Auto-debit',
                  value: p == null ? '—' : (p.autoDebitEnabled ? 'On' : 'Off'),
                  icon: Icons.autorenew_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({required this.plan, super.key});

  final RentalPlan plan;

  @override
  Widget build(BuildContext context) {
    final bool active = plan.mandateStatus == 'active';
    final Color tone = active
        ? AppColors.success
        : plan.mandateStatus == 'failed'
        ? AppColors.danger
        : AppColors.warning;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.floating,
      ),
      padding: const EdgeInsets.all(Insets.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.verified_user_rounded,
                tone: AppColors.primary,
                solid: true,
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-debit mandate',
                      style: AppText.titleMedium.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plan.mandateRef,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label:
                    plan.mandateStatus[0].toUpperCase() +
                    plan.mandateStatus.substring(1),
                tone: active
                    ? StatusTone.success
                    : (plan.mandateStatus == 'failed'
                          ? StatusTone.danger
                          : StatusTone.warning),
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: Insets.lg),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const SizedBox(height: Insets.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 15, color: tone),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  active
                      ? 'Rent is collected automatically from your linked bank account on the debit date above.'
                      : 'Auto-debit is not active — settle upcoming invoices manually until the mandate is restored.',
                  style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InvoiceTile extends StatelessWidget {
  const InvoiceTile({required this.invoice, this.onTap, super.key});

  final RentalInvoice invoice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            const PhotoThumb(
              photo: BrandPhoto.money,
              size: 44,
              radius: 12,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.periodLabel,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    invoice.paidOn != null
                        ? 'Paid ${Fmt.date(invoice.paidOn!)}'
                        : 'Due ${Fmt.date(invoice.dueDate)}',
                    style: AppText.bodySmall.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.money(invoice.amount),
                  style: AppText.numericSmall.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 3),
                StatusChip(
                  label: invoiceLabel(invoice.status),
                  tone: invoiceTone(invoice.status),
                  dense: true,
                  showDot: false,
                ),
              ],
            ),
            const SizedBox(width: Insets.sm),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceReceiptBody extends StatelessWidget {
  const InvoiceReceiptBody({required this.invoice, super.key});

  final RentalInvoice invoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                invoice.id,
                style: AppText.code.copyWith(fontSize: 14),
              ),
            ),
            StatusChip(
              label: invoiceLabel(invoice.status),
              tone: invoiceTone(invoice.status),
            ),
          ],
        ),
        const Gap.lg(),
        for (final item in invoice.items)
          KeyValueRow(
            label: item.label,
            value: item.amount < 0
                ? '−${Fmt.money(item.amount.abs())}'
                : Fmt.money(item.amount),
            valueColor: item.amount < 0 ? AppColors.mint : null,
          ),
        const SizedBox(height: Insets.sm),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        const SizedBox(height: Insets.sm),
        KeyValueRow(
          label: 'Total',
          value: Fmt.money(invoice.amount),
          valueStyle: AppText.numeric.copyWith(fontSize: 18),
        ),
        const Gap.lg(),
        KeyValueRow(label: 'Billing period', value: invoice.periodLabel),
        KeyValueRow(
          label: invoice.paidOn != null ? 'Paid on' : 'Due on',
          value: Fmt.date(invoice.paidOn ?? invoice.dueDate),
        ),
        const Gap.lg(),
      ],
    );
  }
}
