import 'package:evseye_core/evseye_core.dart';

abstract final class OnboardingFlowBuilder {
  const OnboardingFlowBuilder._();

  static UiFlowConfig build(RiderOnboardingConfig config, AppL10n l10n) {
    final List<OnboardingStepConfig> steps = config.steps;
    return UiFlowConfig(
      id: 'rider_onboarding',
      title: l10n.onboardingRiderOnboarding,
      meta: {
        'packageCode': config.packageCode,
        'packageName': config.packageName,
        'submitLabel': l10n.onboardingSubmitApplication,
      },
      steps: [for (int i = 0; i < steps.length; i++) _step(steps[i], isLast: i == steps.length - 1, l10n: l10n)],
    );
  }

  static UiFlowStep _step(OnboardingStepConfig step, {required bool isLast, required AppL10n l10n}) {
    final List<UiNode> body = [];

    final List<UiNode> inputs = [for (final f in step.inputs) _input(f, l10n)];
    if (inputs.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'gap': 18}, children: inputs));
    }

    final List<UiNode> uploads = [for (final f in step.uploads) _upload(f, l10n)];
    if (uploads.isNotEmpty) {
      body.add(
        UiNode(
          type: 'group',
          props: {'title': l10n.onboardingDocuments, 'icon': 'upload', 'gap': 14},
          children: uploads,
        ),
      );
    }

    final List<UiNode> capabilities = [for (final f in step.capabilities) ..._capability(f, l10n)];
    if (capabilities.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'gap': 14}, children: capabilities));
    }

    if (body.isEmpty) {
      body.add(
        UiNode(
          type: 'banner',
          props: {
            'title': l10n.onboardingNothingToFillHere,
            'message': l10n.onboardingStepHandledByOperator,
            'tone': 'info',
            'icon': 'info',
          },
        ),
      );
    }

    return UiFlowStep(
      key: step.stepCode,
      label: step.stepName,
      shortLabel: _shortLabel(step.stepCode, step.stepName, l10n),
      icon: _icon(step.stepCode),
      screen: UiScreenConfig(
        id: 'onboarding_${step.stepCode.toLowerCase()}',
        title: step.stepName,
        subtitle: step.description,
        body: body,
        footer: [
          UiNode(
            type: 'primaryButton',
            props: {
              'label': isLast ? l10n.onboardingReviewApplication : l10n.authContinue,
              'icon': isLast ? 'checklist' : 'arrowForward',
            },
            action: const UiAction(type: 'next'),
          ),
        ],
      ),
    );
  }

  static bool _expectsFutureDate(String code) {
    final String c = code.toUpperCase();
    return c.contains('EXPIR') || c.contains('VALID') || c.contains('RENEW') || c.contains('DUE');
  }

  static UiNode _input(OnboardingFieldConfig f, AppL10n l10n) {
    final List<ValidationRule> rules = _rules(f, l10n);
    final Map<String, dynamic> props = {
      'key': f.fieldCode,
      'label': f.label,
      if (f.placeholder != null) 'hint': f.placeholder,
    };

    switch (f.fieldType) {
      case 'BANK_ACCOUNT':
        return UiNode(type: 'bankAccountField', id: f.fieldCode, props: {...props}, validations: rules);
      case 'REFERENCE':
        return UiNode(
          type: 'referenceField',
          id: f.fieldCode,
          props: {...props, 'minCount': 1, 'maxCount': 3},
          validations: rules,
        );
      case 'NOMINEE':
        return UiNode(type: 'nomineeField', id: f.fieldCode, props: {...props, 'maxCount': 4}, validations: rules);
      case 'MOBILE':
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {...props, 'prefixText': '+91', 'keyboard': 'phone', 'maxLength': 10, 'icon': 'phone'},

          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: rules,
        );
      case 'DATE':
        final bool future = _expectsFutureDate(f.fieldCode);
        return UiNode(
          type: 'dateField',
          id: f.fieldCode,
          props: {...props, 'hint': 'DD / MM / YYYY', if (future) 'future': true},
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: [
            ...rules,
            if (future && !rules.any((r) => r.type == 'futureDate'))
              ValidationRule(type: 'futureDate', message: l10n.onboardingDocumentHasExpiredEnterDate),
          ],
        );
      case 'TEXTAREA':
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {...props, 'maxLines': 3, if (f.maxLength != null) 'maxLength': f.maxLength, 'icon': 'home'},
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: rules,
        );
      case 'NUMBER':
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {...props, 'keyboard': 'number', if (f.maxLength != null) 'maxLength': f.maxLength},
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: rules,
        );
      case 'SELECT':
      case 'DROPDOWN':
        return UiNode(
          type: 'pickerField',
          id: f.fieldCode,
          props: {
            ...props,
            'options': [
              for (final o in f.options) {'value': o, 'label': o},
            ],
          },
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: rules,
        );
      default:
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {
            ...props,
            if (f.maxLength != null) 'maxLength': f.maxLength,
            'icon': _inputIcon(f.fieldCode),

            if (_upperCase(f.fieldCode)) 'caps': true,
          },
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
          validations: rules,
        );
    }
  }

  static List<ValidationRule> _rules(OnboardingFieldConfig f, AppL10n l10n) => [
    if (f.required) ValidationRule(type: 'required', message: '${f.label} is required'),
    if (f.fieldType == 'MOBILE') const ValidationRule(type: 'mobile'),
    if (f.minLength != null) ValidationRule(type: 'minLength', value: f.minLength),
    if (f.maxLength != null) ValidationRule(type: 'maxLength', value: f.maxLength),
    if (f.pattern != null && f.fieldType != 'MOBILE')
      ValidationRule(type: 'pattern', value: f.pattern, message: l10n.onboardingEnterValidField(f.label)),
  ];

  static UiNode _upload(OnboardingFieldConfig f, AppL10n l10n) {
    final List<String> types = f.allowedFileTypes;
    final int? maxMb = f.maxFileSizeMb;
    final String hint = [
      if (types.isNotEmpty) types.join(', '),
      if (maxMb != null) 'up to $maxMb MB',
      if (f.minFiles > 1) '${f.minFiles} files',
    ].join(' · ');
    return UiNode(
      type: 'upload',
      id: f.formKey,
      props: {
        'key': f.formKey,
        'label': f.label,
        if (hint.isNotEmpty) 'hint': hint,
        'featureCode': f.featureCode,
        'fieldCode': f.fieldCode.isEmpty ? f.featureCode : f.fieldCode,
        'required': f.required,
      },
      action: const UiAction(type: 'pickFile'),
      validations: [
        if (f.required) ValidationRule(type: 'required', message: l10n.onboardingAddYourField(f.label.toLowerCase())),
      ],
    );
  }

  static List<UiNode> _capability(OnboardingFieldConfig f, AppL10n l10n) {
    final String code = f.featureCode;

    if (code.contains('CAPTURE_REFERENCE')) {
      final int minCount = (f.configuration['minReferences'] as num?)?.toInt() ?? 1;
      final int configured = (f.configuration['maxReferences'] as num?)?.toInt() ?? 3;
      return [
        UiNode(
          type: 'referenceField',
          id: f.formKey,
          props: {
            'key': f.formKey,
            'label': f.configuration['label']?.toString() ?? l10n.onboardingReferences,
            'minCount': minCount,
            'maxCount': configured < minCount ? minCount : configured,
          },
          validations: [if (f.required) ValidationRule(type: 'required', message: l10n.onboardingAddLeastOneReference)],
        ),
      ];
    }

    if (code.contains('AGREEMENT') || code.contains('E_SIGN')) {
      return [
        UiNode(type: 'termsBlock', props: {'body': l10n.onboardingAgreementBody, 'maxHeight': 200}),
        UiNode(
          type: 'checkbox',
          id: f.formKey,
          props: {'key': f.formKey, 'label': l10n.onboardingAgreeToRiderAgreement},
          validations: [ValidationRule(type: 'required', message: l10n.onboardingAcceptAgreementContinue)],
        ),
      ];
    }
    return const [];
  }

  static String _shortLabel(String stepCode, String name, AppL10n l10n) => switch (stepCode) {
    'RIDER_PERSONAL_PROFILE' => l10n.commonProfile,
    'RIDER_KYC' => 'KYC',
    'RIDER_COMPLIANCE_ELIGIBILITY' => l10n.onboardingStepEligibility,
    'RIDER_COMMERCIALS' => l10n.walletPayments,
    'RIDER_TRAINING' => l10n.onboardingStepTraining,
    'RIDER_AGREEMENT_ESIGN' => l10n.onboardingStepAgreement,
    'RIDER_REVIEW_SUBMIT' => ActiveLocale.strings.onboardingReview,
    _ => name.split(RegExp(r'\s+')).first,
  };

  static String _icon(String stepCode) => switch (stepCode) {
    'RIDER_PERSONAL_PROFILE' => 'person',
    'RIDER_KYC' => 'badge',
    'RIDER_COMPLIANCE_ELIGIBILITY' => 'verified',
    'RIDER_COMMERCIALS' => 'wallet',
    'RIDER_TRAINING' => 'school',
    'RIDER_AGREEMENT_ESIGN' => 'edit',
    _ => 'checklist',
  };

  static String _inputIcon(String code) {
    final String c = code.toUpperCase();
    if (c.contains('NAME')) return 'person';
    if (c.contains('AADHAAR') || c.contains('AADHAR')) return 'badge';
    if (c.contains('PAN')) return 'badge';
    if (c.contains('ADDRESS')) return 'home';
    if (c.contains('BANK')) return 'wallet';
    if (c.contains('LICENSE') || c.contains('LICENCE')) return 'badge';
    if (c.contains('REFERENCE') || c.contains('EMERGENCY')) return 'person';
    if (c.contains('MEDICAL')) return 'health';
    return 'edit';
  }

  static bool _upperCase(String fieldCode) => fieldCode.contains('PAN') || fieldCode.contains('LICEN');
}
