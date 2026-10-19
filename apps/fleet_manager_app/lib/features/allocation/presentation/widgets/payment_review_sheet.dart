import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payment_review.dart';
import '../../domain/usecases/payment_review_usecases.dart';
import '../providers/payment_review_providers.dart';

typedef PaymentDecision = ({int version, String? rejectReason});

class PaymentReviewSheet extends ConsumerStatefulWidget {
  const PaymentReviewSheet({required this.allocationId, super.key});

  final String allocationId;

  static Future<PaymentDecision?> show(BuildContext context, {required String allocationId}) =>
      AppSheet.show<PaymentDecision>(
        context,
        title: context.l10n.allocationReviewPayment,
        maxHeightFactor: 0.92,
        child: PaymentReviewSheet(allocationId: allocationId),
      );

  @override
  ConsumerState<PaymentReviewSheet> createState() => _PaymentReviewSheetState();
}

class _PaymentReviewSheetState extends ConsumerState<PaymentReviewSheet> {
  final TextEditingController _reason = TextEditingController();
  bool _rejecting = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _approve(DeploymentPayment payment) =>
      Navigator.of(context).pop<PaymentDecision>((version: payment.submissionVersion, rejectReason: null));

  void _reject(DeploymentPayment payment) {
    final String reason = _reason.text.trim();
    if (reason.length < 3) {
      setState(() => _showErrors = true);
      return;
    }
    Navigator.of(context).pop<PaymentDecision>((version: payment.submissionVersion, rejectReason: reason));
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AsyncValue<PaymentReview> review = ref.watch(paymentReviewProvider(widget.allocationId));
    final PaymentReview? data = review.value;

    if (data == null) {
      if (review.hasError) {
        return EmptyState(
          title: l10n.allocationPaymentCouldNotLoad,
          message: review.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: l10n.commonTryAgain,
          onAction: () => ref.invalidate(paymentReviewProvider(widget.allocationId)),
          compact: true,
        );
      }
      return const Padding(
        padding: EdgeInsets.only(bottom: Insets.lg),
        child: ShimmerBox(height: 240, borderRadius: Corners.brLg),
      );
    }

    final DeploymentPayment payment = data.payment;
    final DateTime? submittedAt = payment.submittedAt;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Fmt.money(payment.amount), style: AppText.numericLarge.copyWith(color: AppColors.primary)),
          const Gap.md(),
          KeyValueRow(label: l10n.deploymentPaidVia, value: payment.provider ?? '—', icon: Icons.payments_rounded),
          KeyValueRow(
            label: l10n.deploymentReference,
            value: payment.providerReference ?? '—',
            icon: Icons.tag_rounded,
          ),
          if (submittedAt != null)
            KeyValueRow(
              label: l10n.deploymentSubmitted,
              value: Fmt.dateTime(submittedAt),
              icon: Icons.schedule_rounded,
            ),
          const Gap.lg(),
          GroupLabel(l10n.allocationPaymentScreenshots),
          const Gap.sm(),
          if (data.receipts.isEmpty)
            Text(
              l10n.allocationPaymentNoScreenshot,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.textMuted),
            )
          else
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                for (final DeploymentPaymentReceipt receipt in data.receipts)
                  _ReceiptThumb(paymentId: payment.id, photoId: receipt.id),
              ],
            ),
          const Gap.lg(),
          ..._actions(l10n, payment),
          const Gap.md(),
        ],
      ),
    );
  }

  List<Widget> _actions(AppL10n l10n, DeploymentPayment payment) {
    if (payment.isPaid) {
      return [_Note(icon: Icons.verified_rounded, tone: AppColors.success, text: l10n.allocationPaymentVerified)];
    }
    if (payment.isRejected) {
      return [
        _Note(
          icon: Icons.report_outlined,
          tone: AppColors.danger,
          text: l10n.allocationPaymentRejectedNote(payment.rejectionReason ?? '—'),
        ),
      ];
    }
    if (!payment.isSubmitted) {
      return [
        _Note(icon: Icons.hourglass_top_rounded, tone: AppColors.warning, text: l10n.allocationPaymentWaitingRider),
      ];
    }
    if (_rejecting) {
      return [
        AppTextField(
          label: l10n.allocationRejectReason,
          required: true,
          controller: _reason,
          hint: l10n.allocationRejectReasonHint,
          maxLines: 3,
          maxLength: 1000,
          textCapitalization: TextCapitalization.sentences,
          errorText: _showErrors && _reason.text.trim().length < 3 ? l10n.allocationRejectReasonNeeded : null,
          onChanged: (_) {
            if (_showErrors) setState(() {});
          },
        ),
        const Gap.md(),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.commonCancel,
                size: AppButtonSize.medium,
                onPressed: () => setState(() => _rejecting = false),
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: PrimaryButton(
                label: l10n.allocationRejectConfirm,
                icon: Icons.block_rounded,
                size: AppButtonSize.medium,
                fillColor: AppColors.danger,
                onPressed: () => _reject(payment),
              ),
            ),
          ],
        ),
      ];
    }
    return [
      Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: l10n.allocationRejectPayment,
              size: AppButtonSize.medium,
              color: AppColors.danger,
              onPressed: () => setState(() => _rejecting = true),
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: PrimaryButton(
              label: l10n.allocationMarkAsPaid,
              icon: Icons.check_circle_rounded,
              size: AppButtonSize.medium,
              onPressed: () => _approve(payment),
            ),
          ),
        ],
      ),
    ];
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.tone, required this.text});

  final IconData icon;
  final Color tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(color: AppColors.washFor(tone), borderRadius: Corners.brMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: tone),
          const SizedBox(width: Insets.sm),
          Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
        ],
      ),
    );
  }
}

class _ReceiptThumb extends ConsumerWidget {
  const _ReceiptThumb({required this.paymentId, required this.photoId});

  final String paymentId;
  final String photoId;

  static const double _size = 84;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> url = ref.watch(
      paymentReceiptUrlProvider(PaymentReceiptRef(paymentId: paymentId, photoId: photoId)),
    );
    final String? link = url.value;
    final Widget placeholder = ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: url.hasError
            ? const Icon(Icons.image_not_supported_rounded, size: 22, color: AppColors.textMuted)
            : const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
      ),
    );
    return Pressable(
      onTap: link == null ? null : () => PhotoViewer.show(context, link),
      scale: 0.97,
      child: ClipRRect(
        borderRadius: Corners.brMd,
        child: SizedBox.square(
          dimension: _size,
          child: link == null
              ? placeholder
              : Image.network(
                  link,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null ? child : placeholder,
                  errorBuilder: (_, _, _) => placeholder,
                ),
        ),
      ),
    );
  }
}
