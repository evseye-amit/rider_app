import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/auto_pay.dart';
import '../domain/entities/payments_overview.dart';
import '../domain/payments_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  const PaymentsRepositoryImpl(this._api, this._autoPay, this._penalties);

  final RiderPaymentsApi _api;
  final RiderAutoPayApi _autoPay;
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
  Future<Result<AutoPay?>> getAutoPay() async => switch (await _autoPay.current()) {
    Ok<RiderAutoPayDto>(:final value) => Result.ok(_state(value)),
    Err<RiderAutoPayDto>(failure: ServerFailure(status: 404)) => const Result<AutoPay?>.ok(null),
    Err<RiderAutoPayDto>(:final failure) => Result.err(failure),
  };

  @override
  Future<Result<AutoPayMandate>> setUpAutoPay({required String email, required String idempotencyKey}) async =>
      (await _autoPay.setUpMandate(email: email, idempotencyKey: idempotencyKey)).map(_mandate);

  @override
  Future<Result<AutoPayMandate>> verifyAutoPay(String mandateId) async =>
      (await _autoPay.verifyMandate(mandateId)).map(_mandate);

  static AutoPay _state(RiderAutoPayDto dto) => AutoPay(
    state: switch (dto.effectiveStatus) {
      'OFF' => AutoPayState.off,
      'SETUP_REQUIRED' => AutoPayState.setupRequired,
      'AUTHORIZATION_PENDING' => AutoPayState.authorizationPending,
      'ACTIVATION_PENDING' => AutoPayState.activationPending,
      'MANDATE_ACTION_REQUIRED' => AutoPayState.mandateActionRequired,
      'WAITING_FOR_ALLOCATION' => AutoPayState.waitingForAllocation,
      'ACTIVE' => AutoPayState.active,
      'ACTION_REQUIRED' => AutoPayState.actionRequired,
      'PAUSED_BY_CLIENT' => AutoPayState.pausedByClient,
      'MIGRATION_BLOCKED' => AutoPayState.migrationBlocked,
      _ => AutoPayState.unknown,
    },
    enabled: dto.enabled,
    threshold: dto.threshold,
    rechargeAmount: dto.rechargeAmount,
    leadHours: dto.minimumLeadHours,
    cooldownHours: dto.cooldownHours,
    canSetUp: dto.canSetup,
    setupLimit: dto.setupMaxAmount,
    mandate: switch (dto.mandate) {
      final AutoPayMandateDto mandate => _mandate(mandate),
      null => null,
    },
    requests: [
      for (final AutoPayRechargeDto request in dto.requests)
        AutoRecharge(
          id: request.id,
          state: switch (request.status) {
            'CREATING' => AutoRechargeState.creating,
            'PENDING' => AutoRechargeState.pending,
            'REVIEW_REQUIRED' => AutoRechargeState.review,
            'SUCCESS' => AutoRechargeState.success,
            'FAILED' => AutoRechargeState.failed,
            'CANCELLED' => AutoRechargeState.cancelled,
            _ => AutoRechargeState.unknown,
          },
          amount: request.amount,
          scheduledAt: request.scheduledAt,
          completedAt: request.completedAt,
          createdAt: request.createdAt,
        ),
    ],
  );

  static AutoPayMandate _mandate(AutoPayMandateDto dto) => AutoPayMandate(
    id: dto.id,
    state: switch (dto.status) {
      'ACTIVE' => AutoPayMandateState.active,
      'PAUSED' => AutoPayMandateState.paused,
      'CANCELLED' || 'FAILED' || 'EXPIRED' => AutoPayMandateState.closed,
      _ => AutoPayMandateState.awaitingApproval,
    },
    maxAmount: dto.maxAmount,
    cancellationPending: dto.cancellationPending,
    expiresAt: dto.expiresAt,
    approvalUrl: dto.authorizationUrl,
  );

  static PaymentsOverview _overview(PaymentsHome home, SubmissionPenaltySummaryDto? damage) => PaymentsOverview(
    amountDue: home.amountDue,
    overdueAmount: home.overdueAmount,
    currency: home.currency,
    balances: [
      for (final CurrencyBalance balance in home.balancesByCurrency)
        DueBalance(currency: balance.currency, amountDue: balance.amountDue, overdueAmount: balance.overdueAmount),
    ],
    payNowUnavailableReason: home.payNowUnavailableReason,
    payNowAvailable: home.payNowAvailable,
    recentPayments: [for (final RiderPaymentRecord record in home.recentPayments) _record(record)],
    dueDate: home.dueDate,
    damageDue: damage?.outstandingAmount ?? 0,
    damageCount: damage?.pendingCount ?? 0,
  );

  static PaymentRecord _record(RiderPaymentRecord record) => PaymentRecord(
    id: record.id,
    amount: record.amount,
    method: record.method,
    status: record.status,
    receivedAt: record.receivedAt,
    invoiceCount: record.allocations.length,
  );
}
