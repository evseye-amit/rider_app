import 'package:evseye_core/evseye_core.dart';

import '../entities/auto_pay_setup.dart';
import '../payments_repository.dart';

class GetUpcomingDebits extends UseCase<List<AutoPayDebit>, NoParams> {
  const GetUpcomingDebits(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<List<AutoPayDebit>>> call(NoParams params) => _repository.getUpcomingDebits();
}

class GetAutoPayDebits extends UseCase<List<AutoPayDebit>, NoParams> {
  const GetAutoPayDebits(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<List<AutoPayDebit>>> call(NoParams params) => _repository.getDebits();
}
