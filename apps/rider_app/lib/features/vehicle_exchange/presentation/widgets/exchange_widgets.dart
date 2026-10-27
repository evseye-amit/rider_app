import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/exchange_request.dart';
import '../../domain/entities/rental_agreement.dart';
import '../providers/exchange_provider.dart';

String exchangeStatusLabel(AppL10n l10n, ExchangeRequest request) => switch (request.status) {
  ExchangeStatus.requested => l10n.exchangeStageRequested,
  ExchangeStatus.approved => request.oldScooterReturned ? l10n.exchangeStatusChoosing : l10n.exchangeStatusApproved,
  ExchangeStatus.returnPending => request.isCheckingIn ? l10n.exchangeStatusCheckingIn : l10n.exchangeStatusReturn,
  ExchangeStatus.replacementSelected => l10n.exchangeStatusChoosing,
  ExchangeStatus.offerPresented => l10n.exchangeStageOfferReady,
  ExchangeStatus.depositPending => l10n.exchangeStageAccepted,
  ExchangeStatus.handoverPending => l10n.exchangeStageHandover,
  ExchangeStatus.completed => l10n.exchangeStageCompleted,
  ExchangeStatus.rejected => l10n.exchangeStatusRejected,
  ExchangeStatus.cancelled => l10n.exchangeStatusCancelled,
  ExchangeStatus.expired => l10n.exchangeStatusExpired,
};

StatusTone exchangeStatusTone(ExchangeStatus status) => switch (status) {
  ExchangeStatus.offerPresented || ExchangeStatus.returnPending || ExchangeStatus.handoverPending => StatusTone.warning,
  ExchangeStatus.completed => StatusTone.success,
  ExchangeStatus.rejected => StatusTone.danger,
  ExchangeStatus.cancelled || ExchangeStatus.expired => StatusTone.neutral,
  _ => StatusTone.info,
};

String exchangeReasonLabel(AppL10n l10n, String code) => switch (code) {
  'VEHICLE_BREAKDOWN' => l10n.exchangeReasonBreakdown,
  'VEHICLE_UNSAFE' => l10n.exchangeReasonUnsafe,
  'SAFETY_EXCHANGE' => l10n.exchangeReasonSafety,
  'UPGRADE' => l10n.exchangeReasonUpgrade,
  _ => l10n.commonOther,
};

String exchangeReasonHint(AppL10n l10n, ExchangeReason reason) => switch (reason) {
  ExchangeReason.breakdown => l10n.exchangeReasonBreakdownHint,
  ExchangeReason.unsafe => l10n.exchangeReasonUnsafeHint,
  ExchangeReason.safety => l10n.exchangeReasonSafetyHint,
  ExchangeReason.upgrade => l10n.exchangeReasonUpgradeHint,
  ExchangeReason.other => l10n.exchangeReasonOtherHint,
};

IconData exchangeReasonIcon(ExchangeReason reason) => switch (reason) {
  ExchangeReason.breakdown => Icons.car_repair_rounded,
  ExchangeReason.unsafe => Icons.warning_amber_rounded,
  ExchangeReason.safety => Icons.health_and_safety_rounded,
  ExchangeReason.upgrade => Icons.upgrade_rounded,
  ExchangeReason.other => Icons.more_horiz_rounded,
};

String rentWithPeriod(AppL10n l10n, num amount, RentPeriod? period) {
  final String? suffix = switch (period) {
    RentPeriod.daily => l10n.exchangePerDay,
    RentPeriod.weekly => l10n.exchangePerWeek,
    RentPeriod.fortnightly => l10n.exchangePerFortnight,
    RentPeriod.monthly => l10n.exchangePerMonth,
    RentPeriod.quarterly => l10n.exchangePerQuarter,
    RentPeriod.custom || null => null,
  };
  return [Fmt.money(amount), ?suffix].join(' ');
}

String _stepLabel(AppL10n l10n, ExchangeStep step) => switch (step) {
  ExchangeStep.requested => l10n.exchangeStepRequested,
  ExchangeStep.returnScooter => l10n.exchangeStepReturn,
  ExchangeStep.offer => l10n.exchangeStepOffer,
  ExchangeStep.deposit => l10n.exchangeStepDeposit,
  ExchangeStep.handover => l10n.exchangeStepHandover,
};

