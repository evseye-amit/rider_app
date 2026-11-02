import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

enum AppLocale {
  english('en', 'English', 'English'),
  assamese('as', 'অসমীয়া', 'Assamese'),
  bengali('bn', 'বাংলা', 'Bengali'),
  gujarati('gu', 'ગુજરાતી', 'Gujarati'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  kannada('kn', 'ಕನ್ನಡ', 'Kannada'),
  malayalam('ml', 'മലയാളം', 'Malayalam'),
  marathi('mr', 'मराठी', 'Marathi'),
  odia('or', 'ଓଡ଼ିଆ', 'Odia'),
  punjabi('pa', 'ਪੰਜਾਬੀ', 'Punjabi'),
  tamil('ta', 'தமிழ்', 'Tamil'),
  telugu('te', 'తెలుగు', 'Telugu'),
  urdu('ur', 'اردو', 'Urdu');

  const AppLocale(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) =>
      AppLocale.values.firstWhere((l) => l.code == code, orElse: () => AppLocale.english);
}

extension AppLocalizationsX on BuildContext {
  AppL10n get l10n => AppL10n.of(this);
}
