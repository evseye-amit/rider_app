import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/vehicle_option.dart';
import '../../domain/entities/vendor_option.dart';
import '../../maintenance_dependencies.dart';

final vehicleOptionsProvider = FutureProvider.autoDispose<List<VehicleOption>>(
  (ref) async => (await ref.watch(getVehicleOptionsProvider)(const NoParams())).getOrThrow(),
);

final vendorOptionsProvider = FutureProvider.autoDispose<List<VendorOption>>(
  (ref) async => (await ref.watch(getVendorOptionsProvider)(const NoParams())).getOrThrow(),
);
