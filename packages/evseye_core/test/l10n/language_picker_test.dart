import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('language sheet labels follow the selected language before saving', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) => TextButton(
          onPressed: () => LanguagePicker.show(context, selected: AppLocale.english),
          child: const Text('Open picker'),
        )),
      ),
    ));

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('The app will change right away.'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    await tester.ensureVisible(find.text('हिन्दी'));
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();
    expect(find.text('अपनी भाषा चुनें'), findsOneWidget);
    expect(find.text('ऐप तुरंत बदल जाएगा।'), findsOneWidget);
    expect(find.text('सेव करें'), findsOneWidget);
  });
}
