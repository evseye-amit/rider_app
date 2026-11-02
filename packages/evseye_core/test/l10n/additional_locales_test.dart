import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('server catalog locales have a selectable app locale and generated strings', () {
    for (final String code in ['as', 'bn', 'gu', 'ml', 'mr', 'or', 'pa', 'ta', 'ur']) {
      final AppLocale locale = AppLocale.fromCode(code);
      expect(locale.code, code);
      expect(AppL10n.supportedLocales, contains(locale.locale));
      expect(lookupAppL10n(locale.locale).commonChooseLanguage, isNotEmpty);
    }
  });
}
