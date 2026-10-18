import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';
import '../../domain/usecases/rental_plan_usecases.dart';

final rentalPlansProvider = FutureProvider.autoDispose.family<RentalPlanList, RentalPlansQuery>(
  (ref, query) async => (await ref.watch(getRentalPlansProvider)(query)).getOrThrow(),
);

class PlanBreakdownView extends StatelessWidget {
  const PlanBreakdownView({required this.breakdown, super.key});

  final CommercialBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String suffix = rentalPeriodSuffix(l10n, breakdown);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(
          label: l10n.planRent,
          value: rentWithPeriodLabel(l10n, breakdown),
          icon: Icons.receipt_long_rounded,
        ),
        for (final CommercialLine charge in breakdown.recurringCharges)
          if (charge.amount > 0)
            KeyValueRow(
              label: commercialChargeLabel(l10n, charge.type),
              value: [Fmt.money(charge.amount), suffix].where((part) => part.isNotEmpty).join(' '),
              icon: Icons.autorenew_rounded,
            ),
        for (final CommercialLine charge in breakdown.oneTimeCharges)
          KeyValueRow(
            label: commercialChargeLabel(l10n, charge.type),
            value: charge.amount > 0 ? Fmt.money(charge.amount) : l10n.planFree,
            icon: Icons.request_quote_rounded,
            valueColor: charge.amount > 0 ? null : AppColors.success,
          ),
        for (final CommercialLine deposit in breakdown.deposits)
          KeyValueRow(
            label: commercialChargeLabel(l10n, deposit.type),
            value: deposit.amount > 0 ? Fmt.money(deposit.amount) : l10n.planFree,
            icon: Icons.savings_rounded,
            valueColor: deposit.amount > 0 ? null : AppColors.success,
          ),
        for (final CommercialUsage usage in breakdown.usageCharges)
          KeyValueRow(
            label: commercialChargeLabel(l10n, usage.type),
            value: usageRateLabel(l10n, usage),
            icon: Icons.speed_rounded,
          ),
        KeyValueRow(
          label: l10n.planPayableToday,
          value: Fmt.money(breakdown.payableToday),
          icon: Icons.payments_rounded,
          valueStyle: AppText.titleMedium.copyWith(color: AppColors.primary),
        ),
        if (breakdown.refundableAmount > 0)
          Padding(
            padding: const EdgeInsets.only(top: Insets.xs),
            child: Text(
              l10n.planRefundableNote(Fmt.money(breakdown.refundableAmount)),
              style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ),
        if (breakdown.includedServices.isNotEmpty) ...[
          const Gap.md(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final String service in breakdown.includedServices)
                StatusChip(label: service, tone: StatusTone.success, icon: Icons.check_rounded, dense: true),
            ],
          ),
        ],
      ],
    );
  }
}

class RentalPlanPicker extends ConsumerStatefulWidget {
  const RentalPlanPicker({required this.allocationId, super.key});

  final String allocationId;

  static Future<RentalPlanOption?> show(BuildContext context, {required String allocationId}) =>
      AppSheet.show<RentalPlanOption>(
        context,
        title: context.l10n.allocationPlanPickTitle,
        subtitle: context.l10n.allocationPlanPickSubtitle,
        maxHeightFactor: 0.92,
        child: RentalPlanPicker(allocationId: allocationId),
      );

  @override
  ConsumerState<RentalPlanPicker> createState() => _RentalPlanPickerState();
}

class _RentalPlanPickerState extends ConsumerState<RentalPlanPicker> {
  String? _batteryPlanId;
  List<BatteryPlanOption> _batteryPlans = const [];

