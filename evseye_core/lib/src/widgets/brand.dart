import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../theme/app_typography.dart';

class EvseyeMark extends StatelessWidget {
  const EvseyeMark({this.size = 56, this.color, super.key});

  final double size;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.62,
      child: CustomPaint(painter: _EyePainter(color ?? AppGradients.iris)),
    );
  }
}

class _EyePainter extends CustomPainter {
  _EyePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path almond = Path()
      ..moveTo(0, h / 2)
      ..quadraticBezierTo(w * 0.5, -h * 0.08, w, h / 2)
      ..quadraticBezierTo(w * 0.5, h * 1.08, 0, h / 2)
      ..close();

    canvas.drawPath(almond, Paint()..color = color);

    final Offset c = Offset(w / 2, h / 2);
    final double r = h * 0.40;
    canvas.drawCircle(c, r, Paint()..color = AppColors.primaryInk);
    canvas.drawCircle(c, r * 0.72, Paint()..color = AppColors.primary);
    canvas.drawCircle(c, r * 0.40, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(c.dx + r * 0.34, c.dy - r * 0.34),
      r * 0.17,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_EyePainter oldDelegate) => oldDelegate.color != color;
}

class EvseyeLogo extends StatelessWidget {
  const EvseyeLogo({
    this.markSize = 52,
    this.wordSize = 30,
    this.inline = false,
    this.showWordmark = true,
    this.onDark = false,
    super.key,
  });

  final double markSize;
  final double wordSize;
  final bool inline;
  final bool showWordmark;

  final bool onDark;

  static const Color _onDarkAccent = AppColors.onInkAccent;

  @override
  Widget build(BuildContext context) {
    final Widget word = RichText(
      text: TextSpan(
        style: AppText.displayLarge.copyWith(
          fontSize: wordSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.6,
        ),
        children: [
          TextSpan(
            text: 'evs',
            style: TextStyle(color: onDark ? Colors.white : AppColors.textPrimary),
          ),
          TextSpan(
            text: 'eye',
            style: TextStyle(color: onDark ? _onDarkAccent : AppColors.primary),
          ),
        ],
      ),
    );

    final Widget mark = EvseyeMark(size: markSize);
    if (!showWordmark) return mark;

    return inline
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [mark, const SizedBox(width: 10), word],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [mark, const SizedBox(height: 14), word],
          );
  }
}
