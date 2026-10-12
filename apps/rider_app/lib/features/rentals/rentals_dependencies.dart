import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/rentals_repository_impl.dart';
import 'domain/rentals_repository.dart';
import 'domain/usecases/get_rentals_overview.dart';

final rentalsRepositoryProvider = Provider<RentalsRepository>((_) => const RentalsRepositoryImpl());

final getRentalsOverviewProvider = Provider<GetRentalsOverview>(
  (ref) => GetRentalsOverview(ref.watch(rentalsRepositoryProvider)),
);
