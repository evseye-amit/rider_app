import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_summary.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  int _filter = 0;
  String _query = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<String> _filters(AppL10n l10n) => ['All', l10n.walletCredits, l10n.walletDebits];

  List<WalletTransaction> _apply(List<WalletTransaction> all) {
    final Iterable<WalletTransaction> byTab = switch (_filter) {
      1 => all.where((t) => t.isCredit),
      2 => all.where((t) => !t.isCredit),
      _ => all,
    };
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) return byTab.toList();
    return byTab
        .where((t) => t.title.toLowerCase().contains(query) || t.subtitle.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<WalletSummary> wallet = ref.watch(walletProvider);

    if (wallet.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.walletCouldNotLoadWallet,
            message: wallet.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(walletProvider),
          ),
        ),
      );
    }

    final WalletSummary? summary = wallet.value;

    return HeroScaffold(
      bottomPadding: 120,
      controller: _scrollController,
      onRefresh: () => ref.refreshQuietly(walletProvider),
      band: WalletBand(summary: summary),
      children: summary == null ? const [_WalletSkeleton()] : _content(context, summary),
    );
  }

  List<Widget> _content(BuildContext context, WalletSummary summary) {
    final List<WalletTransaction> shown = _apply(summary.transactions);
    final int credits = summary.transactions.where((t) => t.isCredit).length;
    final int debits = summary.transactions.length - credits;

    return [
      ModuleCard(
        title: context.l10n.walletTransactions,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last payment ${summary.lastPayoutAt == null ? '—' : Fmt.relative(summary.lastPayoutAt!)}',
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
            ),
            const Gap.lg(),
            AppSearchField(
              hint: context.l10n.walletSearchTransactions,
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
            ),
            const Gap.md(),
            SegmentedTabs(
              items: _filters(context.l10n),
              selectedIndex: _filter,
              counts: {1: credits, 2: debits},
              onChanged: (i) => setState(() => _filter = i),
            ),
            const Gap.md(),
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                child: ArtBlock(
                  art: BrandArt.wallet,
                  artSize: 130,
                  title: context.l10n.walletNoTransactionsHere,
                  message: summary.transactions.isEmpty
                      ? context.l10n.walletLedgerWillFillUpAs
                      : context.l10n.walletNothingMatchesFilterYet,
                ),
              )
            else
              Column(
                children: [
                  for (final WalletTransaction transaction in shown) ...[
                    TransactionTile(transaction: transaction, onTap: () => _openDetail(context, transaction)),
                    if (transaction != shown.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                  ],
                ],
              ),
          ],
        ),
      ),
    ];
  }

  Future<void> _openDetail(BuildContext context, WalletTransaction transaction) {
    return AppSheet.show(
      context,
      title: transaction.title,
      subtitle: transaction.subtitle,
      child: TransactionDetailBody(transaction: transaction),
    );
  }
}

class _WalletSkeleton extends StatelessWidget {
  const _WalletSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(width: 140, height: 20),
        Gap.lg(),
        ShimmerBox(height: 42, borderRadius: Corners.pill),
        Gap.lg(),
        ShimmerBox(height: 220, borderRadius: Corners.brLg),
      ],
    );
  }
}
