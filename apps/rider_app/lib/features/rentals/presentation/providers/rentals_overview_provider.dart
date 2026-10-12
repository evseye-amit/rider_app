import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rental.dart';
import '../../rentals_dependencies.dart';

final rentalsOverviewProvider = FutureProvider.autoDispose<RentalsOverview>(
  (ref) async => (await ref.watch(getRentalsOverviewProvider)(const NoParams())).getOrThrow(),
);
