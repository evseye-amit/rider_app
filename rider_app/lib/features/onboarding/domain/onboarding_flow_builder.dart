import 'package:evseye_core/evseye_core.dart';

abstract final class OnboardingFlowBuilder {
  const OnboardingFlowBuilder._();

  static UiFlowConfig build(RiderOnboardingConfig config) {
    final List<OnboardingStepConfig> steps = config.steps;
    return UiFlowConfig(
      id: 'rider_onboarding',
      title: 'Rider onboarding',
      meta: {'packageCode': config.packageCode, 'packageName': config.packageName, 'submitLabel': 'Submit application'},
      steps: [
        for (int i = 0; i < steps.length; i++) _step(steps[i], isLast: i == steps.length - 1),
      ],
    );
  }

  static UiFlowStep _step(OnboardingStepConfig step, {required bool isLast}) {
    final List<UiNode> body = [];

    final List<UiNode> inputs = [for (final f in step.inputs) _input(f)];
    if (inputs.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'title': 'Your details', 'icon': _icon(step.stepCode), 'gap': 18}, children: inputs));
    }

    final List<UiNode> uploads = [for (final f in step.uploads) _upload(f)];
    if (uploads.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'title': 'Documents', 'icon': 'upload', 'gap': 14}, children: uploads));
    }

    final List<UiNode> capabilities = [for (final f in step.capabilities) ..._capability(f)];
    if (capabilities.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'title': _capabilityTitle(step.stepCode), 'icon': 'verified', 'gap': 14}, children: capabilities));
    }

    if (body.isEmpty) {
      body.add(const UiNode(
        type: 'banner',
        props: {
          'title': 'Nothing to fill in here',
          'message': 'This step is handled by your fleet operator. Continue to the next one.',
          'tone': 'info',
          'icon': 'info',
        },
      ));
    }

    return UiFlowStep(
      key: step.stepCode,
      label: step.stepName,
      shortLabel: _shortLabel(step.stepCode, step.stepName),
      icon: _icon(step.stepCode),
      screen: UiScreenConfig(
        id: 'onboarding_${step.stepCode.toLowerCase()}',
        title: step.stepName,
        subtitle: step.description,
        body: body,
        footer: [
          UiNode(
            type: 'primaryButton',
            props: {'label': isLast ? 'Review application' : 'Continue', 'icon': isLast ? 'checklist' : 'arrowForward'},
            action: const UiAction(type: 'next'),
          ),
        ],
      ),
    );
  }


  static bool _expectsFutureDate(String code) {
    final String c = code.toUpperCase();
    return c.contains('EXPIR') ||
        c.contains('VALID') ||
        c.contains('RENEW') ||
        c.contains('DUE');
  }

  static UiNode _input(OnboardingFieldConfig f) {
    final List<ValidationRule> rules = _rules(f);
    final Map<String, dynamic> props = {
      'key': f.fieldCode,
      'label': f.label,
      if (f.placeholder != null) 'hint': f.placeholder,
      if (f.description != null && f.description!.isNotEmpty) 'helper': f.description,
    };

    switch (f.fieldType) {
      case 'BANK_ACCOUNT':
        return UiNode(
          type: 'bankAccountField',
          id: f.fieldCode,
          props: {...props},
          validations: rules,
        );
      case 'REFERENCE':
        return UiNode(
          type: 'referenceField',
          id: f.fieldCode,
          props: {...props, 'minCount': 1, 'maxCount': 3},
          validations: rules,
        );
      case 'NOMINEE':
        return UiNode(
          type: 'nomineeField',
          id: f.fieldCode,
          props: {...props, 'maxCount': 4},
          validations: rules,
        );
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
              const ValidationRule(
                type: 'futureDate',
                message: 'This document has expired. Enter a date later than today.',
              ),
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
            'options': [for (final o in f.options) {'value': o, 'label': o}],
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

  static List<ValidationRule> _rules(OnboardingFieldConfig f) => [
        if (f.required) ValidationRule(type: 'required', message: '${f.label} is required'),
        if (f.fieldType == 'MOBILE') const ValidationRule(type: 'mobile'),
        if (f.minLength != null) ValidationRule(type: 'minLength', value: f.minLength),
        if (f.maxLength != null) ValidationRule(type: 'maxLength', value: f.maxLength),
        if (f.pattern != null && f.fieldType != 'MOBILE')
          ValidationRule(type: 'pattern', value: f.pattern, message: 'Enter a valid ${f.label}'),
      ];

  static UiNode _upload(OnboardingFieldConfig f) {
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
        'required': true,
      },
      action: const UiAction(type: 'pickFile'),
      validations: [ValidationRule(type: 'required', message: 'Add your ${f.label.toLowerCase()}')],
    );
  }

  static List<UiNode> _capability(OnboardingFieldConfig f) {
    final String code = f.featureCode;
    if (code.contains('AGREEMENT') || code.contains('E_SIGN')) {
      return [
        const UiNode(
          type: 'termsBlock',
          props: {
            'body': 'This agreement is between you and your fleet operator. It covers the vehicle you are '
                'handed, how it may be used, your responsibility for its care, the deposits and fees on '
                'your plan, and how the arrangement ends. Read it fully before you accept. By ticking '
                'the box below you confirm that you have read and agree to be bound by the rider '
                'agreement and the operator\'s rider policies.',
            'maxHeight': 200,
          },
        ),
        UiNode(
          type: 'checkbox',
          id: f.formKey,
          props: {'key': f.formKey, 'label': 'I have read and agree to the rider agreement'},
          validations: const [ValidationRule(type: 'required', message: 'Accept the agreement to continue')],
        ),
      ];
    }
    if (code.contains('TRAINING')) {
      return [
        UiNode(
          type: 'banner',
          props: {
            'title': f.label,
            'message': 'Your safety training opens once a scooter has been allocated to you. '
                'You will watch it in the app before the handover is completed.',
            'tone': 'info',
            'icon': 'school',
          },
        ),
      ];
    }
    if (code.contains('VERIFICATION')) {
      return [
        UiNode(
          type: 'banner',
          props: {
            'title': f.label,
            'message': f.description?.isNotEmpty == true
                ? f.description
                : 'Verified by your fleet operator against the details and documents you provide.',
            'tone': 'success',
            'icon': 'verified',
          },
        ),
      ];
    }
    return [
      UiNode(
        type: 'banner',
        props: {
          'title': f.label,
          'message': f.description?.isNotEmpty == true
              ? f.description
              : 'Collected by your team lead at the hub when you come in for your scooter.',
          'tone': 'info',
          'icon': _inputIcon(code),
        },
      ),
    ];
  }

  static String _shortLabel(String stepCode, String name) => switch (stepCode) {
        'RIDER_PERSONAL_PROFILE' => 'Profile',
        'RIDER_KYC' => 'KYC',
        'RIDER_COMPLIANCE_ELIGIBILITY' => 'Eligibility',
        'RIDER_COMMERCIALS' => 'Payments',
        'RIDER_TRAINING' => 'Training',
        'RIDER_AGREEMENT_ESIGN' => 'Agreement',
        'RIDER_REVIEW_SUBMIT' => 'Review',
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

  static String _capabilityTitle(String stepCode) => switch (stepCode) {
        'RIDER_AGREEMENT_ESIGN' => 'Rider agreement',
        'RIDER_TRAINING' => 'Training',
        _ => 'Also part of this step',
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
