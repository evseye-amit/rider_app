import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/vehicle.dart';
import '../../scooter_dependencies.dart';

final vehicleProvider = FutureProvider.autoDispose<Vehicle>(
  (ref) async => (await ref.watch(getVehicleProvider)(const NoParams())).getOrThrow(),
);
