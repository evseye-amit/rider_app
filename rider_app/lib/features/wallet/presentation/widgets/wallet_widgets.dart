import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/wallet_summary.dart';

IconData categoryIcon(String category) => switch (category) {
  'trip' => Icons.route_rounded,
  'incentive' => Icons.emoji_events_rounded,
  'rent' => Icons.receipt_long_rounded,
  'penalty' => Icons.report_gmailerrorred_rounded,
  'payout' => Icons.account_balance_rounded,
  'referral' => Icons.group_add_rounded,
  'deposit' => Icons.savings_rounded,
  _ => Icons.swap_horiz_rounded,
};

Color categoryColor(String category) => AppColors.primary;

StatusTone statusTone(String status) => switch (status) {
  'settled' => StatusTone.success,
  'pending' => StatusTone.warning,
  'held' => StatusTone.warning,
  'failed' => StatusTone.danger,
  _ => StatusTone.neutral,
};

class WalletBand extends StatelessWidget {
  const WalletBand({required this.summary, super.key});

  final WalletSummary? summary;

  @override
  Widget build(BuildContext context) {
    final WalletSummary? s = summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(
              icon: Icons.account_balance_wallet_rounded,
              tone: AppColors.primary,
              solid: true,
              size: 44,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your money',
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Wallet',
                    style: AppText.titleLarge.copyWith(
                      fontSize: 20,
                      color: AppColors.onInk,
                    ),
                  ),
                ],
              ),
            ),
            if (s != null && s.pendingPayout > 0)
              StatusChip(
                label: '${Fmt.money(s.pendingPayout)} pending',
                tone: StatusTone.warning,
                solid: true,
                dense: true,
              ),
          ],
        ),
        const Gap.xxl(),
        Text(
          'Paid to date',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Text(
          s == null ? '—' : Fmt.money(s.balance),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.numericLarge.copyWith(
            fontSize: 38,
            color: AppColors.onInk,
          ),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'This week',
                  value: s == null ? '—' : Fmt.money(s.deductedThisWeek),
                  icon: Icons.north_east_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Due now',
                  value: s == null ? '—' : Fmt.money(s.pendingPayout),
                  icon: Icons.schedule_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Payments',
                  value: s == null ? '—' : '${s.transactions.length}',
                  icon: Icons.receipt_long_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeekSummaryRow extends StatelessWidget {
  const WeekSummaryRow({
    required this.credited,
    required this.deducted,
    required this.incentives,
    super.key,
  });

  final num credited;
  final num deducted;
  final num incentives;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _WeekTile(
            label: 'Credited',
            value: Fmt.money(credited),
            icon: Icons.south_west_rounded,
            color: AppColors.mint,
          ),
        ),
        _VDiv(),
        Expanded(
          child: _WeekTile(
            label: 'Deducted',
            value: Fmt.money(deducted),
            icon: Icons.north_east_rounded,
            color: AppColors.danger,
          ),
        ),
        _VDiv(),
        Expanded(
          child: _WeekTile(
            label: 'Incentives',
            value: Fmt.money(incentives),
            icon: Icons.emoji_events_rounded,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }
}

class _VDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 44,
    color: AppColors.stroke.withValues(alpha: 0.6),
  );
}

class _WeekTile extends StatelessWidget {
  const _WeekTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(height: Insets.sm - 2),
        Text(value, style: AppText.numericSmall.copyWith(fontSize: 14.5)),
        const SizedBox(height: 1),
        Text(label, style: AppText.bodySmall.copyWith(fontSize: 10.5)),
      ],
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, this.onTap, super.key});

  final WalletTransaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = categoryColor(transaction.category);
    final String sign = transaction.isCredit ? '+' : '−';

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
        child: Row(
          children: [
            IconTile(icon: categoryIcon(transaction.category), tone: tone, size: 38),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transaction.subtitle} · ${Fmt.relative(transaction.at)}',
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
                  '$sign${Fmt.money(transaction.amount)}',
                  style: AppText.numericSmall.copyWith(
                    fontSize: 14,
                    color: transaction.isCredit
                        ? AppColors.mint
                        : AppColors.danger,
                  ),
                ),
                const SizedBox(height: 3),
                StatusChip(
                  label: transaction.status,
                  tone: statusTone(transaction.status),
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

class TransactionDetailBody extends StatelessWidget {
  const TransactionDetailBody({required this.transaction, super.key});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final Color tone = categoryColor(transaction.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.washFor(tone),
                borderRadius: Corners.brMd,
              ),
              child: Icon(
                categoryIcon(transaction.category),
                size: 22,
                color: tone,
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: AppText.titleMedium.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.subtitle,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.xl(),
        Center(
          child: Text(
            '${transaction.isCredit ? '+' : '−'}${Fmt.money(transaction.amount)}',
            style: AppText.numericLarge.copyWith(
              fontSize: 32,
              color: transaction.isCredit ? AppColors.mint : AppColors.danger,
            ),
          ),
        ),
        const Gap.xl(),
        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        KeyValueRow(label: 'Reference ID', value: transaction.id.toUpperCase()),
        KeyValueRow(label: 'Category', value: _titleCase(transaction.category)),
        KeyValueRow(label: 'Date & time', value: Fmt.dateTime(transaction.at)),
        KeyValueRow(
          label: 'Status',
          value: _titleCase(transaction.status),
          valueColor: statusTone(transaction.status).color,
        ),
        const Gap.lg(),
      ],
    );
  }

  static String _titleCase(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
