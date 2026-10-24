import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';

class DamageChargesPage extends ConsumerStatefulWidget {
  const DamageChargesPage({super.key});

  @override
  ConsumerState<DamageChargesPage> createState() => _DamageChargesPageState();
}

class _DamageChargesPageState extends ConsumerState<DamageChargesPage> {
  int _filter = 0;

  Future<void> _payAtHub(num amount) => AppSheet.show<void>(
    context,
    title: context.l10n.damageChargesPayAtHubTitle,
    child: Text(
      context.l10n.damageChargesPayAtHubMessage(Fmt.money(amount, paise: true)),
      style: AppText.bodyMedium.copyWith(height: 1.55),
    ),
    footer: PrimaryButton(label: context.l10n.notificationsGotIt, onPressed: () => Navigator.of(context).pop()),
  );

  @override
  Widget build(BuildContext context) {
    final bool includePaid = _filter == 1;
    final AsyncValue<DamageChargesSummary> summary = ref.watch(damageChargesSummaryProvider);
    final AsyncValue<List<DamageCharge>> charges = ref.watch(damageChargesProvider(includePaid));
    final DamageChargesSummary? totals = summary.value;
    final List<DamageCharge>? items = charges.value;

    return AppScaffold(
      title: context.l10n.damageChargesTitle,
      footer: switch (totals) {
        final DamageChargesSummary value when value.canPay => PrimaryButton(
          label: context.l10n.damageChargePay(Fmt.money(value.due, paise: true)),
          icon: Icons.payments_rounded,
          onPressed: () => _payAtHub(value.due),
        ),
        _ => null,
      },
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(damageChargesProvider(includePaid));
          await ref.refreshQuietly(damageChargesSummaryProvider);
        },
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (totals != null && totals.total > 0) ...[
              _Total(summary: totals),
              const Gap.lg(),
            ] else if (totals == null && summary.hasError) ...[
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: summary.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesSummaryProvider),
                compact: true,
              ),
              const Gap.lg(),
            ] else if (totals == null) ...[
              const ShimmerBox(height: 150, borderRadius: Corners.brXl),
              const Gap.lg(),
            ],
            FilterChipBar(
              items: [context.l10n.damageChargesUnpaid, context.l10n.damageChargesAll],
              selectedIndex: _filter,
              onChanged: (index) => setState(() => _filter = index),
              padding: EdgeInsets.zero,
            ),
            const Gap.lg(),
            if (items == null && charges.hasError)
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: charges.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesProvider(includePaid)),
              )
            else if (items == null)
              for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 92, borderRadius: Corners.brLg), const Gap.md()]
            else if (items.isEmpty)
              EmptyState(
                title: includePaid ? context.l10n.damageChargesNoneTitle : context.l10n.damageChargesNothingToPay,
                message: includePaid
                    ? context.l10n.damageChargesNoneMessage
                    : context.l10n.damageChargesNothingToPayMessage,
                icon: includePaid ? Icons.receipt_long_rounded : Icons.check_circle_rounded,
                tone: includePaid ? AppColors.primary : AppColors.success,
              )
            else
              for (final DamageCharge charge in items) ...[
                DamageChargeTile(
                  charge: charge,
                  onOpen: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
                ),
                const Gap.md(),
              ],
          ],
        ),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({required this.summary});

  final DamageChargesSummary summary;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final num? processing = summary.processingAmount;
    return ModuleCard(
      title: l10n.damageChargeAmountToPay,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Fmt.money(summary.due, paise: true),
                  style: AppText.numericLarge.copyWith(color: summary.due > 0 ? AppColors.primary : AppColors.success),
                ),
              ),
              if (summary.unpaidCount > 0)
                StatusChip(label: l10n.damageChargesToPay(summary.unpaidCount), tone: StatusTone.warning, dense: true),
            ],
          ),
          const Gap.md(),
          KeyValueRow(label: l10n.damageChargeTotal, value: Fmt.money(summary.total, paise: true)),
          if (summary.paid > 0)
            KeyValueRow(label: l10n.damageChargePaidSoFar, value: Fmt.money(summary.paid, paise: true)),
          if (summary.credit > 0)
            KeyValueRow(label: l10n.damageChargeCreditUsed, value: Fmt.money(summary.credit, paise: true)),
          if (processing != null) ...[
            const Gap.md(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    l10n.damageChargesPaymentProcessing(Fmt.money(processing, paise: true)),
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
