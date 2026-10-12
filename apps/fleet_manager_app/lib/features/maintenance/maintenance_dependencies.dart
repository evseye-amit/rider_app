import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/maintenance_repository_impl.dart';
import 'domain/maintenance_repository.dart';
import 'domain/usecases/get_maintenance_board.dart';
import 'domain/usecases/get_maintenance_job.dart';
import 'domain/usecases/get_vehicle_options.dart';
import 'domain/usecases/get_vendor_options.dart';
import 'domain/usecases/raise_maintenance_job.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => MaintenanceRepositoryImpl(ref.watch(apiClientProvider)),
);

final getMaintenanceBoardProvider = Provider<GetMaintenanceBoard>(
  (ref) => GetMaintenanceBoard(ref.watch(maintenanceRepositoryProvider)),
);

final getMaintenanceJobProvider = Provider<GetMaintenanceJob>(
  (ref) => GetMaintenanceJob(ref.watch(maintenanceRepositoryProvider)),
);

final getVehicleOptionsProvider = Provider<GetVehicleOptions>(
  (ref) => GetVehicleOptions(ref.watch(maintenanceRepositoryProvider)),
);

final getVendorOptionsProvider = Provider<GetVendorOptions>(
  (ref) => GetVendorOptions(ref.watch(maintenanceRepositoryProvider)),
);

final raiseMaintenanceJobProvider = Provider<RaiseMaintenanceJob>(
  (ref) => RaiseMaintenanceJob(ref.watch(maintenanceRepositoryProvider)),
);
