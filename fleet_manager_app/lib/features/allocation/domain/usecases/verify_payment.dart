import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class VerifyPayment extends UseCase<DeploymentWorkflow, String> {
  const VerifyPayment(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(String params) => _repository.verifyPayment(params);
}
