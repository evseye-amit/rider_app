import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class BypassPairingParams {
  const BypassPairingParams({required this.allocationId, required this.remarks});

  final String allocationId;
  final String remarks;
}

class BypassPairing extends UseCase<DeploymentWorkflow, BypassPairingParams> {
  const BypassPairing(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(BypassPairingParams params) => _repository.bypassPairing(params.allocationId, params.remarks);
}
