import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/domain/usecases/enroll_rider.dart';
import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/deployment/domain/usecases/get_current_deployment.dart';
import '../../features/onboarding/domain/onboarding_draft.dart';
import '../../features/onboarding/domain/usecases/get_onboarding.dart';
import 'rider_stage.dart';
import 'scooter_power_store.dart';

export 'rider_stage.dart';

class SessionController extends ChangeNotifier {
  SessionController({
    required UiConfigService config,
    required EnrollRider enrollRider,
    required RequestOtp requestOtp,
    required VerifyOtp verifyOtp,
    required RestoreSession restoreSession,
    required SignOut signOut,
    required GetOnboarding getOnboarding,
    required GetCurrentDeployment getCurrentDeployment,
    required TokenStore tokens,
  })  : _config = config,
        _enrollRider = enrollRider,
        _requestOtp = requestOtp,
        _verifyOtp = verifyOtp,
        _restoreSession = restoreSession,
        _signOut = signOut,
        _getOnboarding = getOnboarding,
        _getCurrentDeployment = getCurrentDeployment,
        _tokens = tokens;

  final UiConfigService _config;
  final TokenStore _tokens;
  final EnrollRider _enrollRider;
  final RequestOtp _requestOtp;
  final VerifyOtp _verifyOtp;
  final RestoreSession _restoreSession;
  final SignOut _signOut;
  final GetOnboarding _getOnboarding;
  final GetCurrentDeployment _getCurrentDeployment;

  AuthUser? _user;

  AuthUser? get user => _user;

  FeatureFlags _flags = FeatureFlags.empty;
  FeatureFlags get flags => _flags;

  RiderStage _stage = RiderStage.signedOut;
  RiderStage get stage => _stage;

  String get clientCode => ApiEnv.companyCode;

  String _mobile = '';
  String get mobile => _mobile;

  RiderOnboardingConfig? _onboarding;

  RiderOnboardingConfig? get onboarding => _onboarding;

  RiderDeployment? _deployment;

  RiderDeployment? get deployment => _deployment;

  String? get riderId => _deployment?.riderId;

  String? get allocationId => _deployment?.allocation?.id;

  bool _present = false;
  bool get present => _present;

  bool _vehicleOn = false;
  bool get vehicleOn => _vehicleOn;

  bool _scooterPaired = false;
  bool get scooterPaired => _scooterPaired;

  bool _pairing = false;
  bool get pairing => _pairing;

  DateTime? _shiftStartedAt;
  DateTime? get shiftStartedAt => _shiftStartedAt;

  Map<String, Object?> _seededProfile = const {};

  Map<String, Object?> get profile => _profile;
  Map<String, Object?> _profile = const {};

  bool get isSignedIn => _stage != RiderStage.signedOut;
  bool get canRide => _stage == RiderStage.active;

  String get homeRoute => _stage.route;

  Future<void> bootstrap() async {
    await loadPackage();
    final Result<AuthUser> me = await _restoreSession(const NoParams());
    if (me case Ok<AuthUser>(:final value)) {
      _user = value;
      await refreshState();
      await loadPackage();
    } else {
      _stage = RiderStage.signedOut;
    }
    notifyListeners();
  }

  Future<void> loadPackage() async {
    _flags = await _config.loadFeatureFlags();
    notifyListeners();
  }

  Future<Result<OtpChallenge>> startSignIn(String mobile) async {
    _mobile = mobile;
    final Result<RiderEnrollment> enrolled = await _enrollRider(mobile);
    if (enrolled case Err<RiderEnrollment>(:final failure)) return Result.err(failure);
    return _requestOtp(mobile);
  }

  Future<Result<OtpChallenge>> requestOtp(String mobile) {
    _mobile = mobile;
    return _requestOtp(mobile);
  }

  Future<Result<AuthUser>> verifyOtp({required String otpRequestId, required String code}) async {
    if (_mobile.isNotEmpty) await _tokens.saveMobile(_mobile);
    final Result<AuthUser> result = await _verifyOtp(VerifyOtpParams(otpRequestId: otpRequestId, code: code));
    if (result case Ok<AuthUser>(:final value)) {
      _user = value;
      await refreshState();
      await loadPackage();
    }
    return result;
  }

  Future<Result<RiderDeployment>> refreshState() async {
    final Result<RiderDeployment> result = await _getCurrentDeployment(const NoParams());
    switch (result) {
      case Ok<RiderDeployment>(:final value):
        _deployment = value;
        _stage = riderStageFrom(value.screen);
        if (_mobile.isEmpty) _mobile = _tokens.mobile ?? '';
        final String? allocated = value.allocation?.rider?.mobile;
        if (_mobile.isEmpty && allocated != null && allocated.isNotEmpty) {
          _mobile = allocated;
        }

        if (value.screen == RiderScreen.onboarding || _onboarding == null) {
          await loadOnboarding();
        }
        _stage = _resolveStage(value);
      case Err<RiderDeployment>(:final failure):
        if (failure is UnauthorizedFailure || failure is AuthFailure) {
          _clearSession();
        } else if (_stage == RiderStage.signedOut) {
          _stage = RiderStage.onboarding;
          await loadOnboarding();
        }
    }
    _profile = _buildProfile();
    notifyListeners();
    return result;
  }


