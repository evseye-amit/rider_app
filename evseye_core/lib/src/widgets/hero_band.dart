import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

class HeroBand extends StatelessWidget {
  const HeroBand({
    required this.child,
    this.height,
    this.color = AppColors.ink,
    this.pattern = true,
    this.padding = const EdgeInsets.fromLTRB(Insets.gutter, 0, Insets.gutter, Insets.xxl),
    this.bottomRadius = 30,
    this.safeTop = true,
    super.key,
  });

  final Widget child;
  final double? height;

  final Color color;

  final bool pattern;

  final EdgeInsetsGeometry padding;
  final double bottomRadius;
  final bool safeTop;

  @override
  Widget build(BuildContext context) {
    final double top = safeTop ? MediaQuery.paddingOf(context).top : 0;

    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
      child: Container(
        height: height,
        width: double.infinity,
        color: color,
        child: Stack(
          children: [
            if (pattern)
              Positioned.fill(
                child: CustomPaint(painter: _IrisPatternPainter(color: color)),
              ),
            Padding(
              padding: EdgeInsets.only(top: top).add(padding),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _IrisPatternPainter extends CustomPainter {
  const _IrisPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = Offset(size.width * 0.92, size.height * 0.12);
    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.07);

    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(centre, size.width * 0.13 * i, stroke);
    }

    canvas.drawCircle(
      centre,
      size.width * 0.075,
      Paint()..color = Colors.white.withValues(alpha: 0.05),
    );

    final Offset second = Offset(-size.width * 0.06, size.height * 0.92);
    final Paint faint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.05);
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(second, size.width * 0.11 * i, faint);
    }
  }

  @override
  bool shouldRepaint(_IrisPatternPainter oldDelegate) => oldDelegate.color != color;
}

class HeroBandBar extends StatelessWidget {
  const HeroBandBar({
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.titleStyle,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: Insets.md)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(
                    fontSize: 12.5,
                    color: AppColors.onInkSecondary,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              if (title != null)
                Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle ??
                      AppText.titleLarge.copyWith(fontSize: 21, color: AppColors.onInk),
                ),
            ],
          ),
        ),
        for (final action in actions) ...[const SizedBox(width: Insets.sm), action],
      ],
    );
  }
}

class InkCircleButton extends StatelessWidget {
  const InkCircleButton({
    required this.icon,
    this.onTap,
    this.size = 40,
    this.badgeCount = 0,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inkStroke),
            ),
            child: Icon(icon, size: size * 0.46, color: AppColors.onInk),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -1,
              top: -1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                constraints: const BoxConstraints(minWidth: 18),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: Corners.pill,
                  border: Border.all(color: AppColors.ink, width: 1.6),
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

class InkStat extends StatelessWidget {
  const InkStat({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;

  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: AppColors.onInkMuted),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(
                  fontSize: 11.5,
                  color: AppColors.onInkMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.numericSmall.copyWith(
            fontSize: 17,
            color: valueColor == null
                ? AppColors.onInk
                : AppColors.onInkTone(valueColor!),
          ),
        ),
      ],
    );
  }
}

class InkDivider extends StatelessWidget {
  const InkDivider({this.height = 30, super.key});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: height, color: AppColors.inkStroke);
}

class HeroScaffold extends StatelessWidget {
  const HeroScaffold({
    required this.band,
    required this.children,
    this.overlap = 26,
    this.bandColor = AppColors.ink,
    this.bottomPadding = Insets.x4l,
    this.floatingAction,
    this.drawer,
    this.bottomNavigationBar,
    this.controller,
    this.onRefresh,
    super.key,
  });

  final Widget band;

  final List<Widget> children;

  final double overlap;

  final Color bandColor;
  final double bottomPadding;
  final Widget? floatingAction;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final ScrollController? controller;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget body = SingleChildScrollView(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroBand(
            color: bandColor,
            padding: EdgeInsets.fromLTRB(
              Insets.gutter,
              Insets.md,
              Insets.gutter,
              Insets.xxl + math.max(overlap, 0),
            ),
            child: band,
          ),
          Transform.translate(
            offset: Offset(0, -overlap),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                Insets.gutter,
                0,
                Insets.gutter,
                bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: drawer,
      extendBody: bottomNavigationBar != null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingAction,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.paddingOf(context).top + 120,
            child: ColoredBox(color: bandColor),
          ),
          Positioned.fill(
            child: onRefresh == null
                ? body
                : RefreshIndicator(
                    onRefresh: onRefresh!,
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    child: body,
                  ),
          ),
        ],
      ),
    );
  }
}
