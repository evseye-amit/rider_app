import '../utils/result.dart';
import 'api_client.dart';
import 'api_env.dart';

class OnboardingFieldConfig {
  const OnboardingFieldConfig({
    required this.featureCode,
    required this.fieldCode,
    required this.storageKey,
    required this.fieldName,
    required this.label,
    required this.fieldType,
    required this.required,
    required this.readOnly,
    required this.disabled,
    required this.editable,
    required this.isUpload,
    required this.sequence,
    this.description,
    this.placeholder,
    this.dataType,
    this.validation = const {},
    this.configuration = const {},
  });

  factory OnboardingFieldConfig.fromJson(Map<String, dynamic> json) => OnboardingFieldConfig(
        featureCode: json['featureCode']?.toString() ?? '',
        fieldCode: json['fieldCode']?.toString() ?? '',
        storageKey: json['storageKey']?.toString() ?? '',
        fieldName: json['fieldName']?.toString() ?? '',
        label: json['label']?.toString() ?? json['fieldName']?.toString() ?? '',
        description: json['description']?.toString(),
        placeholder: json['placeholder']?.toString(),
        fieldType: (json['fieldType']?.toString() ?? 'TEXT').toUpperCase(),
        dataType: json['dataType']?.toString(),
        required: json['required'] == true,
        readOnly: json['readOnly'] == true,
        disabled: json['disabled'] == true,
        editable: json['editable'] != false,
        isUpload: json['isUpload'] == true,
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        validation: Map<String, dynamic>.from(json['validation'] as Map? ?? const {}),
        configuration: Map<String, dynamic>.from(json['configuration'] as Map? ?? const {}),
      );

  final String featureCode;

  final String fieldCode;
  final String storageKey;
  final String fieldName;
  final String label;
  final String? description;
  final String? placeholder;

  final String fieldType;

  final String? dataType;
  final bool required;
  final bool readOnly;
  final bool disabled;
  final bool editable;
  final bool isUpload;
  final int sequence;

  final Map<String, dynamic> validation;

  final Map<String, dynamic> configuration;

  bool get isInput => fieldCode.isNotEmpty;
  bool get isCapability => !isInput && !isUpload;

  bool get isEnabled => editable && !readOnly && !disabled;

  String get formKey => isInput ? fieldCode : (isUpload ? 'upload:$featureCode' : 'feature:$featureCode');

  int? get minLength => (validation['minLength'] as num?)?.toInt();
  int? get maxLength => (validation['maxLength'] as num?)?.toInt();
  String? get pattern => validation['pattern']?.toString();

  List<String> get options {
    final Object? raw = validation['allowedValues'] ?? configuration['options'];
    return raw is List ? raw.map((e) => e.toString()).toList(growable: false) : const [];
  }

  List<String> get allowedFileTypes {
    final Object? raw = configuration['allowedFileTypes'];
    return raw is List ? raw.map((e) => e.toString().toUpperCase()).toList(growable: false) : const [];
  }

  int? get maxFileSizeMb => (configuration['maxFileSizeMB'] as num?)?.toInt();
  int get minFiles => (configuration['minFiles'] as num?)?.toInt() ?? 1;
}

class OnboardingStepConfig {
  const OnboardingStepConfig({
    required this.stepId,
    required this.stepCode,
    required this.stepName,
    required this.sequence,
    required this.enabled,
    required this.fields,
    this.description,
  });

  factory OnboardingStepConfig.fromJson(Map<String, dynamic> json) => OnboardingStepConfig(
        stepId: json['stepId']?.toString() ?? '',
        stepCode: json['stepCode']?.toString() ?? '',
        stepName: json['stepName']?.toString() ?? '',
        description: json['description']?.toString(),
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        enabled: json['enabled'] != false && json['active'] != false,
        fields: (json['fields'] as List<dynamic>? ?? const [])
            .map((e) => OnboardingFieldConfig.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(growable: false),
      );

  final String stepId;

  final String stepCode;
  final String stepName;
  final String? description;
  final int sequence;
  final bool enabled;
  final List<OnboardingFieldConfig> fields;

  Iterable<OnboardingFieldConfig> get inputs => fields.where((f) => f.isInput);
  Iterable<OnboardingFieldConfig> get uploads => fields.where((f) => f.isUpload);
  Iterable<OnboardingFieldConfig> get capabilities => fields.where((f) => f.isCapability);
}

class OnboardingProgress {
  const OnboardingProgress({
    required this.currentStepId,
    required this.completedStepIds,
    required this.skippedStepIds,
    required this.values,
    required this.completed,
  });

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) => OnboardingProgress(
        currentStepId: json['currentStepId']?.toString(),
        completedStepIds: _strings(json['completedStepIds']),
        skippedStepIds: _strings(json['skippedStepIds']),
        values: Map<String, Object?>.from(json['values'] as Map? ?? const {}),
        completed: json['completed'] == true,
      );

