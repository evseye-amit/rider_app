import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/ride_returns_repository_impl.dart';
import 'domain/ride_returns_repository.dart';
import 'domain/usecases/ride_return_usecases.dart';

final rideReturnsRepositoryProvider = Provider<RideReturnsRepository>(
  (ref) => RideReturnsRepositoryImpl(ref.watch(rideReturnsApiProvider)),
);

final getRideReturnsProvider = Provider<GetRideReturns>(
  (ref) => GetRideReturns(ref.watch(rideReturnsRepositoryProvider)),
);

final getRideReturnProvider = Provider<GetRideReturn>((ref) => GetRideReturn(ref.watch(rideReturnsRepositoryProvider)));

final requestRideReturnProvider = Provider<RequestRideReturn>(
  (ref) => RequestRideReturn(ref.watch(rideReturnsRepositoryProvider)),
);

final cancelRideReturnProvider = Provider<CancelRideReturn>(
  (ref) => CancelRideReturn(ref.watch(rideReturnsRepositoryProvider)),
);
