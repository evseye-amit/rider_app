import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'translations.dart';

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

class AppLocaleController extends ChangeNotifier {
  AppLocaleController._();

  static final AppLocaleController instance = AppLocaleController._();

  static const String _key = 'app.locale';
  static const String _askedKey = 'app.locale.asked';

  SharedPreferences? _prefs;

  AppLocale _locale = AppLocale.english;
  bool _asked = false;
  bool _loaded = false;

  AppLocale get locale => _locale;
  bool get asked => _asked;
  bool get loaded => _loaded;

  Future<void> load() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _locale = AppLocale.fromCode(_prefs!.getString(_key));
      _asked = _prefs!.getBool(_askedKey) ?? false;
    } on Object {
      _prefs = null;
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> select(AppLocale next) async {
    _locale = next;
    _asked = true;
    notifyListeners();
    await _write((p) async {
      await p.setString(_key, next.code);
      await p.setBool(_askedKey, true);
    });
  }

  Future<void> markAsked() async {
    _asked = true;
    notifyListeners();
    await _write((p) => p.setBool(_askedKey, true));
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

String tr(String source) {
  final AppLocale locale = AppLocaleController.instance.locale;
  if (locale == AppLocale.english) return source;
  return appTranslations[locale]?[source] ?? source;
}

String trp(String source, Map<String, String> values) {
  String out = tr(source);
  values.forEach((k, v) => out = out.replaceAll('{$k}', v));
  return out;
}

extension TranslateString on String {
  String get t => tr(this);
}
