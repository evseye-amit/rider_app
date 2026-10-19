import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class SubmitPaymentParams {
  const SubmitPaymentParams({
    required this.allocationId,
    required this.provider,
    required this.reference,
    this.receiptPhotoIds = const [],
  });

  final String allocationId;

  final String provider;

  final String reference;

  final List<String> receiptPhotoIds;
}

class SubmitDeploymentPayment extends UseCase<DeploymentPayment, SubmitPaymentParams> {
  const SubmitDeploymentPayment(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentPayment>> call(SubmitPaymentParams params) => _repository.submitPayment(
    params.allocationId,
    provider: params.provider,
    reference: params.reference,
    receiptPhotoIds: params.receiptPhotoIds,
  );
}
