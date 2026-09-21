import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class Insets {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 56;

  static const double gutter = 20;

  const Insets._();
}

abstract final class Corners {
  static const Radius xs = Radius.circular(8);
  static const Radius sm = Radius.circular(12);
  static const Radius md = Radius.circular(16);
  static const Radius lg = Radius.circular(20);
  static const Radius xl = Radius.circular(26);
  static const Radius xxl = Radius.circular(34);

  static const BorderRadius brXs = BorderRadius.all(xs);
  static const BorderRadius brSm = BorderRadius.all(sm);
  static const BorderRadius brMd = BorderRadius.all(md);
  static const BorderRadius brLg = BorderRadius.all(lg);
  static const BorderRadius brXl = BorderRadius.all(xl);
  static const BorderRadius brXxl = BorderRadius.all(xxl);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));

  static const BorderRadius sheet = BorderRadius.vertical(top: xxl);

  const Corners._();
}

abstract final class Shadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x12122C52), blurRadius: 18, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x0A122C52), blurRadius: 3, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x1F122C52), blurRadius: 34, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x0F122C52), blurRadius: 5, offset: Offset(0, 2)),
  ];

  static List<BoxShadow> lift(Color c, {double opacity = 0.22, double blur = 14}) => [
        BoxShadow(color: c.withValues(alpha: opacity), blurRadius: blur, offset: const Offset(0, 4)),
      ];

  static const List<BoxShadow> floating = [
    BoxShadow(color: Color(0x2E081E44), blurRadius: 28, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x14081E44), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x0D122C52), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> bottomBar = [];

  const Shadows._();
}

abstract final class Motion {
  static const Duration instant = Duration(milliseconds: 120);
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration normal = Duration(milliseconds: 340);
  static const Duration slow = Duration(milliseconds: 520);
  static const Duration page = Duration(milliseconds: 420);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve smooth = Curves.easeInOutCubicEmphasized;

  const Motion._();
}

abstract final class Strokes {
  static const BorderSide hairline = BorderSide(color: AppColors.stroke, width: 1);
  static const BorderSide focus = BorderSide(color: AppColors.primary, width: 1.4);
  static const BorderSide error = BorderSide(color: AppColors.danger, width: 1.2);

  const Strokes._();
}
