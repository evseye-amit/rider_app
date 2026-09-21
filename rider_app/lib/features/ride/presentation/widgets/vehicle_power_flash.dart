import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class VehiclePowerFlash {
  const VehiclePowerFlash._();

  static const Duration dwell = Duration(milliseconds: 3500);

  static void show(BuildContext context, {required bool on}) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    bool removed = false;

    void dismiss() {
      if (removed) return;
      removed = true;
      entry.remove();
    }

    entry = OverlayEntry(
      builder: (_) => _Flash(on: on, onDone: dismiss),
    );
    overlay.insert(entry);
  }
}

class _Flash extends StatefulWidget {
  const _Flash({required this.on, required this.onDone});

  final bool on;
  final VoidCallback onDone;

  @override
  State<_Flash> createState() => _FlashState();
}

class _FlashState extends State<_Flash> with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: Motion.fast,
  )..forward();

  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  )..repeat(reverse: true);

  Timer? _timer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(VehiclePowerFlash.dwell, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_leaving) return;
    _leaving = true;
    _timer?.cancel();
    await _enter.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _enter.dispose();
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool on = widget.on;

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
        onTap: _dismiss,
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
                  AnimatedBuilder(
                    animation: _blink,
                    builder: (context, _) {
                      final double b = _blink.value;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 104 + b * 12,
                            height: 104 + b * 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary
                                  .withValues(alpha: 0.08 + b * 0.12),
                            ),
                          ),
                          Container(
                            width: 76,
                            height: 76,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Opacity(
                              opacity: 0.5 + b * 0.5,
                              child: Icon(
                                on
                                    ? Icons.bolt_rounded
                                    : Icons.power_settings_new_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Gap.xl(),
                  Text(
                    on ? 'Vehicle is ON' : 'Vehicle is OFF',
                    textAlign: TextAlign.center,
                    style: AppText.displaySmall.copyWith(fontSize: 22),
                  ),
                  const Gap.sm(),
                  Text(
                    on
                        ? 'Ride safe. Helmet on, lights checked.'
                        : 'Parked and locked.',
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
