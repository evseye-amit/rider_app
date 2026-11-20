import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/rider_session_provider.dart';
import 'payment_recovery_store.dart';
import 'razorpay_checkout.dart';

sealed class OnlinePaymentOutcome {
  const OnlinePaymentOutcome([this.paymentRequestId]);

  final String? paymentRequestId;
}

final class OnlinePaymentPaid extends OnlinePaymentOutcome {
  const OnlinePaymentPaid([super.paymentRequestId, this.autoPay]);

  final PaymentAutoPayDto? autoPay;
}

final class OnlinePaymentPending extends OnlinePaymentOutcome {
  const OnlinePaymentPending([super.paymentRequestId]);
}

final class OnlinePaymentNeedsSupport extends OnlinePaymentOutcome {
  const OnlinePaymentNeedsSupport([super.paymentRequestId]);
}

final class OnlinePaymentRefundPending extends OnlinePaymentOutcome {
  const OnlinePaymentRefundPending([super.paymentRequestId]);
}

final class OnlinePaymentRefunded extends OnlinePaymentOutcome {
  const OnlinePaymentRefunded([super.paymentRequestId]);
}

final class OnlinePaymentDeclined extends OnlinePaymentOutcome {
  const OnlinePaymentDeclined([super.paymentRequestId]);
}

final class OnlinePaymentCancelled extends OnlinePaymentOutcome {
  const OnlinePaymentCancelled([super.paymentRequestId]);
}

final class OnlinePaymentInProgress extends OnlinePaymentOutcome {
  const OnlinePaymentInProgress([super.paymentRequestId]);
}

final class OnlinePaymentUnavailable extends OnlinePaymentOutcome {
  const OnlinePaymentUnavailable([super.paymentRequestId]);
}

final class OnlinePaymentAutoPayRefused extends OnlinePaymentOutcome {
  const OnlinePaymentAutoPayRefused(this.code);

  final String code;
}

final class OnlinePaymentError extends OnlinePaymentOutcome {
  const OnlinePaymentError(this.message);

  final String message;
}

class PaymentIdentity {
  const PaymentIdentity({this.userId, this.contact});

  final String? userId;
  final String? contact;

  String? get scope => switch (userId) {
    final String id when id.isNotEmpty => '${ApiEnv.baseUrl}|${ApiEnv.companyCode}|$id',
    _ => null,
  };
}

class OnlinePayments {
  OnlinePayments(this._api, this._store, this._identity);

  static const Set<String> supportedProviders = {PaymentProviders.razorpay};

  static const List<Duration> _backoff = [
    Duration(seconds: 2),
    Duration(seconds: 3),
    Duration(seconds: 5),
    Duration(seconds: 8),
  ];

  static const Set<String> _unavailableCodes = {
    'PAYMENT_CAPABILITY_UNAVAILABLE',
    'PAYMENT_MERCHANT_UNSUPPORTED',
    'PAYMENT_MERCHANT_UNAVAILABLE',
    'PAYMENT_POLICY_UNAVAILABLE',
    'PAYMENT_PROVIDER_UNAVAILABLE',
    'PAYMENT_UNAVAILABLE',
    'RAZORPAY_UNAVAILABLE',
  };

  static const Set<String> _autoPayRefusedCodes = {
    'AUTOPAY_NOT_IN_PACKAGE',
    'AUTOPAY_UNAVAILABLE',
    'AUTOPAY_MANDATE_EXISTS',
    'AUTOPAY_LIMIT_EXCEEDED',
    'AUTOPAY_TERMS_CHANGED',
  };

  final PaymentOrdersApi _api;
  final PaymentRecoveryStore _store;
  final PaymentIdentity Function() _identity;
  bool _busy = false;

  PendingPayment? saved(String slot) => switch (_identity().scope) {
    final String scope => _store.read(scope, slot),
    null => null,
  };

  Future<OnlinePaymentOutcome> pay(PaymentOrderRequest request, {required String description}) async {
    final PaymentIdentity identity = _identity();
    final String? scope = identity.scope;
    if (scope == null) return OnlinePaymentError(ActiveLocale.strings.commonSessionHasExpiredPleaseSign);
    if (_busy) return const OnlinePaymentInProgress();
    _busy = true;
    try {
      return await _pay(scope, request, description, identity.contact);
    } finally {
      _busy = false;
    }
  }