class ExchangeTile extends StatelessWidget {
  const ExchangeTile({required this.request, required this.onOpen, super.key});

  final ExchangeRequest request;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final bool highlight = request.needsRider;
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const IconTile(icon: Icons.swap_horiz_rounded, solid: true, size: 40),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exchangeReasonLabel(context.l10n, request.reasonCode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        Fmt.relative(request.createdAt),
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
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(
                  label: exchangeStatusLabel(context.l10n, request),
                  tone: exchangeStatusTone(request.status),
                  icon: highlight ? Icons.touch_app_rounded : null,
                  dense: true,
                ),
                if (highlight)
                  Text(
                    context.l10n.exchangeNeedsYou,
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

enum _StepState { done, current, stopped, upcoming }

class ExchangeTimeline extends StatelessWidget {
  const ExchangeTimeline({required this.request, super.key});

  final ExchangeRequest request;

  @override
  Widget build(BuildContext context) {
    final ExchangeStep? current = request.currentStep;
    return ModuleCard(
      title: context.l10n.exchangeProgress,
      leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (final ExchangeStep step in ExchangeStep.values)
            _TimelineRow(
              label: _stepLabel(context.l10n, step),
              state: request.isStepDone(step)
                  ? _StepState.done
                  : step == current
                  ? (request.status.isOpen ? _StepState.current : _StepState.stopped)
                  : _StepState.upcoming,
              last: step == ExchangeStep.values.last,
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.label, required this.state, required this.last});

  final String label;
  final _StepState state;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final Color tone = switch (state) {
      _StepState.done => AppColors.success,
      _StepState.current => AppColors.primary,
      _StepState.stopped => AppColors.danger,
      _StepState.upcoming => AppColors.strokeStrong,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: state == _StepState.upcoming ? AppColors.surface : tone,
                shape: BoxShape.circle,
                border: Border.all(color: tone, width: 2),
              ),
              child: switch (state) {
                _StepState.done => const Icon(Icons.check_rounded, size: 15, color: Colors.white),
                _StepState.stopped => const Icon(Icons.close_rounded, size: 15, color: Colors.white),
                _StepState.current => const Icon(Icons.more_horiz_rounded, size: 15, color: Colors.white),
                _StepState.upcoming => null,
              },
            ),
            if (!last)
              Container(width: 2, height: 22, color: state == _StepState.done ? AppColors.success : AppColors.stroke),
          ],
        ),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: AppText.bodyMedium.copyWith(
                fontWeight: state == _StepState.current ? FontWeight.w800 : FontWeight.w600,
                color: switch (state) {
                  _StepState.upcoming => AppColors.textMuted,
                  _StepState.current => AppColors.primaryInk,
                  _ => AppColors.textPrimary,
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuoteBreakdown extends StatelessWidget {
  const QuoteBreakdown({required this.quote, super.key});

  final ExchangeQuote quote;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? scooter = quote.scooterName;
    final String? hub = quote.hubName;
    final DateTime? rentFrom = quote.newRentFrom;
    return Column(
      children: [
        if (scooter != null)
          KeyValueRow(label: l10n.exchangeNewScooter, value: scooter, icon: Icons.electric_scooter_rounded),
        if (hub != null) KeyValueRow(label: l10n.profileHub, value: hub, icon: Icons.store_mall_directory_rounded),
        KeyValueRow(
          label: l10n.exchangeNewRent,
          value: rentWithPeriod(l10n, quote.newRent, quote.period),
          icon: Icons.receipt_long_rounded,
        ),
        if (quote.rentAdjustment > 0)
          KeyValueRow(
            label: l10n.exchangeExtraRentNow,
            value: Fmt.money(quote.rentAdjustment),
            icon: Icons.add_circle_outline_rounded,
            valueColor: AppColors.danger,
          )
        else if (quote.rentAdjustment < 0)
          KeyValueRow(
            label: l10n.exchangeRentCredit,
            value: Fmt.money(-quote.rentAdjustment),
            icon: Icons.remove_circle_outline_rounded,
            valueColor: AppColors.success,
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
            valueColor: quote.refundsExcess ? AppColors.success : null,
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

class ExchangeOfferCard extends StatefulWidget {
  const ExchangeOfferCard({
    required this.offer,
    required this.onAccept,
    required this.onReject,
    required this.busy,
    super.key,
  });

  final ExchangeOffer offer;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool busy;

  @override
  State<ExchangeOfferCard> createState() => _ExchangeOfferCardState();
}

class _ExchangeOfferCardState extends State<ExchangeOfferCard> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final ExchangeOffer offer = widget.offer;
    return ModuleCard(
      title: context.l10n.exchangeOfferTitle,
      leading: const IconTile(icon: Icons.local_offer_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuoteBreakdown(quote: offer.quote),
          KeyValueRow(
            label: context.l10n.exchangeOfferExpires,
            value: Fmt.dateTime(offer.expiresAt),
            icon: Icons.schedule_rounded,
            valueColor: offer.hasExpired ? AppColors.danger : null,
          ),
          const Gap.md(),
          if (offer.hasExpired)
            AccentCard(
              accent: AppColors.danger,
              child: Text(
                context.l10n.exchangeOfferExpiredMessage,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
              ),
            )
          else ...[
            AppCheckTile(
              value: _agreed,
              onChanged: (value) => setState(() => _agreed = value),
              title: context.l10n.exchangeConsent,
            ),
            const Gap.lg(),
            PrimaryButton(
              label: context.l10n.exchangeAcceptOffer,
              icon: Icons.check_circle_rounded,
              size: AppButtonSize.medium,
              loading: widget.busy,
              onPressed: _agreed && !widget.busy ? widget.onAccept : null,
            ),
            const Gap.md(),
            SecondaryButton(
              label: context.l10n.exchangeRejectOffer,
              icon: Icons.close_rounded,
              onPressed: widget.busy ? null : widget.onReject,
            ),
          ],
        ],
      ),
    );
  }
}

class AcceptedPlanCard extends StatelessWidget {
  const AcceptedPlanCard({required this.request, required this.offer, super.key});

  final ExchangeRequest request;
  final ExchangeOffer offer;

  @override
  Widget build(BuildContext context) {
    final bool depositDue = request.status == ExchangeStatus.depositPending && offer.quote.depositToPay > 0;
    return ModuleCard(
      title: context.l10n.exchangeAcceptedOfferTitle,
      leading: const IconTile(icon: Icons.verified_rounded, tone: AppColors.success, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuoteBreakdown(quote: offer.quote),
          if (depositDue) ...[
            const Gap.md(),
            AccentCard(
              accent: AppColors.warning,
              child: Text(
                context.l10n.exchangeDepositDue(Fmt.money(offer.quote.depositToPay)),
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AgreementHistoryCard extends ConsumerWidget {
  const AgreementHistoryCard({required this.agreementId, super.key});

  final String agreementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<AgreementRevision>? revisions = ref.watch(agreementHistoryProvider(agreementId)).value;
    if (revisions == null || revisions.isEmpty) return const SizedBox.shrink();
    return ModuleCard(
      title: context.l10n.exchangeAgreementHistory,
      leading: const IconTile(icon: Icons.history_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (int i = 0; i < revisions.length; i++) ...[
            if (i > 0) const Divider(height: Insets.xl),
            _RevisionRow(revision: revisions[i]),
          ],
        ],
      ),
    );
  }
}

class _RevisionRow extends StatelessWidget {
  const _RevisionRow({required this.revision});

  final AgreementRevision revision;

  @override
  Widget build(BuildContext context) {
    final String? scooter = revision.scooterName;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.exchangeVersionNumber('${revision.number}'), style: AppText.titleSmall),
              const SizedBox(height: 2),
              Text([?scooter, Fmt.money(revision.rent)].join(' · '), style: AppText.bodySmall.copyWith(fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                context.l10n.exchangeVersionFrom(Fmt.date(revision.effectiveFrom)),
                style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        StatusChip(
          label: switch (revision.state) {
            RevisionState.current => context.l10n.exchangeVersionCurrent,
            RevisionState.pending => context.l10n.commonPending,
            RevisionState.previous => context.l10n.exchangeVersionPrevious,
          },
          tone: switch (revision.state) {
            RevisionState.current => StatusTone.success,
            RevisionState.pending => StatusTone.warning,
            RevisionState.previous => StatusTone.neutral,
          },
          dense: true,
        ),
      ],
    );
  }
}
