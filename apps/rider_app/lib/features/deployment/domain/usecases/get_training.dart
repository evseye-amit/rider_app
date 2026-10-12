import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class GetTraining extends UseCase<List<TrainingItem>, String> {
  const GetTraining(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<List<TrainingItem>>> call(String params) => _repository.training(params);
}
