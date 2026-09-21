import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class PairDeviceParams {
  const PairDeviceParams({required this.allocationId, required this.deviceNumber});

  final String allocationId;
  final String deviceNumber;
}

class PairDevice extends UseCase<DeploymentWorkflow, PairDeviceParams> {
  const PairDevice(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(PairDeviceParams params) =>
      _repository.pair(params.allocationId, params.deviceNumber);
}
