import 'package:evseye_core/evseye_core.dart';

abstract final class OnboardingFlowBuilder {
  const OnboardingFlowBuilder._();

  static const String referralCodeKey = 'REFERRAL_CODE';
  static const String referralAppliedKey = 'REFERRAL_CODE_APPLIED';
  static const String referralLockedKey = 'REFERRAL_CODE_LOCKED';
  static const String bankIfscKey = 'RIDER_BANK_IFSC';
  static const String bankIfscVerifiedKey = 'RIDER_BANK_IFSC_VERIFIED';
  static const String bankIfscCheckedKey = 'RIDER_BANK_IFSC_CHECKED';
  static const String bankIfscNoteKey = 'RIDER_BANK_IFSC_NOTE';
  static const String bankNameKey = 'RIDER_BANK_NAME';
  static const String bankBranchKey = 'RIDER_BANK_BRANCH';
  static const String bankCityKey = 'RIDER_BANK_CITY';
  static const String bankStateKey = 'RIDER_BANK_STATE';
  static const String bankAccountKey = 'RIDER_BANK_ACCOUNT';
  static const String bankProofCode = 'BANK_PROOF_DOCUMENT';
  static const String sameAddressKey = 'SAME_AS_CURRENT_ADDRESS';
  static const String permanentAddressPrefix = 'PERMANENT_ADDRESS';

  static const Map<String, String> bankFieldCodes = {
    'BANK_ACCOUNT_NUMBER': bankAccountKey,
    'REPEAT_BANK_ACCOUNT_NUMBER': '${bankAccountKey}__confirm',
    'IFSC_CODE': bankIfscKey,
    'IFSC': bankIfscKey,
    'BANK_NAME': bankNameKey,
    'BANK_BRANCH': bankBranchKey,
    'BANK_CITY': bankCityKey,
    'BANK_STATE': bankStateKey,
  };

  static const Set<String> _bankFeatures = {'CAPTURE_BANK_ACCOUNT', 'BANK_VERIFICATION', bankProofCode};

  static bool isBankStep(OnboardingStepConfig step) =>
      step.fields.any((field) => _bankFeatures.contains(field.featureCode));

  static bool isReferenceList(OnboardingFieldConfig f) =>
      f.fieldType == 'REFERENCE' || f.featureCode.contains('CAPTURE_REFERENCE');

  static bool isNomineeList(OnboardingFieldConfig f) => f.fieldType == 'NOMINEE' || f.featureCode.contains('NOMINEE');

