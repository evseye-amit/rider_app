import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rental.dart';
import '../providers/rentals_overview_provider.dart';

String billLabel(AppL10n l10n, BillStatus status) => switch (status) {
  BillStatus.due => l10n.rentalsStatusDue,
  BillStatus.partlyPaid => l10n.rentalsStatusPartlyPaid,
  BillStatus.paid => l10n.rentalsPaid,
  BillStatus.overdue => l10n.rentalsStatusOverdue,
  BillStatus.voided => l10n.rentalsStatusVoid,
  BillStatus.draft => l10n.rentalsStatusDraft,
};

StatusTone billTone(BillStatus status) => switch (status) {
  BillStatus.paid => StatusTone.success,
  BillStatus.due || BillStatus.partlyPaid => StatusTone.warning,
  BillStatus.overdue => StatusTone.danger,
  BillStatus.voided || BillStatus.draft => StatusTone.neutral,
};

String? periodSuffix(AppL10n l10n, String? period) => switch (period) {
  'DAILY' => l10n.exchangePerDay,
  'WEEKLY' => l10n.exchangePerWeek,
  'FORTNIGHTLY' => l10n.exchangePerFortnight,
  'MONTHLY' => l10n.exchangePerMonth,
  'QUARTERLY' => l10n.exchangePerQuarter,
  _ => null,
};

String billPeriod(Bill bill) {
  final DateTime? start = bill.periodStart;
  final DateTime? end = bill.periodEnd;
  if (start == null || end == null) return Fmt.date(bill.createdAt);
  return '${Fmt.date(start)} – ${Fmt.date(end)}';
}

class RentalsBand extends StatelessWidget {
  const RentalsBand({required this.overview, super.key});

  final RentalsOverview? overview;