  Future<OnlinePaymentOutcome> check(String paymentRequestId) async {
    final String? scope = _identity().scope;
    if (scope == null) return OnlinePaymentError(ActiveLocale.strings.commonSessionHasExpiredPleaseSign);
    final Result<PaymentRequestDto> latest = await _refresh(paymentRequestId);
    switch (latest) {
      case Ok<PaymentRequestDto>(:final value) when value.isPending:
        return OnlinePaymentPending(paymentRequestId);
      case Ok<PaymentRequestDto>(:final value):
        return _finish(scope, value, paymentRequestId);
      case Err<PaymentRequestDto>(failure: final NotFoundFailure failure):
        await _store.removeRequest(scope, paymentRequestId);
        return OnlinePaymentError(failure.message);
      case Err<PaymentRequestDto>(:final failure):
        return OnlinePaymentError(failure.message);
    }
  }

  Future<OnlinePaymentOutcome> abandon(String paymentRequestId) async {
    final String? scope = _identity().scope;
    if (scope == null) return OnlinePaymentError(ActiveLocale.strings.commonSessionHasExpiredPleaseSign);
    final Result<PaymentRequestDto> result = await _api.abandon(paymentRequestId);
    return switch (result) {
      Ok<PaymentRequestDto>(:final value) when value.isPending => OnlinePaymentInProgress(paymentRequestId),
      Ok<PaymentRequestDto>(:final value) => await _finish(scope, value, paymentRequestId),
      Err<PaymentRequestDto>(:final failure) => OnlinePaymentError(failure.message),
    };
  }

  Future<List<OnlinePaymentOutcome>> recoverAll() async {
    final String? scope = _identity().scope;
    if (scope == null || _busy) return const [];
    final List<OnlinePaymentOutcome> outcomes = [];
    for (final PendingPayment payment in _store.all(scope)) {
      final String? id = payment.paymentRequestId;
      if (id == null) continue;
      final Result<PaymentRequestDto> latest = await _refresh(id);
      if (_identity().scope != scope || _busy) break;
      switch (latest) {
        case Ok<PaymentRequestDto>(:final value) when !value.isUnresolved:
          outcomes.add(await _finish(scope, value, id));
        case Err<PaymentRequestDto>(failure: NotFoundFailure()):
          await _store.remove(scope, payment.slot);
        case _:
          break;
      }
    }
    return outcomes;
  }

  Future<OnlinePaymentOutcome> _pay(
    String scope,
    PaymentOrderRequest request,
    String description,
    String? contact,
  ) async {
    PendingPayment? saved = _store.read(scope, request.slot);
    if (saved case final PendingPayment previous && PendingPayment(paymentRequestId: final String savedId)) {
      final Result<PaymentRequestDto> current = await _refresh(savedId);
      switch (current) {
        case Ok<PaymentRequestDto>(:final value)
            when value.isPending &&
                !previous.paidInCheckout &&
                !previous.matches(request) &&
                request.purpose == PaymentPurposes.deployment:
          await _store.remove(scope, request.slot);
          saved = null;
        case Ok<PaymentRequestDto>(:final value) when value.isPending:
          if (!previous.matches(request)) return OnlinePaymentInProgress(savedId);
          if (previous.paidInCheckout) return _settle(scope, savedId);
          return _proceed(scope, previous, savedId, value, description, contact);
        case Ok<PaymentRequestDto>(:final value) when value.isUnresolved:
          return _outcome(value);
        case Ok<PaymentRequestDto>():
        case Err<PaymentRequestDto>(failure: NotFoundFailure()):
          await _store.remove(scope, request.slot);
          saved = null;
        case Err<PaymentRequestDto>():
          return OnlinePaymentInProgress(savedId);
      }
    }

    final PendingPayment pending = saved != null && saved.matches(request) ? saved : PendingPayment.start(request);
    await _store.write(scope, pending);
    final Result<PaymentRequestDto> created = await _api.create(request, idempotencyKey: pending.idempotencyKey);
    switch (created) {
      case Err<PaymentRequestDto>(:final failure):
        return _createFailed(scope, request, failure);
      case Ok<PaymentRequestDto>(:final value):
        final String? id = value.paymentRequestId;
        if (id == null) {
          await _store.remove(scope, request.slot);
          return _outcome(value);
        }
        final PendingPayment tracked = pending.copyWith(paymentRequestId: id);
        await _store.write(scope, tracked);
        return _proceed(scope, tracked, id, value, description, contact);
    }
  }

