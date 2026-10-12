import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetEligibleFleets extends UseCase<List<EligibleFleet>, NoParams> {
  const GetEligibleFleets(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<List<EligibleFleet>>> call(NoParams params) => _repository.getEligibleFleets();
}
