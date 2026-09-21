import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/wallet_summary.dart';
import '../../domain/usecases/get_wallet.dart';
import '../cubit/wallet_cubit.dart';
import '../widgets/wallet_widgets.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletCubit(GetWallet(sl()))..load(),
      child: const _WalletView(),
    );
  }
}

class _WalletView extends StatefulWidget {
  const _WalletView();

  @override
  State<_WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<_WalletView> {
  int _filter = 0;
  String _query = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _filters = ['All', 'Credits', 'Debits'];

  List<WalletTransaction> _apply(List<WalletTransaction> all) {
    final Iterable<WalletTransaction> byTab = switch (_filter) {
      1 => all.where((t) => t.isCredit),
      2 => all.where((t) => !t.isCredit),
      _ => all,
    };
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return byTab.toList();
    return byTab
        .where(
          (t) =>
              t.title.toLowerCase().contains(q) ||
              t.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        if (state.status == WalletStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load your wallet',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<WalletCubit>().refresh(),
              ),
            ),
          );
        }

        final WalletSummary? summary = state.summary;

        return HeroScaffold(
          bottomPadding: 120,
          controller: _scrollController,
          onRefresh: () => context.read<WalletCubit>().refresh(),
          band: WalletBand(summary: summary),
          children: summary == null
              ? const [_WalletSkeleton()]
              : _content(context, summary),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, WalletSummary summary) {
    final List<WalletTransaction> shown = _apply(summary.transactions);
    final int credits = summary.transactions.where((t) => t.isCredit).length;
    final int debits = summary.transactions.length - credits;

    return [
      ModuleCard(
        title: 'Transactions',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last payment ${summary.lastPayoutAt == null ? '—' : Fmt.relative(summary.lastPayoutAt!)}',
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const Gap.lg(),
            AppSearchField(
              hint: 'Search transactions',
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
            ),
            const Gap.md(),
            SegmentedTabs(
              items: _filters,
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
                  title: 'No transactions here',
                  message: summary.transactions.isEmpty
                      ? 'Your ledger will fill up as you ride and earn.'
                      : 'Nothing matches this filter yet.',
                ),
              )
            else
              Column(
                children: [
                  for (final tx in shown) ...[
                    TransactionTile(
                      transaction: tx,
                      onTap: () => _openDetail(context, tx),
                    ),
                    if (tx != shown.last)
                      Divider(
                        color: AppColors.stroke.withValues(alpha: 0.5),
                        height: 1,
                      ),
                  ],
                ],
              ),
          ],
        ),
      ),
    ];
  }

  Future<void> _openDetail(BuildContext context, WalletTransaction tx) {
    return AppSheet.show(
      context,
      title: tx.title,
      subtitle: tx.subtitle,
      child: TransactionDetailBody(transaction: tx),
    );
  }
}

class _WalletSkeleton extends StatelessWidget {
  const _WalletSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        ShimmerBox(width: 140, height: 20),
        Gap.lg(),
        ShimmerBox(height: 42, borderRadius: Corners.pill),
        Gap.lg(),
        ShimmerBox(height: 220, borderRadius: Corners.brLg),
      ],
    );
  }
}
