import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/rider_session_provider.dart';
import '../../deployment_dependencies.dart';
import '../../domain/usecases/submit_deployment_payment.dart';

class DeploymentPaymentNotifier extends AsyncNotifier<DeploymentPayment> {
  DeploymentPaymentNotifier(this._allocationId);

  final String _allocationId;

  @override
  FutureOr<DeploymentPayment> build() {
    ref.listen(riderSessionProvider.select((s) => s.deployment?.payment), (_, next) {
      if (next != null) state = AsyncData(next);
    });
    final DeploymentPayment? known = ref.read(riderSessionProvider).deployment?.payment;
    if (known != null) return known;
    return _fetch();
  }

  Future<Result<DeploymentPayment>> submit({required String provider, required String reference}) async {
    final Result<DeploymentPayment> result = await ref.read(submitDeploymentPaymentProvider)(
      SubmitPaymentParams(allocationId: _allocationId, provider: provider, reference: reference),
    );
    if (ref.mounted && result is Ok<DeploymentPayment>) state = AsyncData(result.value);
    return result;
  }

  Future<DeploymentPayment> _fetch() async =>
      (await ref.read(getDeploymentPaymentProvider)(_allocationId)).getOrThrow();
}

final deploymentPaymentProvider = AsyncNotifierProvider.autoDispose
    .family<DeploymentPaymentNotifier, DeploymentPayment, String>(DeploymentPaymentNotifier.new);