  static bool isAgeGate(OnboardingFieldConfig f) =>
      f.fieldType == 'AGE' || f.featureCode.contains('AGE_VERIFICATION') || f.featureCode.contains('VERIFY_AGE');

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
      steps: [
        for (int i = 0; i < steps.length; i++) _step(config, steps[i], isLast: i == steps.length - 1, l10n: l10n),
      ],
    );
  }

  static UiFlowStep _step(
    RiderOnboardingConfig config,
    OnboardingStepConfig step, {
    required bool isLast,
    required AppL10n l10n,
  }) {
    final List<UiNode> body = [];

    final List<OnboardingFieldConfig> rejected = [
      for (final f in step.uploads)
        if (config.document(f)?.isRejected ?? false) f,
    ];
    if (rejected.isNotEmpty) body.add(_rejectedBanner(rejected, l10n));

    final bool bank = isBankStep(step);
    final Set<String> seen = <String>{if (bank) ...bankFieldCodes.keys};
    final List<OnboardingFieldConfig> fields = [
      for (final f in step.inputs)
        if (seen.add(f.fieldCode)) f,
    ];

    if (bank) {
      final int bankEnd = step.fields
          .where((f) => bankFieldCodes.containsKey(f.fieldCode))
          .fold(0, (end, f) => f.sequence > end ? f.sequence : end);
      body.addAll(
        _bankBody(
          config,
          step,
          l10n,
          extra: [
            for (final f in fields)
              if (f.sequence <= bankEnd) _input(f, l10n),
          ],
        ),
      );
      final List<UiNode> rest = _inputs([
        for (final f in fields)
          if (f.sequence > bankEnd) f,
      ], l10n);
      if (rest.isNotEmpty) {
        body.add(UiNode(type: 'group', props: {'gap': 18}, children: rest));
      }
    } else {
      final List<UiNode> inputs = _inputs(fields, l10n);
      if (inputs.isNotEmpty) {
        body.add(UiNode(type: 'group', props: {'gap': 18}, children: inputs));
      }

      final List<UiNode> uploads = [for (final f in step.uploads) _upload(f, config.document(f), l10n)];
      if (uploads.isNotEmpty) {
        body.add(
          UiNode(
            type: 'group',
            props: {'title': l10n.onboardingDocuments, 'icon': 'upload', 'gap': 14},
            children: uploads,
          ),
        );
      }
    }

    final List<UiNode> capabilities = [for (final f in step.capabilities) ..._capability(f, l10n)];
    if (capabilities.isNotEmpty) {
      body.add(UiNode(type: 'group', props: {'gap': 14}, children: capabilities));
    }

    final List<UiNode> signatures = [for (final f in step.capabilities) ?_signature(f, l10n)];

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

    return _flowStep(step, body, signatures, isLast: isLast, l10n: l10n);
  }

  static UiFlowStep _flowStep(
    OnboardingStepConfig step,
    List<UiNode> body,
    List<UiNode> signatures, {
    required bool isLast,
    required AppL10n l10n,
  }) {
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
          ...signatures,
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

  static List<UiNode> _bankBody(
    RiderOnboardingConfig config,
    OnboardingStepConfig step,
    AppL10n l10n, {
    List<UiNode> extra = const [],
  }) {
    final List<OnboardingFieldConfig> proofs = step.uploads.toList(growable: false);
    return [
      UiNode(
        type: 'group',
        props: {'title': l10n.onboardingBankAccount, 'icon': 'wallet', 'gap': 18},
        children: [
          UiNode(
            type: 'bankIfscField',
            id: bankIfscKey,
            props: {
              'key': bankIfscKey,
              'checkedKey': bankIfscCheckedKey,
              'foundKey': bankIfscVerifiedKey,
              'noteKey': bankIfscNoteKey,
              'detailKeys': [bankNameKey, bankBranchKey, bankCityKey, bankStateKey],
            },
            action: const UiAction(type: 'lookupIfsc'),
            validations: [
              ValidationRule(type: 'required', message: l10n.onboardingBankIfscPending),
              const ValidationRule(type: 'ifsc'),
              ValidationRule(type: 'match', value: bankIfscCheckedKey, message: l10n.onboardingBankIfscPending),
            ],
          ),
          for (final (String key, String label, String icon) in [
            (bankNameKey, l10n.onboardingBankName, 'bank'),
            (bankBranchKey, l10n.onboardingBankBranch, 'home'),
            (bankCityKey, l10n.onboardingBankCity, 'location'),
            (bankStateKey, l10n.onboardingBankState, 'map'),
          ])
            UiNode(
              type: 'textField',
              id: key,
              props: {'key': key, 'label': label, 'icon': icon, 'maxLength': 100},
              visibleWhen: const UiCondition(field: bankIfscCheckedKey, isNotEmpty: true),
              validations: [ValidationRule(type: 'required', message: l10n.onboardingFieldRequired(label))],
            ),
          UiNode(
            type: 'bankAccountField',
            id: bankAccountKey,
            props: {'key': bankAccountKey},
            validations: [
              ValidationRule(type: 'required', message: l10n.onboardingBankAccountNeeded),
              ValidationRule(type: 'minLength', value: 9, message: l10n.onboardingBankAccountTooShort),
            ],
          ),
          ...extra,
        ],
      ),
      UiNode(
        type: 'group',
        props: {'title': l10n.onboardingDocuments, 'icon': 'upload', 'gap': 14},
        children: [
          if (proofs.isEmpty)
            UiNode(
              type: 'upload',
              id: bankProofCode,
              props: {
                'key': bankProofCode,
                'label': l10n.onboardingBankProof,
                'featureCode': bankProofCode,
                'fieldCode': bankProofCode,
                'required': false,
              },
              action: const UiAction(type: 'pickFile'),
            )
          else
            for (final OnboardingFieldConfig f in proofs) _upload(f, config.document(f), l10n),
        ],
      ),
    ];
  }

  static List<UiNode> _inputs(List<OnboardingFieldConfig> fields, AppL10n l10n) {
    bool permanent(OnboardingFieldConfig f) => f.fieldCode.startsWith(permanentAddressPrefix);
    final bool sameAddress = fields.any((f) => f.fieldCode == sameAddressKey && f.isCheckbox);
    final int at = fields.indexWhere(permanent);
    if (!sameAddress || at < 0) return [for (final f in fields) _input(f, l10n)];
    return [
      for (final f in fields.take(at)) _input(f, l10n),
      UiNode(
        type: 'group',
        props: {'gap': 18},
        visibleWhen: const UiCondition(field: sameAddressKey, isNotEmpty: false),
        children: [
          for (final f in fields)
            if (permanent(f)) _input(f, l10n),
        ],
      ),
      for (final f in fields.skip(at))
        if (!permanent(f)) _input(f, l10n),
    ];
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

    if (_isAadhaarNumber(f)) {
      return UiNode(
        type: 'textField',
        id: f.fieldCode,
        props: {...props, 'keyboard': 'number', 'maxLength': _aadhaarDigits, 'icon': _inputIcon(f.fieldCode)},
        enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
        validations: [
          ...rules,
          const ValidationRule(type: 'aadhaar'),
        ],
      );
    }

    if (f.fieldCode == referralCodeKey) {
      return UiNode(
        type: 'referralCode',
        id: f.fieldCode,
        props: {
          ...props,
          'icon': 'gift',
          'caps': true,
          'maxLength': _referralCodeLength,
          'appliedKey': referralAppliedKey,
          'lockedKey': referralLockedKey,
          'scan': true,
        },
        action: const UiAction(type: 'applyReferral'),
        enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
        validations: [
          ...rules,
          ValidationRule(type: 'match', value: referralAppliedKey, message: l10n.onboardingReferralTapApply),
        ],
      );
    }

    if (f.isCheckbox) {
      return UiNode(
        type: 'checkbox',
        id: f.fieldCode,
        props: {'key': f.fieldCode, 'label': f.label},
        enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
        validations: rules,
      );
    }

    if (isReferenceList(f)) {
      final int minReferences = (f.configuration['minReferences'] as num?)?.toInt() ?? 1;
      final int maxReferences = (f.configuration['maxReferences'] as num?)?.toInt() ?? 2;
      return UiNode(
        type: 'referenceField',
        id: f.fieldCode,
        props: {
          ...props,
          'minCount': minReferences,
          'maxCount': maxReferences < minReferences ? minReferences : maxReferences,
        },
        validations: rules,
      );
    }

    if (isNomineeList(f)) {
      final int maxNominees =
          ((f.configuration['maxNominees'] ?? f.configuration['maxReferences']) as num?)?.toInt() ?? 4;
      return UiNode(
        type: 'nomineeField',
        id: f.fieldCode,
        props: {...props, 'maxCount': maxNominees < 1 ? 1 : maxNominees},
        validations: rules,
      );
    }

    switch (f.fieldType) {
      case 'BANK_ACCOUNT':
        return UiNode(type: 'bankAccountField', id: f.fieldCode, props: {...props}, validations: rules);
      case 'EMAIL':
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {
            ...props,
            'keyboard': 'email',
            'caps': false,
            'icon': 'mail',
            if (f.maxLength != null) 'maxLength': f.maxLength,
          },
          enabledWhen: f.isEnabled ? null : const UiCondition(flag: '__NEVER__'),
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
              ValidationRule(type: 'futureDate', message: l10n.onboardingDocumentHasExpiredEnterDate),
          ],
        );
      case 'TEXTAREA':
        return UiNode(
          type: 'textField',
          id: f.fieldCode,
          props: {
            ...props,
            'maxLines': 3,
            if (f.maxLength != null) 'maxLength': f.maxLength,
            'icon': _inputIcon(f.fieldCode),
          },
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
              for (final choice in f.choices) {'value': choice.value, 'label': choice.label},
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
            if (_isHandle(f.fieldCode)) ...{'caps': false, 'keyboard': 'email'},
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

  static UiNode _rejectedBanner(List<OnboardingFieldConfig> fields, AppL10n l10n) => UiNode(
    type: 'banner',
    props: {
      'title': l10n.onboardingRejectedTitle,
      'message': l10n.onboardingRejectedMessage(fields.map((f) => f.label).join(', ')),
      'tone': 'danger',
      'icon': 'warning',
    },
    visibleWhen: UiCondition(anyOf: [for (final f in fields) UiCondition(field: f.formKey, isNotEmpty: false)]),
  );

  static UiNode _upload(OnboardingFieldConfig f, OnboardingDocument? document, AppL10n l10n) {
    final List<String> types = f.allowedFileTypes;
    final int? maxMb = f.maxFileSizeMb;
    final String hint = [
      if (types.isNotEmpty) types.join(', '),
      if (maxMb != null) 'up to $maxMb MB',
      if (f.minFiles > 1) '${f.minFiles} files',
    ].join(' · ');
    final bool rejected = document?.isRejected ?? false;
    return UiNode(
      type: 'upload',
      id: f.formKey,
      props: {
        'key': f.formKey,
        'label': f.label,
        if (hint.isNotEmpty) 'hint': hint,
        if (types.isNotEmpty) 'fileTypes': types,
        'maxFileSizeMb': ?maxMb,
        'featureCode': f.featureCode,
        'fieldCode': f.uploadCode,
        'required': f.required,
        if (rejected) 'rejected': document?.rejectionReason ?? '',
      },
      action: const UiAction(type: 'pickFile'),
      validations: [
        if (f.required || rejected)
          ValidationRule(type: 'required', message: l10n.onboardingAddYourField(f.label.toLowerCase())),
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

    if (f.isAgreement) {
      return [
        UiNode(type: 'termsBlock', props: {'body': l10n.onboardingAgreementBody, 'maxHeight': 200}),
      ];
    }
    return const [];
  }

  static UiNode? _signature(OnboardingFieldConfig f, AppL10n l10n) {
    if (!f.isAgreement) return null;
    return UiNode(
      type: 'esign',
      id: f.formKey,
      props: {'key': f.formKey, 'nameKey': 'FULL_NAME'},
      validations: [ValidationRule(type: 'required', message: l10n.onboardingSignAgreementContinue)],
    );
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
    if (c.contains('UPI')) return 'wallet';
    if (c.contains('EMAIL')) return 'mail';
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

  static bool _isHandle(String fieldCode) => fieldCode.contains('UPI') || fieldCode.contains('EMAIL');

  static const int _aadhaarDigits = 12;

  static const int _referralCodeLength = 12;

  static bool _isAadhaarNumber(OnboardingFieldConfig f) {
    final String code = '${f.fieldCode} ${f.featureCode}'.toUpperCase();
    return (code.contains('AADHAAR') || code.contains('AADHAR')) && !code.contains('NAME') && !code.contains('ADDRESS');
  }
}
