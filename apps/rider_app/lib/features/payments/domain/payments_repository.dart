import 'package:evseye_core/evseye_core.dart';

import 'entities/auto_pay.dart';
import 'entities/payments_overview.dart';

abstract interface class PaymentsRepository {
  Future<Result<PaymentsOverview>> getOverview();

  Future<Result<List<PaymentRecord>>> getHistory();

  Future<Result<AutoPay?>> getAutoPay();

  Future<Result<AutoPayMandate>> setUpAutoPay({required String email, required String idempotencyKey});

  Future<Result<AutoPayMandate>> verifyAutoPay(String mandateId);

  Future<Result<AutoRechargePage>> getAutoRecharges(int page);
}
