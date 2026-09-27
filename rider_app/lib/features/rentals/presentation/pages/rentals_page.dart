import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/rental.dart';
import '../../domain/usecases/get_rentals_overview.dart';
import '../cubit/rentals_cubit.dart';
import '../widgets/rentals_widgets.dart';

class RentalsPage extends StatelessWidget {
  const RentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RentalsCubit(GetRentalsOverview(sl()))..load(),
      child: const _RentalsView(),
    );
  }
}

class _RentalsView extends StatelessWidget {
  const _RentalsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentalsCubit, RentalsState>(
      builder: (context, state) {
        final RentalsOverview? overview = state.overview;

        return HeroScaffold(
          onRefresh: () => context.read<RentalsCubit>().refresh(),
          band: RentalsBand(plan: overview?.plan),
          children: state.status == RentalsStatus.failure
              ? [
                  EmptyState(
                    title: context.l10n.rentalsCouldNotLoadRentPlan,
                    message: state.message,
                    icon: Icons.cloud_off_rounded,
                    tone: AppColors.danger,
                    actionLabel: context.l10n.commonTryAgain,
                    onAction: () => context.read<RentalsCubit>().refresh(),
                  ),
                ]
              : overview == null
              ? const [_RentalsSkeleton()]
              : _content(context, overview),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, RentalsOverview overview) {
    return [
      PlanCard(plan: overview.plan),
      const Gap.lg(),

      PhotoPanel(
        photo: BrandPhoto.money,
        height: 130,
        title: context.l10n.rentalsRentHandledAutomatically,
        subtitle: context.l10n.rentalsAutoDebitKeepsEveryCycle,
      ),
      const Gap.lg(),

      ModuleCard(
        title: context.l10n.rentalsInvoiceHistory,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.rentalsTapReceiptSeeFullBreakdown,
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const Gap.lg(),
            if (overview.invoices.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: Insets.md),
                child: EmptyState(
                  title: context.l10n.rentalsNoInvoicesYet,
                  message: context.l10n.rentalsRentReceiptsWillAppearHere,
                  icon: Icons.receipt_long_rounded,
                  compact: true,
                ),
              )
            else
              for (final invoice in overview.invoices) ...[
                InvoiceTile(
                  invoice: invoice,
                  onTap: () => _openReceipt(context, invoice),
                ),
                if (invoice != overview.invoices.last)
                  Divider(
                    color: AppColors.stroke.withValues(alpha: 0.5),
                    height: 1,
                  ),
              ],
          ],
        ),
      ),
    ];
  }

  Future<void> _openReceipt(BuildContext context, RentalInvoice invoice) {
    return AppSheet.show(
      context,
      title: context.l10n.rentalsRentReceipt,
      subtitle: invoice.periodLabel,
      child: InvoiceReceiptBody(invoice: invoice),
      footer: SecondaryButton(
        label: context.l10n.rentalsDownloadPdf,
        icon: Icons.download_rounded,
        onPressed: () {
          Navigator.of(context).pop();
          AppSnack.success(
            context,
            'Receipt for ${invoice.periodLabel} downloaded.',
          );
        },
      ),
    );
  }
}

class _RentalsSkeleton extends StatelessWidget {
  const _RentalsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        ShimmerBox(height: 128, borderRadius: Corners.brXl),
        Gap.xxl(),
        ShimmerBox(width: 150, height: 20),
        Gap.lg(),
        ShimmerBox(height: 320, borderRadius: Corners.brLg),
      ],
    );
  }
}
