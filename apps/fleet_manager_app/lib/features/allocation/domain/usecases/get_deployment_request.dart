import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetDeploymentRequest extends UseCase<DeploymentAllocation, String> {
  const GetDeploymentRequest(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentAllocation>> call(String params) => _repository.getRequest(params);
}
