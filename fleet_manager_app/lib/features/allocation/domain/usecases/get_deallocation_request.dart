import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';
import '../entities/deallocation_request.dart';

class GetDeallocationRequest extends UseCase<DeallocationRequest, String> {
  const GetDeallocationRequest(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeallocationRequest>> call(String requestId) =>
      _repository.getDeallocationRequest(requestId);
}
