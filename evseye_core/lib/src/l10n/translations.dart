import 'app_locale.dart';
import 'translations_hi.dart';
import 'translations_kn.dart';
import 'translations_te.dart';

final Map<AppLocale, Map<String, String>> appTranslations = {
  AppLocale.hindi: hindiStrings,
  AppLocale.kannada: kannadaStrings,
  AppLocale.telugu: teluguStrings,
};
