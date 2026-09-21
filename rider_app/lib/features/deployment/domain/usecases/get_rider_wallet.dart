import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class GetRiderWallet extends UseCase<RiderWallet, NoParams> {
  const GetRiderWallet(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<RiderWallet>> call(NoParams params) => _repository.wallet();
}
