import 'dart:convert';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

DynamicUiScope _scope(DynamicFormController form, {Map<String, Object?> data = const {}}) =>
    DynamicUiScope(
      flags: FeatureFlags.empty,
      form: form,
      onAction: (_, __, ___) {},
      data: data,
    );

Widget _host(List<UiNode> nodes, DynamicUiScope scope) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: SingleChildScrollView(child: DynamicNodeList(nodes: nodes, scope: scope))),
    );

void main() {
  setUp(registerDefaultWidgets);

  testWidgets('nominee shares under 100 prompt to add or top up', (tester) async {
    tester.view.physicalSize = const Size(440, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final form = DynamicFormController();
    final scope = _scope(form);
    final node = UiNode.fromJson({
      'type': 'nomineeField',
      'props': {'key': 'NOMINEES', 'label': 'Nominees'},
    });

    await tester.pumpWidget(_host([node], scope));
    expect(find.textContaining('add up to 100%'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '100'), '60');
    await tester.pump();

    expect(find.textContaining('less than 100%'), findsOneWidget);
    expect(find.textContaining('remaining 40'), findsOneWidget);
    expect(find.text('Add nominee'), findsOneWidget);
    expect(find.text('Make it 100%'), findsOneWidget);
    expect(form.valueOf('NOMINEES'), anyOf(isNull, ''));

    await tester.tap(find.text('Make it 100%'));
    await tester.pump();
    expect(find.textContaining('add up to 100%'), findsOneWidget);
  });

  testWidgets('a second nominee takes the remaining share', (tester) async {
    tester.view.physicalSize = const Size(440, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final form = DynamicFormController();
    final scope = _scope(form);
    final node = UiNode.fromJson({
      'type': 'nomineeField',
      'props': {'key': 'NOMINEES'},
    });

    await tester.pumpWidget(_host([node], scope));
    await tester.enterText(find.widgetWithText(TextField, '100'), '70');
    await tester.pump();
    await tester.tap(find.text('Add nominee'));
    await tester.pump();

    expect(find.text('Nominee 2'), findsOneWidget);
    expect(find.textContaining('add up to 100%'), findsOneWidget);
  });

  testWidgets('bank account must match its confirmation', (tester) async {
    final form = DynamicFormController();
    final scope = _scope(form);
    final node = UiNode.fromJson({
      'type': 'bankAccountField',
      'props': {'key': 'BANK_ACCOUNT_NUMBER', 'label': 'Bank account number'},
    });

    await tester.pumpWidget(_host([node], scope));
    final fields = find.byType(TextField);

    await tester.enterText(fields.at(0), '50100123454471');
    await tester.enterText(fields.at(1), '50100123459999');
    await tester.pump();

    expect(find.text('Account numbers do not match'), findsOneWidget);
    expect(form.valueOf('BANK_ACCOUNT_NUMBER'), '');

    await tester.enterText(fields.at(1), '50100123454471');
    await tester.pump();

    expect(find.text('Account numbers do not match'), findsNothing);
    expect(find.text('Account numbers match'), findsOneWidget);
    expect(form.valueOf('BANK_ACCOUNT_NUMBER'), '50100123454471');
  });

  testWidgets('a reference cannot reuse the rider own number', (tester) async {
    final form = DynamicFormController();
    final scope = _scope(form, data: {'mobile': '9876543277'});
    final node = UiNode.fromJson({
      'type': 'referenceField',
      'props': {'key': 'REFERENCES'},
    });

    await tester.pumpWidget(_host([node], scope));
    await tester.enterText(find.widgetWithText(TextField, 'Their name'), 'Ramesh Gupta');
    await tester.enterText(find.widgetWithText(TextField, '98765 43210'), '9876543277');
    await tester.pump();

    expect(find.text('This is your own number. Use a different one.'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '98765 43210'), '9812345001');
    await tester.pump();

    expect(find.text('This is your own number. Use a different one.'), findsNothing);
    expect(jsonDecode(form.valueOf('REFERENCES')! as String), isA<List<dynamic>>());
  });

  test('futureDate rejects today and the past, accepts tomorrow', () {
    String? check(DateTime d) => validateValue(
          d.toIso8601String().split('T').first,
          const [ValidationRule(type: 'futureDate')],
          label: 'Expiry',
        );
    final DateTime now = DateTime.now();
    expect(check(now), isNotNull);
    expect(check(now.subtract(const Duration(days: 1))), isNotNull);
    expect(check(now.add(const Duration(days: 1))), isNull);
  });
}
