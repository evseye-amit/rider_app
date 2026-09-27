import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/core_providers.dart';
import 'active_locale.dart';
import 'app_locale.dart';

class LocalePreference extends Equatable {
  const LocalePreference({required this.locale, required this.hasBeenPrompted});

  final AppLocale locale;
  final bool hasBeenPrompted;

  LocalePreference copyWith({AppLocale? locale, bool? hasBeenPrompted}) =>
      LocalePreference(locale: locale ?? this.locale, hasBeenPrompted: hasBeenPrompted ?? this.hasBeenPrompted);

  @override
  List<Object?> get props => [locale, hasBeenPrompted];
}

class LocaleNotifier extends Notifier<LocalePreference> {
  static const String _localeKey = 'app.locale';
  static const String _promptedKey = 'app.locale.prompted';

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  @override
  LocalePreference build() {
    final SharedPreferences preferences = ref.watch(sharedPreferencesProvider);
    final AppLocale locale = AppLocale.fromCode(preferences.getString(_localeKey));
    ActiveLocale.apply(locale);
    return LocalePreference(locale: locale, hasBeenPrompted: preferences.getBool(_promptedKey) ?? false);
  }

  Future<void> select(AppLocale locale) async {
    ActiveLocale.apply(locale);
    state = LocalePreference(locale: locale, hasBeenPrompted: true);
    await _preferences.setString(_localeKey, locale.code);
    await _preferences.setBool(_promptedKey, true);
  }

  Future<void> markPrompted() async {
    if (state.hasBeenPrompted) return;
    state = state.copyWith(hasBeenPrompted: true);
    await _preferences.setBool(_promptedKey, true);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, LocalePreference>(LocaleNotifier.new);