  @override
  Widget build(BuildContext context) {
    final RentalPlan? plan = overview?.plan;
    final BillingSummary? summary = overview?.summary;
    final String? suffix = periodSuffix(context.l10n, plan?.period);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroBandBar(
          leading: Builder(
            builder: (context) =>
                InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
          ),
          subtitle: context.l10n.rentalsSubtitle,
          title: context.l10n.rentalsRentals,
        ),
        const Gap.xxl(),
        Text(
          plan == null ? context.l10n.rentalsCurrentPlan : [plan.agreementNumber, ?plan.scooterName].join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                plan == null ? '—' : Fmt.money(plan.rent),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
              ),
            ),
            if (suffix != null) ...[
              const SizedBox(width: Insets.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(suffix, style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary)),
              ),
            ],
          ],
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: InkStat(
                  label: context.l10n.rentalsOutstanding,
                  value: summary == null ? '—' : Fmt.money(summary.outstanding),
                  icon: Icons.receipt_long_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 5,
                child: InkStat(
                  label: context.l10n.rentalsStatusOverdue,
                  value: summary == null ? '—' : Fmt.money(summary.overdue),
                  icon: Icons.warning_amber_rounded,
                  valueColor: (summary?.overdue ?? 0) > 0 ? AppColors.danger : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 4,
                child: InkStat(
                  label: context.l10n.rentalsAutoDebit,
                  value: summary == null
                      ? '—'
                      : summary.autoPay
                      ? context.l10n.commonOn
                      : context.l10n.commonOff,
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

class AccountCard extends StatelessWidget {
  const AccountCard({required this.summary, super.key});

  final BillingSummary summary;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.rentalsYourAccount,
      leading: const IconTile(icon: Icons.account_balance_rounded, solid: true, size: 28),
      child: Column(
        children: [
          KeyValueRow(
            label: context.l10n.rentalsOutstanding,
            value: Fmt.money(summary.outstanding, paise: true),
            icon: Icons.receipt_long_rounded,
          ),
          if (summary.overdue > 0)
            KeyValueRow(
              label: context.l10n.rentalsStatusOverdue,
              value: Fmt.money(summary.overdue, paise: true),
              icon: Icons.warning_amber_rounded,
              valueColor: AppColors.danger,
            ),
          KeyValueRow(
            label: context.l10n.rentalsDueLater,
            value: Fmt.money(summary.dueLater, paise: true),
            icon: Icons.event_rounded,
          ),
          if (summary.credit > 0)
            KeyValueRow(
              label: context.l10n.rentalsCredit,
              value: Fmt.money(summary.credit, paise: true),
              icon: Icons.savings_rounded,
              valueColor: AppColors.success,
            ),
          if (summary.unallocated > 0)
            KeyValueRow(
              label: context.l10n.rentalsUnallocated,
              value: Fmt.money(summary.unallocated, paise: true),
              icon: Icons.payments_rounded,
            ),
          KeyValueRow(
            label: context.l10n.rentalsDepositHeld,
            value: Fmt.money(summary.depositHeld, paise: true),
            icon: Icons.lock_rounded,
          ),
        ],
      ),
    );
  }
}

class BillTile extends StatelessWidget {
  const BillTile({required this.bill, this.onTap, super.key});

  final Bill bill;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime? paidAt = bill.paidAt;
    final DateTime? dueDate = bill.dueDate;
    final String when = paidAt != null
        ? '${context.l10n.rentalsPaid2} ${Fmt.date(paidAt)}'
        : dueDate != null
        ? '${context.l10n.rentalsDue} ${Fmt.date(dueDate)}'
        : bill.number;
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            const PhotoThumb(photo: BrandPhoto.money, size: 44, radius: 12),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(billPeriod(bill), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text(when, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(Fmt.money(bill.total), style: AppText.numericSmall.copyWith(fontSize: 14)),
                const SizedBox(height: 3),
                StatusChip(
                  label: billLabel(context.l10n, bill.status),
                  tone: billTone(bill.status),
                  dense: true,
                  showDot: false,
                ),
              ],
            ),
            const SizedBox(width: Insets.sm),
            const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class BillSheetBody extends ConsumerWidget {
  const BillSheetBody({required this.billId, super.key});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BillDetail> detail = ref.watch(billProvider(billId));
    final BillDetail? value = detail.value;
    if (value == null) {
      return detail.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.rentalsCouldNotLoadBill,
              message: detail.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(billProvider(billId)),
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

    final Bill bill = value.bill;
    final DateTime? dueDate = bill.dueDate;
    final DateTime? paidAt = bill.paidAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(bill.number, style: AppText.code.copyWith(fontSize: 14))),
            StatusChip(label: billLabel(context.l10n, bill.status), tone: billTone(bill.status)),
          ],
        ),
        const Gap.lg(),
        for (final BillLine line in value.lines)
          KeyValueRow(
            label: line.description,
            value: line.isCredit
                ? '−${Fmt.money(line.amount.abs(), paise: true)}'
                : Fmt.money(line.amount, paise: true),
            valueColor: line.isCredit ? AppColors.mint : null,
          ),
        const SizedBox(height: Insets.sm),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        const SizedBox(height: Insets.sm),
        KeyValueRow(label: context.l10n.rentalsSubtotal, value: Fmt.money(value.subtotal, paise: true), dense: true),
        if (value.credit > 0)
          KeyValueRow(
            label: context.l10n.rentalsCreditsApplied,
            value: '−${Fmt.money(value.credit, paise: true)}',
            valueColor: AppColors.mint,
            dense: true,
          ),
        if (value.tax > 0)
          KeyValueRow(label: context.l10n.rentalsTax, value: Fmt.money(value.tax, paise: true), dense: true),
        KeyValueRow(
          label: context.l10n.commonTotal,
          value: Fmt.money(bill.total, paise: true),
          valueStyle: AppText.numeric.copyWith(fontSize: 18),
        ),
        const SizedBox(height: Insets.sm),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        const SizedBox(height: Insets.sm),
        KeyValueRow(label: context.l10n.rentalsPaidSoFar, value: Fmt.money(bill.paid, paise: true), dense: true),
        if (value.walletPaid > 0)
          KeyValueRow(
            label: context.l10n.rentalsFromWallet,
            value: Fmt.money(value.walletPaid, paise: true),
            dense: true,
          ),
        if (value.settlementCredit > 0)
          KeyValueRow(
            label: context.l10n.rentalsCreditsApplied,
            value: Fmt.money(value.settlementCredit, paise: true),
            dense: true,
          ),
        KeyValueRow(
          label: context.l10n.rentalsStillDue,
          value: Fmt.money(bill.outstanding, paise: true),
          valueColor: bill.outstanding > 0 ? AppColors.danger : AppColors.success,
          dense: true,
        ),
        const Gap.md(),
        KeyValueRow(label: context.l10n.rentalsBillingPeriod, value: billPeriod(bill), dense: true),
        if (dueDate != null) KeyValueRow(label: context.l10n.rentalsDue, value: Fmt.date(dueDate), dense: true),
        if (paidAt != null) KeyValueRow(label: context.l10n.rentalsPaid2, value: Fmt.date(paidAt), dense: true),
        const Gap.lg(),
      ],
    );
  }
}

