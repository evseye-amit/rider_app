import 'package:evseye_core/evseye_core.dart';

import '../entities/payments_overview.dart';
import '../payments_repository.dart';

class GetPaymentAttempt extends UseCase<PaymentAttemptDetail, String> {
  const GetPaymentAttempt(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<PaymentAttemptDetail>> call(String params) => _repository.getAttempt(params);
}
