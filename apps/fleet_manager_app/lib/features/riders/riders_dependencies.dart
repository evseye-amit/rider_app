import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/riders_repository_impl.dart';
import 'domain/riders_repository.dart';
import 'domain/usecases/get_riders.dart';

final ridersRepositoryProvider = Provider<RidersRepository>(
  (ref) => RidersRepositoryImpl(ref.watch(apiClientProvider)),
);

final getRidersProvider = Provider<GetRiders>((ref) => GetRiders(ref.watch(ridersRepositoryProvider)));
