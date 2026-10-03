import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/exchange_request.dart';

String exchangeStageLabel(AppL10n l10n, ExchangeStage stage) => switch (stage) {
  ExchangeStage.requested => l10n.exchangeStageRequested,
  ExchangeStage.inReview => l10n.exchangeStageInReview,
  ExchangeStage.offerReady => l10n.exchangeStageOfferReady,
  ExchangeStage.accepted => l10n.exchangeStageAccepted,
  ExchangeStage.awaitingHandover => l10n.exchangeStageHandover,
  ExchangeStage.completed => l10n.exchangeStageCompleted,
  ExchangeStage.closed => l10n.exchangeStageClosed,
};

StatusTone exchangeStageTone(ExchangeStage stage) => switch (stage) {
  ExchangeStage.offerReady => StatusTone.warning,
  ExchangeStage.completed => StatusTone.success,
  ExchangeStage.closed => StatusTone.neutral,
  _ => StatusTone.info,
};

String exchangeReasonLabel(AppL10n l10n, String code) => switch (code) {
  'VEHICLE_BREAKDOWN' => l10n.exchangeReasonBreakdown,
  'VEHICLE_UNSAFE' => l10n.exchangeReasonUnsafe,
  'SAFETY_EXCHANGE' => l10n.exchangeReasonSafety,
  'UPGRADE' => l10n.exchangeReasonUpgrade,
  _ => l10n.commonOther,
};

class ExchangeTile extends StatelessWidget {
  const ExchangeTile({required this.request, required this.onOpen, super.key});

  final ExchangeRequest request;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        tint: request.stage.needsRider ? AppColors.primaryWash : null,
        borderColor: request.stage.needsRider ? AppColors.primary.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const IconTile(icon: Icons.swap_horiz_rounded, tone: AppColors.primary, solid: true, size: 40),
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
                  label: exchangeStageLabel(context.l10n, request.stage),
                  tone: exchangeStageTone(request.stage),
                  icon: request.stage.needsRider ? Icons.touch_app_rounded : null,
                  dense: true,
                ),
                if (request.stage.needsRider)
                  Text(
                    context.l10n.exchangeNeedsYou,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.primary),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExchangeOfferCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.exchangeOfferTitle,
      leading: const IconTile(icon: Icons.local_offer_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer.termsTitle, style: AppText.titleSmall.copyWith(fontSize: 14)),
          const Gap.sm(),
          if (offer.rentDifference != null)
            KeyValueRow(
              label: context.l10n.exchangeRentChange,
              value: Fmt.money(offer.rentDifference!),
              icon: Icons.receipt_long_rounded,
              valueColor: offer.rentDifference! > 0 ? AppColors.danger : AppColors.mint,
            ),
          if (offer.depositDifference != null)
            KeyValueRow(
              label: context.l10n.exchangeDepositChange,
              value: Fmt.money(offer.depositDifference!),
              icon: Icons.savings_rounded,
              valueColor: offer.depositDifference! > 0 ? AppColors.danger : AppColors.mint,
            ),
          KeyValueRow(
            label: context.l10n.exchangeOfferExpires,
            value: Fmt.dateTime(offer.expiresAt),
            icon: Icons.schedule_rounded,
            valueColor: offer.hasExpired ? AppColors.danger : null,
          ),
          const Gap.md(),
          GhostButton(
            label: context.l10n.exchangeReadTerms,
            icon: Icons.description_rounded,
            onPressed: () => _openTerms(context),
          ),
          const Gap.lg(),
          if (offer.hasExpired)
            AccentCard(
              accent: AppColors.danger,
              child: Text(
                context.l10n.exchangeOfferExpiredMessage,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
              ),
            )
          else ...[
            PrimaryButton(
              label: context.l10n.exchangeAcceptOffer,
              icon: Icons.check_circle_rounded,
              loading: busy,
              onPressed: busy ? null : onAccept,
            ),
            const Gap.md(),
            SecondaryButton(
              label: context.l10n.exchangeRejectOffer,
              icon: Icons.close_rounded,
              onPressed: busy ? null : onReject,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openTerms(BuildContext context) => AppSheet.show<void>(
    context,
    title: offer.termsTitle,
    subtitle: offer.termsVersion,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Text(offer.termsBody, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.55)),
    ),
  );
}
