import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/payments_overview.dart';
import '../domain/payments_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  const PaymentsRepositoryImpl(this._api);

  final RiderPaymentsApi _api;

  @override
  Future<Result<PaymentsOverview>> getOverview() async => (await _api.home()).map(_overview);

  @override
  Future<Result<List<PaymentRecord>>> getHistory() async =>
      (await _api.history()).map((records) => [for (final RiderPaymentRecord record in records) _record(record)]);

  @override
  Future<Result<PaymentAttemptDetail>> getAttempt(String id) async => (await _api.attempt(id)).map(_attempt);

  @override
  Future<Result<List<PaymentAttemptDetail>>> getRefunds() async =>
      (await _api.refunds()).map((attempts) => [for (final PaymentAttempt attempt in attempts) _attempt(attempt)]);

  static PaymentsOverview _overview(PaymentsHome home) => PaymentsOverview(
    amountDue: home.amountDue,
    overdueAmount: home.overdueAmount,
    currency: home.currency,
    autoPay: _autoPay(home.autoPayStatus),
    payNowAvailable: home.payNowAvailable,
    recentPayments: [for (final RiderPaymentRecord record in home.recentPayments) _record(record)],
    dueDate: home.dueDate,
    paymentMethod: home.paymentMethod,
    mandateMaxAmount: home.mandateMaxAmount,
    mandateExpiresAt: home.mandateExpiresAt,
    nextAutoPayDate: home.nextAutoPayDate,
  );

  static AutoPayState _autoPay(AutoPayStatus status) => switch (status) {
    AutoPayStatus.notEnabled => AutoPayState.notEnabled,
    AutoPayStatus.setupRequired => AutoPayState.setupRequired,
    AutoPayStatus.authenticationPending => AutoPayState.authenticationPending,
    AutoPayStatus.active => AutoPayState.active,
    AutoPayStatus.paused => AutoPayState.paused,
    AutoPayStatus.failed => AutoPayState.failed,
    AutoPayStatus.revoked => AutoPayState.revoked,
    AutoPayStatus.expired => AutoPayState.expired,
  };

  static PaymentRecord _record(RiderPaymentRecord record) => PaymentRecord(
    id: record.id,
    amount: record.amount,
    method: record.method,
    status: record.status,
    receivedAt: record.receivedAt,
    invoiceCount: record.allocations.length,
  );

  static PaymentAttemptDetail _attempt(PaymentAttempt attempt) => PaymentAttemptDetail(
    id: attempt.id,
    status: attempt.status,
    amount: attempt.amount,
    method: attempt.method,
    startedAt: attempt.startedAt,
    completedAt: attempt.completedAt,
  );
}
