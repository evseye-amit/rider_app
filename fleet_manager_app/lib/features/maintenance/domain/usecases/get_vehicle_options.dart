import 'package:evseye_core/evseye_core.dart';

import '../entities/vehicle_option.dart';
import '../maintenance_repository.dart';

class GetVehicleOptions extends UseCase<List<VehicleOption>, NoParams> {
  const GetVehicleOptions(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<List<VehicleOption>>> call(NoParams params) => _repository.getVehicleOptions();
}
