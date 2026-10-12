import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app_locale.dart';
import 'generated/app_localizations.dart';

abstract final class ActiveLocale {
  static AppLocale _current = AppLocale.english;

  static AppL10n strings = lookupAppL10n(AppLocale.english.locale);

  static AppLocale get current => _current;

  static String get languageTag => _current.code;

  static Future<void> initializeFormatting() => initializeDateFormatting();

  static void apply(AppLocale locale) {
    _current = locale;
    strings = lookupAppL10n(locale.locale);
    Intl.defaultLocale = locale == AppLocale.english ? 'en_IN' : locale.code;
  }
}
