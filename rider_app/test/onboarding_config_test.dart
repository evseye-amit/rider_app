import 'dart:convert';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UiFlowConfig flow;
  late FeatureFlags shippedFlags;

  setUpAll(() {
    flow = UiFlowConfig.fromJson(
      json.decode(File('assets/config/onboarding_flow.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    shippedFlags = FeatureFlags.fromJson(
      json.decode(File('assets/config/package_features.json').readAsStringSync())
          as Map<String, dynamic>,
    );
  });

  List<String> visibleFields(UiFlowStep step, FeatureFlags flags) {
    final form = DynamicFormController();
    final scope = DynamicUiScope(flags: flags, form: form, onAction: (_, __, ___) {});
    final out = <String>[];
    void walk(List<UiNode> nodes) {
      for (final node in nodes) {
        if (!scope.isVisible(node)) continue;
        if (node.validations.isNotEmpty || node.props.containsKey('key')) {
          out.add(node.fieldKey);
        }
        walk(node.children);
      }
    }

    walk(step.screen.body);
    return out;
  }

  UiFlowStep stepFor(String key) => flow.steps.firstWhere((s) => s.key == key);

  test('the shipped flow has the six steps the spec describes', () {
    expect(
      flow.steps.map((s) => s.key),
      ['profile', 'kyc', 'compliance', 'commercials', 'training', 'agreement'],
    );
    for (final step in flow.steps) {
      expect(step.screen.body, isNotEmpty, reason: 'step ${step.key} has no body');
      expect(step.screen.footer, isNotEmpty, reason: 'step ${step.key} has no footer action');
    }
  });

  test('every component type the documents use is registered', () {
    registerDefaultWidgets();
    final registry = WidgetRegistry.instance;
    final missing = <String>{};
    void walk(List<UiNode> nodes) {
      for (final n in nodes) {
        if (!registry.contains(n.type)) missing.add(n.type);
        walk(n.children);
      }
    }

    for (final step in flow.steps) {
      walk(step.screen.body);
      walk(step.screen.footer);
    }
    expect(missing, isEmpty, reason: 'unregistered types: $missing');
  });

  test('turning PAN_VERIFICATION off removes the field and its validation', () {
    final kyc = stepFor('kyc');

    expect(visibleFields(kyc, shippedFlags), contains('panNumber'));

    final withoutPan = shippedFlags.withOverride(FeatureKeys.panVerification, false);
    expect(visibleFields(kyc, withoutPan), isNot(contains('panNumber')));

    final form = DynamicFormController();
    final scope = DynamicUiScope(flags: withoutPan, form: form, onAction: (_, __, ___) {});
    form.validateNodes(kyc.screen.body, isVisible: scope.isVisible);
    expect(form.errors.containsKey('panNumber'), isFalse);
  });

  test('a step can empty out entirely when its whole feature set is off', () {
    final compliance = stepFor('compliance');
    expect(visibleFields(compliance, shippedFlags), isNotEmpty);

    var off = shippedFlags;
    for (final key in [
      FeatureKeys.drivingLicenceVerification,
      FeatureKeys.drivingLicenceProofDocument,
      FeatureKeys.referenceCheck,
      FeatureKeys.emergencyContact,
      FeatureKeys.medicalDeclaration,
      FeatureKeys.medicalProofDocument,
    ]) {
      off = off.withOverride(key, false);
    }
    expect(visibleFields(compliance, off), isEmpty);
  });

  test('a value-driven condition reacts to what the rider answered', () {
    const condition = UiCondition(field: 'condition', equals: 'damaged');
    final form = DynamicFormController();
    final scope = DynamicUiScope(
      flags: shippedFlags,
      form: form,
      onAction: (_, __, ___) {},
    );

    bool visible() => condition.evaluate(
          isFlagEnabled: scope.flags.isEnabled,
          valueOf: form.valueOf,
        );

    expect(visible(), isFalse);
    form.setValue('condition', 'damaged');
    expect(visible(), isTrue);
  });

  test('required KYC fields carry the right format validators', () {
    final kyc = stepFor('kyc');
    final types = <String, List<String>>{};
    void walk(List<UiNode> nodes) {
      for (final n in nodes) {
        if (n.validations.isNotEmpty) {
          types[n.fieldKey] = n.validations.map((v) => v.type).toList();
        }
        walk(n.children);
      }
    }

    walk(kyc.screen.body);
    expect(types['aadhaarNumber'], containsAll(['required', 'aadhaar']));
    expect(types['panNumber'], containsAll(['required', 'pan']));
  });
}
