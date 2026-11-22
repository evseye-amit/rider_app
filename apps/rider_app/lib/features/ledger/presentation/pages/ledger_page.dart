import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/payments/online_payments.dart';
import '../../../../core/payments/payment_capabilities_provider.dart';
import '../../../../core/payments/payment_feedback.dart';
import '../../../../core/payments/payment_flow_provider.dart';
import '../../../payments/domain/entities/auto_pay.dart';
import '../../../payments/presentation/providers/auto_pay_provider.dart';
import '../../domain/entities/ledger_overview.dart';
import '../../domain/entities/ledger_top_up.dart';
import '../providers/ledger_provider.dart';
import '../widgets/add_money_sheet.dart';
import '../widgets/deposit_sheets.dart';
import '../widgets/ledger_widgets.dart';

enum _Filter { all, credits, debits }

class LedgerPage extends ConsumerStatefulWidget {
  const LedgerPage({super.key});

  @override
  ConsumerState<LedgerPage> createState() => _LedgerPageState();
}

class _LedgerPageState extends ConsumerState<LedgerPage> {
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

  List<LedgerEntry> _apply(List<LedgerEntry> all) {
    final Iterable<LedgerEntry> byTab = switch (_filter) {
      _Filter.credits => all.where((entry) => entry.isCredit),
      _Filter.debits => all.where((entry) => entry.isDebit),
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

  Future<void> _addMoney(num? autoRecharge) async {
    final AppL10n l10n = context.l10n;
    final int? paise = await AddMoneySheet.show(context, pendingAutoRecharge: autoRecharge);
    if (paise == null || !mounted) return;
    final OnlinePaymentOutcome? outcome = await ref
        .read(paymentFlowProvider(PaymentSlots.topUp).notifier)
        .pay(PaymentOrderRequest.topUp(LedgerTopUpLimits.wire(paise)), description: l10n.ledgerAddMoney);
    if (outcome == null || !mounted) return;
    showPaymentOutcome(
      context,
      outcome,
      unavailable: l10n.ledgerAddMoneyUnavailable,
      success: l10n.ledgerAddMoneyDone(topUpMoney(paise)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LedgerOverview> overview = ref.watch(ledgerOverviewProvider);
    final PaymentFlowState topUp = ref.watch(paymentFlowProvider(PaymentSlots.topUp));
    final bool canTopUp = ref.watch(canPayOnlineProvider(PaymentPurposes.topUp));
    final num? autoRecharge = switch (ref.watch(autoPayProvider).value?.openRequest) {
      final AutoRecharge request when request.state.isAwaitingBank => request.amount,
      _ => null,
    };

    if (overview.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.ledgerCouldNotLoadLedger,
            message: overview.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(ledgerOverviewProvider),
          ),
        ),
      );
    }

    final LedgerOverview? ledger = overview.value;

    return HeroScaffold(
      controller: _scrollController,
      onRefresh: () async {
        ref
          ..invalidate(ledgerTransactionsProvider)
          ..invalidate(autoPayProvider);
        await Future.wait([
          ref.refreshQuietly(ledgerOverviewProvider),
          if (topUp.notice != null) ref.read(paymentFlowProvider(PaymentSlots.topUp).notifier).check(),
        ]);
      },
      band: LedgerBand(
        overview: ledger,
        onAddMoney: canTopUp ? () => _addMoney(autoRecharge) : null,
        addingMoney: topUp.busy,
      ),
      children: ledger == null ? const [_LedgerSkeleton()] : _content(context, ledger, hasNotice: topUp.notice != null),
    );
  }

  List<Widget> _content(BuildContext context, LedgerOverview ledger, {required bool hasNotice}) {
    return [
      if (hasNotice) ...[const PaymentNoticeCard(slot: PaymentSlots.topUp), const Gap.lg()],
      if (ledger.hasRewards) ...[
        ModuleCard(
          title: context.l10n.commonIncentives,
          leading: const IconTile(icon: Icons.emoji_events_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(label: context.l10n.ledgerRewardsEarned, value: Fmt.money(ledger.rewardsEarned)),
              KeyValueRow(label: context.l10n.ledgerAvailable, value: Fmt.money(ledger.rewards.available)),
              if (ledger.rewardsExpiringSoon > 0)
                KeyValueRow(
                  label: context.l10n.ledgerExpiringSoon,
                  value: Fmt.money(ledger.rewardsExpiringSoon),
                  valueColor: AppColors.warning,
                  icon: Icons.schedule_rounded,
                ),
            ],
          ),
        ),
        const Gap.lg(),
      ],
      if (ledger.hasDeposits) ...[
        ModuleCard(
          title: context.l10n.ledgerSecurityDeposit,
          leading: const IconTile(icon: Icons.savings_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final LedgerDeposit deposit in ledger.deposits)
                LedgerDepositCard(deposit: deposit, onTap: () => showDepositSheet(context, deposit)),
              if (ledger.deposits.isEmpty)
                KeyValueRow(label: context.l10n.commonTotal, value: Fmt.money(ledger.depositBucket.total)),
              Text(context.l10n.ledgerDepositReturnedSeparately, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
            ],
          ),
        ),
        const Gap.lg(),
      ],
      _Transactions(
        recent: ledger.recentEntries,
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

  final List<LedgerEntry> recent;
  final _Filter filter;
  final ValueChanged<_Filter> onFilterChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;
  final List<LedgerEntry> Function(List<LedgerEntry> all) apply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LedgerEntry>> page = ref.watch(ledgerTransactionsProvider);
    final List<LedgerEntry> all = page.value ?? recent;
    final List<LedgerEntry> shown = apply(all);
    final int credits = all.where((entry) => entry.isCredit).length;
    final int debits = all.where((entry) => entry.isDebit).length;

    return ModuleCard(
      title: context.l10n.ledgerTransactions,
      actionLabel: context.l10n.ledgerStatement,
      onAction: () => context.push(Routes.ledgerStatement),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSearchField(
            hint: context.l10n.ledgerSearchTransactions,
            controller: searchController,
            onChanged: onQueryChanged,
          ),
          const Gap.md(),
          SegmentedTabs(
            items: [context.l10n.supportAll, context.l10n.ledgerCredits, context.l10n.ledgerDebits],
            selectedIndex: _Filter.values.indexOf(filter),
            counts: {1: credits, 2: debits},
            onChanged: (index) => onFilterChanged(_Filter.values[index]),
          ),
          const Gap.md(),
          if (page.isLoading && !page.hasValue && recent.isEmpty)
            const ShimmerBox(height: 180, borderRadius: Corners.brLg)
          else if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.lg),
              child: ArtBlock(
                art: BrandArt.ledger,
                artSize: 130,
                title: context.l10n.ledgerNoTransactionsHere,
                message: all.isEmpty ? context.l10n.ledgerWillFillUpAs : context.l10n.ledgerNothingMatchesFilterYet,
              ),
            )
          else
            Column(
              children: [
                for (final LedgerEntry entry in shown) ...[
                  LedgerEntryTile(entry: entry, onTap: () => _openDetail(context, entry)),
                  if (entry != shown.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, LedgerEntry entry) => AppSheet.show(
    context,
    title: entry.description ?? ledgerEntryLabel(context.l10n, entry.kind),
    subtitle: entry.reference,
    child: LedgerEntryDetailBody(entry: entry),
  );
}

class _LedgerSkeleton extends StatelessWidget {
  const _LedgerSkeleton();

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
