import 'package:evseye_core/evseye_core.dart';

import '../entities/hub_summary.dart';
import '../hub_repository.dart';

class GetHubSummary extends UseCase<HubSummary, String> {
  const GetHubSummary(this._repository);

  final HubRepository _repository;

  @override

  Future<Result<HubSummary>> call(String params) => _repository.getSummary(params);
}
