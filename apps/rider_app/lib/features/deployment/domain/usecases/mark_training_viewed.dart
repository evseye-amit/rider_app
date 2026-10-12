import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class TrainingViewedParams {
  const TrainingViewedParams({required this.allocationId, required this.contentCode});

  final String allocationId;
  final String contentCode;
}

class MarkTrainingViewed extends UseCase<DeploymentWorkflow, TrainingViewedParams> {
  const MarkTrainingViewed(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(TrainingViewedParams params) =>
      _repository.markTrainingViewed(params.allocationId, params.contentCode);
}
