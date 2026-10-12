import 'package:evseye_core/evseye_core.dart';

import '../entities/raise_job_input.dart';
import '../maintenance_repository.dart';

class RaiseMaintenanceJob extends UseCase<String, RaiseJobInput> {
  const RaiseMaintenanceJob(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<String>> call(RaiseJobInput params) => _repository.raiseJob(params);
}
