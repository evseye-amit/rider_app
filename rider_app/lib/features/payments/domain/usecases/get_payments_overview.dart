import 'package:evseye_core/evseye_core.dart';

import '../entities/payments_overview.dart';
import '../payments_repository.dart';

class GetPaymentsOverview extends UseCase<PaymentsOverview, NoParams> {
  const GetPaymentsOverview(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<PaymentsOverview>> call(NoParams params) => _repository.getOverview();
}
