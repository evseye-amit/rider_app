import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/core_providers.dart';

class TermsConsentNotifier extends Notifier<bool> {
  static const String _acceptedKey = 'app.terms.accepted';

  SharedPreferences get _preferences => ref.read(sharedPreferencesProvider);

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_acceptedKey) ?? false;

  Future<void> accept() async {
    state = true;
    await _preferences.setBool(_acceptedKey, true);
  }
}

final termsConsentProvider = NotifierProvider<TermsConsentNotifier, bool>(TermsConsentNotifier.new);
