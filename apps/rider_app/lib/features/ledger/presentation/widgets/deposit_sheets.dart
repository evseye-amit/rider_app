import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/ledger_overview.dart';
import '../../domain/usecases/get_ledger_receipt.dart';
import '../providers/ledger_provider.dart';

String depositStatusLabel(AppL10n l10n, String status) => switch (status) {
  'PENDING' => l10n.ledgerDepositStatusPending,
  'PARTIALLY_PAID' => l10n.ledgerDepositStatusPartlyPaid,
  'PAID' => l10n.ledgerDepositStatusPaid,
  'LOCKED' => l10n.ledgerDepositStatusLocked,
  'PARTIALLY_DEDUCTED' => l10n.ledgerDepositStatusPartlyDeducted,
  'REFUND_ELIGIBLE' => l10n.ledgerDepositStatusReturnable,
  'REFUND_REQUESTED' => l10n.ledgerDepositStatusReturnRequested,
  'REFUNDED' => l10n.ledgerDepositStatusReturned,
  'FORFEITED' => l10n.ledgerDepositStatusForfeited,
  _ => l10n.ledgerDepositStatusCancelled,
};

StatusTone depositStatusTone(String status) => switch (status) {
  'PAID' || 'LOCKED' || 'REFUNDED' => StatusTone.success,
  'PENDING' || 'PARTIALLY_PAID' || 'REFUND_ELIGIBLE' || 'REFUND_REQUESTED' => StatusTone.warning,
  'PARTIALLY_DEDUCTED' || 'FORFEITED' => StatusTone.danger,
  _ => StatusTone.neutral,
};

String depositReturnLabel(AppL10n l10n, String status) => switch (status) {
  'REQUESTED' => l10n.ledgerReturnRequested,
  'UNDER_REVIEW' => l10n.ledgerReturnReview,
  'APPROVED' => l10n.ledgerReturnApproved,
  'PROCESSING' => l10n.ledgerReturnProcessing,
  'RETURNED' => l10n.ledgerReturnDone,
  'FAILED' => l10n.ledgerReturnFailed,
  'REJECTED' => l10n.ledgerReturnRejected,
  _ => l10n.ledgerReturnCancelled,
};

StatusTone depositReturnTone(String status) => switch (status) {
  'RETURNED' => StatusTone.success,
  'FAILED' || 'REJECTED' => StatusTone.danger,
  'CANCELLED' => StatusTone.neutral,
  _ => StatusTone.warning,
};

Future<void> showDepositSheet(BuildContext context, LedgerDeposit deposit) => AppSheet.show<void>(
  context,
  title: context.l10n.ledgerSecurityDeposit,
  subtitle: context.l10n.ledgerDepositReturnedSeparately,
  child: DepositSheetBody(fallback: deposit),
);

class DepositSheetBody extends ConsumerWidget {
  const DepositSheetBody({required this.fallback, super.key});

  final LedgerDeposit fallback;

  Future<void> _openReceipt(BuildContext context, DepositReturn item) => AppSheet.show<void>(
    context,
    title: context.l10n.ledgerReceipt,
    child: ReceiptSheetBody(
      params: ReceiptParams(kind: WalletReceiptKind.depositReturn, id: item.id),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<LedgerDeposit> detail = ref.watch(securityDepositProvider(fallback.id));
    final LedgerDeposit deposit = detail.value ?? fallback;
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
          label: context.l10n.ledgerFundedOf(Fmt.money(deposit.funded), Fmt.money(deposit.required_)),
          trailingLabel: Fmt.percent(deposit.fundedProgress),
        ),
        const Gap.md(),
        KeyValueRow(label: context.l10n.ledgerDepositRequired, value: Fmt.money(deposit.required_, paise: true)),
        KeyValueRow(label: context.l10n.ledgerDepositPaidIn, value: Fmt.money(deposit.funded, paise: true)),
        if (deposit.outstanding > 0)
          KeyValueRow(
            label: context.l10n.ledgerDepositToPay,
            value: Fmt.money(deposit.outstanding, paise: true),
            valueColor: AppColors.warning,
          ),
        KeyValueRow(label: context.l10n.ledgerDepositHeld, value: Fmt.money(deposit.held, paise: true)),
        if (deposit.locked > 0)
          KeyValueRow(label: context.l10n.ledgerDepositLocked, value: Fmt.money(deposit.locked, paise: true)),
        if (deposit.deducted > 0)
          KeyValueRow(
            label: context.l10n.ledgerDepositDeducted,
            value: Fmt.money(deposit.deducted, paise: true),
            valueColor: AppColors.danger,
          ),
        if (deposit.refunded > 0)
          KeyValueRow(label: context.l10n.ledgerDepositReturnedAmount, value: Fmt.money(deposit.refunded, paise: true)),
        KeyValueRow(
          label: context.l10n.ledgerRefundable,
          value: Fmt.money(deposit.refundable, paise: true),
          valueColor: AppColors.mint,
        ),
        if (detail.hasError && !detail.hasValue) ...[
          const Gap.sm(),
          Text(
            detail.failureMessage ?? context.l10n.ledgerCouldNotLoadDeposit,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.danger),
          ),
        ],
        if (deposit.returns.isNotEmpty) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.ledgerDepositReturns),
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
                  item.toLedger ? context.l10n.ledgerToLedger : context.l10n.ledgerToBank,
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
                      ? context.l10n.ledgerRequestedOn(Fmt.date(item.requestedAt))
                      : context.l10n.ledgerCompletedOn(Fmt.date(completedAt)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
              ),
              if (onReceipt != null)
                GhostButton(label: context.l10n.ledgerViewReceipt, dense: true, onPressed: onReceipt),
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
    final AsyncValue<WalletReceipt> receipt = ref.watch(ledgerReceiptProvider(params));
    final WalletReceipt? value = receipt.value;
    if (value == null) {
      return receipt.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.ledgerCouldNotLoadReceipt,
              message: receipt.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(ledgerReceiptProvider(params)),
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
        KeyValueRow(label: context.l10n.ledgerReceiptNumber, value: value.receiptNumber),
        if (issuedAt != null) KeyValueRow(label: context.l10n.ledgerIssued, value: Fmt.dateTime(issuedAt)),
        if (method != null && method.isNotEmpty) KeyValueRow(label: context.l10n.ledgerMethod, value: method),
        if (destination != null && destination.isNotEmpty)
          KeyValueRow(
            label: context.l10n.ledgerDestination,
            value: destination == 'WALLET_CASH' ? context.l10n.ledgerToLedger : context.l10n.ledgerToBank,
          ),
        if (reference != null && reference.isNotEmpty)
          KeyValueRow(label: context.l10n.ledgerReferenceId, value: reference),
        if (value.invoices.isNotEmpty) ...[
          const Gap.md(),
          GroupLabel(context.l10n.ledgerInvoicesSettled),
          const Gap.sm(),
          for (final ReceiptInvoice invoice in value.invoices)
            KeyValueRow(label: invoice.number, value: Fmt.money(invoice.amount, paise: true), dense: true),
        ],
        const Gap.lg(),
      ],
    );
  }
}
