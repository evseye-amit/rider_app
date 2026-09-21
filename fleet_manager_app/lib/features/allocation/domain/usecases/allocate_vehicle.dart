import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class AllocateParams {
  const AllocateParams({required this.riderId, required this.fleetId});

  final String riderId;
  final String fleetId;
}

class AllocateVehicle extends UseCase<DeploymentAllocation, AllocateParams> {
  const AllocateVehicle(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentAllocation>> call(AllocateParams params) => _repository.allocate(riderId: params.riderId, fleetId: params.fleetId);
}
