import 'package:evseye_core/src/api/company_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bootstrap languages follow server locale order and names', () {
    final BootstrapLanguages bootstrap = BootstrapLanguages.fromJson({
      'supportedLocales': ['hi', 'en'],
      'languages': [
        {'code': 'en', 'name': 'English', 'nativeName': 'English'},
        {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी'},
      ],
    });

    expect(bootstrap.options.map((language) => language.code), ['hi', 'en']);
    expect(bootstrap.options.first.nativeName, 'हिन्दी');
  });
}
