import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/auth_dependencies.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/hub/domain/entities/hub_profile.dart';
import '../../features/hub/hub_dependencies.dart';
import 'fleet_session.dart';

export 'fleet_session.dart';

class FleetSessionNotifier extends Notifier<FleetSession> {
  UiConfigService get _config => ref.read(uiConfigServiceProvider);

  @override
  FleetSession build() => FleetSession();

  Future<void> bootstrap() async {
    final FeatureFlags flags = await _config.loadFeatureFlags();
    final Result<AuthUser> restored = await ref.read(restoreSessionProvider)(const NoParams());
    switch (restored) {
      case Ok<AuthUser>(:final value):
        await _openSession(value);
      case Err<AuthUser>():
        state = state.copyWith(flags: flags);
    }
  }

  Future<Result<OtpChallenge>> requestOtp(String mobile) {
    state = state.copyWith(mobile: mobile);
    return ref.read(requestOtpProvider)(mobile);
  }

  Future<Result<AuthUser>> verifyOtp({required String otpRequestId, required String code}) async {
    final Result<AuthUser> result = await ref.read(verifyOtpProvider)(
      VerifyOtpParams(otpRequestId: otpRequestId, code: code),
    );
    if (result case Ok<AuthUser>(:final value)) {
      if (!value.isFleetManager) {
        return const Result.err(ForbiddenFailure('This application is not available for your role.', 'UNSUPPORTED_APP_ROLE'));
      }
      await _openSession(value);
    }
    return result;
  }

  void selectHub(int? index) {
    final int count = state.hubs.length;
    final Set<int> next = index == null
        ? {for (int i = 0; i < count; i++) i}
        : {if (index >= 0 && index < count) index};
    if (next.isEmpty) return;
    if (next.length == state.selectedHubIndexes.length && next.every(state.selectedHubIndexes.contains)) return;
    state = state.copyWith(selectedHubIndexes: next);
  }

  Future<Result<bool>> setAttendance(bool present) async {
    final bool previous = state.present;
    state = state.copyWith(present: present);
    final Result<bool> result = await ref.read(attendanceApiProvider).mark(present);
    state = state.copyWith(present: result.valueOrNull ?? previous);
    return result;
  }

  Future<void> signOut() async {
    await ref.read(pushRegistrationProvider).stop();
    await ref.read(signOutProvider)();
    state = FleetSession(flags: state.flags);
  }

  Future<void> _loadAttendance() async {
    final Result<bool> present = await ref.read(attendanceApiProvider).isPresent();
    if (present case Ok<bool>(:final value)) state = state.copyWith(present: value);
  }

  Future<void> _openSession(AuthUser user) async {
    unawaited(_loadAttendance());
    unawaited(ref.read(pushRegistrationProvider).start());
    final FeatureFlags flags = await _config.loadFeatureFlags();
    final List<HubProfile> hubs = (await ref.read(listHubsProvider)(const NoParams())).valueOrNull ?? state.hubs;
    state = state.copyWith(
      user: user,
      flags: flags,
      hubs: hubs,
      selectedHubIndexes: {for (int i = 0; i < hubs.length; i++) i},
    );
  }
}

final fleetSessionProvider = NotifierProvider<FleetSessionNotifier, FleetSession>(FleetSessionNotifier.new);
