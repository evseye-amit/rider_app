import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.accent = AppColors.primary,
    this.caption,
    this.delta,
    this.deltaPositive = true,
    this.onTap,
    this.compact = false,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color accent;
  final String? caption;
  final String? delta;
  final bool deltaPositive;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.975,
      child: Container(
        padding: EdgeInsets.all(compact ? Insets.sm + 3 : Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(color: AppColors.stroke),
          boxShadow: Shadows.card,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null)
                  Container(
                    width: compact ? 26 : 34,
                    height: compact ? 26 : 34,
                    decoration: BoxDecoration(
                      color: AppColors.washFor(accent),
                      borderRadius: Corners.brSm,
                    ),
                    child: Icon(icon, size: compact ? 15 : 18, color: accent),
                  ),
                const Spacer(),
                if (delta != null)
                  Row(
                    children: [
                      Icon(
                        deltaPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 13,
                        color: deltaPositive ? AppColors.success : AppColors.danger,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        delta!,
                        style: AppText.bodySmall.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: deltaPositive ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(height: compact ? Insets.sm : Insets.lg),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppText.numeric.copyWith(fontSize: compact ? 21 : 25),
              ),
            ),
            const SizedBox(height: Insets.xs),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            if (caption != null)
              Text(
                caption!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}

class HeroStatCard extends StatelessWidget {
  const HeroStatCard({
    required this.label,
    required this.value,
    this.caption,
    this.icon,
    this.gradient,
    this.trailing,
    this.onTap,
    this.footer,
    super.key,
  });

  final String label;
  final String value;
  final String? caption;
  final IconData? icon;
  final Gradient? gradient;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.985,
      child: Container(
        padding: const EdgeInsets.all(Insets.xl),
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? AppColors.primaryWash : null,
          borderRadius: Corners.brXl,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: Corners.brSm,
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
                    ),
                    child: Icon(icon, size: 19, color: AppColors.primary),
                  ),
                  const SizedBox(width: Insets.md),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: AppText.label.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: Insets.lg),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: AppText.numericLarge),
            ),
            if (caption != null) ...[
              const SizedBox(height: Insets.sm - 2),
              Text(
                caption!,
                style: AppText.bodySmall,
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: Insets.lg),
              Divider(color: AppColors.primary.withValues(alpha: 0.14), height: 1),
              const SizedBox(height: Insets.md),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class KeyValueRow extends StatelessWidget {
  const KeyValueRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
    this.valueStyle,
    this.dense = false,
    this.trailing,
    super.key,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;
  final TextStyle? valueStyle;
  final bool dense;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? Insets.xs + 1 : Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: AppColors.textMuted),
            const SizedBox(width: Insets.sm),
          ],
          Expanded(
            flex: 4,
            child: Text(label, style: AppText.bodySmall.copyWith(fontSize: 13)),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: valueStyle ??
                  AppText.bodyMedium.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: Insets.sm), trailing!],
        ],
      ),
    );
  }
}
