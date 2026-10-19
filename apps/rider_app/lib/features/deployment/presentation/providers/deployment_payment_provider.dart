import 'dart:async';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/rider_session_provider.dart';
import '../../deployment_dependencies.dart';
import '../../domain/usecases/payment_receipt_usecases.dart';
import '../../domain/usecases/submit_deployment_payment.dart';

class DeploymentPaymentNotifier extends AsyncNotifier<DeploymentPayment> {
  DeploymentPaymentNotifier(this._allocationId);

  final String _allocationId;

  @override
  FutureOr<DeploymentPayment> build() {
    ref.listen(riderSessionProvider.select((s) => s.deployment?.payment), (_, next) {
      final DeploymentPayment? current = state.value;
      if (next == null) return;
      if (current == null || next.status != current.status || next.submissionVersion != current.submissionVersion) {
        unawaited(reload());
      }
    });
    final DeploymentPayment? known = ref.read(riderSessionProvider).deployment?.payment;
    if (known == null) return _fetch();
    unawaited(Future<void>.microtask(reload));
    return known;
  }

  Future<void> reload() async {
    final Result<DeploymentPayment> result = await ref.read(getDeploymentPaymentProvider)(_allocationId);
    if (!ref.mounted) return;
    if (result case Ok<DeploymentPayment>(:final value)) state = AsyncData(value);
  }

  Future<Result<DeploymentPayment>> submit({
    required String provider,
    required String reference,
    List<String> receiptPhotoIds = const [],
  }) async {
    final Result<DeploymentPayment> result = await ref.read(submitDeploymentPaymentProvider)(
      SubmitPaymentParams(
        allocationId: _allocationId,
        provider: provider,
        reference: reference,
        receiptPhotoIds: receiptPhotoIds,
      ),
    );
    if (ref.mounted && result is Ok<DeploymentPayment>) state = AsyncData(result.value);
    return result;
  }

  Future<Result<String>> uploadReceipt(File file) async {
    final String paymentId = state.value?.id ?? '';
    if (paymentId.isEmpty) return const Result.err(NotFoundFailure());
    return ref.read(uploadPaymentReceiptProvider)(ReceiptUploadParams(paymentId: paymentId, file: file));
  }

  Future<DeploymentPayment> _fetch() async =>
      (await ref.read(getDeploymentPaymentProvider)(_allocationId)).getOrThrow();
}

final deploymentPaymentProvider = AsyncNotifierProvider.autoDispose
    .family<DeploymentPaymentNotifier, DeploymentPayment, String>(DeploymentPaymentNotifier.new);

final paymentReceiptUrlProvider = FutureProvider.autoDispose.family<String, ReceiptRef>(
  (ref, receipt) async => (await ref.watch(getPaymentReceiptUrlProvider)(receipt)).getOrThrow(),
);
