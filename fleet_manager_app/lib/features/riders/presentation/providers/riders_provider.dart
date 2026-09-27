import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rider.dart';
import '../../riders_dependencies.dart';

final ridersProvider = FutureProvider.autoDispose<List<Rider>>(
  (ref) async => (await ref.watch(getRidersProvider)(const NoParams())).getOrThrow(),
);
