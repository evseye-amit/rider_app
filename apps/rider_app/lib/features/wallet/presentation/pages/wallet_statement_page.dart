import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_overview.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class WalletStatementPage extends ConsumerStatefulWidget {
  const WalletStatementPage({super.key});

  @override
  ConsumerState<WalletStatementPage> createState() => _WalletStatementPageState();
}

class _WalletStatementPageState extends ConsumerState<WalletStatementPage> {
  static const int _monthsBack = 12;

  late final DateTime _latest = _currentMonth();
  late DateTime _month = _latest;
  bool _loadingMore = false;

  static DateTime _currentMonth() {
    final DateTime now = DateTime.now().toUtc();
    return DateTime.utc(now.year, now.month);
  }

  DateTime get _earliest => DateTime.utc(_latest.year, _latest.month - _monthsBack);

  void _shift(int months) {
    final DateTime next = DateTime.utc(_month.year, _month.month + months);
    if (next.isAfter(_latest) || next.isBefore(_earliest)) return;
    setState(() => _month = next);
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    final bool loaded = await ref.read(walletStatementProvider(_month).notifier).loadMore();
    if (!mounted) return;
    setState(() => _loadingMore = false);
    if (!loaded) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<WalletStatementView> statement = ref.watch(walletStatementProvider(_month));
    final WalletStatementView? value = statement.value;

    return AppScaffold(
      title: context.l10n.walletStatement,
      subtitle: context.l10n.walletStatementSubtitle,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
            child: Row(
              children: [
                CircleIconButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: _month.isAfter(_earliest) ? () => _shift(-1) : null,
                ),
                Expanded(
                  child: Text(
                    Fmt.month(_month),
                    textAlign: TextAlign.center,
                    style: AppText.titleMedium.copyWith(fontSize: 16),
                  ),
                ),
                CircleIconButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: _month.isBefore(_latest) ? () => _shift(1) : null,
                ),
              ],
            ),
          ),
          const Gap.md(),
          Expanded(
            child: value == null
                ? statement.hasError
                      ? EmptyState(
                          title: context.l10n.walletCouldNotLoadStatement,
                          message: statement.failureMessage,
                          icon: Icons.cloud_off_rounded,
                          tone: AppColors.danger,
                          actionLabel: context.l10n.commonTryAgain,
                          onAction: () => ref.invalidate(walletStatementProvider(_month)),
                        )
                      : const PageBody(
                          children: [
                            ShimmerBox(height: 180, borderRadius: Corners.brXl),
                            Gap.lg(),
                            ShimmerBox(height: 260, borderRadius: Corners.brXl),
                          ],
                        )
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.refresh(walletStatementProvider(_month).future).then<void>((_) {}, onError: (_) {}),
                    color: AppColors.primary,
                    child: PageBody(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        _Summary(statement: value),
                        const Gap.lg(),
                        ModuleCard(
                          title: context.l10n.walletTransactions,
                          child: value.lines.isEmpty
                              ? EmptyState(
                                  compact: true,
                                  title: context.l10n.walletStatementEmpty,
                                  message: context.l10n.walletStatementEmptyBody,
                                  icon: Icons.receipt_long_outlined,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    for (final StatementLine line in value.lines) ...[
                                      _StatementRow(line: line),
                                      if (line != value.lines.last)
                                        Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                                    ],
                                    if (value.hasMore) ...[
                                      const Gap.md(),
                                      Center(
                                        child: _loadingMore
                                            ? const SizedBox.square(
                                                dimension: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.primary,
                                                ),
                                              )
                                            : GhostButton(label: context.l10n.commonLoadMore, onPressed: _loadMore),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.statement});

  final WalletStatementView statement;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.walletStatementSummary,
      leading: const IconTile(icon: Icons.summarize_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyValueRow(label: context.l10n.walletOpeningBalance, value: Fmt.money(statement.opening, paise: true)),
          KeyValueRow(
            label: context.l10n.walletMoneyIn,
            value: '+${Fmt.money(statement.moneyIn, paise: true)}',
            valueColor: AppColors.mint,
          ),
          KeyValueRow(
            label: context.l10n.walletMoneyOut,
            value: '−${Fmt.money(statement.moneyOut, paise: true)}',
            valueColor: AppColors.danger,
          ),
          const SizedBox(height: Insets.xs),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const SizedBox(height: Insets.xs),
          KeyValueRow(
            label: context.l10n.walletClosingBalance,
            value: Fmt.money(statement.closing, paise: true),
            valueStyle: AppText.numeric.copyWith(fontSize: 17),
          ),
          if (statement.depositClosing != 0)
            KeyValueRow(
              label: context.l10n.walletSecurityDeposit,
              value: Fmt.money(statement.depositClosing, paise: true),
              icon: Icons.savings_rounded,
            ),
          if (statement.reference.isNotEmpty) ...[
            const Gap.sm(),
            Text(
              context.l10n.walletStatementReference(statement.reference),
              style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatementRow extends StatelessWidget {
  const _StatementRow({required this.line});

  final StatementLine line;

  @override
  Widget build(BuildContext context) {
    final num shown = line.change != 0 ? line.change : line.depositChange;
    final bool incoming = shown >= 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        children: [
          IconTile(icon: walletEntryIcon(line.kind), tone: AppColors.primary, size: 38),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.description.isEmpty ? walletEntryLabel(context.l10n, line.kind) : line.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    Fmt.dateTime(line.at),
                    if (line.change != 0 && line.depositChange != 0)
                      context.l10n.walletDepositMoved(Fmt.money(line.depositChange.abs(), paise: true)),
                  ].join(' · '),
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
                '${incoming ? '+' : '−'}${Fmt.money(shown.abs(), paise: true)}',
                style: AppText.numericSmall.copyWith(fontSize: 14, color: incoming ? AppColors.mint : AppColors.danger),
              ),
              if (line.reversed) ...[
                const SizedBox(height: 3),
                StatusChip(
                  label: context.l10n.walletStateReversed,
                  tone: StatusTone.neutral,
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
}
