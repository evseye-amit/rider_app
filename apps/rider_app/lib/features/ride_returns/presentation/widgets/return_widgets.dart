import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/ride_return.dart';

class ReturnStatusStyle {
  const ReturnStatusStyle._(this.label, this.tone, this.icon);

  factory ReturnStatusStyle.of(AppL10n l10n, RideReturn item) {
    if (item.status == ReturnStatus.cancelled) {
      return ReturnStatusStyle._(l10n.returnsStatusCancelled, StatusTone.neutral, Icons.cancel_outlined);
    }
    return switch (item.checkIn) {
      CheckInStage.none when item.status == ReturnStatus.returned => ReturnStatusStyle._(
        l10n.returnsStatusClosed,
        StatusTone.success,
        Icons.check_circle_rounded,
      ),
      CheckInStage.none => ReturnStatusStyle._(
        l10n.returnsStatusRequested,
        StatusTone.info,
        Icons.event_available_rounded,
      ),
      CheckInStage.inProgress => ReturnStatusStyle._(
        l10n.returnsStatusCheckingIn,
        StatusTone.warning,
        Icons.fact_check_rounded,
      ),
      CheckInStage.finalChecks => ReturnStatusStyle._(
        l10n.returnsStatusFinalChecks,
        StatusTone.info,
        Icons.build_circle_rounded,
      ),
      CheckInStage.done => ReturnStatusStyle._(
        l10n.returnsStatusClosed,
        StatusTone.success,
        Icons.check_circle_rounded,
      ),
    };
  }

  final String label;
  final StatusTone tone;
  final IconData icon;
}

class ReturnTile extends StatelessWidget {
  const ReturnTile({required this.item, required this.onOpen, super.key});

  final RideReturn item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final ReturnStatusStyle style = ReturnStatusStyle.of(context.l10n, item);
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Row(
          children: [
            IconTile(icon: style.icon, tone: style.tone.color, size: 42),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    returnReasonLabel(context.l10n, item.reasonCode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.returnsPlannedFor(Fmt.date(item.plannedDate)),
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: Insets.sm),
                  StatusChip(label: style.label, tone: style.tone, dense: true),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class ReturnTimeline extends StatelessWidget {
  const ReturnTimeline({required this.item, super.key});

  final RideReturn item;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? receivedAt = item.receivedAt;
    final CheckInStage stage = item.checkIn;
    final bool confirmed = stage == CheckInStage.finalChecks || stage == CheckInStage.done;
    final bool closed = stage == CheckInStage.done;
    final List<(String, bool, bool, String?)> steps = [
      (l10n.returnsStepRequested, true, false, Fmt.date(item.createdAt)),
      (l10n.returnsStepCheckIn, confirmed, !confirmed, receivedAt == null ? null : Fmt.date(receivedAt)),
      (l10n.returnsStepFinalChecks, closed, confirmed && !closed, null),
      (l10n.returnsStepClosed, closed, false, null),
    ];
    return ModuleCard(
      title: context.l10n.returnsProgress,
      leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (final (int i, (String title, bool done, bool current, String? time)) in steps.indexed)
            TimelineRow(
              title: title,
              done: done,
              current: current,
              isLast: i == steps.length - 1,
              time: current ? null : time,
              currentLabel: context.l10n.commonNow,
            ),
        ],
      ),
    );
  }
}
