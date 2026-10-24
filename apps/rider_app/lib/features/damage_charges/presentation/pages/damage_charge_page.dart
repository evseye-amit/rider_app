import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';

class DamageChargePage extends ConsumerWidget {
  const DamageChargePage({required this.chargeId, super.key});

  final String chargeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DamageCharge> detail = ref.watch(damageChargeProvider(chargeId));
    final DamageCharge? charge = detail.value;
    final DateTime? raisedAt = charge?.raisedAt;

    return AppScaffold(
      title: context.l10n.damageChargeTitle,
      subtitle: raisedAt == null ? null : context.l10n.damageChargeRaisedOn(Fmt.date(raisedAt)),
      body: switch (charge) {
        final DamageCharge value => RefreshIndicator(
          onRefresh: () => ref.refreshQuietly(damageChargeProvider(chargeId)),
          color: AppColors.primary,
          child: PageBody(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _Bill(charge: value),
              const Gap.lg(),
              if (value.state == DamageChargeState.paid) ...[
                ArtBlock(
                  art: BrandArt.success,
                  artSize: 120,
                  title: context.l10n.damageChargePaidTitle,
                  message: context.l10n.damageChargePaidBody,
                ),
                const Gap.lg(),
              ] else if (value.state == DamageChargeState.cancelled) ...[
                AccentCard(
                  accent: AppColors.textMuted,
                  child: Text(
                    context.l10n.damageChargeCancelledBody,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                  ),
                ),
                const Gap.lg(),
              ],
              _Lines(charge: value),
              if (value.summary.isNotEmpty) ...[const Gap.lg(), _Report(charge: value)],
            ],
          ),
        ),
        null when detail.hasError => EmptyState(
          title: context.l10n.damageChargeCouldNotLoad,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(damageChargeProvider(chargeId)),
        ),
        null => const PageBody(
          children: [
            ShimmerBox(height: 200, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 220, borderRadius: Corners.brXl),
          ],
        ),
      },
    );
  }
}

class _Bill extends StatelessWidget {
  const _Bill({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    final (String label, StatusTone tone) = damageChargeStatus(context.l10n, charge.state);
    return ModuleCard(
      title: context.l10n.damageChargeAmountToPay,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  Fmt.money(charge.due, paise: true),
                  style: AppText.numericLarge.copyWith(color: charge.isOpen ? AppColors.primary : AppColors.success),
                ),
              ),
              StatusChip(label: label, tone: tone, dense: true),
            ],
          ),
          const Gap.md(),
          KeyValueRow(label: context.l10n.damageChargeTotal, value: Fmt.money(charge.total, paise: true)),
          if (charge.paid > 0)
            KeyValueRow(label: context.l10n.damageChargePaidSoFar, value: Fmt.money(charge.paid, paise: true)),
          if (charge.credit > 0)
            KeyValueRow(label: context.l10n.damageChargeCreditUsed, value: Fmt.money(charge.credit, paise: true)),
          const Divider(),
          KeyValueRow(
            label: context.l10n.damageChargeLeftToPay,
            value: Fmt.money(charge.due, paise: true),
            valueStyle: AppText.titleSmall,
          ),
        ],
      ),
    );
  }
}

class _Lines extends StatelessWidget {
  const _Lines({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    final String? submissionId = charge.submissionId;
    return ModuleCard(
      title: context.l10n.damageChargeWhatWasCharged,
      leading: const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (charge.lines.isEmpty)
            Text(context.l10n.checkInNoCharges, style: AppText.bodySmall.copyWith(fontSize: 12.5)),
          for (final (int i, DamageChargeLine line) in charge.lines.indexed) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.quantity > 1 ? '${line.name} × ${line.quantity}' : line.name,
                              style: AppText.titleSmall.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              context.l10n.damageChargeEach(Fmt.money(line.unitAmount, paise: true)),
                              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                            ),
                            if (line.note.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(line.note, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      Text(Fmt.money(line.amount, paise: true), style: AppText.titleSmall.copyWith(fontSize: 14)),
                    ],
                  ),
                  if (submissionId != null && line.photoIds.isNotEmpty) ...[
                    const Gap.sm(),
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: [
                        for (final String photoId in line.photoIds)
                          DamagePhotoThumb(submissionId: submissionId, photoId: photoId),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (i != charge.lines.length - 1) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          ],
        ],
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: charge.finalCheck ? context.l10n.checkInDeepReport : context.l10n.checkInBasicReport,
      leading: const IconTile(icon: Icons.engineering_rounded, solid: true, size: 28),
      child: Text(charge.summary, style: AppText.bodySmall.copyWith(fontSize: 13, height: 1.5)),
    );
  }
}
