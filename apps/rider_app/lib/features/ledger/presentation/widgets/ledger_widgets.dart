import 'package:evseye_core/evseye_core.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/ledger_overview.dart';

IconData ledgerEntryIcon(LedgerEntryKind kind) => switch (kind) {
  LedgerEntryKind.topUp => Icons.add_circle_rounded,
  LedgerEntryKind.reward ||
  LedgerEntryKind.referralReward ||
  LedgerEntryKind.selfSubmissionReward => Icons.emoji_events_rounded,
  LedgerEntryKind.refund || LedgerEntryKind.securityDepositRefund || LedgerEntryKind.reversal => Icons.undo_rounded,
  LedgerEntryKind.rental => Icons.receipt_long_rounded,
  LedgerEntryKind.payment => Icons.account_balance_rounded,
  LedgerEntryKind.securityDeposit ||
  LedgerEntryKind.securityDepositDeduction ||
  LedgerEntryKind.securityDepositForfeiture => Icons.savings_rounded,
  LedgerEntryKind.penalty || LedgerEntryKind.trafficChallan => Icons.report_gmailerrorred_rounded,
  LedgerEntryKind.repairCharge || LedgerEntryKind.serviceCharge => Icons.build_rounded,
  LedgerEntryKind.batteryCharge || LedgerEntryKind.swapCharge => Icons.battery_charging_full_rounded,
  LedgerEntryKind.onboardingFee || LedgerEntryKind.exchangeFee => Icons.assignment_rounded,
  LedgerEntryKind.accessoryCharge || LedgerEntryKind.lostEquipmentCharge => Icons.inventory_2_rounded,
  _ => Icons.swap_horiz_rounded,
};

String ledgerEntryLabel(AppL10n l10n, LedgerEntryKind kind) => switch (kind) {
  LedgerEntryKind.topUp => l10n.ledgerKindTopUp,
  LedgerEntryKind.reward ||
  LedgerEntryKind.referralReward ||
  LedgerEntryKind.selfSubmissionReward => l10n.ledgerKindReward,
  LedgerEntryKind.refund || LedgerEntryKind.securityDepositRefund || LedgerEntryKind.reversal => l10n.ledgerKindRefund,
  LedgerEntryKind.rental => l10n.ledgerKindRental,
  LedgerEntryKind.payment => l10n.ledgerKindPayment,
  LedgerEntryKind.securityDeposit ||
  LedgerEntryKind.securityDepositDeduction ||
  LedgerEntryKind.securityDepositForfeiture => l10n.ledgerKindDeposit,
  LedgerEntryKind.penalty || LedgerEntryKind.trafficChallan => l10n.ledgerKindPenalty,
  LedgerEntryKind.repairCharge ||
  LedgerEntryKind.serviceCharge ||
  LedgerEntryKind.batteryCharge ||
  LedgerEntryKind.swapCharge => l10n.ledgerKindService,
  _ => l10n.ledgerKindAdjustment,
};

String ledgerEntryCategory(AppL10n l10n, LedgerEntry entry) => switch (entry.origin) {
  LedgerEntryOrigin.rewardExpiry => l10n.ledgerRewardExpired,
  LedgerEntryOrigin.rewardReversal => l10n.ledgerRewardReversed,
  LedgerEntryOrigin.other => ledgerEntryLabel(l10n, entry.kind),
};

String ledgerSigned(LedgerEntry entry) => switch (entry.direction) {
  LedgerEntryDirection.credit => '+${Fmt.money(entry.amount)}',
  LedgerEntryDirection.debit => '−${Fmt.money(entry.amount)}',
  LedgerEntryDirection.unknown => Fmt.money(entry.amount),
};

Color ledgerSignedTone(LedgerEntry entry) => switch (entry.direction) {
  LedgerEntryDirection.credit => AppColors.mint,
  LedgerEntryDirection.debit => AppColors.danger,
  LedgerEntryDirection.unknown => AppColors.textPrimary,
};

StatusTone ledgerStateTone(LedgerEntryState state) => switch (state) {
  LedgerEntryState.settled => StatusTone.success,
  LedgerEntryState.pending => StatusTone.warning,
  LedgerEntryState.failed => StatusTone.danger,
  LedgerEntryState.reversed => StatusTone.neutral,
};

String ledgerStateLabel(AppL10n l10n, LedgerEntryState state) => switch (state) {
  LedgerEntryState.settled => l10n.ledgerStateSettled,
  LedgerEntryState.pending => l10n.ledgerStatePending,
  LedgerEntryState.failed => l10n.ledgerStateFailed,
  LedgerEntryState.reversed => l10n.ledgerStateReversed,
};

