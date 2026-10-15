import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/return_case.dart';

const String checklistPhotoType = 'RETURN_CHECKLIST';
const String damagePhotoPrefix = 'DAMAGE_';

class ReturnStageStyle {
  const ReturnStageStyle._(this.label, this.tone, this.icon, {this.needsAction = false});

  factory ReturnStageStyle.of(AppL10n l10n, ReturnCase item) {
    if (item.state == ReturnState.cancelled) {
      return ReturnStageStyle._(l10n.returnsStatusCancelled, StatusTone.neutral, Icons.cancel_outlined);
    }
    if (item.state == ReturnState.requested) {
      return ReturnStageStyle._(
        l10n.returnDeskStageAwaiting,
        StatusTone.info,
        Icons.event_available_rounded,
        needsAction: true,
      );
    }
    return switch (item.penalty?.stage) {
      null when !item.inspectionDone => ReturnStageStyle._(
        l10n.returnDeskStageInspect,
        StatusTone.warning,
        Icons.fact_check_rounded,
        needsAction: true,
      ),
      null || PenaltyStage.draft => ReturnStageStyle._(
        l10n.returnDeskStageCharges,
        StatusTone.warning,
        Icons.receipt_long_rounded,
        needsAction: true,
      ),
      PenaltyStage.awaitingRider => ReturnStageStyle._(
        l10n.returnDeskStageWithRider,
        StatusTone.info,
        Icons.hourglass_top_rounded,
      ),
      PenaltyStage.awaitingManager => ReturnStageStyle._(
        l10n.returnDeskStageApproval,
        StatusTone.warning,
        Icons.verified_user_rounded,
        needsAction: true,
      ),
      PenaltyStage.disputed => ReturnStageStyle._(
        l10n.returnsStatusDisputed,
        StatusTone.danger,
        Icons.gavel_rounded,
        needsAction: true,
      ),
      PenaltyStage.posted => ReturnStageStyle._(
        l10n.returnsStatusClosed,
        StatusTone.success,
        Icons.check_circle_rounded,
      ),
    };
  }

  final String label;
  final StatusTone tone;
  final IconData icon;
  final bool needsAction;
}

String photoTypeLabel(AppL10n l10n, String photoType, {List<InspectionSlot> slots = const []}) {
  if (photoType == checklistPhotoType) return l10n.returnDeskChecklistPhoto;
  if (photoType.startsWith(damagePhotoPrefix)) return l10n.returnDeskDamagePhoto;
  final InspectionSlot? slot = slots.where((slot) => slot.photoType == photoType).firstOrNull;
  if (slot != null) return slot.label;
  final String spaced = photoType.replaceAll('_', ' ').toLowerCase();
  return spaced.isEmpty ? photoType : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}

class ReturnCaseTile extends StatelessWidget {
  const ReturnCaseTile({required this.item, required this.hubName, required this.onOpen, super.key});

  final ReturnCase item;
  final String? hubName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final ReturnStageStyle style = ReturnStageStyle.of(context.l10n, item);
    final String when = item.receivedAt == null
        ? context.l10n.returnsPlannedFor(Fmt.date(item.plannedDate))
        : context.l10n.returnDeskReceivedOn(Fmt.date(item.receivedAt!));
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        tint: style.needsAction ? AppColors.primaryWash : null,
        borderColor: style.needsAction ? AppColors.primary.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(name: item.riderName, size: 40),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.riderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [returnReasonLabel(context.l10n, item.reasonCode), ?hubName].join(' · '),
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
                  label: style.label,
                  tone: style.tone,
                  icon: style.needsAction ? Icons.touch_app_rounded : null,
                  dense: true,
                ),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    when,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PenaltyLineRow extends StatelessWidget {
  const PenaltyLineRow({required this.line, this.onTap, this.onRemove, super.key});

  final PenaltyLine line;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final num? amount = line.amount;
    final bool missing = line.kind == PenaltyKind.missingItem;
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: missing ? Icons.inventory_2_rounded : Icons.car_crash_rounded,
            tone: missing ? AppColors.amber : AppColors.danger,
            size: 34,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.description ?? '—', style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                if (line.details.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(line.details, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4)),
                ],
                const SizedBox(height: 4),
                Text(
                  [
                    missing ? context.l10n.returnsKindMissing : context.l10n.returnsKindDamage,
                    context.l10n.returnsEvidenceCount(line.evidencePhotoIds.length),
                  ].join(' · '),
                  style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (amount != null) ...[
            const SizedBox(width: Insets.sm),
            Text(Fmt.money(amount, paise: true), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
          ],
          if (onRemove != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
              onPressed: onRemove,
            ),
        ],
      ),
    );
    return onTap == null ? row : Pressable(onTap: onTap, scale: 0.99, child: row);
  }
}

class ChargesTotal extends StatelessWidget {
  const ChargesTotal({required this.total, super.key});

  final num total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brMd),
      child: Row(
        children: [
          Expanded(child: Text(context.l10n.commonTotal, style: AppText.titleSmall)),
          Text(Fmt.money(total, paise: true), style: AppText.numeric.copyWith(fontSize: 17)),
        ],
      ),
    );
  }
}
