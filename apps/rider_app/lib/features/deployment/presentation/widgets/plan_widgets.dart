import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class PlanSummary extends StatelessWidget {
  const PlanSummary({required this.breakdown, this.paid = false, super.key});

  final CommercialBreakdown breakdown;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String suffix = rentalPeriodSuffix(l10n, breakdown);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(
          label: l10n.planRent,
          value: rentWithPeriodLabel(l10n, breakdown),
          icon: Icons.receipt_long_rounded,
          valueStyle: AppText.titleSmall.copyWith(color: AppColors.primary),
        ),
        for (final CommercialLine charge in breakdown.recurringCharges)
          if (charge.amount > 0)
            KeyValueRow(
              label: commercialChargeLabel(l10n, charge.type),
              value: [Fmt.money(charge.amount), suffix].where((part) => part.isNotEmpty).join(' '),
              icon: Icons.autorenew_rounded,
            ),
        for (final CommercialLine charge in breakdown.oneTimeCharges)
          KeyValueRow(
            label: commercialChargeLabel(l10n, charge.type),
            value: charge.amount > 0 ? Fmt.money(charge.amount) : l10n.planFree,
            icon: Icons.request_quote_rounded,
            valueColor: charge.amount > 0 ? null : AppColors.success,
          ),
        for (final CommercialLine deposit in breakdown.deposits)
          KeyValueRow(
            label: commercialChargeLabel(l10n, deposit.type),
            value: deposit.amount > 0 ? Fmt.money(deposit.amount) : l10n.planFree,
            icon: Icons.savings_rounded,
            valueColor: deposit.amount > 0 ? null : AppColors.success,
          ),
        for (final CommercialUsage usage in breakdown.usageCharges)
          KeyValueRow(
            label: commercialChargeLabel(l10n, usage.type),
            value: usageRateLabel(l10n, usage),
            icon: Icons.speed_rounded,
          ),
        const Gap.sm(),
        Container(
          padding: const EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: paid ? AppColors.successWash : AppColors.primaryWash,
            borderRadius: Corners.brMd,
          ),
          child: Row(
            children: [
              if (paid) ...[
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                const SizedBox(width: Insets.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paid ? l10n.deploymentPaymentReceived : l10n.planPayableToday,
                      style: AppText.titleSmall.copyWith(fontSize: 13.5),
                    ),
                    if (breakdown.refundableAmount > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.planRefundableNote(Fmt.money(breakdown.refundableAmount)),
                        style: AppText.bodySmall.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                Fmt.money(breakdown.payableToday),
                style: AppText.numeric.copyWith(fontSize: 20, color: paid ? AppColors.success : AppColors.primary),
              ),
            ],
          ),
        ),
        if (breakdown.includedServices.isNotEmpty) ...[
          const Gap.md(),
          Text(l10n.planIncluded, style: AppText.titleSmall.copyWith(fontSize: 13)),
          const Gap.sm(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final String service in breakdown.includedServices)
                StatusChip(label: service, tone: StatusTone.success, icon: Icons.check_rounded, dense: true),
            ],
          ),
        ],
      ],
    );
  }
}
