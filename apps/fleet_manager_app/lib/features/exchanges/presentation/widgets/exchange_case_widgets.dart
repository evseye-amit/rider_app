import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/exchange_case.dart';

String caseStatusLabel(AppL10n l10n, ExchangeCase exchange) => switch (exchange.status) {
  CaseStatus.requested => l10n.exchangeStageRequested,
  CaseStatus.approved => exchange.oldScooterReturned ? l10n.exchangeStatusChoosing : l10n.exchangeStatusApproved,
  CaseStatus.returnPending => l10n.exchangeStatusReturn,
  CaseStatus.replacementSelected => l10n.exchangeDeskStatusReserved,
  CaseStatus.offerPresented => l10n.exchangeDeskStatusOfferSent,
  CaseStatus.depositPending => l10n.exchangeStepDeposit,
  CaseStatus.handoverPending => l10n.exchangeStageHandover,
  CaseStatus.completed => l10n.exchangeStageCompleted,
  CaseStatus.rejected => l10n.exchangeStatusRejected,
  CaseStatus.cancelled => l10n.exchangeStatusCancelled,
  CaseStatus.expired => l10n.exchangeStatusExpired,
};

StatusTone caseStatusTone(ExchangeCase exchange) => switch (exchange.status) {
  CaseStatus.completed => StatusTone.success,
  CaseStatus.rejected => StatusTone.danger,
  CaseStatus.cancelled || CaseStatus.expired => StatusTone.neutral,
  _ => exchange.needsStaff ? StatusTone.warning : StatusTone.info,
};

String? caseStepGuide(AppL10n l10n, CaseStep step) => switch (step) {
  CaseStep.review => l10n.exchangeDeskGuideReview,
  CaseStep.startReturn => l10n.exchangeDeskGuideStartReturn,
  CaseStep.finishReturn => l10n.exchangeDeskReturnHint,
  CaseStep.chooseScooter => l10n.exchangeDeskGuideChoose,
  CaseStep.sendOffer => l10n.exchangeDeskGuideSendOffer,
  CaseStep.awaitRider => l10n.exchangeDeskWaitingRider,
  CaseStep.settleDeposits => l10n.exchangeDeskGuideDeposits,
  CaseStep.startHandover => l10n.exchangeDeskGuideStartHandover,
  CaseStep.finishHandover => l10n.exchangeDeskHandoverHint,
  CaseStep.none => null,
};

String caseReasonLabel(AppL10n l10n, String code) => switch (code) {
  'VEHICLE_BREAKDOWN' => l10n.exchangeReasonBreakdown,
  'VEHICLE_UNSAFE' => l10n.exchangeReasonUnsafe,
  'SAFETY_EXCHANGE' => l10n.exchangeReasonSafety,
  'UPGRADE' => l10n.exchangeReasonUpgrade,
  _ => l10n.commonOther,
};

String caseRent(AppL10n l10n, num amount, String? period) {
  final String? suffix = switch (period) {
    'DAILY' => l10n.exchangePerDay,
    'WEEKLY' => l10n.exchangePerWeek,
    'FORTNIGHTLY' => l10n.exchangePerFortnight,
    'MONTHLY' => l10n.exchangePerMonth,
    'QUARTERLY' => l10n.exchangePerQuarter,
    _ => null,
  };
  return [Fmt.money(amount), ?suffix].join(' ');
}

class ExchangeCaseTile extends StatelessWidget {
  const ExchangeCaseTile({required this.exchange, required this.onOpen, super.key});

  final ExchangeCase exchange;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final String? scooter = exchange.oldScooter?.number;
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        tint: exchange.needsStaff ? AppColors.primaryWash : null,
        borderColor: exchange.needsStaff ? AppColors.primary.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(name: exchange.riderName, size: 40),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exchange.riderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [caseReasonLabel(context.l10n, exchange.reasonCode), ?scooter].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: Insets.md),
            Row(
              children: [
                StatusChip(
                  label: caseStatusLabel(context.l10n, exchange),
                  tone: caseStatusTone(exchange),
                  icon: exchange.needsStaff ? Icons.touch_app_rounded : null,
                  dense: true,
                ),
                const Spacer(),
                Text(
                  Fmt.relative(exchange.createdAt),
                  style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CaseQuoteView extends StatelessWidget {
  const CaseQuoteView({required this.quote, super.key});

  final CaseQuote quote;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? scooter = quote.scooterName;
    final DateTime? rentFrom = quote.newRentFrom;
    return Column(
      children: [
        if (scooter != null)
          KeyValueRow(label: l10n.exchangeNewScooter, value: scooter, icon: Icons.electric_scooter_rounded),
        KeyValueRow(
          label: l10n.exchangeNewRent,
          value: caseRent(l10n, quote.newRent, quote.period),
          icon: Icons.receipt_long_rounded,
        ),
        if (quote.rentAdjustment > 0)
          KeyValueRow(
            label: l10n.exchangeExtraRentNow,
            value: Fmt.money(quote.rentAdjustment),
            icon: Icons.add_circle_outline_rounded,
          )
        else if (quote.rentAdjustment < 0)
          KeyValueRow(
            label: l10n.exchangeRentCredit,
            value: Fmt.money(-quote.rentAdjustment),
            icon: Icons.remove_circle_outline_rounded,
          ),
        if (rentFrom != null)
          KeyValueRow(label: l10n.exchangeNewRentFrom, value: Fmt.date(rentFrom), icon: Icons.event_rounded),
        if (quote.depositMoved > 0)
          KeyValueRow(
            label: l10n.exchangeDepositMoved,
            value: Fmt.money(quote.depositMoved),
            icon: Icons.sync_alt_rounded,
          ),
        if (quote.depositToPay > 0)
          KeyValueRow(
            label: l10n.exchangeDepositToPay,
            value: Fmt.money(quote.depositToPay),
            icon: Icons.savings_rounded,
            valueColor: AppColors.danger,
          ),
        if (quote.depositExcess > 0)
          KeyValueRow(
            label: quote.refundsExcess ? l10n.exchangeDepositRefund : l10n.exchangeDepositHeld,
            value: Fmt.money(quote.depositExcess),
            icon: Icons.savings_rounded,
          ),
        if (quote.feeWaived)
          KeyValueRow(
            label: l10n.exchangeFee,
            value: l10n.exchangeFeeWaived,
            icon: Icons.local_offer_rounded,
            valueColor: AppColors.success,
          )
        else if (quote.fee > 0)
          KeyValueRow(label: l10n.exchangeFee, value: Fmt.money(quote.fee), icon: Icons.local_offer_rounded),
      ],
    );
  }
}
