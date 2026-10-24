import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/profile_repository_impl.dart';
import 'domain/profile_repository.dart';
import 'domain/usecases/get_rider_profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(riderAppApiProvider)),
);

final getRiderProfileProvider = Provider<GetRiderProfile>(
  (ref) => GetRiderProfile(ref.watch(profileRepositoryProvider)),
);
