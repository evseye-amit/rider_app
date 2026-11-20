import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'online_payments.dart';
import 'payment_recovery_store.dart';
import 'payment_refresh.dart';

enum PaymentNotice { pending, review, refundPending, refunded, inProgress }

class PaymentFlowState extends Equatable {
  const PaymentFlowState({this.busy = false, this.notice, this.requestId});

  final bool busy;
  final PaymentNotice? notice;
  final String? requestId;

  bool get canDiscard => notice == PaymentNotice.inProgress && (requestId?.startsWith('collection:') ?? false);

  bool get blocksPayment => switch (notice) {
    PaymentNotice.pending || PaymentNotice.review || PaymentNotice.refundPending || PaymentNotice.inProgress => true,
    PaymentNotice.refunded || null => false,
  };

  @override
  List<Object?> get props => [busy, notice, requestId];
}

class PaymentFlowController extends Notifier<PaymentFlowState> {
  PaymentFlowController(this.slot);

  final String slot;

  OnlinePayments get _payments => ref.read(onlinePaymentsProvider);

  @override
  PaymentFlowState build() {
    final PendingPayment? saved = _payments.saved(slot);
    final String? requestId = saved?.paymentRequestId;
    if (saved == null || requestId == null) return const PaymentFlowState();
    if (saved.paidInCheckout) unawaited(Future<void>.microtask(check));
    return PaymentFlowState(requestId: requestId, notice: saved.paidInCheckout ? PaymentNotice.pending : null);
  }

  Future<OnlinePaymentOutcome?> pay(PaymentOrderRequest request, {required String description}) =>
      _run(() => _payments.pay(request, description: description));

  Future<OnlinePaymentOutcome?> check() async {
    if (state.busy) return null;
    final String? requestId =
        state.requestId ??
        _payments.saved(slot)?.paymentRequestId ??
        await _payments.findPending(slot.split(':').first);
    if (requestId == null || !ref.mounted) return null;
    return _run(() => _payments.check(requestId));
  }

  Future<OnlinePaymentOutcome?> discard() async {
    final String? requestId = state.requestId;
    if (requestId == null) return null;
    return _run(() => _payments.abandon(requestId));
  }

  Future<OnlinePaymentOutcome?> _run(Future<OnlinePaymentOutcome> Function() action) async {
    if (state.busy) return null;
    final PaymentFlowState before = state;
    state = PaymentFlowState(busy: true, notice: before.notice, requestId: before.requestId);
    final OnlinePaymentOutcome outcome = await action();
    if (!ref.mounted) return outcome;
    state = _next(outcome, before);
    if (outcome is! OnlinePaymentError && outcome is! OnlinePaymentInProgress) refreshPaymentData(ref.invalidate);
    return outcome;
  }

  static PaymentFlowState _next(OnlinePaymentOutcome outcome, PaymentFlowState before) => switch (outcome) {
    OnlinePaymentPending(:final paymentRequestId) => PaymentFlowState(
      notice: before.notice == PaymentNotice.inProgress ? PaymentNotice.inProgress : PaymentNotice.pending,
      requestId: paymentRequestId,
    ),
    OnlinePaymentNeedsSupport(:final paymentRequestId) => PaymentFlowState(
      notice: PaymentNotice.review,
      requestId: paymentRequestId,
    ),
    OnlinePaymentRefundPending(:final paymentRequestId) => PaymentFlowState(
      notice: PaymentNotice.refundPending,
      requestId: paymentRequestId,
    ),
    OnlinePaymentRefunded(:final paymentRequestId) => PaymentFlowState(
      notice: PaymentNotice.refunded,
      requestId: paymentRequestId,
    ),
    OnlinePaymentInProgress(:final paymentRequestId) => PaymentFlowState(
      notice: PaymentNotice.inProgress,
      requestId: paymentRequestId,
    ),
    OnlinePaymentCancelled(:final paymentRequestId) ||
    OnlinePaymentDeclined(:final paymentRequestId) ||
    OnlinePaymentUnavailable(:final paymentRequestId) => PaymentFlowState(requestId: paymentRequestId),
    OnlinePaymentPaid() || OnlinePaymentAutoPayRefused() => const PaymentFlowState(),
    OnlinePaymentError() => PaymentFlowState(notice: before.notice, requestId: before.requestId),
  };
}

final paymentFlowProvider = NotifierProvider.autoDispose.family<PaymentFlowController, PaymentFlowState, String>(
  PaymentFlowController.new,
);
