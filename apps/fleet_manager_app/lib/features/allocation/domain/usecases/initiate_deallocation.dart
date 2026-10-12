import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class InitiateDeallocation extends UseCase<DeallocationStart, String> {
  const InitiateDeallocation(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeallocationStart>> call(String params) => _repository.initiateDeallocation(params);
}
