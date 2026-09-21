import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class GetCurrentDeployment extends UseCase<RiderDeployment, NoParams> {
  const GetCurrentDeployment(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<RiderDeployment>> call(NoParams params) => _repository.current();
}