class LedgerBand extends StatelessWidget {
  const LedgerBand({required this.overview, this.onAddMoney, this.addingMoney = false, super.key});

  final LedgerOverview? overview;
  final VoidCallback? onAddMoney;
  final bool addingMoney;

  @override
  Widget build(BuildContext context) {
    final LedgerOverview? ledger = overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            const SizedBox(width: Insets.md),
            const IconTile(icon: Icons.menu_book_rounded, tone: AppColors.primary, solid: true, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.ledgerMoney,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    context.l10n.commonLedger,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
            if (ledger != null && ledger.spendable.held > 0)
              StatusChip(
                label: '${Fmt.money(ledger.spendable.held)} ${context.l10n.ledgerOnHold}',
                tone: StatusTone.warning,
                solid: true,
                dense: true,
              ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.ledgerAvailable, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text(
          ledger == null ? '—' : Fmt.money(ledger.spendable.available),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk),
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
                  label: context.l10n.ledgerCash,
                  value: ledger == null ? '—' : Fmt.money(ledger.cash.available),
                  icon: Icons.payments_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.commonIncentives,
                  value: ledger == null ? '—' : Fmt.money(ledger.rewards.available),
                  icon: Icons.emoji_events_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.ledgerDeposit,
                  value: ledger == null ? '—' : Fmt.money(ledger.depositBucket.total),
                  icon: Icons.savings_rounded,
                ),
              ),
            ],
          ),
        ),
        if (ledger != null && onAddMoney != null) ...[
          const Gap.lg(),
          PrimaryButton(
            label: context.l10n.ledgerAddMoney,
            icon: Icons.add_rounded,
            loading: addingMoney,
            onPressed: addingMoney ? null : onAddMoney,
          ),
        ],
      ],
    );
  }
}

class LedgerEntryTile extends StatelessWidget {
  const LedgerEntryTile({required this.entry, this.onTap, super.key});

  final LedgerEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            IconTile(icon: ledgerEntryIcon(entry.kind), tone: AppColors.primary, size: 38),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.description ?? ledgerEntryCategory(context.l10n, entry),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ledgerEntryCategory(context.l10n, entry)} · ${Fmt.relative(entry.at)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ledgerSigned(entry),
                  style: AppText.numericSmall.copyWith(fontSize: 14, color: ledgerSignedTone(entry)),
                ),
                const SizedBox(height: 3),
                StatusChip(
                  label: ledgerStateLabel(context.l10n, entry.state),
                  tone: ledgerStateTone(entry.state),
                  dense: true,
                  showDot: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LedgerEntryDetailBody extends StatelessWidget {
  const LedgerEntryDetailBody({required this.entry, super.key});

  final LedgerEntry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            ledgerSigned(entry),
            style: AppText.numericLarge.copyWith(fontSize: 32, color: ledgerSignedTone(entry)),
          ),
        ),
        const Gap.xl(),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        KeyValueRow(label: context.l10n.ledgerReferenceId, value: entry.reference),
        KeyValueRow(label: context.l10n.commonCategory, value: ledgerEntryCategory(context.l10n, entry)),
        KeyValueRow(label: context.l10n.ledgerDateTime, value: Fmt.dateTime(entry.at)),
        KeyValueRow(
          label: context.l10n.commonStatus,
          value: ledgerStateLabel(context.l10n, entry.state),
          valueColor: ledgerStateTone(entry.state).color,
        ),
        if (entry.description != null) ...[
          const Gap.md(),
          Text(entry.description!, style: AppText.bodyMedium.copyWith(fontSize: 13, height: 1.5)),
        ],
        const Gap.lg(),
      ],
    );
  }
}

class LedgerDepositCard extends StatelessWidget {
  const LedgerDepositCard({required this.deposit, this.onTap, super.key});

  final LedgerDeposit deposit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledProgress(
              value: deposit.fundedProgress,
              label: context.l10n.ledgerFundedOf(Fmt.money(deposit.funded), Fmt.money(deposit.required_)),
              trailingLabel: Fmt.percent(deposit.fundedProgress),
            ),
            const Gap.sm(),
            Row(
              children: [
                Expanded(child: Text(context.l10n.ledgerRefundable, style: AppText.bodySmall.copyWith(fontSize: 11.5))),
                Text(
                  Fmt.money(deposit.refundable),
                  style: AppText.numericSmall.copyWith(fontSize: 13, color: AppColors.mint),
                ),
                if (onTap != null) ...[
                  const SizedBox(width: Insets.xs),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
