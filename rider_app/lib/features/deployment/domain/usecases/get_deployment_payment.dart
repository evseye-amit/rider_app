import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class GetDeploymentPayment extends UseCase<DeploymentPayment, String> {
  const GetDeploymentPayment(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentPayment>> call(String params) => _repository.payment(params);
}
