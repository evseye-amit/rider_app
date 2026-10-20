import 'package:evseye_core/evseye_core.dart';

import 'entities/maintenance_vehicle.dart';
import 'usecases/maintenance_usecases.dart';

abstract interface class MaintenanceRepository {
  Future<Result<MaintenanceVehicleList>> vehicles(MaintenanceQuery query);

  Future<Result<MaintenanceVehicleDetail>> vehicle(String fleetId);

  Future<Result<String>> photoUrl(String photoId);

  Future<Result<void>> changeStatus(String fleetId, String status);
}
