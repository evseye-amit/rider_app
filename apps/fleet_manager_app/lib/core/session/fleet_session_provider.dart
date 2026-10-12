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
    if (result case Ok<AuthUser>(:final value)) await _openSession(value);
    return result;
  }

  void setHubSelection(Iterable<int> indexes) {
    final Set<int> next = indexes.where((i) => i >= 0 && i < state.hubs.length).toSet();
    if (next.isEmpty) return;
    if (next.length == state.selectedHubIndexes.length && next.every(state.selectedHubIndexes.contains)) return;
    state = state.copyWith(selectedHubIndexes: next);
  }

  void setAttendance(bool present) {
    state = state.copyWith(present: present);
  }

  Future<void> signOut() async {
    await ref.read(signOutProvider)();
    state = FleetSession(flags: state.flags, present: state.present);
  }

  Future<void> _openSession(AuthUser user) async {
    final FeatureFlags flags = await _config.loadFeatureFlags();
    final List<HubProfile> hubs = (await ref.read(listHubsProvider)(const NoParams())).valueOrNull ?? state.hubs;
    final Set<int> selection = state.selectedHubIndexes.where((i) => i < hubs.length).toSet();
    state = state.copyWith(
      user: user,
      flags: flags,
      hubs: hubs,
      selectedHubIndexes: selection.isEmpty ? const {0} : selection,
    );
  }
}

final fleetSessionProvider = NotifierProvider<FleetSessionNotifier, FleetSession>(FleetSessionNotifier.new);
