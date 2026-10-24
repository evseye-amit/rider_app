import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rider_profile.dart';
import '../../profile_dependencies.dart';

final riderProfileProvider = FutureProvider.autoDispose<RiderProfile>(
  (ref) async => (await ref.watch(getRiderProfileProvider)(const NoParams())).getOrThrow(),
);
