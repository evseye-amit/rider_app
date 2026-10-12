import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/earnings_repository_impl.dart';
import 'domain/earnings_repository.dart';
import 'domain/usecases/get_incentives_overview.dart';

final earningsRepositoryProvider = Provider<EarningsRepository>((_) => const EarningsRepositoryImpl());

final getIncentivesOverviewProvider = Provider<GetIncentivesOverview>(
  (ref) => GetIncentivesOverview(ref.watch(earningsRepositoryProvider)),
);
