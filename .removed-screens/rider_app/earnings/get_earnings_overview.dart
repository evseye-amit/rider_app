import 'package:evseye_core/evseye_core.dart';

import '../earnings_repository.dart';
import '../entities/earnings_overview.dart';

class GetEarningsOverview extends UseCase<EarningsOverview, NoParams> {
  const GetEarningsOverview(this._repository);

  final EarningsRepository _repository;

  @override
  Future<Result<EarningsOverview>> call(NoParams params) =>
      _repository.getEarnings();
}
