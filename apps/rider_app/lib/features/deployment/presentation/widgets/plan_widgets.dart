import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class PlanSummary extends StatelessWidget {
  const PlanSummary({required this.breakdown, super.key});

  final CommercialBreakdown breakdown;

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
          decoration: BoxDecoration(color: AppColors.primaryWash, borderRadius: Corners.brMd),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.planPayableToday, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
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
                style: AppText.numeric.copyWith(fontSize: 20, color: AppColors.primary),
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

Future<void> showPlanTerms(BuildContext context, CommercialTerms terms) => AppSheet.show<void>(
  context,
  title: terms.title.isEmpty ? context.l10n.planTermsTitle : terms.title,
  subtitle: terms.version.isEmpty ? null : terms.version,
  child: Padding(
    padding: const EdgeInsets.only(bottom: Insets.lg),
    child: Text(plainTextFromHtml(terms.content), style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.55)),
  ),
);
