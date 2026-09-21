import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class CompleteInspection extends UseCase<void, String> {
  const CompleteInspection(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.completeInspection(params);
}
