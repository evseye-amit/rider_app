import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class CompleteTraining extends UseCase<DeploymentWorkflow, String> {
  const CompleteTraining(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(String params) => _repository.completeTraining(params);
}
