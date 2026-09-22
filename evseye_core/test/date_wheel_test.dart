import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dateField opens the wheel sheet', (tester) async {
    registerDefaultWidgets();
    final form = DynamicFormController();
    final scope = DynamicUiScope(
      flags: FeatureFlags.empty,
      form: form,
      onAction: (_, __, ___) {},
    );
    final node = UiNode.fromJson({
      'type': 'dateField',
      'props': {'key': 'DATE_OF_BIRTH', 'label': 'Date of Birth'},
    });

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: DynamicNodeList(nodes: [node], scope: scope)),
    ));

    await tester.tap(find.text('DD / MM / YYYY'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
  });
}
