import 'dart:async';
import 'dart:ui';

import 'package:evseye_core/evseye_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

enum OnlinePaymentOutcome { paid, cancelled, failed }

typedef OnlinePaymentResult = ({OnlinePaymentOutcome outcome, String? paymentId});

class RazorpayCheckout {
  RazorpayCheckout() {
    _razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _onSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _onError);
  }

  static const String provider = 'Razorpay';

  static bool get available => FlavorConfig.razorpayKeyId.isNotEmpty;

  final Razorpay _razorpay = Razorpay();
  Completer<OnlinePaymentResult>? _pending;

  Future<OnlinePaymentResult> pay({
    required num amount,
    required String description,
    String? contact,
    Map<String, String> notes = const {},
  }) {
    _finish((outcome: OnlinePaymentOutcome.cancelled, paymentId: null));
    final Completer<OnlinePaymentResult> pending = Completer<OnlinePaymentResult>();
    _pending = pending;
    _razorpay.open({
      'key': FlavorConfig.razorpayKeyId,
      'amount': (amount * 100).round(),
      'currency': 'INR',
      'name': FlavorConfig.razorpayName,
      'description': description,
      'prefill': {'contact': ?contact},
      'notes': notes,
      'theme': {'color': _hex(FlavorConfig.primary)},
    });
    return pending.future;
  }

  void dispose() {
    _finish((outcome: OnlinePaymentOutcome.cancelled, paymentId: null));
    _razorpay.clear();
  }

  void _onSuccess(PaymentSuccessResponse response) =>
      _finish((outcome: OnlinePaymentOutcome.paid, paymentId: response.paymentId));

  void _onError(PaymentFailureResponse response) => _finish((
    outcome: response.code == Razorpay.PAYMENT_CANCELLED ? OnlinePaymentOutcome.cancelled : OnlinePaymentOutcome.failed,
    paymentId: null,
  ));

  void _finish(OnlinePaymentResult result) {
    final Completer<OnlinePaymentResult>? pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) pending.complete(result);
  }

  static String _hex(Color color) =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
