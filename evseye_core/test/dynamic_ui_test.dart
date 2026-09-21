import 'dart:convert';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UiCondition', () {
    bool flagOn(String f) => const {'AADHAAR_VERIFICATION', 'PAN_VERIFICATION'}.contains(f);

    test('passes when the named flag is enabled', () {
      final c = UiCondition.fromJson({'flag': 'AADHAAR_VERIFICATION'});
      expect(c.evaluate(isFlagEnabled: flagOn, valueOf: (_) => null), isTrue);
    });

    test('fails when the named flag is disabled', () {
      final c = UiCondition.fromJson({'flag': 'E_MANDATE'});
      expect(c.evaluate(isFlagEnabled: flagOn, valueOf: (_) => null), isFalse);
    });

    test('notFlag inverts the test', () {
      final c = UiCondition.fromJson({'notFlag': 'E_MANDATE'});
      expect(c.evaluate(isFlagEnabled: flagOn, valueOf: (_) => null), isTrue);
    });

    test('compares a form value', () {
      final c = UiCondition.fromJson({'field': 'condition', 'equals': 'damaged'});
      expect(
        c.evaluate(isFlagEnabled: flagOn, valueOf: (k) => k == 'condition' ? 'damaged' : null),
        isTrue,
      );
      expect(
        c.evaluate(isFlagEnabled: flagOn, valueOf: (k) => k == 'condition' ? 'good' : null),
        isFalse,
      );
    });

    test('anyOf passes when one branch passes', () {
      final c = UiCondition.fromJson({
        'anyOf': [
          {'flag': 'SECURITY_DEPOSIT'},
          {'flag': 'PAN_VERIFICATION'},
        ],
      });
      expect(c.evaluate(isFlagEnabled: flagOn, valueOf: (_) => null), isTrue);
    });
  });

  group('validateValue', () {
    test('required catches empty and blank', () {
      const rules = [ValidationRule(type: 'required')];
      expect(validateValue(null, rules), isNotNull);
      expect(validateValue('   ', rules), isNotNull);
      expect(validateValue('Arjun', rules), isNull);
    });

    test('Indian mobile, PAN, IFSC and Aadhaar formats', () {
      expect(validateValue('9876543210', [const ValidationRule(type: 'mobile')]), isNull);
      expect(validateValue('1234567890', [const ValidationRule(type: 'mobile')]), isNotNull);
      expect(validateValue('ABCDE1234F', [const ValidationRule(type: 'pan')]), isNull);
      expect(validateValue('ABCD1234F', [const ValidationRule(type: 'pan')]), isNotNull);
      expect(validateValue('HDFC0001234', [const ValidationRule(type: 'ifsc')]), isNull);
      expect(validateValue('1234 5678 9012', [const ValidationRule(type: 'aadhaar')]), isNull);
    });

    test('minAge rejects an under-age date of birth', () {
      final DateTime now = DateTime.now();
      final String minor = DateTime(now.year - 16, now.month, now.day)
          .toIso8601String()
          .split('T')
          .first;
      final String adult = DateTime(now.year - 25, now.month, now.day)
          .toIso8601String()
          .split('T')
          .first;
      const rules = [ValidationRule(type: 'minAge', value: 18)];
      expect(validateValue(minor, rules), isNotNull);
      expect(validateValue(adult, rules), isNull);
    });

    test('a custom message overrides the default', () {
      final String? err = validateValue(
        '',
        [const ValidationRule(type: 'required', message: 'Enter your full name')],
      );
      expect(err, 'Enter your full name');
    });
  });

  group('DynamicFormController', () {
    test('validates only the nodes that are visible', () {
      final form = DynamicFormController();
      final nodes = [
        UiNode.fromJson({
          'type': 'textField',
          'id': 'pan',
          'props': {'key': 'pan', 'label': 'PAN'},
          'validations': [
            {'type': 'required'},
          ],
        }),
        UiNode.fromJson({
          'type': 'textField',
          'id': 'hidden',
          'props': {'key': 'hidden', 'label': 'Hidden'},
          'validations': [
            {'type': 'required'},
          ],
        }),
      ];

      final bool ok = form.validateNodes(nodes, isVisible: (n) => n.id == 'pan');
      expect(ok, isFalse);
      expect(form.errors['pan'], isNotNull);
      expect(form.errors.containsKey('hidden'), isFalse);

      form.setValue('pan', 'ABCDE1234F');
      expect(form.validateNodes(nodes, isVisible: (n) => n.id == 'pan'), isTrue);
    });

    test('nested children are walked', () {
      final form = DynamicFormController();
      final group = UiNode.fromJson({
        'type': 'group',
        'children': [
          {
            'type': 'textField',
            'id': 'name',
            'props': {'key': 'name'},
            'validations': [
              {'type': 'required'},
            ],
          },
        ],
      });
      expect(form.validateNodes([group], isVisible: (_) => true), isFalse);
      expect(form.errors['name'], isNotNull);
    });
  });

  group('FeatureFlags', () {
    test('parses the map form and the terse list form', () {
      final a = FeatureFlags.fromJson({
        'features': {'WALLET': true, 'TRAINING': false},
      });
      expect(a.isEnabled('WALLET'), isTrue);
      expect(a.isEnabled('TRAINING'), isFalse);

      final b = FeatureFlags.fromJson({
        'features': ['WALLET', 'TRAINING'],
      });
      expect(b.isEnabled('TRAINING'), isTrue);
      expect(b.isEnabled('MISSING'), isFalse);
    });

    test('withOverride flips a single flag', () {
      const flags = FeatureFlags(flags: {'WALLET': true});
      expect(flags.withOverride('WALLET', false).isEnabled('WALLET'), isFalse);
    });
  });

  group('UiScreenConfig parsing', () {
    const raw = '''
    {
      "id": "demo",
      "title": "Demo",
      "body": [
        {
          "type": "group",
          "props": {"title": "Identity"},
          "visibleWhen": {"flag": "AADHAAR_VERIFICATION"},
          "children": [
            {"type": "textField", "id": "aadhaar", "props": {"key": "aadhaar"}}
          ]
        }
      ],
      "footer": [
        {"type": "primaryButton", "props": {"label": "Continue"}, "action": {"type": "next"}}
      ]
    }
    ''';

    test('round-trips structure, conditions and actions', () {
      final config = UiScreenConfig.fromJson(json.decode(raw) as Map<String, dynamic>);
      expect(config.id, 'demo');
      expect(config.body, hasLength(1));
      expect(config.body.first.children, hasLength(1));
      expect(config.body.first.visibleWhen?.flag, 'AADHAAR_VERIFICATION');
      expect(config.footer.first.action?.type, 'next');
      expect(config.footer.first.props['label'], 'Continue');
    });
  });

  group('WidgetRegistry', () {
    testWidgets('renders registered types and hides invisible nodes', (tester) async {
      final registry = WidgetRegistry.instance;
      registerDefaultWidgets(registry);

      final form = DynamicFormController();
      final scope = DynamicUiScope(
        flags: const FeatureFlags(flags: {'SHOW': true}),
        form: form,
        onAction: (_, __, ___) {},
        data: const {'rider': {'name': 'Arjun'}},
      );

      final nodes = [
        UiNode.fromJson({
          'type': 'text',
          'props': {'text': 'Hello {{rider.name}}'},
        }),
        UiNode.fromJson({
          'type': 'text',
          'props': {'text': 'Never shown'},
          'visibleWhen': {'flag': 'MISSING_FLAG'},
        }),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: DynamicNodeList(nodes: nodes, scope: scope)),
        ),
      );

      expect(find.text('Hello Arjun'), findsOneWidget);
      expect(find.text('Never shown'), findsNothing);
    });

    testWidgets('an unknown type degrades instead of crashing', (tester) async {
      registerDefaultWidgets();
      final scope = DynamicUiScope(
        flags: FeatureFlags.empty,
        form: DynamicFormController(),
        onAction: (_, __, ___) {},
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: DynamicNodeList(
              nodes: [UiNode.fromJson({'type': 'someFutureComponent'})],
              scope: scope,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Unsupported component'), findsOneWidget);
    });

    testWidgets('a field in the same slot on the next step starts empty', (tester) async {
      registerDefaultWidgets();
      final form = DynamicFormController();
      final scope = DynamicUiScope(
        flags: FeatureFlags.empty,
        form: form,
        onAction: (_, __, ___) {},
      );
      UiNode field(String key) => UiNode.fromJson({
            'type': 'textField',
            'props': {'key': key, 'label': key},
          });

      Widget app(List<UiNode> nodes) => MaterialApp(
            theme: AppTheme.light,
            home: Scaffold(body: DynamicNodeList(nodes: nodes, scope: scope)),
          );

      await tester.pumpWidget(app([field('FULL_NAME')]));
      await tester.enterText(find.byType(TextField), 'Ravi Kumar');
      expect(form.valueOf('FULL_NAME'), 'Ravi Kumar');

      await tester.pumpWidget(app([field('AADHAAR_NUMBER')]));
      await tester.pump();

      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
      expect(form.valueOf('AADHAAR_NUMBER'), isNull);
    });
  });

  group('Fmt', () {
    test('formats rupees and masks identifiers', () {
      expect(Fmt.money(1284), contains('1,284'));
      expect(Fmt.maskAadhaar('123456789012'), 'XXXX XXXX 9012');
      expect(Fmt.maskAccount('50100123454471'), endsWith('4471'));
      expect(Fmt.phone('9876543210'), '+91 98765 43210');
      expect(Fmt.duration(const Duration(minutes: 392)), '6h 32m');
    });
  });
}
