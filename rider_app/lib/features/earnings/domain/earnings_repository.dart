import 'package:evseye_core/evseye_core.dart';

import 'entities/earnings_overview.dart';
import 'entities/incentive_scheme.dart';

abstract interface class EarningsRepository {
  Future<Result<EarningsOverview>> getEarnings();

  Future<Result<IncentivesOverview>> getIncentives();
}
