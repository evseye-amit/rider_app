import 'package:evseye_core/evseye_core.dart';

import 'entities/vehicle.dart';

abstract interface class ScooterRepository {
  Future<Result<Vehicle>> getVehicle();
}
