import 'package:evseye_core/evseye_core.dart';

import '../entities/payments_overview.dart';
import '../payments_repository.dart';

class GetPaymentRefunds extends UseCase<List<PaymentAttemptDetail>, NoParams> {
  const GetPaymentRefunds(this._repository);

  final PaymentsRepository _repository;

  @override
  Future<Result<List<PaymentAttemptDetail>>> call(NoParams params) => _repository.getRefunds();
}