  Future<OnlinePaymentOutcome> _proceed(
    String scope,
    PendingPayment pending,
    String id,
    PaymentRequestDto payment,
    String description,
    String? contact,
  ) async {
    if (!payment.isPending) return _finish(scope, payment, id);
    if (!payment.isRazorpay || (payment.hasCheckout && payment.checkout == null)) return OnlinePaymentUnavailable(id);
    final PaymentCheckoutDto? checkout = payment.checkout;
    if (checkout == null) return _settle(scope, id);

    final CheckoutResult result = await RazorpayCheckout.open(
      checkout,
      currency: payment.currency,
      description: description,
      contact: contact,
      email: pending.request.autoPayEmail,
    );
    if (_identity().scope != scope) return OnlinePaymentCancelled(id);
    switch (result) {
      case CheckoutSucceeded(:final orderId, :final paymentId, :final signature):
        await _store.write(scope, pending.copyWith(paidInCheckout: true));
        final Result<PaymentRequestDto> verified = await _api.verifyRazorpay(
          id,
          orderId: orderId,
          paymentId: paymentId,
          signature: signature,
        );
        if (verified case Ok<PaymentRequestDto>(:final value) when !value.isPending) return _finish(scope, value, id);
        return _settle(scope, id);
      case CheckoutCancelled() || CheckoutFailed():
        final Result<PaymentRequestDto> latest = await _refresh(id);
        if (latest case Ok<PaymentRequestDto>(:final value) when !value.isPending) return _finish(scope, value, id);
        return result is CheckoutCancelled ? OnlinePaymentCancelled(id) : OnlinePaymentDeclined(id);
    }
  }

  Future<OnlinePaymentOutcome> _settle(String scope, String id) async {
    for (final Duration delay in _backoff) {
      await Future<void>.delayed(delay);
      if (_identity().scope != scope) return OnlinePaymentPending(id);
      final Result<PaymentRequestDto> latest = await _refresh(id);
      if (latest case Ok<PaymentRequestDto>(:final value) when !value.isPending) return _finish(scope, value, id);
    }
    return OnlinePaymentPending(id);
  }

  Future<OnlinePaymentOutcome> _createFailed(String scope, PaymentOrderRequest request, Failure failure) async {
    final String? code = failure.serverCode;
    if (code == 'PAYMENT_ALREADY_IN_PROGRESS' || code == 'AUTOPAY_ALREADY_IN_PROGRESS') {
      await _store.remove(scope, request.slot);
      return OnlinePaymentInProgress(code == 'PAYMENT_ALREADY_IN_PROGRESS' ? await findPending(request.purpose) : null);
    }
    if (code == 'WALLET_INACTIVE') {
      await _store.remove(scope, request.slot);
      return OnlinePaymentError(ActiveLocale.strings.paymentWalletInactive);
    }
    if (code != null && _autoPayRefusedCodes.contains(code)) {
      await _store.remove(scope, request.slot);
      return OnlinePaymentAutoPayRefused(code);
    }
    if (failure is ServerFailure && failure.status == 503) return const OnlinePaymentUnavailable();
    if (_unavailableCodes.contains(code)) {
      await _store.remove(scope, request.slot);
      return const OnlinePaymentUnavailable();
    }
    if (failure is NetworkFailure ||
        (failure is ServerFailure && (failure.status == 409 || (failure.status ?? 500) >= 500))) {
      return OnlinePaymentError(failure.message);
    }
    await _store.remove(scope, request.slot);
    return OnlinePaymentError(failure.message);
  }

  Future<String?> findPending(String purpose) async {
    final Result<List<PaymentRequestDto>> pending = await _api.pending();
    for (final PaymentRequestDto request in pending.valueOrNull ?? const <PaymentRequestDto>[]) {
      if (request.purpose == purpose && request.paymentRequestId != null) return request.paymentRequestId;
    }
    return null;
  }

  Future<Result<PaymentRequestDto>> _refresh(String id) async {
    final Result<PaymentRequestDto> reconciled = await _api.reconcile(id);
    if (reconciled case Err<PaymentRequestDto>(failure: NotFoundFailure())) return _api.detail(id);
    return reconciled;
  }

  Future<OnlinePaymentOutcome> _finish(String scope, PaymentRequestDto payment, String id) async {
    if (!payment.isUnresolved) await _store.removeRequest(scope, id);
    return _outcome(payment);
  }

  static OnlinePaymentOutcome _outcome(PaymentRequestDto payment) {
    final String? id = payment.paymentRequestId;
    if (payment.isSucceeded) return OnlinePaymentPaid(id, payment.autoPay);
    if (payment.isRefunded) return OnlinePaymentRefunded(id);
    if (payment.isRefundPending) return OnlinePaymentRefundPending(id);
    if (payment.needsSupport) return OnlinePaymentNeedsSupport(id);
    if (payment.isClosed) return OnlinePaymentDeclined(id);
    return OnlinePaymentPending(id);
  }
}

final onlinePaymentsProvider = Provider<OnlinePayments>(
  (ref) => OnlinePayments(
    ref.watch(paymentOrdersApiProvider),
    PaymentRecoveryStore(ref.watch(sharedPreferencesProvider)),
    () {
      final RiderSession session = ref.read(riderSessionProvider);
      return PaymentIdentity(userId: session.user?.id, contact: session.mobile.isEmpty ? null : session.mobile);
    },
  ),
);
