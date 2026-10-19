import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class GetWorkPartners extends UseCase<List<WorkPartnerOption>, NoParams> {
  const GetWorkPartners(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<List<WorkPartnerOption>>> call(NoParams params) => _repository.getWorkPartners();
}
