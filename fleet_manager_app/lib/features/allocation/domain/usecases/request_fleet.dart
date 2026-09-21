import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class RequestFleet extends UseCase<DeploymentWorkflow, String> {
  const RequestFleet(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(String params) => _repository.requestFleet(params);
}
