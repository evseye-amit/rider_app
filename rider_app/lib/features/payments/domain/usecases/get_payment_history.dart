import 'package:evseye_core/evseye_core.dart';

import '../entities/payments_overview.dart';
import '../payments_repository.dart';

class GetPaymentHistory extends UseCase<List<PaymentRecord>, NoParams> {
  const GetPaymentHistory(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<List<PaymentRecord>>> call(NoParams params) => _repository.getHistory();
}
