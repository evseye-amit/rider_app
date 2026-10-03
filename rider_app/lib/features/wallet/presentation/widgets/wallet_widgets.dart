import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/wallet_overview.dart';

IconData walletEntryIcon(WalletEntryKind kind) => switch (kind) {
  WalletEntryKind.topUp => Icons.add_circle_rounded,
  WalletEntryKind.reward ||
  WalletEntryKind.referralReward ||
  WalletEntryKind.selfSubmissionReward => Icons.emoji_events_rounded,
  WalletEntryKind.refund || WalletEntryKind.securityDepositRefund || WalletEntryKind.reversal => Icons.undo_rounded,
  WalletEntryKind.rental => Icons.receipt_long_rounded,
  WalletEntryKind.payment => Icons.account_balance_rounded,
  WalletEntryKind.securityDeposit ||
  WalletEntryKind.securityDepositDeduction ||
  WalletEntryKind.securityDepositForfeiture => Icons.savings_rounded,
  WalletEntryKind.penalty || WalletEntryKind.trafficChallan => Icons.report_gmailerrorred_rounded,
  WalletEntryKind.repairCharge || WalletEntryKind.serviceCharge => Icons.build_rounded,
  WalletEntryKind.batteryCharge || WalletEntryKind.swapCharge => Icons.battery_charging_full_rounded,
  WalletEntryKind.onboardingFee || WalletEntryKind.exchangeFee => Icons.assignment_rounded,
  WalletEntryKind.accessoryCharge || WalletEntryKind.lostEquipmentCharge => Icons.inventory_2_rounded,
  _ => Icons.swap_horiz_rounded,
};

String walletEntryLabel(AppL10n l10n, WalletEntryKind kind) => switch (kind) {
  WalletEntryKind.topUp => l10n.walletKindTopUp,
  WalletEntryKind.reward ||
  WalletEntryKind.referralReward ||
  WalletEntryKind.selfSubmissionReward => l10n.walletKindReward,
  WalletEntryKind.refund || WalletEntryKind.securityDepositRefund || WalletEntryKind.reversal => l10n.walletKindRefund,
  WalletEntryKind.rental => l10n.walletKindRental,
  WalletEntryKind.payment => l10n.walletKindPayment,
  WalletEntryKind.securityDeposit ||
  WalletEntryKind.securityDepositDeduction ||
  WalletEntryKind.securityDepositForfeiture => l10n.walletKindDeposit,
  WalletEntryKind.penalty || WalletEntryKind.trafficChallan => l10n.walletKindPenalty,
  WalletEntryKind.repairCharge ||
  WalletEntryKind.serviceCharge ||
  WalletEntryKind.batteryCharge ||
  WalletEntryKind.swapCharge => l10n.walletKindService,
  _ => l10n.walletKindAdjustment,
};

StatusTone walletStateTone(WalletEntryState state) => switch (state) {
  WalletEntryState.settled => StatusTone.success,
  WalletEntryState.pending => StatusTone.warning,
  WalletEntryState.failed => StatusTone.danger,
  WalletEntryState.reversed => StatusTone.neutral,
};

String walletStateLabel(AppL10n l10n, WalletEntryState state) => switch (state) {
  WalletEntryState.settled => l10n.walletStateSettled,
  WalletEntryState.pending => l10n.walletStatePending,
  WalletEntryState.failed => l10n.walletStateFailed,
  WalletEntryState.reversed => l10n.walletStateReversed,
};

class WalletBand extends StatelessWidget {
  const WalletBand({required this.overview, super.key});

  final WalletOverview? overview;

  @override
  Widget build(BuildContext context) {
    final WalletOverview? wallet = overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.account_balance_wallet_rounded, tone: AppColors.primary, solid: true, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.walletMoney,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    context.l10n.commonWallet,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
            if (wallet != null && wallet.spendable.held > 0)
              StatusChip(
                label: '${Fmt.money(wallet.spendable.held)} ${context.l10n.walletOnHold}',
                tone: StatusTone.warning,
                solid: true,
                dense: true,
              ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.walletAvailable, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Text(
          wallet == null ? '—' : Fmt.money(wallet.spendable.available),
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
                  label: context.l10n.walletCash,
                  value: wallet == null ? '—' : Fmt.money(wallet.cash.available),
                  icon: Icons.payments_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.commonIncentives,
                  value: wallet == null ? '—' : Fmt.money(wallet.rewards.available),
                  icon: Icons.emoji_events_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.walletDeposit,
                  value: wallet == null ? '—' : Fmt.money(wallet.depositBucket.total),
                  icon: Icons.savings_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WalletEntryTile extends StatelessWidget {
  const WalletEntryTile({required this.entry, this.onTap, super.key});

  final WalletEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String sign = entry.isCredit ? '+' : '−';
    final Color tone = entry.isCredit ? AppColors.mint : AppColors.danger;

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            IconTile(icon: walletEntryIcon(entry.kind), tone: AppColors.primary, size: 38),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.description ?? walletEntryLabel(context.l10n, entry.kind),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${walletEntryLabel(context.l10n, entry.kind)} · ${Fmt.relative(entry.at)}',
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
                  '$sign${Fmt.money(entry.amount)}',
                  style: AppText.numericSmall.copyWith(fontSize: 14, color: tone),
                ),
                const SizedBox(height: 3),
                StatusChip(
                  label: walletStateLabel(context.l10n, entry.state),
                  tone: walletStateTone(entry.state),
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

class WalletEntryDetailBody extends StatelessWidget {
  const WalletEntryDetailBody({required this.entry, super.key});

  final WalletEntry entry;

  @override
  Widget build(BuildContext context) {
    final Color tone = entry.isCredit ? AppColors.mint : AppColors.danger;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            '${entry.isCredit ? '+' : '−'}${Fmt.money(entry.amount)}',
            style: AppText.numericLarge.copyWith(fontSize: 32, color: tone),
          ),
        ),
        const Gap.xl(),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        KeyValueRow(label: context.l10n.walletReferenceId, value: entry.reference),
        KeyValueRow(label: context.l10n.commonCategory, value: walletEntryLabel(context.l10n, entry.kind)),
        KeyValueRow(label: context.l10n.walletDateTime, value: Fmt.dateTime(entry.at)),
        KeyValueRow(
          label: context.l10n.commonStatus,
          value: walletStateLabel(context.l10n, entry.state),
          valueColor: walletStateTone(entry.state).color,
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

class WalletDepositCard extends StatelessWidget {
  const WalletDepositCard({required this.deposit, super.key});

  final WalletDeposit deposit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledProgress(
            value: deposit.fundedProgress,
            label: '${Fmt.money(deposit.funded)} of ${Fmt.money(deposit.required_)}',
            trailingLabel: Fmt.percent(deposit.fundedProgress),
          ),
          const Gap.sm(),
          Row(
            children: [
              Expanded(child: Text(context.l10n.walletRefundable, style: AppText.bodySmall.copyWith(fontSize: 11.5))),
              Text(
                Fmt.money(deposit.refundable),
                style: AppText.numericSmall.copyWith(fontSize: 13, color: AppColors.mint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
