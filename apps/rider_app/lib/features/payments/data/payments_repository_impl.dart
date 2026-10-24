import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/auto_pay_setup.dart';
import '../domain/entities/payments_overview.dart';
import '../domain/payments_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  const PaymentsRepositoryImpl(this._api, this._penalties);

  final RiderPaymentsApi _api;
  final SubmissionPenaltyApi _penalties;

  @override
  Future<Result<PaymentsOverview>> getOverview() async {
    final (Result<PaymentsHome> home, Result<SubmissionPenaltySummaryDto> penalties) = await (
      _api.home(),
      _penalties.summary(),
    ).wait;
    return home.map((value) => _overview(value, penalties.valueOrNull));
  }

  @override
  Future<Result<List<PaymentRecord>>> getHistory() async =>
      (await _api.history()).map((records) => [for (final RiderPaymentRecord record in records) _record(record)]);

  @override
  Future<Result<PaymentAttemptDetail>> getAttempt(String id) async => (await _api.attempt(id)).map(_attempt);

  @override
  Future<Result<List<PaymentAttemptDetail>>> getRefunds() async => (await _api.refunds()).map(
    (refunds) => [
      for (final PaymentRefund refund in refunds)
        PaymentAttemptDetail(
          id: refund.id,
          status: refund.status,
          amount: refund.amount,
          startedAt: refund.requestedAt,
          completedAt: refund.completedAt,
        ),
    ],
  );

  @override
  Future<Result<AutoPaySetup?>> getAutoPay() async => switch (await _api.autoPay()) {
    Ok<AutoPaySetupDto>(:final value) => Result.ok(_setup(value)),
    Err<AutoPaySetupDto>(failure: ServerFailure(status: 400 || 404)) => const Result<AutoPaySetup?>.ok(null),
    Err<AutoPaySetupDto>(:final failure) => Result.err(failure),
  };

  @override
  Future<Result<AutoPayMandate>> setUpAutoPay({required String email, required String idempotencyKey}) async =>
      (await _api.setUpAutoPay(email: email, idempotencyKey: idempotencyKey)).map(_mandate);

  @override
  Future<Result<AutoPayMandate>> verifyAutoPay(String mandateId) async =>
      (await _api.verifyAutoPay(mandateId)).map(_mandate);

  @override
  Future<Result<AutoPayMandate>> cancelAutoPay(String mandateId, {required String idempotencyKey}) async =>
      (await _api.cancelAutoPay(mandateId, idempotencyKey: idempotencyKey)).map(_mandate);

  @override
  Future<Result<AutoPayMandate>> pauseAutoPay(
    String mandateId, {
    required bool pause,
    required String idempotencyKey,
  }) async => (await _api.pauseAutoPay(mandateId, pause: pause, idempotencyKey: idempotencyKey)).map(_mandate);

  @override
  Future<Result<AutoPayMandate>> setAutoDebit({required bool enabled}) async =>
      (await _api.setAutoDebit(enabled: enabled)).map(_mandate);

  static AutoPaySetup _setup(AutoPaySetupDto dto) {
    final AutoPayMandate? mandate = switch (dto.mandate) {
      final AutoPayMandateDto value => _mandate(value),
      null => null,
    };
    return AutoPaySetup(
      canSetUp: dto.provider == 'RAZORPAY' && (mandate == null || mandate.state == AutoPayMandateState.closed),
      maxAmount: dto.maxAmount,
      mandate: mandate,
    );
  }

  static AutoPayMandate _mandate(AutoPayMandateDto dto) => AutoPayMandate(
    id: dto.id,
    state: switch (dto.status) {
      'ACTIVE' => AutoPayMandateState.active,
      'PAUSED' => AutoPayMandateState.paused,
      'CANCELLED' || 'FAILED' || 'EXPIRED' => AutoPayMandateState.closed,
      _ => AutoPayMandateState.awaitingApproval,
    },
    autoDebitOn: dto.autoDebitEnabled,
    canPause: dto.canPause,
    canResume: dto.canResume,
    canCancel: dto.canCancel,
    canTurnOff: dto.canTurnOff,
    cancellationPending: dto.cancellationPending,
    managedInUpiApp: dto.provider == 'RAZORPAY',
    approvalUrl: dto.authorizationUrl,
  );

  static PaymentsOverview _overview(PaymentsHome home, SubmissionPenaltySummaryDto? damage) => PaymentsOverview(
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
    damageDue: damage?.outstandingAmount ?? 0,
    damageCount: damage?.pendingCount ?? 0,
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
