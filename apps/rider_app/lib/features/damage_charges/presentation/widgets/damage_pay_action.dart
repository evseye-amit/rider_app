import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/payments/online_payments.dart';
import '../../../../core/payments/razorpay_checkout.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../providers/damage_payment_provider.dart';

Future<void> payDamageCharges(BuildContext context, WidgetRef ref) async {
  final AppL10n l10n = context.l10n;
  final OnlinePaymentOutcome? outcome = await ref
      .read(damagePaymentProvider.notifier)
      .pay(description: l10n.damageChargesTitle);
  if (outcome == null || !context.mounted) return;
  switch (outcome) {
    case OnlinePaymentPaid():
      AppSnack.success(context, l10n.onlinePaymentDone);
    case OnlinePaymentCancelled():
      AppSnack.info(context, l10n.onlinePaymentCancelled);
    case OnlinePaymentDeclined():
      AppSnack.error(context, l10n.onlinePaymentFailed);
    case OnlinePaymentUnavailable():
      AppSnack.error(context, l10n.damageChargesOnlineUnavailable);
    case OnlinePaymentError(:final message):
      AppSnack.error(context, message);
    case OnlinePaymentPending() || OnlinePaymentNeedsSupport():
      break;
  }
}

String? damagePaymentNote(AppL10n l10n, DamageChargesSummary summary, DamagePaymentNotice? notice) => switch (notice) {
  DamagePaymentNotice.pending => l10n.onlinePaymentPending,
  DamagePaymentNotice.review => l10n.onlinePaymentReview,
  null => switch (summary.activity) {
    DamagePaymentActivity.processing => l10n.damageChargesPaymentProcessing(
      Fmt.money(summary.activityAmount ?? summary.due, paise: true),
    ),
    DamagePaymentActivity.underReview => l10n.onlinePaymentReview,
    _ when summary.due > 0 && !RazorpayCheckout.available => l10n.damageChargesOnlineUnavailable,
    _ => null,
  },
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
    final DamagePaymentState payment = ref.watch(damagePaymentProvider);
    if (summary == null) {
      return PrimaryButton(
        label: l10n.damageChargePay(Fmt.money(charge.due, paise: true)),
        icon: Icons.lock_rounded,
        size: size,
        loading: true,
        onPressed: null,
      );
    }
    final String? note = damagePaymentNote(l10n, summary, payment.notice);
    if (note != null) return DamagePaymentNoteRow(text: note);
    if (!summary.canPay) return const SizedBox.shrink();
    final num amount = summary.payAmount;
    final bool includesOthers = (amount * 100).round() > (charge.due * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          label: includesOthers
              ? l10n.damageChargePayAll(Fmt.money(amount, paise: true))
              : l10n.damageChargePay(Fmt.money(amount, paise: true)),
          icon: Icons.lock_rounded,
          size: size,
          loading: payment.paying,
          onPressed: payment.paying ? null : () => payDamageCharges(context, ref),
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
