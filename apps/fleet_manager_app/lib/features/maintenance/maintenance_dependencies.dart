import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/maintenance_repository_impl.dart';
import 'domain/maintenance_repository.dart';
import 'domain/usecases/maintenance_usecases.dart';

final maintenanceRepositoryProvider = Provider<MaintenanceRepository>(
  (ref) => MaintenanceRepositoryImpl(ref.watch(apiClientProvider), ref.watch(mediaApiProvider)),
);

final getMaintenanceVehiclesProvider = Provider<GetMaintenanceVehicles>(
  (ref) => GetMaintenanceVehicles(ref.watch(maintenanceRepositoryProvider)),
);

final getMaintenanceVehicleProvider = Provider<GetMaintenanceVehicle>(
  (ref) => GetMaintenanceVehicle(ref.watch(maintenanceRepositoryProvider)),
);

final getEvidencePhotoUrlProvider = Provider<GetEvidencePhotoUrl>(
  (ref) => GetEvidencePhotoUrl(ref.watch(maintenanceRepositoryProvider)),
);

final changeVehicleStatusProvider = Provider<ChangeVehicleStatus>(
  (ref) => ChangeVehicleStatus(ref.watch(maintenanceRepositoryProvider)),
);
