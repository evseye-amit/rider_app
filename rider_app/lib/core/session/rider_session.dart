import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import 'rider_stage.dart';

class RiderSession extends Equatable {
  RiderSession({
    this.stage = RiderStage.signedOut,
    this.user,
    FeatureFlags? flags,
    this.mobile = '',
    this.onboarding,
    this.deployment,
    this.present = false,
    this.vehicleOn = false,
    this.scooterPaired = false,
    this.pairing = false,
  }) : flags = flags ?? FeatureFlags.empty,
       profile = _profileOf(onboarding: onboarding, deployment: deployment, mobile: mobile);

  final RiderStage stage;
  final AuthUser? user;
  final FeatureFlags flags;
  final String mobile;
  final RiderOnboardingConfig? onboarding;
  final RiderDeployment? deployment;
  final bool present;
  final bool vehicleOn;
  final bool scooterPaired;
  final bool pairing;
  final Map<String, Object?> profile;

  bool get isSignedIn => stage != RiderStage.signedOut;

  String get homeRoute => stage.route;

  String get clientCode => ApiEnv.companyCode;

  RiderSession copyWith({
    RiderStage? stage,
    AuthUser? user,
    FeatureFlags? flags,
    String? mobile,
    RiderOnboardingConfig? onboarding,
    RiderDeployment? deployment,
    bool? present,
    bool? vehicleOn,
    bool? scooterPaired,
    bool? pairing,
  }) => RiderSession(
    stage: stage ?? this.stage,
    user: user ?? this.user,
    flags: flags ?? this.flags,
    mobile: mobile ?? this.mobile,
    onboarding: onboarding ?? this.onboarding,
    deployment: deployment ?? this.deployment,
    present: present ?? this.present,
    vehicleOn: vehicleOn ?? this.vehicleOn,
    scooterPaired: scooterPaired ?? this.scooterPaired,
    pairing: pairing ?? this.pairing,
  );

  DynamicUiScope scope({
    required DynamicFormController form,
    required UiActionHandler onAction,
    Map<String, Object?> data = const {},
    Set<String> busyFields = const {},
  }) => DynamicUiScope(
    flags: flags,
    form: form,
    onAction: onAction,
    busyFields: busyFields,
    data: {'rider': profile, 'clientCode': clientCode, 'mobile': mobile, ...data},
  );

  static Map<String, Object?> _profileOf({
    required RiderOnboardingConfig? onboarding,
    required RiderDeployment? deployment,
    required String mobile,
  }) {
    final DeploymentAllocation? allocation = deployment?.allocation;
    final DeploymentRider? rider = allocation?.rider;
    final DeploymentFleet? fleet = allocation?.fleet;

    String? clean(Object? value) {
      final String text = value?.toString().trim() ?? '';
      return text.isEmpty ? null : text;
    }

    final String? name = onboarding?.value('FULL_NAME') ?? clean(rider?.name);
    final Map<String, Object?> derived = {
      'name': name,
      'shortName': name?.split(RegExp(r'\s+')).first,
      'mobile': onboarding?.value('MOBILE_NUMBER') ?? clean(rider?.mobile) ?? clean(mobile),
      'riderCode': clean(rider?.riderCode),
      'city': clean(rider?.city),
      'status': clean(rider?.status),
      'joinedOn': rider?.joiningDate?.toIso8601String(),
      'dateOfBirth': onboarding?.value('DATE_OF_BIRTH'),
      'address': onboarding?.value('ADDRESS'),
      'aadhaarNumber': onboarding?.value('AADHAAR_NUMBER'),
      'panNumber': onboarding?.value('PAN_NUMBER'),
      'vehicleNumber': clean(fleet?.vehicleNumber),
      'vehicleModel': clean(fleet?.modelName),
      'vehicleColour': clean(fleet?.colour),
      'deviceId': clean(fleet?.iotDeviceNumber),
      'allocationStatus': clean(allocation?.status),
      'deploymentStatus': deployment?.status.wire,
      'packageName': clean(onboarding?.packageName),
    };
    return Map<String, Object?>.unmodifiable({
      for (final MapEntry<String, Object?> entry in derived.entries)
        if (entry.value != null) entry.key: entry.value,
    });
  }

  @override
  List<Object?> get props => [
    stage,
    user,
    flags,
    mobile,
    onboarding,
    deployment,
    present,
    vehicleOn,
    scooterPaired,
    pairing,
  ];
}
