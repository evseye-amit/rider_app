import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'online_payments.dart';
import 'payment_flow_provider.dart';

String? paymentNoticeText(AppL10n l10n, PaymentNotice? notice) => switch (notice) {
  PaymentNotice.pending => l10n.onlinePaymentPending,
  PaymentNotice.review => l10n.onlinePaymentReview,
  PaymentNotice.refundPending => l10n.paymentRefundPending,
  PaymentNotice.refunded => l10n.paymentRefunded,
  PaymentNotice.inProgress => l10n.paymentInProgress,
  null => null,
};

void showPaymentOutcome(
  BuildContext context,
  OnlinePaymentOutcome outcome, {
  required String unavailable,
  String? success,
}) {
  final AppL10n l10n = context.l10n;
  switch (outcome) {
    case OnlinePaymentPaid():
      AppSnack.success(context, success ?? l10n.onlinePaymentDone);
    case OnlinePaymentCancelled():
      AppSnack.info(context, l10n.onlinePaymentCancelled);
    case OnlinePaymentDeclined():
      AppSnack.error(context, l10n.onlinePaymentFailed);
    case OnlinePaymentUnavailable():
      AppSnack.error(context, unavailable);
    case OnlinePaymentRefunded():
      AppSnack.info(context, l10n.paymentRefunded);
    case OnlinePaymentError(:final message):
      AppSnack.error(context, message);
    case OnlinePaymentPending() ||
        OnlinePaymentNeedsSupport() ||
        OnlinePaymentRefundPending() ||
        OnlinePaymentInProgress():
      break;
  }
}

Future<void> checkPaymentStatus(BuildContext context, WidgetRef ref, String slot) async {
  final AppL10n l10n = context.l10n;
  final bool blocked = ref.read(paymentFlowProvider(slot)).notice == PaymentNotice.inProgress;
  final OnlinePaymentOutcome? outcome = await ref.read(paymentFlowProvider(slot).notifier).check();
  if (outcome == null || !context.mounted) return;
  if (outcome is OnlinePaymentPending) {
    AppSnack.info(context, blocked ? l10n.paymentInProgress : l10n.paymentStillConfirming);
  } else {
    showPaymentOutcome(context, outcome, unavailable: l10n.paymentUnavailable);
  }
}

Future<bool> discardPayment(BuildContext context, WidgetRef ref, String slot) async {
  final AppL10n l10n = context.l10n;
  final bool confirmed = await AppDialog.confirm(
    context,
    title: l10n.paymentDiscardTitle,
    message: l10n.paymentDiscardMessage,
    confirmLabel: l10n.paymentDiscard,
    icon: Icons.delete_outline_rounded,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return false;
  final OnlinePaymentOutcome? outcome = await ref.read(paymentFlowProvider(slot).notifier).discard();
  if (outcome == null || !context.mounted) return false;
  switch (outcome) {
    case OnlinePaymentDeclined():
      AppSnack.success(context, l10n.paymentDiscarded);
      return true;
    case OnlinePaymentInProgress():
      AppSnack.error(context, l10n.paymentDiscardFailed);
    case _:
      showPaymentOutcome(context, outcome, unavailable: l10n.paymentUnavailable);
  }
  return false;
}

class PaymentNoticeCard extends ConsumerWidget {
  const PaymentNoticeCard({required this.slot, this.spacing = 0, super.key});

  final String slot;
  final double spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final PaymentFlowState flow = ref.watch(paymentFlowProvider(slot));
    final String? text = paymentNoticeText(l10n, flow.notice);
    if (text == null) return const SizedBox.shrink();
    final bool refunded = flow.notice == PaymentNotice.refunded;
    final bool checkable = flow.requestId != null && !refunded;
    final Widget card = AccentCard(
      accent: refunded ? AppColors.info : AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                refunded ? Icons.undo_rounded : Icons.hourglass_top_rounded,
                size: 18,
                color: refunded ? AppColors.info : AppColors.warning,
              ),
              const SizedBox(width: Insets.sm),
              Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
            ],
          ),
          if (checkable) ...[
            const Gap.sm(),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.xs,
              children: [
                GhostButton(
                  label: l10n.paymentCheckStatus,
                  icon: Icons.refresh_rounded,
                  dense: true,
                  onPressed: flow.busy ? null : () => checkPaymentStatus(context, ref, slot),
                ),
                if (flow.canDiscard)
                  GhostButton(
                    label: l10n.paymentDiscard,
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.danger,
                    dense: true,
                    onPressed: flow.busy ? null : () => discardPayment(context, ref, slot),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
    return spacing == 0
        ? card
        : Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: card,
          );
  }
}
