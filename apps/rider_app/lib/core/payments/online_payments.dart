import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'razorpay_checkout.dart';

sealed class OnlinePaymentOutcome {
  const OnlinePaymentOutcome();
}

final class OnlinePaymentPaid extends OnlinePaymentOutcome {
  const OnlinePaymentPaid();
}

final class OnlinePaymentPending extends OnlinePaymentOutcome {
  const OnlinePaymentPending();
}

final class OnlinePaymentNeedsSupport extends OnlinePaymentOutcome {
  const OnlinePaymentNeedsSupport();
}

final class OnlinePaymentDeclined extends OnlinePaymentOutcome {
  const OnlinePaymentDeclined();
}

final class OnlinePaymentCancelled extends OnlinePaymentOutcome {
  const OnlinePaymentCancelled();
}

final class OnlinePaymentUnavailable extends OnlinePaymentOutcome {
  const OnlinePaymentUnavailable();
}

final class OnlinePaymentError extends OnlinePaymentOutcome {
  const OnlinePaymentError(this.message);

  final String message;
}

class OnlinePayments {
  const OnlinePayments(this._api);

  final PaymentOrdersApi _api;

  Future<OnlinePaymentOutcome> pay(PaymentOrderRequest request, {required String description, String? contact}) async {
    final Result<PaymentRequestDto> created = await _api.create(request);
    if (created case Err<PaymentRequestDto>(:final failure)) {
      return failure is ServerFailure && failure.status == 503
          ? const OnlinePaymentUnavailable()
          : OnlinePaymentError(failure.message);
    }
    final PaymentRequestDto payment = created.getOrThrow();
    final PaymentCheckoutDto? checkout = payment.checkout;
    final String? requestId = payment.paymentRequestId;
    if (checkout == null || requestId == null) return _outcome(payment);

    final CheckoutResult result = await RazorpayCheckout.open(
      checkout,
      currency: payment.currency,
      description: description,
      contact: contact,
    );
    switch (result) {
      case CheckoutSucceeded(:final orderId, :final paymentId, :final signature):
        final Result<PaymentRequestDto> verified = await _api.verifyRazorpay(
          requestId,
          orderId: orderId,
          paymentId: paymentId,
          signature: signature,
        );
        return switch (verified) {
          Ok<PaymentRequestDto>(:final value) => _outcome(value),
          Err<PaymentRequestDto>() => const OnlinePaymentPending(),
        };
      case CheckoutCancelled():
        return const OnlinePaymentCancelled();
      case CheckoutFailed():
        return const OnlinePaymentDeclined();
    }
  }

  static OnlinePaymentOutcome _outcome(PaymentRequestDto payment) => switch (payment) {
    PaymentRequestDto(isSucceeded: true) => const OnlinePaymentPaid(),
    PaymentRequestDto(needsSupport: true) => const OnlinePaymentNeedsSupport(),
    PaymentRequestDto(canRetry: true) => const OnlinePaymentDeclined(),
    _ => const OnlinePaymentPending(),
  };
}

final onlinePaymentsProvider = Provider<OnlinePayments>((ref) => OnlinePayments(ref.watch(paymentOrdersApiProvider)));
