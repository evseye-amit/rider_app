import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';

typedef AssignVehicleOptions = ({PendingRider rider, List<EligibleFleet> vehicles});

final assignVehicleOptionsProvider = FutureProvider.autoDispose.family<AssignVehicleOptions, String>((
  ref,
  riderId,
) async {
  final (Result<PendingRider> rider, Result<List<EligibleFleet>> vehicles) = await (
    ref.watch(getPendingRiderProvider)(riderId),
    ref.watch(getEligibleFleetsProvider)(const NoParams()),
  ).wait;
  return (rider: rider.getOrThrow(), vehicles: vehicles.getOrThrow());
});
