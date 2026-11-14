import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/company_api.dart';
import '../api/legal_api.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';
import 'app_locale.dart';

final companyLanguagesProvider = FutureProvider.family<BootstrapLanguages, String>((ref, code) async {
  final Result<BootstrapLanguages> result = await ref
      .read(companyApiProvider)
      .languages(code: code, audience: LegalAudience.rider);
  final BootstrapLanguages languages = result.getOrThrow();
  if (languages.locales.isEmpty) {
    throw const ValidationFailure('No available language has an app translation.');
  }
  return languages;
});

extension BootstrapLanguagesLocales on BootstrapLanguages {
  List<AppLocale> get locales => [
    for (final BootstrapLanguage language in options)
      for (final AppLocale locale in AppLocale.values)
        if (locale.code == language.code) locale,
  ];

  Map<String, String> get nativeNames => {
    for (final BootstrapLanguage language in options) language.code: language.nativeName,
  };

  Map<String, String> get englishNames => {
    for (final BootstrapLanguage language in options) language.code: language.name,
  };
}
