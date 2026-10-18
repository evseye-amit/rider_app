import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class AskPayment extends UseCase<DeploymentPayment, String> {
  const AskPayment(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentPayment>> call(String allocationId) => _repository.askPayment(allocationId);
}
