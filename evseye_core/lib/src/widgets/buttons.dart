import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

enum AppButtonSize { small, medium, large }

extension on AppButtonSize {
  double get height => switch (this) {
        AppButtonSize.small => 40,
        AppButtonSize.medium => 50,
        AppButtonSize.large => 58,
      };

  double get fontSize => switch (this) {
        AppButtonSize.small => 13.5,
        AppButtonSize.medium => 15,
        AppButtonSize.large => 16,
      };

  EdgeInsets get padding => switch (this) {
        AppButtonSize.small => const EdgeInsets.symmetric(horizontal: Insets.lg),
        AppButtonSize.medium => const EdgeInsets.symmetric(horizontal: Insets.xl),
        AppButtonSize.large => const EdgeInsets.symmetric(horizontal: Insets.xxl),
      };
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.loading = false,
    this.expand = true,
    this.size = AppButtonSize.large,
    this.fillColor,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool loading;
  final bool expand;
  final AppButtonSize size;

  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || loading;
    final Color fill = fillColor ?? AppColors.primary;

    return Pressable(
      enabled: !disabled,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: Motion.fast,
        height: size.height,
        width: expand ? double.infinity : null,
        padding: size.padding,
        decoration: BoxDecoration(
          color: disabled ? AppColors.surfaceSunken : fill,
          borderRadius: Corners.pill,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: Motion.fast,
            child: loading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 19, color: _ink(disabled)),
                        const SizedBox(width: Insets.sm + 2),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.button.copyWith(
                            fontSize: size.fontSize,
                            color: _ink(disabled),
                          ),
                        ),
                      ),
                      if (trailingIcon != null) ...[
                        const SizedBox(width: Insets.sm + 2),
                        Icon(trailingIcon, size: 19, color: _ink(disabled)),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  static Color _ink(bool disabled) => disabled ? AppColors.textMuted : Colors.white;
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
    this.size = AppButtonSize.large,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final AppButtonSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? AppColors.textPrimary;
    final bool disabled = onPressed == null;

    return Pressable(
      enabled: !disabled,
      onTap: onPressed,
      child: Container(
        height: size.height,
        width: expand ? double.infinity : null,
        padding: size.padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: color ?? AppColors.strokeStrong, width: 1.2),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19, color: c),
                const SizedBox(width: Insets.sm + 2),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.button.copyWith(fontSize: size.fontSize, color: c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    this.dense = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? AppColors.primary;
    return Pressable(
      enabled: onPressed != null,
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? Insets.sm : Insets.md,
          vertical: dense ? Insets.xs : Insets.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 17, color: c),
              const SizedBox(width: Insets.xs + 2),
            ],
            Text(label, style: AppText.titleSmall.copyWith(color: c)),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    required this.icon,
    this.onTap,
    this.size = 42,
    this.iconSize = 20,
    this.background,
    this.foreground,
    this.badgeCount = 0,
    this.borderColor,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color? background;
  final Color? foreground;
  final int badgeCount;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.9,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background ?? AppColors.surfaceMuted,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor ?? AppColors.stroke),
            ),
            child: Icon(icon, size: iconSize, color: foreground ?? AppColors.textPrimary),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(minWidth: 18),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: Corners.pill,
                  border: Border.all(color: AppColors.canvas, width: 1.6),
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  textAlign: TextAlign.center,
                  style: AppText.bodySmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
