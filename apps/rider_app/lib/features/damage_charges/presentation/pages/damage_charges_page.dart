import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/payments/payment_feedback.dart';
import '../../../../core/payments/payment_flow_provider.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';
import '../widgets/damage_pay_action.dart';

class DamageChargesPage extends ConsumerWidget {
  const DamageChargesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DamageChargesSummary> summary = ref.watch(damageChargesSummaryProvider);
    final AsyncValue<List<DamageCharge>> charges = ref.watch(damageChargesProvider);
    final PaymentFlowState payment = ref.watch(paymentFlowProvider(PaymentSlots.submissionPenalty));
    final DamageChargesSummary? totals = summary.value;
    final List<DamageCharge>? items = charges.value;
    final List<DamageCharge> toPay = [...?items?.where((charge) => charge.isOpen)];
    final List<DamageCharge> paid = [...?items?.where((charge) => !charge.isOpen)];

    return AppScaffold(
      title: context.l10n.damageChargesTitle,
      footer: switch (totals) {
        final DamageChargesSummary value when value.canPay && !payment.blocksPayment => PrimaryButton(
          label: context.l10n.damageChargePay(Fmt.money(value.payAmount, paise: true)),
          icon: Icons.lock_rounded,
          loading: payment.busy,
          onPressed: payment.busy ? null : () => payDamageCharges(context, ref),
        ),
        _ => null,
      },
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(damageChargesProvider);
          await ref.refreshQuietly(damageChargesSummaryProvider);
        },
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const PaymentNoticeCard(slot: PaymentSlots.submissionPenalty, spacing: Insets.lg),
            if (totals != null && totals.total > 0) ...[
              _Total(summary: totals),
              const Gap.lg(),
            ] else if (totals == null && summary.hasError) ...[
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: summary.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesSummaryProvider),
                compact: true,
              ),
              const Gap.lg(),
            ] else if (totals == null) ...[
              const ShimmerBox(height: 150, borderRadius: Corners.brXl),
              const Gap.lg(),
            ],
            if (items == null && charges.hasError)
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: charges.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesProvider),
              )
            else if (items == null)
              for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 92, borderRadius: Corners.brLg), const Gap.md()]
            else if (items.isEmpty)
              EmptyState(
                title: context.l10n.damageChargesNoneTitle,
                message: context.l10n.damageChargesNoneMessage,
                icon: Icons.receipt_long_rounded,
                tone: AppColors.primary,
              )
            else ...[
              if (toPay.isNotEmpty) ...[
                GroupLabel(context.l10n.damageChargesSectionToPay),
                const Gap.sm(),
                for (final DamageCharge charge in toPay) _ChargeTile(charge: charge),
              ],
              if (toPay.isNotEmpty && paid.isNotEmpty) const Gap.sm(),
              if (paid.isNotEmpty) ...[
                GroupLabel(context.l10n.damageChargesSectionPaid),
                const Gap.sm(),
                for (final DamageCharge charge in paid) _ChargeTile(charge: charge),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ChargeTile extends StatelessWidget {
  const _ChargeTile({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: DamageChargeTile(
        charge: charge,
        onOpen: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.summary});

  final DamageChargesSummary summary;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? note = damagePaymentNote(l10n, summary);
    return ModuleCard(
      title: l10n.damageChargeAmountToPay,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Fmt.money(summary.due, paise: true),
                  style: AppText.numericLarge.copyWith(color: summary.due > 0 ? AppColors.primary : AppColors.success),
                ),
              ),
              if (summary.due > 0)
                StatusChip(label: l10n.damageChargesToPay(summary.unpaidCount), tone: StatusTone.warning, dense: true)
              else
                StatusChip(label: l10n.damageChargesNothingToPay, tone: StatusTone.success, dense: true),
            ],
          ),
          const Gap.md(),
          KeyValueRow(label: l10n.damageChargeTotal, value: Fmt.money(summary.total, paise: true)),
          if (summary.paid > 0)
            KeyValueRow(label: l10n.damageChargePaidSoFar, value: Fmt.money(summary.paid, paise: true)),
          if (summary.credit > 0)
            KeyValueRow(label: l10n.damageChargeCreditUsed, value: Fmt.money(summary.credit, paise: true)),
          if (note != null) ...[const Gap.md(), DamagePaymentNoteRow(text: note)],
        ],
      ),
    );
  }
}