  static const OnboardingProgress empty = OnboardingProgress(
    currentStepId: null,
    completedStepIds: [],
    skippedStepIds: [],
    values: {},
    completed: false,
  );

  final String? currentStepId;
  final List<String> completedStepIds;
  final List<String> skippedStepIds;

  final Map<String, Object?> values;
  final bool completed;

  bool isDone(String stepId) => completedStepIds.contains(stepId) || skippedStepIds.contains(stepId);

  static List<String> _strings(Object? raw) =>
      raw is List ? raw.map((e) => e.toString()).toList(growable: false) : const [];
}

class RiderOnboardingConfig {
  const RiderOnboardingConfig({
    required this.packageId,
    required this.packageCode,
    required this.packageName,
    required this.steps,
    required this.progress,
  });

  factory RiderOnboardingConfig.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> pkg = Map<String, dynamic>.from(json['package'] as Map? ?? const {});
    final Map<String, dynamic> onboarding =
        Map<String, dynamic>.from(json['onboarding'] as Map? ?? const {});
    final List<OnboardingStepConfig> steps = (onboarding['steps'] as List<dynamic>? ?? const [])
        .map((e) => OnboardingStepConfig.fromJson(Map<String, dynamic>.from(e as Map)))
        .where((s) => s.enabled)
        .toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    return RiderOnboardingConfig(
      packageId: pkg['id']?.toString() ?? '',
      packageCode: pkg['code']?.toString() ?? '',
      packageName: pkg['name']?.toString() ?? '',
      steps: List<OnboardingStepConfig>.unmodifiable(steps),
      progress: json['progress'] == null
          ? OnboardingProgress.empty
          : OnboardingProgress.fromJson(Map<String, dynamic>.from(json['progress'] as Map)),
    );
  }

  final String packageId;
  final String packageCode;
  final String packageName;
  final List<OnboardingStepConfig> steps;
  final OnboardingProgress progress;

  bool get isComplete => progress.completed;

  int get resumeIndex {
    final String? id = progress.currentStepId;
    if (id != null) {
      final int i = steps.indexWhere((s) => s.stepId == id);
      if (i >= 0) return i;
    }
    return steps.isEmpty ? 0 : steps.length - 1;
  }

  Set<String> get fieldCodes => {for (final s in steps) for (final f in s.inputs) f.fieldCode};

  String? value(String fieldCode) {
    final Object? v = progress.values[fieldCode];
    if (v == null) return null;
    final String s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}

class RiderEnrollment {
  const RiderEnrollment({required this.clientId, required this.userId, required this.phone});

  factory RiderEnrollment.fromJson(Map<String, dynamic> json) => RiderEnrollment(
        clientId: json['clientId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
      );

  final String clientId;
  final String userId;
  final String phone;
}

class RiderAppApi {
  const RiderAppApi(this._client);

  final ApiClient _client;

  Future<Result<RiderEnrollment>> enroll(String mobile, {String? companyCode}) {
    return _client.post<RiderEnrollment>(
      '/rider-app/enroll',
      skipAuth: true,
      body: {
        'phone': _normalise(mobile),
        'companyCode': companyCode ?? ApiEnv.companyCode,
      },
      parse: (data) => RiderEnrollment.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  Future<Result<RiderOnboardingConfig>> onboarding() => _client.get<RiderOnboardingConfig>(
        '/rider-app/onboarding',
        parse: (data) => RiderOnboardingConfig.fromJson(Map<String, dynamic>.from(data as Map)),
      );

  Future<Result<RiderOnboardingConfig>> saveStep(String stepId, Map<String, Object?> values) {
    return _client.post<RiderOnboardingConfig>(
      '/rider-app/onboarding/steps',
      body: {'stepId': stepId, 'values': values},
      parse: (data) => RiderOnboardingConfig.fromJson(Map<String, dynamic>.from(data as Map)),
    );
  }

  static String _normalise(String mobile) {
    final String digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) return digits.substring(digits.length - 10);
    return digits;
  }
}
