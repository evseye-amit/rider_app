import 'package:evseye_core/evseye_core.dart';

import '../earnings_repository.dart';
import '../entities/incentive_scheme.dart';

class GetIncentivesOverview extends UseCase<IncentivesOverview, NoParams> {
  const GetIncentivesOverview(this._repository);

  final EarningsRepository _repository;

  @override
  Future<Result<IncentivesOverview>> call(NoParams params) =>
      _repository.getIncentives();
}
