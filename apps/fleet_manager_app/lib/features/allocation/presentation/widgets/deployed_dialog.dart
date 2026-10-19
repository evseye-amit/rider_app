import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeployedDialog extends StatefulWidget {
  const DeployedDialog({required this.riderName, required this.vehicleNumber, super.key});

  final String riderName;
  final String vehicleNumber;

  static Future<void> show(BuildContext context, {required String riderName, required String vehicleNumber}) {
    HapticFeedback.mediumImpact();
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: Motion.slow,
      pageBuilder: (context, _, _) => DeployedDialog(riderName: riderName, vehicleNumber: vehicleNumber),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Motion.enter),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.86, end: 1).animate(CurvedAnimation(parent: animation, curve: Motion.spring)),
          child: child,
        ),
      ),
    );
  }

  @override
  State<DeployedDialog> createState() => _DeployedDialogState();
}

class _DeployedDialogState extends State<DeployedDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  )..forward();

  late final Animation<double> _content = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.42, 0.85, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: Container(
                padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.lg, Insets.xl, Insets.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: Corners.brXl,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.5),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryWash, AppColors.surface],
                    stops: [0, 0.6],
                  ),
                  boxShadow: Shadows.floating,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) => _SuccessBurst(progress: _controller.value),
                    ),
                    FadeTransition(
                      opacity: _content,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(_content),
                        child: Column(
                          children: [
                            Text(
                              l10n.allocationDeployedTitle,
                              textAlign: TextAlign.center,
                              style: AppText.titleLarge.copyWith(fontSize: 23, fontWeight: FontWeight.w800),
                            ),
                            const Gap.sm(),
                            Text(
                              l10n.allocationDeployedMessage(widget.vehicleNumber, widget.riderName),
                              textAlign: TextAlign.center,
                              style: AppText.bodyMedium.copyWith(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Gap.lg(),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: Insets.sm,
                              runSpacing: Insets.sm,
                              children: [
                                StatusChip(label: widget.riderName, tone: StatusTone.brand, icon: Icons.person_rounded),
                                StatusChip(
                                  label: widget.vehicleNumber,
                                  tone: StatusTone.success,
                                  icon: Icons.electric_scooter_rounded,
                                ),
                              ],
                            ),
                            const Gap.xl(),
                            PrimaryButton(
                              label: l10n.allocationBackToAllocations,
                              icon: Icons.format_list_bulleted_rounded,
                              onPressed: _close,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessBurst extends StatelessWidget {
  const _SuccessBurst({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final double pop = const Interval(0, 0.42, curve: Curves.elasticOut).transform(progress);
    final double check = const Interval(0.28, 0.6, curve: Curves.easeOutCubic).transform(progress);
    final double burst = const Interval(0.3, 1, curve: Curves.easeOutCubic).transform(progress);

    return SizedBox(
      width: 200,
      height: 176,
      child: CustomPaint(
        painter: _BurstPainter(progress: burst),
        child: Center(
          child: Transform.scale(
            scale: pop,
            child: Container(
              width: 98,
              height: 98,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryBright, AppColors.primaryDeep],
                ),
                border: Border.all(color: AppColors.surface, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.45),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CustomPaint(painter: _CheckPainter(progress: check)),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final Path path = Path()
      ..moveTo(size.width * 0.29, size.height * 0.52)
      ..lineTo(size.width * 0.44, size.height * 0.67)
      ..lineTo(size.width * 0.72, size.height * 0.37);
    final Paint paint = Paint()
      ..color = AppColors.textOnPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final Path drawn = Path();
    double remaining = progress * path.computeMetrics().fold<double>(0, (sum, metric) => sum + metric.length);
    for (final PathMetric metric in path.computeMetrics()) {
      if (remaining <= 0) break;
      drawn.addPath(metric.extractPath(0, math.min(remaining, metric.length)), Offset.zero);
      remaining -= metric.length;
    }
    canvas.drawPath(drawn, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) => oldDelegate.progress != progress;
}

class _BurstPainter extends CustomPainter {
  const _BurstPainter({required this.progress});

  final double progress;

  static const List<Color> _dots = [AppColors.primary, AppColors.success, AppColors.primaryBright, AppColors.warning];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final Offset center = size.center(Offset.zero);
    final double fade = 1 - progress;

    for (int ring = 0; ring < 2; ring++) {
      final double t = ((progress - ring * 0.18) / 0.82).clamp(0.0, 1.0);
      if (t <= 0) continue;
      canvas.drawCircle(
        center,
        50 + 38 * t,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..color = AppColors.primary.withValues(alpha: 0.45 * (1 - t)),
      );
    }

    const int count = 12;
    for (int i = 0; i < count; i++) {
      final double angle = i * 2 * math.pi / count - math.pi / 2;
      final double distance = 56 + 34 * progress + (i.isEven ? 6 : 0);
      final Offset position = center + Offset(math.cos(angle), math.sin(angle)) * distance;
      canvas.drawCircle(
        position,
        (i.isEven ? 4.2 : 3.0) * (1 - progress * 0.5),
        Paint()..color = _dots[i % _dots.length].withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => oldDelegate.progress != progress;
}
