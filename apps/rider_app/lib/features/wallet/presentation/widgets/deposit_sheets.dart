import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_overview.dart';
import '../../domain/usecases/get_wallet_receipt.dart';
import '../providers/wallet_provider.dart';

String depositStatusLabel(AppL10n l10n, String status) => switch (status) {
  'PENDING' => l10n.walletDepositStatusPending,
  'PARTIALLY_PAID' => l10n.walletDepositStatusPartlyPaid,
  'PAID' => l10n.walletDepositStatusPaid,
  'LOCKED' => l10n.walletDepositStatusLocked,
  'PARTIALLY_DEDUCTED' => l10n.walletDepositStatusPartlyDeducted,
  'REFUND_ELIGIBLE' => l10n.walletDepositStatusReturnable,
  'REFUND_REQUESTED' => l10n.walletDepositStatusReturnRequested,
  'REFUNDED' => l10n.walletDepositStatusReturned,
  'FORFEITED' => l10n.walletDepositStatusForfeited,
  _ => l10n.walletDepositStatusCancelled,
};

StatusTone depositStatusTone(String status) => switch (status) {
  'PAID' || 'LOCKED' || 'REFUNDED' => StatusTone.success,
  'PENDING' || 'PARTIALLY_PAID' || 'REFUND_ELIGIBLE' || 'REFUND_REQUESTED' => StatusTone.warning,
  'PARTIALLY_DEDUCTED' || 'FORFEITED' => StatusTone.danger,
  _ => StatusTone.neutral,
};

String depositReturnLabel(AppL10n l10n, String status) => switch (status) {
  'REQUESTED' => l10n.walletReturnRequested,
  'UNDER_REVIEW' => l10n.walletReturnReview,
  'APPROVED' => l10n.walletReturnApproved,
  'PROCESSING' => l10n.walletReturnProcessing,
  'RETURNED' => l10n.walletReturnDone,
  'FAILED' => l10n.walletReturnFailed,
  'REJECTED' => l10n.walletReturnRejected,
  _ => l10n.walletReturnCancelled,
};

StatusTone depositReturnTone(String status) => switch (status) {
  'RETURNED' => StatusTone.success,
  'FAILED' || 'REJECTED' => StatusTone.danger,
  'CANCELLED' => StatusTone.neutral,
  _ => StatusTone.warning,
};

Future<void> showDepositSheet(BuildContext context, WalletDeposit deposit) => AppSheet.show<void>(
  context,
  title: context.l10n.walletSecurityDeposit,
  subtitle: context.l10n.walletDepositReturnedSeparately,
  child: DepositSheetBody(fallback: deposit),
);

class DepositSheetBody extends ConsumerWidget {
  const DepositSheetBody({required this.fallback, super.key});

  final WalletDeposit fallback;

  Future<void> _openReceipt(BuildContext context, DepositReturn item) => AppSheet.show<void>(
    context,
    title: context.l10n.walletReceipt,
    child: ReceiptSheetBody(
      params: ReceiptParams(kind: WalletReceiptKind.depositReturn, id: item.id),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WalletDeposit> detail = ref.watch(securityDepositProvider(fallback.id));
    final WalletDeposit deposit = detail.value ?? fallback;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: StatusChip(
            label: depositStatusLabel(context.l10n, deposit.status),
            tone: depositStatusTone(deposit.status),
          ),
        ),
        const Gap.md(),
        LabeledProgress(
          value: deposit.fundedProgress,
          label: context.l10n.walletFundedOf(Fmt.money(deposit.funded), Fmt.money(deposit.required_)),
          trailingLabel: Fmt.percent(deposit.fundedProgress),
        ),
        const Gap.md(),
        KeyValueRow(label: context.l10n.walletDepositRequired, value: Fmt.money(deposit.required_, paise: true)),
        KeyValueRow(label: context.l10n.walletDepositPaidIn, value: Fmt.money(deposit.funded, paise: true)),
        if (deposit.outstanding > 0)
          KeyValueRow(
            label: context.l10n.walletDepositToPay,
            value: Fmt.money(deposit.outstanding, paise: true),
            valueColor: AppColors.warning,
          ),
        KeyValueRow(label: context.l10n.walletDepositHeld, value: Fmt.money(deposit.held, paise: true)),
        if (deposit.locked > 0)
          KeyValueRow(label: context.l10n.walletDepositLocked, value: Fmt.money(deposit.locked, paise: true)),
        if (deposit.deducted > 0)
          KeyValueRow(
            label: context.l10n.walletDepositDeducted,
            value: Fmt.money(deposit.deducted, paise: true),
            valueColor: AppColors.danger,
          ),
        if (deposit.refunded > 0)
          KeyValueRow(label: context.l10n.walletDepositReturnedAmount, value: Fmt.money(deposit.refunded, paise: true)),
        KeyValueRow(
          label: context.l10n.walletRefundable,
          value: Fmt.money(deposit.refundable, paise: true),
          valueColor: AppColors.mint,
        ),
        if (detail.hasError && !detail.hasValue) ...[
          const Gap.sm(),
          Text(
            detail.failureMessage ?? context.l10n.walletCouldNotLoadDeposit,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.danger),
          ),
        ],
        if (deposit.returns.isNotEmpty) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.walletDepositReturns),
          const Gap.sm(),
          for (final DepositReturn item in deposit.returns) ...[
            _ReturnRow(item: item, onReceipt: item.returned ? () => _openReceipt(context, item) : null),
            if (item != deposit.returns.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
          ],
        ],
        const Gap.lg(),
      ],
    );
  }
}

