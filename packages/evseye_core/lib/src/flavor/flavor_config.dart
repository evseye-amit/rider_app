import 'dart:ui';

abstract final class FlavorConfig {
  static const String name = 'pinkrides';
  static const String companyCode = 'yogmaya';

  static const String riderAppName = 'Pink Rider App';
  static const String fleetAppName = 'Pink FM app';
  static const String supportEmail = 'support@pinkrides.in';

  static const Color primary = Color(0xFFF475D0);
  static const Color primaryBright = Color(0xFFF475D0);
  static const Color primaryDeep = Color(0xFFF475D0);
  static const Color primaryWash = Color(0xFFFDECF8);
  static const Color primaryInk = Color(0xFF3D0A2C);
  static const Color onInkSecondary = Color(0xFF6B2453);
  static const Color onInkMuted = Color(0xFF854070);
  static const Color textOnPrimary = Color(0xFF3D0A2C);
  static const Color primaryOverlay = Color(0x1FF475D0);
  static const Color primarySelection = Color(0x33F475D0);

  const FlavorConfig._();
}
