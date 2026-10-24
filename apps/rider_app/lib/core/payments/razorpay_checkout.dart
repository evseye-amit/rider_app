import 'dart:async';
import 'dart:ui';

import 'package:evseye_core/evseye_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

sealed class CheckoutResult {
  const CheckoutResult();
}

final class CheckoutSucceeded extends CheckoutResult {
  const CheckoutSucceeded({required this.orderId, required this.paymentId, required this.signature});

  final String orderId;
  final String paymentId;
  final String signature;
}

final class CheckoutCancelled extends CheckoutResult {
  const CheckoutCancelled();
}

final class CheckoutFailed extends CheckoutResult {
  const CheckoutFailed();
}

abstract final class RazorpayCheckout {
  static bool get available => FlavorConfig.razorpayKeyId.isNotEmpty;

  static Future<CheckoutResult> open(
    PaymentCheckoutDto checkout, {
    required String currency,
    required String description,
    String? contact,
  }) {
    final Razorpay razorpay = Razorpay();
    final Completer<CheckoutResult> done = Completer<CheckoutResult>();

    void finish(CheckoutResult result) {
      if (done.isCompleted) return;
      done.complete(result);
      scheduleMicrotask(razorpay.clear);
    }

    razorpay
      ..on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) => finish(switch (response) {
          PaymentSuccessResponse(:final String orderId, :final String paymentId, :final String signature) =>
            CheckoutSucceeded(orderId: orderId, paymentId: paymentId, signature: signature),
          _ => const CheckoutFailed(),
        }),
      )
      ..on(
        Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) =>
            finish(response.code == Razorpay.PAYMENT_CANCELLED ? const CheckoutCancelled() : const CheckoutFailed()),
      )
      ..open({
        'key': checkout.keyId,
        'order_id': checkout.orderId,
        'amount': checkout.amountPaise,
        'currency': currency,
        'name': FlavorConfig.razorpayName,
        'description': description,
        'prefill': {'contact': ?contact},
        'theme': {'color': _hex(FlavorConfig.primary)},
      });
    return done.future;
  }

  static String _hex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
