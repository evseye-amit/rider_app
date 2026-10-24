import 'package:evseye_core/evseye_core.dart';

import 'entities/auto_pay_setup.dart';
import 'entities/payments_overview.dart';

abstract interface class PaymentsRepository {
  Future<Result<PaymentsOverview>> getOverview();

  Future<Result<List<PaymentRecord>>> getHistory();

  Future<Result<PaymentAttemptDetail>> getAttempt(String id);

  Future<Result<List<PaymentAttemptDetail>>> getRefunds();

  Future<Result<AutoPaySetup?>> getAutoPay();

  Future<Result<AutoPayMandate>> setUpAutoPay({required String email, required String idempotencyKey});

  Future<Result<AutoPayMandate>> verifyAutoPay(String mandateId);

  Future<Result<AutoPayMandate>> cancelAutoPay(String mandateId, {required String idempotencyKey});

  Future<Result<AutoPayMandate>> pauseAutoPay(String mandateId, {required bool pause, required String idempotencyKey});

  Future<Result<AutoPayMandate>> setAutoDebit({required bool enabled});
}
