import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/damage_charge.dart';
import '../providers/damage_charges_providers.dart';
import '../widgets/damage_charge_widgets.dart';
import '../widgets/damage_pay_action.dart';

class DamageChargePage extends ConsumerWidget {
  const DamageChargePage({required this.chargeId, super.key});

  final String chargeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DamageCharge> detail = ref.watch(damageChargeProvider(chargeId));
    final DamageCharge? charge = detail.value;

    if (charge == null) {
      return AppScaffold(
        title: context.l10n.damageChargeTitle,
        body: detail.hasError
            ? EmptyState(
                title: context.l10n.damageChargeCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(damageChargeProvider(chargeId)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 200, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 220, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    return HeroScaffold(
      bottomPadding: charge.isOpen ? 120 : Insets.x4l,
      onRefresh: () async {
        ref.invalidate(damageChargesSummaryProvider);
        await ref.refreshQuietly(damageChargeProvider(chargeId));
      },
      band: _Band(charge: charge),
      bottomNavigationBar: charge.isOpen
          ? Container(
              padding: EdgeInsets.fromLTRB(
                Insets.gutter,
                Insets.md,
                Insets.gutter,
                MediaQuery.paddingOf(context).bottom + Insets.md,
              ),
              decoration: const BoxDecoration(
                color: AppColors.canvas,
                border: Border(top: BorderSide(color: AppColors.stroke)),
              ),
              child: DamagePayAction(charge: charge),
            )
          : null,
      children: [
        _Lines(charge: charge),
        if (charge.state == DamageChargeState.paid) ...[
          const Gap.xl(),
          ArtBlock(
            art: BrandArt.success,
            artSize: 120,
            title: context.l10n.damageChargePaidTitle,
            message: context.l10n.damageChargePaidBody,
          ),
        ] else if (charge.state == DamageChargeState.cancelled) ...[
          const Gap.lg(),
          AccentCard(
            accent: AppColors.textMuted,
            child: Text(
              context.l10n.damageChargeCancelledBody,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            ),
          ),
        ],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final (String label, StatusTone tone) = damageChargeStatus(l10n, charge.state);
    final bool open = charge.isOpen;
    final DateTime? raisedAt = charge.raisedAt;
    final bool breakdown = open ? charge.paid > 0 || charge.credit > 0 : charge.credit > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            const Spacer(),
            StatusChip(
              label: label,
              tone: tone,
              icon: switch (charge.state) {
                DamageChargeState.unpaid => Icons.schedule_rounded,
                DamageChargeState.partlyPaid => Icons.timelapse_rounded,
                DamageChargeState.paid => Icons.verified_rounded,
                DamageChargeState.cancelled => Icons.block_rounded,
              },
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Text(
          open ? l10n.damageChargeAmountToPay : l10n.damageChargeTotal,
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          Fmt.money(open ? charge.due : charge.total, paise: true),
          style: AppText.numericLarge.copyWith(color: AppColors.onInk),
        ),
        if (raisedAt != null) ...[
          const SizedBox(height: 4),
          Text(
            '${l10n.damageChargeTitle} · ${l10n.damageChargeRaisedOn(Fmt.date(raisedAt))}',
            style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.onInkMuted),
          ),
        ],
        if (breakdown) ...[
          const Gap.lg(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: Corners.brMd,
              border: Border.all(color: AppColors.inkStroke),
            ),
            child: Row(
              children: [
                if (open) ...[
                  Expanded(
                    child: InkStat(
                      label: l10n.damageChargeTotal,
                      value: Fmt.money(charge.total, paise: true),
                      icon: Icons.receipt_long_rounded,
                    ),
                  ),
                  const InkDivider(),
                  const SizedBox(width: Insets.md),
                ],
                if (charge.paid > 0)
                  Expanded(
                    child: InkStat(
                      label: l10n.damageChargePaidSoFar,
                      value: Fmt.money(charge.paid, paise: true),
                      icon: Icons.check_circle_rounded,
                    ),
                  ),
                if (charge.paid > 0 && charge.credit > 0) ...[const InkDivider(), const SizedBox(width: Insets.md)],
                if (charge.credit > 0)
                  Expanded(
                    child: InkStat(
                      label: l10n.damageChargeCreditUsed,
                      value: Fmt.money(charge.credit, paise: true),
                      icon: Icons.savings_rounded,
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (charge.summary.isNotEmpty) ...[
          const Gap.lg(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Insets.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: Corners.brMd,
              border: Border.all(color: AppColors.inkStroke),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.engineering_rounded, size: 18, color: AppColors.onInkSecondary),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charge.finalCheck ? l10n.checkInDeepReport : l10n.checkInBasicReport,
                        style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.onInkMuted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        charge.summary,
                        style: AppText.bodySmall.copyWith(fontSize: 13, height: 1.45, color: AppColors.onInk),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Lines extends StatelessWidget {
  const _Lines({required this.charge});

  final DamageCharge charge;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? submissionId = charge.submissionId;
    return ModuleCard(
      title: l10n.damageChargeWhatWasCharged,
      leading: const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (charge.lines.isEmpty)
            Text(l10n.checkInNoCharges, style: AppText.bodySmall.copyWith(fontSize: 12.5))
          else ...[
            for (final (int i, DamageChargeLine line) in charge.lines.indexed) ...[
              if (i > 0) Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Insets.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconTile(icon: Icons.build_rounded, tone: AppColors.danger, size: 36),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  line.quantity > 1 ? '${line.name} × ${line.quantity}' : line.name,
                                  style: AppText.titleSmall.copyWith(fontSize: 13.5, height: 1.35),
                                ),
                              ),
                              const SizedBox(width: Insets.sm),
                              Text(
                                Fmt.money(line.amount, paise: true),
                                style: AppText.titleSmall.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          if (line.quantity > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              l10n.damageChargeEach(Fmt.money(line.unitAmount, paise: true)),
                              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                          if (line.note.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(line.note, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.4)),
                          ],
                          if (submissionId != null && line.photoIds.isNotEmpty) ...[
                            const Gap.sm(),
                            Wrap(
                              spacing: Insets.sm,
                              runSpacing: Insets.sm,
                              children: [
                                for (final String photoId in line.photoIds)
                                  DamagePhotoThumb(submissionId: submissionId, photoId: photoId, size: 72),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              margin: const EdgeInsets.only(top: Insets.xs),
              padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
              decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brMd),
              child: Row(
                children: [
                  Expanded(child: Text(l10n.damageChargeTotal, style: AppText.titleSmall.copyWith(fontSize: 14))),
                  Text(
                    Fmt.money(charge.total, paise: true),
                    style: AppText.titleSmall.copyWith(fontSize: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
