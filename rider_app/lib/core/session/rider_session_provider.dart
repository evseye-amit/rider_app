import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_dependencies.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/deployment/deployment_dependencies.dart';
import '../../features/onboarding/onboarding_dependencies.dart';
import 'rider_session.dart';
import 'rider_stage.dart';
import 'scooter_pairing_store.dart';

export 'rider_session.dart';
export 'rider_stage.dart';

class RiderSessionNotifier extends Notifier<RiderSession> {
  UiConfigService get _config => ref.read(uiConfigServiceProvider);

  TokenStore get _tokens => ref.read(tokenStoreProvider);

  ScooterPairingStore get _pairingStore => ref.read(scooterPairingStoreProvider);

  @override
  RiderSession build() {
    ref.read(apiClientProvider).onSessionExpired = handleSessionExpired;
    ref.listen(localeProvider.select((p) => p.locale), (_, _) => _onLocaleChanged());
    return RiderSession(scooterPaired: _pairingStore.paired);
  }

  Future<void> bootstrap() async {
    await loadPackage();
    final Result<AuthUser> restored = await ref.read(restoreSessionProvider)(const NoParams());
    if (restored case Ok<AuthUser>(:final value)) {
      state = state.copyWith(user: value);
      await refreshState();
      await loadPackage();
    } else {
      state = state.copyWith(stage: RiderStage.signedOut);
    }
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
        if (value.screen == RiderScreen.onboarding || onboarding == null) {
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

  Future<void> applyOnboarding(RiderOnboardingConfig config) async {
    state = state.copyWith(onboarding: config);
    if (config.isComplete) await refreshState();
  }

  void setAttendance(bool present) {
    state = state.copyWith(present: present, vehicleOn: present && state.vehicleOn);
  }

  void setVehicleOn(bool on) {
    state = state.copyWith(vehicleOn: on);
  }

  void setPairing(bool pairing) {
    state = state.copyWith(pairing: pairing);
  }

  Future<void> markPaired() async {
    await _pairingStore.setPaired(true);
    state = state.copyWith(scooterPaired: true, pairing: false);
  }

  Future<void> signOut() async {
    await ref.read(signOutProvider)();
    _clearSession();
  }

  void handleSessionExpired() => _clearSession();

  Future<RiderOnboardingConfig?> _fetchOnboarding() async =>
      (await ref.read(getOnboardingProvider)(const NoParams())).valueOrNull;

  RiderStage _resolveStage(RiderDeployment deployment, RiderOnboardingConfig? onboarding) {
    if (onboarding == null) return RiderStage.fromScreen(deployment.screen);
    if (!onboarding.isComplete) return RiderStage.onboarding;
    if (deployment.allocation != null) return RiderStage.fromScreen(deployment.screen);
    return RiderStage.fromScreen(RiderScreen.parse(onboarding.screen));
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
    unawaited(_pairingStore.reset());
    state = RiderSession(flags: state.flags);
  }
}

final riderSessionProvider = NotifierProvider<RiderSessionNotifier, RiderSession>(RiderSessionNotifier.new);