  RentalPlansQuery get _query => RentalPlansQuery(allocationId: widget.allocationId, batteryPlanId: _batteryPlanId);

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RentalPlanList> plans = ref.watch(rentalPlansProvider(_query));
    final RentalPlanList? list = plans.value;
    if (list != null && list.batteryPlans.isNotEmpty) _batteryPlans = list.batteryPlans;
    final int selected = _batteryPlans.indexWhere((plan) => plan.id == _batteryPlanId) + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_batteryPlans.isNotEmpty) ...[
          FilterChipBar(
            items: [
              context.l10n.allocationNoBatteryPlan,
              for (final BatteryPlanOption plan in _batteryPlans) plan.name,
            ],
            selectedIndex: selected,
            onChanged: (index) => setState(() => _batteryPlanId = index == 0 ? null : _batteryPlans[index - 1].id),
            padding: EdgeInsets.zero,
          ),
          const Gap.lg(),
        ],
        if (list == null && plans.hasError)
          EmptyState(
            title: context.l10n.allocationPlanCouldNotLoad,
            message: plans.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(rentalPlansProvider(_query)),
            compact: true,
          )
        else if (list == null)
          for (int i = 0; i < 2; i++) ...[const ShimmerBox(height: 220, borderRadius: Corners.brLg), const Gap.md()]
        else if (list.items.isEmpty)
          EmptyState(
            title: context.l10n.allocationPlanNoneTitle,
            message: context.l10n.allocationPlanNoneBody,
            icon: Icons.price_change_rounded,
            compact: true,
          )
        else
          for (final RentalPlanOption plan in list.items) ...[
            _PlanOptionCard(plan: plan, onSelect: () => Navigator.of(context).pop(plan)),
            const Gap.md(),
          ],
        const Gap.sm(),
      ],
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  const _PlanOptionCard({required this.plan, required this.onSelect});

  final RentalPlanOption plan;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final int? age = plan.scooterAgeMonths;
    return Container(
      padding: const EdgeInsets.all(Insets.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brLg,
        border: Border.all(color: AppColors.stroke),
        boxShadow: Shadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconTile(icon: Icons.price_change_rounded, tone: AppColors.primary, size: 38),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.rateCardName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleSmall.copyWith(fontSize: 14.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      rentalPeriodName(l10n, plan.breakdown),
                      style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                rentWithPeriodLabel(l10n, plan.breakdown),
                style: AppText.titleSmall.copyWith(fontSize: 14, color: AppColors.primary),
              ),
            ],
          ),
          const Gap.md(),
          PlanBreakdownView(breakdown: plan.breakdown),
          if (age != null) ...[
            const Gap.sm(),
            Text(
              l10n.allocationScooterAge(age),
              style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ],
          const Gap.md(),
          PrimaryButton(
            label: l10n.allocationPlanSend,
            icon: Icons.send_rounded,
            size: AppButtonSize.medium,
            onPressed: onSelect,
          ),
        ],
      ),
    );
  }
}

class RentalPlanCard extends StatelessWidget {
  const RentalPlanCard({
    required this.commercial,
    required this.isExchange,
    required this.onChange,
    this.paymentTotal,
    super.key,
  });

  final AllocationCommercial? commercial;
  final bool isExchange;
  final VoidCallback? onChange;
  final num? paymentTotal;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AllocationCommercial? current = commercial;
    final CommercialBreakdown? breakdown = current?.breakdown;
    final num? total = paymentTotal;
    final (String label, StatusTone tone) = switch (current) {
      _ when isExchange => (l10n.allocationPlanExchangeChip, StatusTone.info),
      AllocationCommercial(isAccepted: true) => (l10n.allocationPlanAcceptedChip, StatusTone.success),
      AllocationCommercial(awaitingRider: true) => (l10n.allocationPlanAwaitingChip, StatusTone.warning),
      _ => (l10n.allocationPlanNotChosenChip, StatusTone.neutral),
    };

    return ModuleCard(
      title: l10n.allocationPlanTitle,
      leading: const IconTile(icon: Icons.price_change_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(label: label, tone: tone, dense: true),
          ),
          const Gap.md(),
          if (isExchange)
            Text(l10n.allocationPlanExchangeBody, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5))
          else if (breakdown == null || (current?.needsPlan ?? true))
            Text(
              current?.offer == null ? l10n.allocationPlanNotChosenBody : l10n.allocationPlanExpiredBody,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            )
          else ...[
            Text(rentalPeriodName(l10n, breakdown), style: AppText.titleSmall.copyWith(fontSize: 14)),
            const Gap.sm(),
            PlanBreakdownView(breakdown: breakdown),
            if (current?.awaitingRider ?? false) ...[
              const Gap.md(),
              AccentCard(
                accent: AppColors.warning,
                child: Text(
                  l10n.allocationPlanAwaitingBody,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                ),
              ),
            ],
          ],
          if (total != null) ...[
            const Gap.md(),
            KeyValueRow(
              label: l10n.allocationPaymentRequestedAmount,
              value: Fmt.money(total),
              icon: Icons.receipt_rounded,
              valueStyle: AppText.titleMedium,
            ),
          ],
          if (onChange != null && (current?.awaitingRider ?? false)) ...[
            const Gap.sm(),
            GhostButton(
              label: l10n.allocationChangePlan,
              icon: Icons.swap_horiz_rounded,
              dense: true,
              onPressed: onChange,
            ),
          ],
        ],
      ),
    );
  }
}
