import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/scooter_repository_impl.dart';
import 'domain/scooter_repository.dart';
import 'domain/usecases/get_vehicle.dart';

final scooterRepositoryProvider = Provider<ScooterRepository>(
  (ref) => ScooterRepositoryImpl(ref.watch(deploymentApiProvider)),
);

final getVehicleProvider = Provider<GetVehicle>((ref) => GetVehicle(ref.watch(scooterRepositoryProvider)));
