import 'package:evseye_core/evseye_core.dart';

import 'entities/payments_overview.dart';

abstract interface class PaymentsRepository {
  Future<Result<PaymentsOverview>> getOverview();

  Future<Result<List<PaymentRecord>>> getHistory();

  Future<Result<PaymentAttemptDetail>> getAttempt(String id);

  Future<Result<List<PaymentAttemptDetail>>> getRefunds();
}
