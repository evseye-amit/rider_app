import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetAllocationEvidence extends UseCase<AllocationEvidence, String> {
  const GetAllocationEvidence(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationEvidence>> call(String params) => _repository.getEvidence(params);
}