  RiderStage _resolveStage(RiderDeployment deployment) {
    final RiderOnboardingConfig? config = _onboarding;
    if (config == null) return riderStageFrom(deployment.screen);
    if (!config.isComplete) return RiderStage.onboarding;
    if (deployment.allocation != null) return riderStageFrom(deployment.screen);
    return riderStageFrom(RiderScreen.parse(config.screen));
  }

  Future<Result<RiderOnboardingConfig>> loadOnboarding() async {
    final Result<RiderOnboardingConfig> result = await _getOnboarding(const NoParams());
    if (result case Ok<RiderOnboardingConfig>(:final value)) {
      _onboarding = value;
      final String? saved = value.value('MOBILE_NUMBER');
      if (_mobile.isEmpty && saved != null && saved.isNotEmpty) _mobile = saved;
      _profile = _buildProfile();
      notifyListeners();
    }
    return result;
  }

  Future<void> applyOnboarding(RiderOnboardingConfig config) async {
    _onboarding = config;
    _profile = _buildProfile();
    notifyListeners();
    if (config.isComplete) await refreshState();
  }

  void seedProfile(Map<String, Object?> profile) {
    _seededProfile = Map<String, Object?>.unmodifiable(profile);
    _profile = _buildProfile();
    notifyListeners();
  }

  Future<void> signIn(String mobile) async {
    _mobile = mobile;
    if (_flags.all.isEmpty) await loadPackage();
    _stage = RiderStage.onboarding;
    _profile = _buildProfile();
    notifyListeners();
  }

  void setAttendance(bool present) {
    _present = present;
    _shiftStartedAt = present ? DateTime.now() : null;
    if (!present) _vehicleOn = false;
    notifyListeners();
  }

  void setVehicleOn(bool on) {
    _vehicleOn = on;
    notifyListeners();
  }

  Future<void> loadPairing() async {
    final ScooterPowerStore store = ScooterPowerStore.instance;
    if (!store.loaded) await store.load();
    _scooterPaired = store.paired;
    notifyListeners();
  }

  void setPairing(bool value) {
    _pairing = value;
    notifyListeners();
  }

  Future<void> markPaired() async {
    await ScooterPowerStore.instance.setPaired(true);
    _scooterPaired = true;
    _pairing = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _signOut();
    _clearSession();
    notifyListeners();
  }

  void handleSessionExpired() {
    _clearSession();
    notifyListeners();
  }

  void _clearSession() {
    _stage = RiderStage.signedOut;
    _user = null;
    _mobile = '';
    _present = false;
    _vehicleOn = false;
    _shiftStartedAt = null;
    _onboarding = null;
    _deployment = null;
    _profile = _buildProfile();
    _scooterPaired = false;
    _pairing = false;
    ScooterPowerStore.instance.reset();
    OnboardingDraft.instance.clear();
  }

  Map<String, Object?> _buildProfile() {
    final RiderOnboardingConfig? o = _onboarding;
    final DeploymentAllocation? a = _deployment?.allocation;
    final DeploymentRider? r = a?.rider;
    final DeploymentFleet? f = a?.fleet;

    String? clean(Object? v) {
      if (v == null) return null;
      final String s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    final String? name = o?.value('FULL_NAME') ?? clean(r?.name);
    final Map<String, Object?> derived = {
      'name': name,
      'shortName': name?.split(RegExp(r'\s+')).first,
      'mobile': o?.value('MOBILE_NUMBER') ?? clean(r?.mobile) ?? clean(_mobile),
      'riderCode': clean(r?.riderCode),
      'city': clean(r?.city),
      'status': clean(r?.status),
      'joinedOn': r?.joiningDate?.toIso8601String(),
      'dateOfBirth': o?.value('DATE_OF_BIRTH'),
      'address': o?.value('ADDRESS'),
      'aadhaarNumber': o?.value('AADHAAR_NUMBER'),
      'panNumber': o?.value('PAN_NUMBER'),
      'vehicleNumber': clean(f?.vehicleNumber),
      'vehicleModel': clean(f?.modelName),
      'vehicleColour': clean(f?.colour),
      'deviceId': clean(f?.iotDeviceNumber),
      'allocationStatus': clean(a?.status),
      'deploymentStatus': _deployment?.status.wire,
      'packageName': clean(o?.packageName),
    };
    return Map<String, Object?>.unmodifiable({
      ..._seededProfile,
      for (final e in derived.entries)
        if (e.value != null) e.key: e.value,
    });
  }

  DynamicUiScope scope({
    required DynamicFormController form,
    required UiActionHandler onAction,
    Map<String, Object?> data = const {},
    Set<String> busyFields = const {},
  }) =>
      DynamicUiScope(
        flags: _flags,
        form: form,
        onAction: onAction,
        busyFields: busyFields,
        data: {
          'rider': _profile,
          'clientCode': clientCode,
          'mobile': _mobile,
          ...data,
        },
      );
}
