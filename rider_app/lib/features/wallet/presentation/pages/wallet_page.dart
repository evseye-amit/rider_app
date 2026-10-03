import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet_overview.dart';
import '../providers/wallet_provider.dart';
import '../widgets/wallet_widgets.dart';

enum _Filter { all, credits, debits }

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  _Filter _filter = _Filter.all;
  String _query = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<WalletEntry> _apply(List<WalletEntry> all) {
    final Iterable<WalletEntry> byTab = switch (_filter) {
      _Filter.credits => all.where((entry) => entry.isCredit),
      _Filter.debits => all.where((entry) => !entry.isCredit),
      _Filter.all => all,
    };
    final String query = _query.trim().toLowerCase();
    if (query.isEmpty) return byTab.toList(growable: false);
    return byTab
        .where(
          (entry) =>
              (entry.description ?? '').toLowerCase().contains(query) || entry.reference.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<WalletOverview> overview = ref.watch(walletOverviewProvider);

    if (overview.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.walletCouldNotLoadWallet,
            message: overview.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(walletOverviewProvider),
          ),
        ),
      );
    }

    final WalletOverview? wallet = overview.value;

    return HeroScaffold(
      bottomPadding: 120,
      controller: _scrollController,
      onRefresh: () async {
        ref.invalidate(walletTransactionsProvider);
        await ref.refreshQuietly(walletOverviewProvider);
      },
      band: WalletBand(overview: wallet),
      children: wallet == null ? const [_WalletSkeleton()] : _content(context, wallet),
    );
  }

  List<Widget> _content(BuildContext context, WalletOverview wallet) {
    return [
      if (wallet.hasRewards) ...[
        ModuleCard(
          title: context.l10n.commonIncentives,
          leading: const IconTile(icon: Icons.emoji_events_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(label: context.l10n.walletRewardsEarned, value: Fmt.money(wallet.rewardsEarned)),
              KeyValueRow(label: context.l10n.walletAvailable, value: Fmt.money(wallet.rewards.available)),
              if (wallet.rewardsExpiringSoon > 0)
                KeyValueRow(
                  label: context.l10n.walletExpiringSoon,
                  value: Fmt.money(wallet.rewardsExpiringSoon),
                  valueColor: AppColors.warning,
                  icon: Icons.schedule_rounded,
                ),
            ],
          ),
        ),
        const Gap.lg(),
      ],
      if (wallet.hasDeposits) ...[
        ModuleCard(
          title: context.l10n.walletSecurityDeposit,
          leading: const IconTile(icon: Icons.savings_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final WalletDeposit deposit in wallet.deposits) WalletDepositCard(deposit: deposit),
              if (wallet.deposits.isEmpty)
                KeyValueRow(label: context.l10n.commonTotal, value: Fmt.money(wallet.depositBucket.total)),
              Text(context.l10n.walletDepositReturnedSeparately, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
            ],
          ),
        ),
        const Gap.lg(),
      ],
      _Transactions(
        recent: wallet.recentEntries,
        filter: _filter,
        onFilterChanged: (filter) => setState(() => _filter = filter),
        searchController: _searchController,
        onQueryChanged: (query) => setState(() => _query = query),
        apply: _apply,
      ),
    ];
  }
}

class _Transactions extends ConsumerWidget {
  const _Transactions({
    required this.recent,
    required this.filter,
    required this.onFilterChanged,
    required this.searchController,
    required this.onQueryChanged,
    required this.apply,
  });

  final List<WalletEntry> recent;
  final _Filter filter;
  final ValueChanged<_Filter> onFilterChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final List<WalletEntry> Function(List<WalletEntry> all) apply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<WalletEntry>> page = ref.watch(walletTransactionsProvider);
    final List<WalletEntry> all = page.value ?? recent;
    final List<WalletEntry> shown = apply(all);
    final int credits = all.where((entry) => entry.isCredit).length;

    return ModuleCard(
      title: context.l10n.walletTransactions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSearchField(
            hint: context.l10n.walletSearchTransactions,
            controller: searchController,
            onChanged: onQueryChanged,
          ),
          const Gap.md(),
          SegmentedTabs(
            items: ['All', context.l10n.walletCredits, context.l10n.walletDebits],
            selectedIndex: _Filter.values.indexOf(filter),
            counts: {1: credits, 2: all.length - credits},
            onChanged: (index) => onFilterChanged(_Filter.values[index]),
          ),
          const Gap.md(),
          if (page.isLoading && !page.hasValue && recent.isEmpty)
            const ShimmerBox(height: 180, borderRadius: Corners.brLg)
          else if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.lg),
              child: ArtBlock(
                art: BrandArt.wallet,
                artSize: 130,
                title: context.l10n.walletNoTransactionsHere,
                message: all.isEmpty
                    ? context.l10n.walletLedgerWillFillUpAs
                    : context.l10n.walletNothingMatchesFilterYet,
              ),
            )
          else
            Column(
              children: [
                for (final WalletEntry entry in shown) ...[
                  WalletEntryTile(entry: entry, onTap: () => _openDetail(context, entry)),
                  if (entry != shown.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, WalletEntry entry) => AppSheet.show(
    context,
    title: entry.description ?? walletEntryLabel(context.l10n, entry.kind),
    subtitle: entry.reference,
    child: WalletEntryDetailBody(entry: entry),
  );
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
