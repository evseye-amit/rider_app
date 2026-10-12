import 'package:evseye_core/evseye_core.dart';

import '../entities/vehicle.dart';
import '../scooter_repository.dart';

class GetVehicle extends UseCase<Vehicle, NoParams> {
  const GetVehicle(this._repository);

  final ScooterRepository _repository;

  @override
  Future<Result<Vehicle>> call(NoParams params) => _repository.getVehicle();
}
