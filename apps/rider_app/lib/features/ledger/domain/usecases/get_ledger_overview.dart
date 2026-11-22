import 'package:evseye_core/evseye_core.dart';

import '../entities/ledger_overview.dart';
import '../ledger_repository.dart';

class GetLedgerOverview extends UseCase<LedgerOverview, NoParams> {
  const GetLedgerOverview(this._repository);

  final LedgerRepository _repository;

  @override
  Future<Result<LedgerOverview>> call(NoParams params) => _repository.getOverview();
}
