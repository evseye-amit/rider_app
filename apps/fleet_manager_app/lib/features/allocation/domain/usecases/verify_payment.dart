import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class VerifyPaymentParams {
  const VerifyPaymentParams({required this.allocationId, this.expectedVersion});

  final String allocationId;
  final int? expectedVersion;
}

class VerifyPayment extends UseCase<DeploymentWorkflow, VerifyPaymentParams> {
  const VerifyPayment(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(VerifyPaymentParams params) =>
      _repository.verifyPayment(params.allocationId, expectedVersion: params.expectedVersion);
}
