import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/payments/online_payments.dart';
import '../../../../core/payments/payment_feedback.dart';
import '../../../../core/payments/payment_flow_provider.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';

Future<void> payDamageCharges(BuildContext context, WidgetRef ref) async {
  final AppL10n l10n = context.l10n;
  final OnlinePaymentOutcome? outcome = await ref
      .read(paymentFlowProvider(PaymentSlots.submissionPenalty).notifier)
      .pay(PaymentOrderRequest.submissionPenalty(), description: l10n.damageChargesTitle);
  if (outcome == null || !context.mounted) return;
  showPaymentOutcome(context, outcome, unavailable: l10n.damageChargesOnlineUnavailable);
}

String? damagePaymentNote(AppL10n l10n, DamageChargesSummary summary) => switch (summary.activity) {
  DamagePaymentActivity.processing => l10n.damageChargesPaymentProcessing(
    Fmt.money(summary.activityAmount ?? summary.due, paise: true),
  ),
  DamagePaymentActivity.underReview => l10n.onlinePaymentReview,
  _ => null,
};

class DamagePaymentNoteRow extends StatelessWidget {
  const DamagePaymentNoteRow({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: Insets.sm),
        Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
      ],
    );
  }
}

class DamagePayAction extends ConsumerWidget {
  const DamagePayAction({required this.charge, this.size = AppButtonSize.large, super.key});

  final DamageCharge charge;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final DamageChargesSummary? summary = ref.watch(damageChargesSummaryProvider).value;
    final PaymentFlowState payment = ref.watch(paymentFlowProvider(PaymentSlots.submissionPenalty));
    if (summary == null) {
      return PrimaryButton(
        label: l10n.damageChargePay(Fmt.money(charge.due, paise: true)),
        icon: Icons.lock_rounded,
        size: size,
        loading: true,
        onPressed: null,
      );
    }
    if (payment.blocksPayment) return const PaymentNoticeCard(slot: PaymentSlots.submissionPenalty);
    final String? note = damagePaymentNote(l10n, summary);
    if (note != null) return DamagePaymentNoteRow(text: note);
    if (!summary.canPay) return const SizedBox.shrink();
    final num amount = summary.payAmount;
    final bool includesOthers = (amount * 100).round() > (charge.due * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const PaymentNoticeCard(slot: PaymentSlots.submissionPenalty, spacing: Insets.md),
        PrimaryButton(
          label: includesOthers
              ? l10n.damageChargePayAll(Fmt.money(amount, paise: true))
              : l10n.damageChargePay(Fmt.money(amount, paise: true)),
          icon: Icons.lock_rounded,
          size: size,
          loading: payment.busy,
          onPressed: payment.busy ? null : () => payDamageCharges(context, ref),
        ),
        if (includesOthers) ...[
          const Gap.sm(),
          Text(
            l10n.damageChargePayAllHint,
            textAlign: TextAlign.center,
            style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4),
          ),
        ],
      ],
    );
  }
}