class LedgerTile extends StatelessWidget {
  const LedgerTile({required this.line, super.key});

  final LedgerLine line;

  @override
  Widget build(BuildContext context) {
    final bool incoming = line.net >= 0;
    final (IconData icon, String kind) = switch (line.kind) {
      LedgerKind.charge => (Icons.receipt_rounded, context.l10n.rentalsLedgerCharge),
      LedgerKind.credit => (Icons.savings_rounded, context.l10n.rentalsLedgerCredit),
      LedgerKind.payment => (Icons.payments_rounded, context.l10n.rentalsLedgerPayment),
      LedgerKind.refund => (Icons.currency_exchange_rounded, context.l10n.rentalsLedgerRefund),
      LedgerKind.adjustment => (Icons.tune_rounded, context.l10n.rentalsLedgerAdjustment),
      LedgerKind.reversal => (Icons.undo_rounded, context.l10n.rentalsLedgerReversal),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        children: [
          IconTile(icon: icon, tone: incoming ? AppColors.success : AppColors.primary, size: 38),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.description.isEmpty ? kind : line.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  [kind, Fmt.date(line.at), if (line.isDeposit) context.l10n.rentalsLedgerDeposit].join(' · '),
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          Text(
            '${incoming ? '+' : '−'}${Fmt.money(line.net.abs(), paise: true)}',
            style: AppText.numericSmall.copyWith(
              fontSize: 14,
              color: incoming ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  const ReceiptTile({required this.receipt, super.key});

  final PaymentReceipt receipt;

  @override
  Widget build(BuildContext context) {
    final String? reference = receipt.reference;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        children: [
          const IconTile(icon: Icons.payments_rounded, tone: AppColors.success, size: 38),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_humanize(receipt.method), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(
                  [
                    Fmt.dateTime(receipt.receivedAt),
                    if (receipt.invoiceCount > 0) context.l10n.rentalsReceiptInvoices(receipt.invoiceCount),
                    ?reference,
                  ].join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
                if (receipt.refunded > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.rentalsRefunded(Fmt.money(receipt.refunded, paise: true)),
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.warning),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.money(receipt.amount, paise: true), style: AppText.numericSmall.copyWith(fontSize: 14)),
              if (!receipt.confirmed) ...[
                const SizedBox(height: 3),
                StatusChip(
                  label: context.l10n.walletStatePending,
                  tone: StatusTone.warning,
                  dense: true,
                  showDot: false,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _humanize(String code) {
    final String spaced = code.replaceAll('_', ' ').trim().toLowerCase();
    if (spaced.isEmpty) return '—';
    return '${spaced[0].toUpperCase()}${spaced.substring(1)}';
  }
}
