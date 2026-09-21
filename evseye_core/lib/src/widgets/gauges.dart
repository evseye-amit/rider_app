import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

class RingGauge extends StatelessWidget {
  const RingGauge({
    required this.value,
    this.size = 120,
    this.strokeWidth = 10,
    this.label,
    this.centerText,
    this.color,
    this.trackColor = AppColors.surfaceSunken,
    this.icon,
    super.key,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final String? label;
  final String? centerText;
  final Color? color;
  final Color trackColor;
  final IconData? icon;

  Color get _autoColor {
    if (color != null) return color!;
    if (value >= 0.6) return AppColors.mint;
    if (value >= 0.3) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: Motion.slow,
        curve: Motion.enter,
        builder: (context, v, _) => CustomPaint(
          painter: _RingPainter(
            value: v,
            color: _autoColor,
            trackColor: trackColor,
            strokeWidth: strokeWidth,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: size * 0.16, color: _autoColor),
                  const SizedBox(height: 2),
                ],
                Text(
                  centerText ?? '${(v * 100).round()}%',
                  style: AppText.numeric.copyWith(fontSize: size * 0.21),
                ),
                if (label != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    label!,
                    style: AppText.bodySmall.copyWith(fontSize: size * 0.085),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    const double startAngle = -math.pi * 0.75;
    const double sweepTotal = math.pi * 1.5;

    canvas.drawArc(
      rect,
      startAngle,
      sweepTotal,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    if (value <= 0) return;

    canvas.drawArc(
      rect,
      startAngle,
      sweepTotal * value,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value || old.color != color;
}

class BatteryBar extends StatelessWidget {
  const BatteryBar({
    required this.percent,
    this.width = 64,
    this.height = 26,
    this.charging = false,
    super.key,
  });

  final int percent;
  final double width;
  final double height;
  final bool charging;

  Color get _tone {
    if (charging) return AppColors.primary;
    if (percent >= 60) return AppColors.mint;
    if (percent >= 30) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: Corners.brXs,
            border: Border.all(color: AppColors.strokeStrong, width: 1.5),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: (percent / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _tone,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              if (charging)
                const Center(child: Icon(Icons.bolt_rounded, size: 14, color: Colors.white)),
            ],
          ),
        ),
        Container(
          width: 3,
          height: height * 0.4,
          decoration: const BoxDecoration(
            color: AppColors.strokeStrong,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(2)),
          ),
        ),
        const SizedBox(width: Insets.sm),
        Text('$percent%', style: AppText.numericSmall.copyWith(fontSize: 14, color: _tone)),
      ],
    );
  }
}
