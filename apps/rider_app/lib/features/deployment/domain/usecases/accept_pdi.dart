import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class AcceptPdiParams {
  const AcceptPdiParams({required this.allocationId, required this.items});

  final String allocationId;

  final List<PdiItemResponse> items;
}

class AcceptPdi extends UseCase<DeploymentWorkflow, AcceptPdiParams> {
  const AcceptPdi(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(AcceptPdiParams params) =>
      _repository.acceptPdi(params.allocationId, params.items);
}
