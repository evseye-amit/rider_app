import 'package:evseye_core/evseye_core.dart';

import '../entities/home_summary.dart';
import '../home_repository.dart';

class GetHomeSummary extends UseCase<HomeSummary, NoParams> {
  const GetHomeSummary(this._repository);

  final HomeRepository _repository;

  @override
  Future<Result<HomeSummary>> call(NoParams params) => _repository.getSummary();
}
