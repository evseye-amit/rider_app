import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/app_localizations.dart';

enum AppLocale {
  english('en', 'English', 'English'),
  hindi('hi', 'हिन्दी', 'Hindi'),
  kannada('kn', 'ಕನ್ನಡ', 'Kannada'),
  telugu('te', 'తెలుగు', 'Telugu');

  const AppLocale(this.code, this.nativeName, this.englishName);

  final String code;
  final String nativeName;
  final String englishName;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) =>
      AppLocale.values.firstWhere((l) => l.code == code, orElse: () => AppLocale.english);
}

class LocaleController extends ChangeNotifier {
  LocaleController({SharedPreferences? preferences}) : _prefs = preferences;

  static const String _localeKey = 'app.locale';
  static const String _promptedKey = 'app.locale.prompted';

  SharedPreferences? _prefs;

  AppLocale _locale = AppLocale.english;
  bool _prompted = false;

  AppLocale get current => _locale;
  Locale get locale => _locale.locale;
  bool get hasBeenPrompted => _prompted;

  Future<void> load() async {
    await initializeDateFormatting();
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _locale = AppLocale.fromCode(_prefs!.getString(_localeKey));
      _prompted = _prefs!.getBool(_promptedKey) ?? false;
      _applyIntlDefault();
    } on Object {
      _prefs = null;
    }
    notifyListeners();
  }

  Future<void> select(AppLocale next) async {
    if (_locale != next) {
      _locale = next;
    }
    _prompted = true;
    _applyIntlDefault();
    notifyListeners();
    await _write((prefs) async {
      await prefs.setString(_localeKey, next.code);
      await prefs.setBool(_promptedKey, true);
    });
  }

  Future<void> markPrompted() async {
    if (_prompted) return;
    _prompted = true;
    notifyListeners();
    await _write((prefs) => prefs.setBool(_promptedKey, true));
  }

  Future<void> reset() async {
    _locale = AppLocale.english;
    _prompted = false;
    notifyListeners();
    await _write((prefs) async {
      await prefs.remove(_localeKey);
      await prefs.remove(_promptedKey);
    });
  }

  /// Resolved messages for the active locale, for code that has no
  /// [BuildContext] such as network error mapping and form validators.
  static AppL10n strings = lookupAppL10n(const Locale('en'));

  /// Language tag sent as `Accept-Language`, so the API answers in the
  /// language the person picked.
  static String activeLanguageTag = AppLocale.english.code;

  void _applyIntlDefault() {
    Intl.defaultLocale = _locale == AppLocale.english ? 'en_IN' : _locale.code;
    strings = lookupAppL10n(_locale.locale);
    activeLanguageTag = _locale.code;
  }

  Future<void> _write(Future<void> Function(SharedPreferences prefs) action) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await action(_prefs!);
    } on Object {
      _prefs = null;
    }
  }
}

extension AppLocalizationsX on BuildContext {
  AppL10n get l10n => AppL10n.of(this);
}
