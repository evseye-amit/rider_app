import 'package:flutter/foundation.dart';

abstract final class FeatureKeys {
  static const String mobileLoginOtp = 'MOBILE_LOGIN_OTP';
  static const String emailLoginOtp = 'EMAIL_LOGIN_OTP';

  static const String ageVerification = 'AGE_VERIFICATION';
  static const String addressVerification = 'ADDRESS_VERIFICATION';
  static const String aadharVerification = 'AADHAR_VERIFICATION';
  static const String panVerification = 'PAN_VERIFICATION';
  static const String drivingLicenceVerification = 'DRIVING_LICENCE_VERIFICATION';
  static const String bankVerification = 'BANK_VERIFICATION';
  static const String backgroundVerification = 'BACKGROUND_VERIFICATION';
  static const String policeVerification = 'POLICE_VERIFICATION';
  static const String referenceCheck = 'REFERENCE_CHECK';
  static const String emergencyContact = 'EMERGENCY_CONTACT';
  static const String medicalDeclaration = 'MEDICAL_DECLARATION';

  static const String profilePhoto = 'PROFILE_PHOTO';
  static const String ageProofDocument = 'AGE_PROOF_DOCUMENT';
  static const String addressProofDocument = 'ADDRESS_PROOF_DOCUMENT';
  static const String aadharProofDocument = 'AADHAR_PROOF_DOCUMENT';
  static const String panProofDocument = 'PAN_PROOF_DOCUMENT';
  static const String drivingLicenceProofDocument = 'DRIVING_LICENCE_PROOF_DOCUMENT';
  static const String bankProofDocument = 'BANK_PROOF_DOCUMENT';
  static const String medicalProofDocument = 'MEDICAL_PROOF_DOCUMENT';

  static const String faceLivenessCheck = 'FACE_LIVENESS_CHECK';

  static const String hubSelection = 'HUB_SELECTION';
  static const String planSelection = 'PLAN_SELECTION';
  static const String securityDeposit = 'SECURITY_DEPOSIT';
  static const String onBoardingFees = 'ON_BOARDING_FEES';
  static const String upiCapture = 'UPI_CAPTURE';
  static const String nachEmandate = 'NACH_EMANDATE';
  static const String insuranceNominee = 'INSURANCE_NOMINEE';
  static const String agreementESign = 'AGREEMENT_E_SIGN';
  static const String pdiChecklist = 'PDI_CHECKLIST';
  static const String devicePairing = 'DEVICE_PAIRING';

  static const String referralBenefit = 'REFERRAL_BENEFIT';
  static const String training = 'TRAINING';

  static const String attendance = 'ATTENDANCE';
  static const String wallet = 'WALLET';
  static const String incentives = 'INCENTIVES';
  static const String helpSupport = 'HELP_SUPPORT';
  static const String iotTelemetry = 'IOT_TELEMETRY';

  static const Set<String> backendCatalogue = {
    mobileLoginOtp, emailLoginOtp,
    ageVerification, addressVerification, aadharVerification, panVerification,
    drivingLicenceVerification, bankVerification, backgroundVerification,
    policeVerification, referenceCheck, emergencyContact, medicalDeclaration,
    profilePhoto, ageProofDocument, addressProofDocument, aadharProofDocument,
    panProofDocument, drivingLicenceProofDocument, bankProofDocument,
    medicalProofDocument,
    faceLivenessCheck,
    hubSelection, planSelection, securityDeposit, onBoardingFees, upiCapture,
    nachEmandate, insuranceNominee, agreementESign, pdiChecklist, devicePairing,
    referralBenefit, training,
  };

  const FeatureKeys._();
}

@immutable
class FeatureFlags {
  const FeatureFlags({
    Map<String, bool> flags = const {},
    Map<String, dynamic> settings = const {},
    this.packageName = '',
    this.clientCode = '',
  })  : _flags = flags,
        _settings = settings;

  final Map<String, bool> _flags;
  final Map<String, dynamic> _settings;
  final String packageName;
  final String clientCode;

  static const FeatureFlags empty = FeatureFlags();

  Map<String, bool> get all => Map.unmodifiable(_flags);

  Map<String, dynamic> get allSettings => Map.unmodifiable(_settings);

  bool isEnabled(String key) => _flags[key] ?? false;

  bool isAnyEnabled(Iterable<String> keys) => keys.any(isEnabled);

  T? setting<T>(String key) {
    final Object? v = _settings[key];
    return v is T ? v : null;
  }

  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    final Object? raw = json['features'] ?? json['flags'];
    final Map<String, bool> parsed = {};
    if (raw is Map) {
      raw.forEach((k, v) => parsed[k.toString()] = v == true || v.toString() == 'true');
    } else if (raw is List) {
      for (final e in raw) {
        parsed[e.toString()] = true;
      }
    }
    return FeatureFlags(
      flags: parsed,
      settings: Map<String, dynamic>.from(json['settings'] as Map? ?? const {}),
      packageName: json['packageName'] as String? ?? json['package'] as String? ?? '',
      clientCode: json['clientCode'] as String? ?? '',
    );
  }

  FeatureFlags copyWith({Map<String, bool>? flags, Map<String, dynamic>? settings}) => FeatureFlags(
        flags: flags ?? _flags,
        settings: settings ?? _settings,
        packageName: packageName,
        clientCode: clientCode,
      );

  FeatureFlags withOverride(String key, bool value) =>
      copyWith(flags: {..._flags, key: value});

  @override
  bool operator ==(Object other) =>
      other is FeatureFlags &&
      mapEquals(other._flags, _flags) &&
      other.packageName == packageName &&
      other.clientCode == clientCode;

  @override
  int get hashCode => Object.hash(packageName, clientCode, _flags.length);
}
