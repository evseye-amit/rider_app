import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_dependencies.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/deployment/deployment_dependencies.dart';
import '../../features/onboarding/onboarding_dependencies.dart';
import 'rider_session.dart';
import 'rider_stage.dart';

export 'rider_session.dart';
export 'rider_stage.dart';

class RiderSessionNotifier extends Notifier<RiderSession> {
  static const Duration _documentCheckInterval = Duration(seconds: 30);
  static const Duration _consentCheckInterval = Duration(minutes: 5);
  static const Duration _resumeRefreshInterval = Duration(seconds: 30);
  static const String _hygieneKey = 'deployment.hygiene_done';

  DateTime? _documentsCheckedAt;
  DateTime? _consentCheckedAt;
  DateTime? _resumedAt;

  UiConfigService get _config => ref.read(uiConfigServiceProvider);

  TokenStore get _tokens => ref.read(tokenStoreProvider);

  @override
  RiderSession build() {
    ref.read(apiClientProvider).onSessionExpired = handleSessionExpired;
    ref.listen(localeProvider.select((p) => p.locale), (_, _) => _onLocaleChanged());
    return RiderSession();
  }

  Future<void> bootstrap() async {
    final Future<void> consent = verifyConsent();
    await loadPackage();
    final Result<AuthUser> restored = await ref.read(restoreSessionProvider)(const NoParams());
    if (restored case Ok<AuthUser>(:final value)) {
      state = state.copyWith(user: value);
      unawaited(_loadAttendance());
      unawaited(ref.read(pushRegistrationProvider).start());
      await refreshState();
      await loadPackage();
    } else {
      state = state.copyWith(stage: RiderStage.signedOut);
    }
    await consent;
    if (state.user case final AuthUser user) unawaited(ref.read(consentProvider.notifier).recordAcceptance(user.id));
  }

  Future<void> refreshOnResume() async {
    if (!state.isSignedIn) return;
    final DateTime now = DateTime.now();
    if (_resumedAt case final DateTime last when now.difference(last) < _resumeRefreshInterval) return;
    _resumedAt = now;
    await refreshState();
  }

  Future<void> verifyConsent() async {
    final DateTime now = DateTime.now();
    if (_consentCheckedAt case final DateTime last when now.difference(last) < _consentCheckInterval) return;
    _consentCheckedAt = now;
    await ref.read(consentProvider.notifier).verify(LegalAudience.rider);
  }

  Future<void> loadPackage() async {
    state = state.copyWith(flags: await _config.loadFeatureFlags());
  }

  Future<Result<OtpChallenge>> startSignIn(String mobile) async {
    state = state.copyWith(mobile: mobile);
    final Result<RiderEnrollment> enrolled = await ref.read(enrollRiderProvider)(mobile);
    if (enrolled case Err<RiderEnrollment>(:final failure)) return Result.err(failure);
    return ref.read(requestOtpProvider)(mobile);
  }

  Future<Result<OtpChallenge>> requestOtp(String mobile) {
    state = state.copyWith(mobile: mobile);
    return ref.read(requestOtpProvider)(mobile);
  }

  Future<Result<AuthUser>> verifyOtp({required String otpRequestId, required String code}) async {
    if (state.mobile.isNotEmpty) await _tokens.saveMobile(state.mobile);
    final Result<AuthUser> result = await ref.read(verifyOtpProvider)(
      VerifyOtpParams(otpRequestId: otpRequestId, code: code),
    );
    if (result case Ok<AuthUser>(:final value)) {
      state = state.copyWith(user: value);
      unawaited(ref.read(consentProvider.notifier).recordAcceptance(value.id));
      unawaited(_loadAttendance());
      unawaited(ref.read(pushRegistrationProvider).start());
      await refreshState();
      await loadPackage();
    }
    return result;
  }

  Future<Result<RiderDeployment>> refreshState() async {
    final Result<RiderDeployment> result = await ref.read(getCurrentDeploymentProvider)(const NoParams());
    switch (result) {
      case Ok<RiderDeployment>(:final value):
        RiderOnboardingConfig? onboarding = state.onboarding;
        if (value.screen == RiderScreen.onboarding || onboarding == null || _documentsDue(value)) {
          onboarding = await _fetchOnboarding() ?? onboarding;
        }
        state = state.copyWith(
          deployment: value,
          onboarding: onboarding,
          mobile: _resolveMobile(deployment: value, onboarding: onboarding),
          stage: _resolveStage(value, onboarding),
        );
      case Err<RiderDeployment>(:final failure):
        if (failure is UnauthorizedFailure || failure is AuthFailure) {
          _clearSession();
        } else if (state.stage == RiderStage.signedOut) {
          final RiderOnboardingConfig? onboarding = await _fetchOnboarding() ?? state.onboarding;
          state = state.copyWith(
            stage: RiderStage.onboarding,
            onboarding: onboarding,
            mobile: _resolveMobile(deployment: state.deployment, onboarding: onboarding),
          );
        }
    }
    return result;
  }

