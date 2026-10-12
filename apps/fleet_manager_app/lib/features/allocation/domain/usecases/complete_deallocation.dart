import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class CompleteDeallocation extends UseCase<void, String> {
  const CompleteDeallocation(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.completeDeallocation(params);
}
