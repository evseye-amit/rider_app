import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rental.dart';
import '../providers/rentals_overview_provider.dart';
import '../widgets/rentals_widgets.dart';

class RentalsPage extends ConsumerStatefulWidget {
  const RentalsPage({super.key});

  @override
  ConsumerState<RentalsPage> createState() => _RentalsPageState();
}

class _RentalsPageState extends ConsumerState<RentalsPage> {
  int _tab = 0;

  Future<void> _refresh() async {
    ref.invalidate(ledgerProvider);
    ref.invalidate(paymentReceiptsProvider);
    await ref.refreshQuietly(rentalsOverviewProvider);
  }

  Future<void> _openBill(Bill bill) {
    return AppSheet.show<void>(
      context,
      title: context.l10n.rentalsRentReceipt,
      subtitle: billPeriod(bill),
      child: BillSheetBody(billId: bill.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RentalsOverview> rentals = ref.watch(rentalsOverviewProvider);
    final RentalsOverview? overview = rentals.value;

    return HeroScaffold(
      onRefresh: _refresh,
      band: RentalsBand(overview: overview),
      children: rentals.hasError && overview == null
          ? [
              EmptyState(
                title: context.l10n.rentalsCouldNotLoadRentPlan,
                message: rentals.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(rentalsOverviewProvider),
              ),
            ]
          : overview == null
          ? const [_RentalsSkeleton()]
          : _content(overview),
    );
  }

  List<Widget> _content(RentalsOverview overview) {
    final BillingSummary summary = overview.summary;
    return [
      if (summary.overdue > 0) ...[
        AccentCard(
          accent: AppColors.danger,
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Text(
                  context.l10n.rentalsOverdueNotice(Fmt.money(summary.overdue, paise: true)),
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                ),
              ),
            ],
          ),
        ),
        const Gap.lg(),
      ],
      AccountCard(summary: summary),
      if (summary.autoPay) ...[
        const Gap.lg(),
        PhotoPanel(
          photo: BrandPhoto.money,
          height: 130,
          title: context.l10n.rentalsRentHandledAutomatically,
          subtitle: context.l10n.rentalsAutoDebitKeepsEveryCycle,
        ),
      ],
      const Gap.xl(),
      SegmentedTabs(
        items: [context.l10n.rentalsBills, context.l10n.rentalsLedger, context.l10n.rentalsPayments],
        selectedIndex: _tab,
        onChanged: (index) => setState(() => _tab = index),
      ),
      const Gap.lg(),
      switch (_tab) {
        0 => _BillsTab(bills: overview.bills, onOpen: _openBill),
        1 => const _LedgerTab(),
        _ => const _PaymentsTab(),
      },
    ];
  }
}

class _BillsTab extends StatelessWidget {
  const _BillsTab({required this.bills, required this.onOpen});

  final List<Bill> bills;
  final ValueChanged<Bill> onOpen;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.rentalsInvoiceHistory,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.rentalsTapReceiptSeeFullBreakdown,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const Gap.lg(),
          if (bills.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.md),
              child: EmptyState(
                title: context.l10n.rentalsNoInvoicesYet,
                message: context.l10n.rentalsRentReceiptsWillAppearHere,
                icon: Icons.receipt_long_rounded,
                compact: true,
              ),
            )
          else
            for (final Bill bill in bills) ...[
              BillTile(bill: bill, onTap: () => onOpen(bill)),
              if (bill != bills.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
            ],
        ],
      ),
    );
  }
}

class _LedgerTab extends ConsumerWidget {
  const _LedgerTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LedgerLine>> ledger = ref.watch(ledgerProvider);
    final List<LedgerLine>? lines = ledger.value;
    return ModuleCard(
      title: context.l10n.rentalsLedger,
      child: lines == null
          ? ledger.hasError
                ? EmptyState(
                    compact: true,
                    title: context.l10n.rentalsCouldNotLoadLedger,
                    message: ledger.failureMessage,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: context.l10n.commonTryAgain,
                    onAction: () => ref.invalidate(ledgerProvider),
                  )
                : const _TabLoading()
          : lines.isEmpty
          ? EmptyState(
              compact: true,
              title: context.l10n.rentalsNoLedger,
              message: context.l10n.rentalsNoLedgerBody,
              icon: Icons.menu_book_rounded,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.rentalsLedgerHint,
                  style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
                ),
                const Gap.md(),
                for (final LedgerLine line in lines) ...[
                  LedgerTile(line: line),
                  if (line != lines.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
    );
  }
}

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PaymentReceipt>> receipts = ref.watch(paymentReceiptsProvider);
    final List<PaymentReceipt>? list = receipts.value;
    return ModuleCard(
      title: context.l10n.rentalsPayments,
      child: list == null
          ? receipts.hasError
                ? EmptyState(
                    compact: true,
                    title: context.l10n.rentalsCouldNotLoadPayments,
                    message: receipts.failureMessage,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: context.l10n.commonTryAgain,
                    onAction: () => ref.invalidate(paymentReceiptsProvider),
                  )
                : const _TabLoading()
          : list.isEmpty
          ? EmptyState(
              compact: true,
              title: context.l10n.rentalsNoPayments,
              message: context.l10n.rentalsNoPaymentsBody,
              icon: Icons.payments_outlined,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final PaymentReceipt receipt in list) ...[
                  ReceiptTile(receipt: receipt),
                  if (receipt != list.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
    );
  }
}

class _TabLoading extends StatelessWidget {
  const _TabLoading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ShimmerBox(height: 52, borderRadius: Corners.brMd),
        Gap.sm(),
        ShimmerBox(height: 52, borderRadius: Corners.brMd),
        Gap.sm(),
        ShimmerBox(height: 52, borderRadius: Corners.brMd),
      ],
    );
  }
}

class _RentalsSkeleton extends StatelessWidget {
  const _RentalsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 170, borderRadius: Corners.brXl),
        Gap.xxl(),
        ShimmerBox(height: 42, borderRadius: Corners.pill),
        Gap.lg(),
        ShimmerBox(height: 320, borderRadius: Corners.brLg),
      ],
    );
  }
}
