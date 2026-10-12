import 'package:flutter/material.dart';

import '../flavor/flavor_config.dart';

abstract final class AppColors {
  static const Color primary = FlavorConfig.primary;
  static const Color primaryBright = FlavorConfig.primaryBright;
  static const Color primaryDeep = FlavorConfig.primaryDeep;

  static const Color primaryWash = FlavorConfig.primaryWash;

  static const Color primaryInk = FlavorConfig.primaryInk;

  static const Color primaryOverlay = FlavorConfig.primaryOverlay;
  static const Color primarySelection = FlavorConfig.primarySelection;

  static const Color cyan = Color(0xFF00A3C4);
  static const Color cyanWash = Color(0xFFE1F5FA);

  static const Color mint = Color(0xFF00B87C);
  static const Color mintWash = Color(0xFFE2F7F0);

  static const Color violet = Color(0xFF7C3AED);
  static const Color violetWash = Color(0xFFF0E9FE);

  static const Color coral = Color(0xFFFF5A5F);
  static const Color coralWash = Color(0xFFFFEDEE);

  static const Color amber = Color(0xFFFF9F1C);
  static const Color amberWash = Color(0xFFFFF4E3);

  static const Color teal = Color(0xFF00B8D9);
  static const Color tealWash = Color(0xFFE1F7FB);

  static const Color ink = primaryWash;
  static const Color inkSoft = primaryWash;
  static const Color inkDeep = primaryWash;

  static const Color onInk = primaryInk;
  static const Color onInkSecondary = FlavorConfig.onInkSecondary;
  static const Color onInkMuted = FlavorConfig.onInkMuted;

  static const Color onInkAccent = primaryInk;

  static const Color onInkMint = Color(0xFF0A5C3E);
  static const Color onInkAmber = Color(0xFF6B4405);
  static const Color onInkCoral = Color(0xFF7A1720);

  static const Color inkStroke = Color(0x29000000);

  static const Color canvas = Color(0xFFF4F6FA);

  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceMuted = Color(0xFFF4F6F9);

  static const Color surfaceSunken = Color(0xFFEDF1F5);

  static const Color stroke = Color(0xFFE4E9EF);

  static const Color strokeStrong = Color(0xFFCFD8E3);

  static const Color textPrimary = Color(0xFF11202F);
  static const Color textSecondary = Color(0xFF5B6B7C);
  static const Color textMuted = Color(0xFF8B9AAA);
  static const Color textOnPrimary = FlavorConfig.textOnPrimary;

  static const Color success = Color(0xFF12A05F);
  static const Color successWash = Color(0xFFE6F6EE);

  static const Color danger = Color(0xFFD92D3C);
  static const Color dangerWash = Color(0xFFFDEBEC);

  static const Color warning = Color(0xFFB2740B);
  static const Color warningWash = Color(0xFFFDF3E2);

  static const Color info = primary;
  static const Color infoWash = primaryWash;

  static Color onInkTone(Color tone) => switch (tone) {
        mint || success => onInkMint,
        warning || amber => onInkAmber,
        danger || coral => onInkCoral,
        cyan || teal || violet || primary => onInkAccent,
        _ => onInk,
      };

  static Color washFor(Color tone) => switch (tone) {
        success => successWash,
        danger => dangerWash,
        warning => warningWash,
        mint => mintWash,
        cyan => cyanWash,
        violet => violetWash,
        coral => coralWash,
        amber => amberWash,
        teal => tealWash,
        _ => primaryWash,
      };

  static const List<Color> serviceTones = [
    primary,
    mint,
    amber,
    coral,
    violet,
    teal,
    cyan,
    success,
  ];

  const AppColors._();
}
