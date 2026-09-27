import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/rider_session_provider.dart';

class DeploymentNotifier extends AsyncNotifier<RiderDeployment> {
  RiderSessionNotifier get _session => ref.read(riderSessionProvider.notifier);

  @override
  FutureOr<RiderDeployment> build() {
    ref.listen(riderSessionProvider.select((s) => s.deployment), (_, next) {
      if (next != null) state = AsyncData(next);
    });
    final RiderDeployment? cached = ref.read(riderSessionProvider).deployment;
    if (cached == null) return _fetch();
    unawaited(refresh(silent: true));
    return cached;
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent && !state.hasValue) state = const AsyncLoading();
    final Result<RiderDeployment> result = await _session.refreshState();
    if (!ref.mounted) return;
    switch (result) {
      case Ok<RiderDeployment>(:final value):
        state = AsyncData(value);
      case Err<RiderDeployment>(:final failure):
        if (!state.hasValue) state = AsyncError(failure, StackTrace.current);
    }
  }

  Future<RiderDeployment> _fetch() async => (await _session.refreshState()).getOrThrow();
}

final deploymentProvider = AsyncNotifierProvider.autoDispose<DeploymentNotifier, RiderDeployment>(
  DeploymentNotifier.new,
);

final deploymentPollingProvider = Provider.autoDispose<void>((ref) {
  final Timer timer = Timer.periodic(
    const Duration(seconds: 10),
    (_) => ref.read(deploymentProvider.notifier).refresh(silent: true),
  );
  ref.onDispose(timer.cancel);
});
