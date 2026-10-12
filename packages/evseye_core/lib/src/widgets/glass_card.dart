import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'pressable.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.margin,
    this.borderRadius = Corners.brXl,
    this.onTap,
    this.blur = 0,
    this.tint,
    this.borderColor,
    this.shadows,
    this.gradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  final double blur;

  final Color? tint;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    Widget surface = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (tint ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: borderRadius,

        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: shadows ?? Shadows.card,
      ),
      child: child,
    );

    if (margin != null) surface = Padding(padding: margin!, child: surface);
    if (onTap != null) surface = Pressable(onTap: onTap, scale: 0.99, child: surface);
    return surface;
  }
}

class AccentCard extends StatelessWidget {
  const AccentCard({
    required this.child,
    required this.accent,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color accent;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      decoration: BoxDecoration(
        color: AppColors.washFor(accent),
        borderRadius: Corners.brXl,
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(left: Corners.xl),
              ),
            ),
            Expanded(child: Padding(padding: padding, child: child)),
          ],
        ),
      ),
    );
    return onTap == null ? card : Pressable(onTap: onTap, scale: 0.99, child: card);
  }
}
