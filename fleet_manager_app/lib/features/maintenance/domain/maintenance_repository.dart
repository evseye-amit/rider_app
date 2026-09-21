import 'package:evseye_core/evseye_core.dart';

import 'entities/maintenance_board.dart';
import 'entities/maintenance_job.dart';
import 'entities/raise_job_input.dart';
import 'entities/vehicle_option.dart';
import 'entities/vendor_option.dart';

abstract interface class MaintenanceRepository {
  Future<Result<MaintenanceBoard>> getBoard();

  Future<Result<MaintenanceJob>> getJob(String id);

  Future<Result<List<VehicleOption>>> getVehicleOptions();

  Future<Result<List<VendorOption>>> getVendorOptions();

  Future<Result<String>> raiseJob(RaiseJobInput input);
}
