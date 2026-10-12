import 'package:evseye_core/evseye_core.dart';

import '../entities/maintenance_job.dart';
import '../maintenance_repository.dart';

class GetMaintenanceJob extends UseCase<MaintenanceJob, String> {
  const GetMaintenanceJob(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<MaintenanceJob>> call(String jobId) => _repository.getJob(jobId);
}
