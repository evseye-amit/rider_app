import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

enum StatusTone { neutral, success, warning, danger, info, brand }

extension StatusToneX on StatusTone {
  Color get color => switch (this) {
        StatusTone.neutral => AppColors.textSecondary,
        StatusTone.success => AppColors.success,
        StatusTone.warning => AppColors.warning,
        StatusTone.danger => AppColors.danger,
        StatusTone.info => AppColors.primary,

        StatusTone.brand => AppColors.primary,
      };
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    this.showDot = true,
    this.dense = false,
    this.solid = false,
    super.key,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool showDot;
  final bool dense;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final Color c = tone.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? Insets.sm : Insets.md,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: solid
            ? c
            : tone == StatusTone.neutral
                ? AppColors.surfaceMuted
                : AppColors.washFor(c),
        borderRadius: Corners.pill,
        border: Border.all(
          color: solid ? Colors.transparent : c.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 11 : 13, color: solid ? Colors.white : c),
            const SizedBox(width: Insets.xs + 2),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: solid ? Colors.white : c,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: Insets.sm - 1),
          ],
          Text(
            label,
            style: AppText.bodySmall.copyWith(
              color: solid ? Colors.white : c,
              fontWeight: FontWeight.w700,
              fontSize: dense ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    required this.icon,
    required this.value,
    this.label,
    this.color = AppColors.primary,
    super.key,
  });

  final IconData icon;
  final String value;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: Corners.pill,
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: Insets.sm - 2),
          Text(value, style: AppText.numericSmall.copyWith(fontSize: 14)),
          if (label != null) ...[
            const SizedBox(width: 3),
            Text(label!, style: AppText.bodySmall.copyWith(fontSize: 11)),
          ],
        ],
      ),
    );
  }
}
