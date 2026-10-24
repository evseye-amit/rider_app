import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/payments/online_payments.dart';
import '../../../../core/payments/razorpay_checkout.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../../home/presentation/providers/home_summary_provider.dart';
import '../../../payments/presentation/providers/payments_provider.dart';
import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';

class DamageChargesPage extends ConsumerStatefulWidget {
  const DamageChargesPage({super.key});

  @override
  ConsumerState<DamageChargesPage> createState() => _DamageChargesPageState();
}

class _DamageChargesPageState extends ConsumerState<DamageChargesPage> {
  bool _paying = false;
  String? _notice;

  Future<void> _pay() async {
    final String mobile = ref.read(riderSessionProvider).mobile;
    final AppL10n l10n = context.l10n;
    setState(() => _paying = true);
    final OnlinePaymentOutcome outcome = await ref
        .read(onlinePaymentsProvider)
        .pay(
          PaymentOrderRequest.submissionPenalty(),
          description: l10n.damageChargesTitle,
          contact: mobile.isEmpty ? null : mobile,
        );
    if (!mounted) return;
    setState(() {
      _paying = false;
      _notice = switch (outcome) {
        OnlinePaymentPending() => l10n.onlinePaymentPending,
        OnlinePaymentNeedsSupport() => l10n.onlinePaymentReview,
        _ => _notice,
      };
    });
    switch (outcome) {
      case OnlinePaymentPaid():
        AppSnack.success(context, l10n.onlinePaymentDone);
      case OnlinePaymentCancelled():
        AppSnack.info(context, l10n.onlinePaymentCancelled);
      case OnlinePaymentDeclined():
        AppSnack.error(context, l10n.onlinePaymentFailed);
      case OnlinePaymentUnavailable():
        AppSnack.error(context, l10n.damageChargesOnlineUnavailable);
      case OnlinePaymentError(:final message):
        AppSnack.error(context, message);
      case OnlinePaymentPending() || OnlinePaymentNeedsSupport():
        break;
    }
    ref
      ..invalidate(damageChargesSummaryProvider)
      ..invalidate(damageChargesProvider)
      ..invalidate(homeSummaryProvider)
      ..invalidate(paymentsOverviewProvider);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<DamageChargesSummary> summary = ref.watch(damageChargesSummaryProvider);
    final AsyncValue<List<DamageCharge>> charges = ref.watch(damageChargesProvider);
    final DamageChargesSummary? totals = summary.value;
    final List<DamageCharge>? items = charges.value;
    final List<DamageCharge> toPay = [...?items?.where((charge) => charge.isOpen)];
    final List<DamageCharge> paid = [...?items?.where((charge) => !charge.isOpen)];
    final String? notice = _notice;

    return AppScaffold(
      title: context.l10n.damageChargesTitle,
      footer: switch (totals) {
        final DamageChargesSummary value when RazorpayCheckout.available && value.canPay && notice == null =>
          PrimaryButton(
            label: context.l10n.damageChargePay(Fmt.money(value.payAmount, paise: true)),
            icon: Icons.lock_rounded,
            loading: _paying,
            onPressed: _paying ? null : _pay,
          ),
        _ => null,
      },
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(damageChargesProvider);
          await ref.refreshQuietly(damageChargesSummaryProvider);
        },
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (notice != null) ...[
              AccentCard(
                accent: AppColors.info,
                child: Text(notice, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
              ),
              const Gap.lg(),
            ],
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
            if (items == null && charges.hasError)
              EmptyState(
                title: context.l10n.damageChargesCouldNotLoad,
                message: charges.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargesProvider),
              )
            else if (items == null)
              for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 92, borderRadius: Corners.brLg), const Gap.md()]
            else if (items.isEmpty)
              EmptyState(
                title: context.l10n.damageChargesNoneTitle,
                message: context.l10n.damageChargesNoneMessage,
                icon: Icons.receipt_long_rounded,
                tone: AppColors.primary,
              )
            else ...[
              if (toPay.isNotEmpty) ...[
                GroupLabel(context.l10n.damageChargesSectionToPay),
                const Gap.sm(),
                for (final DamageCharge charge in toPay) _ChargeTile(charge: charge),
              ],
              if (toPay.isNotEmpty && paid.isNotEmpty) const Gap.sm(),
              if (paid.isNotEmpty) ...[
                GroupLabel(context.l10n.damageChargesSectionPaid),
                const Gap.sm(),
                for (final DamageCharge charge in paid) _ChargeTile(charge: charge),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ChargeTile extends StatelessWidget {
  const _ChargeTile({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: DamageChargeTile(
        charge: charge,
        onOpen: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
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
    final String? note = switch (summary.activity) {
      DamagePaymentActivity.processing => l10n.damageChargesPaymentProcessing(
        Fmt.money(summary.activityAmount ?? summary.due, paise: true),
      ),
      DamagePaymentActivity.underReview => l10n.onlinePaymentReview,
      _ when summary.due > 0 && !RazorpayCheckout.available => l10n.damageChargesOnlineUnavailable,
      _ => null,
    };
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
              if (summary.due > 0)
                StatusChip(label: l10n.damageChargesToPay(summary.unpaidCount), tone: StatusTone.warning, dense: true)
              else
                StatusChip(label: l10n.damageChargesNothingToPay, tone: StatusTone.success, dense: true),
            ],
          ),
          const Gap.md(),
          KeyValueRow(label: l10n.damageChargeTotal, value: Fmt.money(summary.total, paise: true)),
          if (summary.paid > 0)
            KeyValueRow(label: l10n.damageChargePaidSoFar, value: Fmt.money(summary.paid, paise: true)),
          if (summary.credit > 0)
            KeyValueRow(label: l10n.damageChargeCreditUsed, value: Fmt.money(summary.credit, paise: true)),
          if (note != null) ...[
            const Gap.md(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: Insets.sm),
                Expanded(child: Text(note, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