  Future<Result<RiderOnboardingConfig>> loadOnboarding() async {
    final Result<RiderOnboardingConfig> result = await ref.read(getOnboardingProvider)(const NoParams());
    if (result case Ok<RiderOnboardingConfig>(:final value)) {
      state = state.copyWith(
        onboarding: value,
        mobile: _resolveMobile(deployment: state.deployment, onboarding: value),
      );
    }
    return result;
  }

  Future<void> finishHygiene(String allocationId) async {
    final List<String> done = ref.read(sharedPreferencesProvider).getStringList(_hygieneKey) ?? const [];
    if (!done.contains(allocationId)) {
      await ref.read(sharedPreferencesProvider).setStringList(_hygieneKey, [...done, allocationId]);
    }
    final RiderDeployment? deployment = state.deployment;
    if (deployment != null) state = state.copyWith(stage: _resolveStage(deployment, state.onboarding));
  }

  Future<void> applyOnboarding(RiderOnboardingConfig config) async {
    state = state.copyWith(onboarding: config);
    if (config.isComplete) await refreshState();
  }

  Future<Result<bool>> setAttendance(bool present) async {
    final bool previous = state.present;
    state = state.copyWith(present: present, vehicleOn: present && state.vehicleOn);
    final Result<bool> result = await ref.read(attendanceApiProvider).mark(present);
    final bool actual = result.valueOrNull ?? previous;
    state = state.copyWith(present: actual, vehicleOn: actual && state.vehicleOn);
    return result;
  }

  Future<void> _loadAttendance() async {
    final Result<bool> present = await ref.read(attendanceApiProvider).isPresent();
    if (present case Ok<bool>(:final value)) {
      state = state.copyWith(present: value, vehicleOn: value && state.vehicleOn);
    }
  }

  void setVehicleOn(bool on) {
    state = state.copyWith(vehicleOn: on);
  }

  Future<void> signOut() async {
    await ref.read(pushRegistrationProvider).stop();
    await ref.read(signOutProvider)();
    _clearSession();
  }

  void handleSessionExpired() {
    unawaited(ref.read(pushRegistrationProvider).stop(unregister: false));
    _clearSession();
  }

  Future<RiderOnboardingConfig?> _fetchOnboarding() async {
    _documentsCheckedAt = DateTime.now();
    return (await ref.read(getOnboardingProvider)(const NoParams())).valueOrNull;
  }

  bool _documentsDue(RiderDeployment deployment) {
    if (deployment.screen != RiderScreen.waiting || deployment.allocation != null) return false;
    final DateTime? checked = _documentsCheckedAt;
    return checked == null || DateTime.now().difference(checked) >= _documentCheckInterval;
  }

  RiderStage _resolveStage(RiderDeployment deployment, RiderOnboardingConfig? onboarding) {
    if (onboarding == null) return _deploymentStage(deployment);
    if (!onboarding.isComplete) return RiderStage.onboarding;
    if (deployment.allocation != null || deployment.screen == RiderScreen.home) return _deploymentStage(deployment);
    if (onboarding.needsResubmission) return RiderStage.onboarding;
    return RiderStage.fromScreen(RiderScreen.parse(onboarding.screen));
  }

  RiderStage _deploymentStage(RiderDeployment deployment) {
    final RiderStage stage = RiderStage.fromScreen(deployment.screen);
    final String? allocationId = deployment.allocation?.id;
    if (allocationId == null || (stage != RiderStage.training && stage != RiderStage.active)) return stage;
    final List<String> done = ref.read(sharedPreferencesProvider).getStringList(_hygieneKey) ?? const [];
    return done.contains(allocationId) ? RiderStage.active : RiderStage.training;
  }

  String _resolveMobile({required RiderDeployment? deployment, required RiderOnboardingConfig? onboarding}) {
    final List<String?> candidates = [
      state.mobile,
      _tokens.mobile,
      deployment?.allocation?.rider?.mobile,
      onboarding?.value('MOBILE_NUMBER'),
    ];
    return candidates.firstWhere((m) => m != null && m.isNotEmpty, orElse: () => '') ?? '';
  }

  void _onLocaleChanged() {
    if (state.user == null) return;
    _config.invalidate();
    unawaited(_reloadForLocale());
  }

  Future<void> _reloadForLocale() async {
    if (state.onboarding != null) await loadOnboarding();
    await refreshState();
  }

  void _clearSession() {
    state = RiderSession(flags: state.flags);
  }
}

final riderSessionProvider = NotifierProvider<RiderSessionNotifier, RiderSession>(RiderSessionNotifier.new);
