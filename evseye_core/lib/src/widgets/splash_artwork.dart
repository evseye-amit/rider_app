import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

class SplashArtwork extends StatelessWidget {
  const SplashArtwork({
    this.asset = 'assets/images/splash_screen.png',
    this.progress,
    super.key,
  });

  final String asset;

  final Animation<double>? progress;

  static const Color ground = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: ground),
        Center(
          child: Image.asset(
            asset,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
          ),
        ),
        if (progress != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Insets.x5l,
                  0,
                  Insets.x5l,
                  Insets.xl,
                ),
                child: _ProgressRule(progress: progress!),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgressRule extends StatelessWidget {
  const _ProgressRule({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Corners.pill,
      child: SizedBox(
        height: 3,
        child: Stack(
          children: [
            const ColoredBox(
              color: AppColors.primaryWash,
              child: SizedBox.expand(),
            ),
            AnimatedBuilder(
              animation: progress,
              builder: (context, _) => FractionallySizedBox(
                widthFactor: progress.value.clamp(0.0, 1.0),
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: Corners.pill,
                    color: AppColors.primary,
                  ),
                  child: SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
