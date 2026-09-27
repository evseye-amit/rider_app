import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/incentive_scheme.dart';
import '../../earnings_dependencies.dart';

final incentivesOverviewProvider = FutureProvider.autoDispose<IncentivesOverview>(
  (ref) async => (await ref.watch(getIncentivesOverviewProvider)(const NoParams())).getOrThrow(),
);
