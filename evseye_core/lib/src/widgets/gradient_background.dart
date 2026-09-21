import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    this.showBlooms = false,
    this.color,
    super.key,
  });

  final Widget child;

  final bool showBlooms;

  final Color? color;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: color ?? AppColors.canvas, child: child);
}

class BrandBloom extends StatelessWidget {
  const BrandBloom({required this.child, this.size = 260, super.key});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppGradients.bloom),
        ),
        child,
      ],
    );
  }
}