class _ReturnRow extends StatelessWidget {
  const _ReturnRow({required this.item, required this.onReceipt});

  final DepositReturn item;
  final VoidCallback? onReceipt;

  @override
  Widget build(BuildContext context) {
    final DateTime? completedAt = item.completedAt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.toWallet ? context.l10n.walletToWallet : context.l10n.walletToBank,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
              ),
              Text(Fmt.money(item.amount, paise: true), style: AppText.numericSmall.copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              StatusChip(
                label: depositReturnLabel(context.l10n, item.status),
                tone: depositReturnTone(item.status),
                dense: true,
              ),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  completedAt == null
                      ? context.l10n.walletRequestedOn(Fmt.date(item.requestedAt))
                      : context.l10n.walletCompletedOn(Fmt.date(completedAt)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
              ),
              if (onReceipt != null)
                GhostButton(label: context.l10n.walletViewReceipt, dense: true, onPressed: onReceipt),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptSheetBody extends ConsumerWidget {
  const ReceiptSheetBody({required this.params, super.key});

  final ReceiptParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<WalletReceipt> receipt = ref.watch(walletReceiptProvider(params));
    final WalletReceipt? value = receipt.value;
    if (value == null) {
      return receipt.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.walletCouldNotLoadReceipt,
              message: receipt.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(walletReceiptProvider(params)),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: Insets.x3l),
              child: Center(
                child: SizedBox.square(
                  dimension: 26,
                  child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
                ),
              ),
            );
    }
    final DateTime? issuedAt = value.issuedAt;
    final String? method = value.method;
    final String? reference = value.reference;
    final String? destination = value.destination;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            Fmt.money(value.amount, paise: true),
            style: AppText.numericLarge.copyWith(fontSize: 32, color: AppColors.mint),
          ),
        ),
        const Gap.xl(),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        KeyValueRow(label: context.l10n.walletReceiptNumber, value: value.receiptNumber),
        if (issuedAt != null) KeyValueRow(label: context.l10n.walletIssued, value: Fmt.dateTime(issuedAt)),
        if (method != null && method.isNotEmpty) KeyValueRow(label: context.l10n.walletMethod, value: method),
        if (destination != null && destination.isNotEmpty)
          KeyValueRow(
            label: context.l10n.walletDestination,
            value: destination == 'WALLET_CASH' ? context.l10n.walletToWallet : context.l10n.walletToBank,
          ),
        if (reference != null && reference.isNotEmpty)
          KeyValueRow(label: context.l10n.walletReferenceId, value: reference),
        if (value.invoices.isNotEmpty) ...[
          const Gap.md(),
          GroupLabel(context.l10n.walletInvoicesSettled),
          const Gap.sm(),
          for (final ReceiptInvoice invoice in value.invoices)
            KeyValueRow(label: invoice.number, value: Fmt.money(invoice.amount, paise: true), dense: true),
        ],
        const Gap.lg(),
      ],
    );
  }
}
