import 'dart:async';
import 'dart:math' as math;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PairingFlash {
  const PairingFlash._();

  static const Duration connecting = Duration(seconds: 4);
  static const Duration settle = Duration(milliseconds: 1600);

  static void show(BuildContext context, {required VoidCallback onPaired}) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    bool removed = false;

    void dismiss() {
      if (removed) return;
      removed = true;
      entry.remove();
    }

    entry = OverlayEntry(
      builder: (_) => _Pairing(onPaired: onPaired, onDone: dismiss),
    );
    overlay.insert(entry);
  }
}

class _Pairing extends StatefulWidget {
  const _Pairing({required this.onPaired, required this.onDone});

  final VoidCallback onPaired;
  final VoidCallback onDone;

  @override
  State<_Pairing> createState() => _PairingState();
}

class _PairingState extends State<_Pairing> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: Motion.fast,
  )..forward();

  late final AnimationController _ripple = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  late final AnimationController _arc = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat();

  Timer? _buzz;
  Timer? _connect;
  Timer? _leave;
  bool _paired = false;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _buzz = Timer.periodic(
      const Duration(milliseconds: 240),
      (_) => HapticFeedback.selectionClick(),
    );
    _connect = Timer(PairingFlash.connecting, _complete);
  }

  void _complete() {
    _buzz?.cancel();
    _arc.stop();
    HapticFeedback.heavyImpact();
    widget.onPaired();
    if (!mounted) return;
    setState(() => _paired = true);
    _leave = Timer(PairingFlash.settle, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_leaving) return;
    _leaving = true;
    _buzz?.cancel();
    _connect?.cancel();
    _leave?.cancel();
    await _enter.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _buzz?.cancel();
    _connect?.cancel();
    _leave?.cancel();
    _enter.dispose();
    _ripple.dispose();
    _arc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _enter,
      builder: (context, child) {
        final double t = Curves.easeOutCubic.transform(_enter.value);
        return Opacity(
          opacity: t,
          child: ColoredBox(
            color: const Color(0xB3120A28),
            child: Center(
              child: Transform.scale(scale: 0.88 + 0.12 * t, child: child),
            ),
          ),
        );
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _paired ? _dismiss : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.x4l),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(Insets.x3l),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: Corners.brXxl,
                boxShadow: Shadows.raised,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 168,
                    height: 168,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_ripple, _arc]),
                      builder: (context, _) => CustomPaint(
                        size: const Size.square(168),
                        painter: _ElectricHalo(
                          ripple: _ripple.value,
                          sweep: _arc.value,
                          paired: _paired,
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: Motion.normal,
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.45),
                                  blurRadius: _paired ? 28 : 18,
                                  spreadRadius: _paired ? 2 : 0,
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: Motion.fast,
                              child: Icon(
                                _paired ? Icons.check_rounded : Icons.bolt_rounded,
                                key: ValueKey<bool>(_paired),
                                size: 42,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap.xl(),
                  AnimatedSwitcher(
                    duration: Motion.fast,
                    child: Text(
                      _paired ? 'Paired' : 'Pairing your scooter',
                      key: ValueKey<bool>(_paired),
                      textAlign: TextAlign.center,
                      style: AppText.displaySmall.copyWith(fontSize: 22),
                    ),
                  ),
                  const Gap.sm(),
                  Text(
                    _paired
                        ? 'Your scooter is connected. Use the power button to switch it on.'
                        : 'Talking to the IoT unit. Keep your phone close.',
                    textAlign: TextAlign.center,
                    style: AppText.bodyMedium.copyWith(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ElectricHalo extends CustomPainter {
  const _ElectricHalo({required this.ripple, required this.sweep, required this.paired});

  final double ripple;
  final double sweep;
  final bool paired;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centre = Offset(size.width / 2, size.height / 2);
    const double base = 46;
    final double span = size.width / 2 - base;

    for (int i = 0; i < 3; i++) {
      final double t = (ripple + i / 3) % 1.0;
      final double fade = (1 - t) * (paired ? 0.22 : 0.55);
      if (fade <= 0) continue;
      canvas.drawCircle(
        centre,
        base + span * t,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.6 - t * 1.4
          ..color = AppColors.primary.withValues(alpha: fade),
      );
    }

    final double radius = base + span * 0.6;
    final Rect ring = Rect.fromCircle(center: centre, radius: radius);

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = AppColors.primary.withValues(alpha: 0.18),
    );

    if (paired) {
      canvas.drawCircle(
        centre,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.4
          ..color = AppColors.primary.withValues(alpha: 0.85),
      );
      return;
    }

    canvas.drawArc(
      ring,
      sweep * 2 * math.pi,
      math.pi / 2.4,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.2
        ..shader = SweepGradient(
          startAngle: sweep * 2 * math.pi,
          endAngle: sweep * 2 * math.pi + math.pi / 2.4,
          colors: [
            AppColors.primary.withValues(alpha: 0.0),
            AppColors.primary,
          ],
        ).createShader(ring),
    );

    final math.Random spark = math.Random((sweep * 14).floor());
    for (int i = 0; i < 6; i++) {
      final double angle = spark.nextDouble() * 2 * math.pi;
      final double inner = radius - 6 - spark.nextDouble() * 7;
      final double outer = radius + 6 + spark.nextDouble() * 11;
      canvas.drawLine(
        centre + Offset(math.cos(angle) * inner, math.sin(angle) * inner),
        centre + Offset(math.cos(angle) * outer, math.sin(angle) * outer),
        Paint()
          ..strokeWidth = 1.9
          ..strokeCap = StrokeCap.round
          ..color = AppColors.primary.withValues(alpha: 0.3 + spark.nextDouble() * 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(_ElectricHalo old) =>
      old.ripple != ripple || old.sweep != sweep || old.paired != paired;
}
