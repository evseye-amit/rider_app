import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/payments_overview.dart';

String autoPayLabel(AppL10n l10n, AutoPayState state) => switch (state) {
  AutoPayState.active => l10n.paymentsAutoPayActive,
  AutoPayState.paused => l10n.paymentsAutoPayPaused,
  AutoPayState.setupRequired => l10n.paymentsAutoPaySetupRequired,
  AutoPayState.authenticationPending => l10n.paymentsAutoPayAuthPending,
  AutoPayState.failed => l10n.paymentsAutoPayFailed,
  AutoPayState.revoked => l10n.paymentsAutoPayRevoked,
  AutoPayState.expired => l10n.paymentsAutoPayExpired,
  AutoPayState.notEnabled => l10n.paymentsAutoPayNotEnabled,
};

StatusTone autoPayTone(AutoPayState state) => switch (state) {
  AutoPayState.active => StatusTone.success,
  AutoPayState.paused || AutoPayState.setupRequired || AutoPayState.authenticationPending => StatusTone.warning,
  AutoPayState.failed || AutoPayState.expired || AutoPayState.revoked => StatusTone.danger,
  AutoPayState.notEnabled => StatusTone.neutral,
};

class PaymentsBand extends StatelessWidget {
  const PaymentsBand({required this.overview, super.key});

  final PaymentsOverview? overview;

  @override
  Widget build(BuildContext context) {
    final PaymentsOverview? payments = overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeroBandBar(
          leading: Builder(
            builder: (context) =>
                InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
          ),
          title: context.l10n.paymentsTitle,
          subtitle: context.l10n.paymentsSubtitle,
        ),
        const Gap.xxl(),
        Text(
          payments != null && payments.isSettled ? context.l10n.paymentsNothingDue : context.l10n.paymentsAmountDue,
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                payments == null ? '—' : Fmt.money(payments.amountDue),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
              ),
            ),
            if (payments != null && payments.isOverdue) ...[
              const SizedBox(width: Insets.md),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: StatusChip(
                  label: context.l10n.paymentsOverdue,
                  tone: StatusTone.danger,
                  solid: true,
                  dense: true,
                ),
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
                child: InkStat(
                  label: context.l10n.paymentsDueOn,
                  value: payments?.dueDate == null ? '—' : Fmt.date(payments!.dueDate!),
                  icon: Icons.event_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.paymentsAutoPay,
                  value: payments == null ? '—' : autoPayLabel(context.l10n, payments.autoPay),
                  icon: Icons.autorenew_rounded,
                  valueColor: payments != null && payments.autoPayNeedsAttention ? AppColors.onInkAmber : null,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.paymentsNextDebit,
                  value: payments?.nextAutoPayDate == null ? '—' : Fmt.date(payments!.nextAutoPayDate!),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PaymentRecordTile extends StatelessWidget {
  const PaymentRecordTile({required this.record, super.key});

  final PaymentRecord record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        children: [
          const IconTile(icon: Icons.account_balance_rounded, tone: AppColors.primary, size: 38),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.method ?? context.l10n.paymentsPayment,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  record.receivedAt == null ? '—' : Fmt.relative(record.receivedAt!),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          Text(Fmt.money(record.amount), style: AppText.numericSmall.copyWith(fontSize: 14, color: AppColors.mint)),
        ],
      ),
    );
  }
}
