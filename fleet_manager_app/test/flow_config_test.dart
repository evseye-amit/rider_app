import 'dart:convert';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UiFlowConfig deallocation;
  late FeatureFlags flags;

  UiFlowConfig load(String name) => UiFlowConfig.fromJson(
        json.decode(File('assets/config/$name.json').readAsStringSync())
            as Map<String, dynamic>,
      );

  setUpAll(() {
    deallocation = load('deallocation_flow');
    flags = FeatureFlags.fromJson(
      json.decode(File('assets/config/package_features.json').readAsStringSync())
          as Map<String, dynamic>,
    );
  });

  List<String> visibleFields(UiFlowStep step, FeatureFlags f) {
    final scope = DynamicUiScope(
      flags: f,
      form: DynamicFormController(),
      onAction: (_, __, ___) {},
    );
    final out = <String>[];
    void walk(List<UiNode> nodes) {
      for (final node in nodes) {
        if (!scope.isVisible(node)) continue;
        if (node.validations.isNotEmpty || node.props.containsKey('key')) out.add(node.fieldKey);
        walk(node.children);
      }
    }

    walk(step.screen.body);
    return out;
  }

  test('the return flow has the steps the spec describes', () {
    expect(deallocation.steps.map((s) => s.key), ['photos', 'assessment', 'verification']);
  });

  test('every component type the document uses is registered', () {
    registerDefaultWidgets();
    final registry = WidgetRegistry.instance;
    final missing = <String>{};
    void walk(List<UiNode> nodes) {
      for (final n in nodes) {
        if (!registry.contains(n.type)) missing.add(n.type);
        walk(n.children);
      }
    }

    for (final step in deallocation.steps) {
      walk(step.screen.body);
      walk(step.screen.footer);
    }
    expect(missing, isEmpty, reason: 'unregistered types: $missing');
  });

  test('de-allocation requires both OTPs, and dropping a flag drops one', () {
    final verification = deallocation.steps.firstWhere((s) => s.key == 'verification');
    expect(visibleFields(verification, flags), containsAll(['riderOtp', 'teamLeadOtp']));

    final noTlOtp = flags.withOverride('TEAM_LEAD_OTP', false);
    final fields = visibleFields(verification, noTlOtp);
    expect(fields, contains('riderOtp'));
    expect(fields, isNot(contains('teamLeadOtp')));
  });

  test('damage fields appear only once the vehicle is marked damaged', () {
    final assessment = deallocation.steps.firstWhere((s) => s.key == 'assessment');
    final form = DynamicFormController();
    final scope = DynamicUiScope(flags: flags, form: form, onAction: (_, __, ___) {});

    List<String> fields() {
      final out = <String>[];
      void walk(List<UiNode> nodes) {
        for (final n in nodes) {
          if (!scope.isVisible(n)) continue;
          if (n.props.containsKey('key')) out.add(n.fieldKey);
          walk(n.children);
        }
      }

      walk(assessment.screen.body);
      return out;
    }

    expect(fields(), isNot(contains('damageNotes')));
    form.setValue('condition', 'damaged');
    expect(fields(), containsAll(['damageNotes', 'recoveryAmount']));

    form.setValue('condition', 'good');
    expect(fields(), isNot(contains('damageNotes')));
    form.validateNodes(assessment.screen.body, isVisible: scope.isVisible);
    expect(form.errors.containsKey('damageNotes'), isFalse);
  });
}
