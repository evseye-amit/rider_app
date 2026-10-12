import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetPendingRider extends UseCase<PendingRider, String> {
  const GetPendingRider(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<PendingRider>> call(String params) => _repository.getPendingRider(params);
}
