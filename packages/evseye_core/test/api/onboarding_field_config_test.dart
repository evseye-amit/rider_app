import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads onboarding placeholder from configuration', () {
    final OnboardingFieldConfig field = OnboardingFieldConfig.fromJson({
      'featureCode': 'CAPTURE_FULL_NAME',
      'fieldCode': 'FULL_NAME',
      'placeholder': 'Legacy top-level placeholder',
      'configuration': {'placeholder': 'Enter your full name'},
    });

    expect(field.placeholder, 'Enter your full name');
  });

  test('does not accept a top-level onboarding placeholder', () {
    final OnboardingFieldConfig field = OnboardingFieldConfig.fromJson({
      'featureCode': 'CAPTURE_FULL_NAME',
      'fieldCode': 'FULL_NAME',
      'placeholder': 'Legacy top-level placeholder',
      'configuration': <String, Object?>{},
    });

    expect(field.placeholder, isNull);
  });
}
