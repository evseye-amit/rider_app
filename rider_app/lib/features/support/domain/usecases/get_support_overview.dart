import 'package:evseye_core/evseye_core.dart';

import '../entities/support_overview.dart';
import '../support_repository.dart';

class GetSupportOverview extends UseCase<SupportOverview, NoParams> {
  const GetSupportOverview(this._repository);

  final SupportRepository _repository;

  @override
  Future<Result<SupportOverview>> call(NoParams params) =>
      _repository.getOverview();
}
