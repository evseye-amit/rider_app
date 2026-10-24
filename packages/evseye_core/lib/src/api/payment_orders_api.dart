import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

final class PaymentOrderRequest {
  const PaymentOrderRequest._(this.body);

  factory PaymentOrderRequest.deployment(String allocationId) =>
      PaymentOrderRequest._({'purpose': 'DEPLOYMENT', 'allocationId': allocationId});

  factory PaymentOrderRequest.submissionPenalty({String? amount}) =>
      PaymentOrderRequest._({'purpose': 'SUBMISSION_PENALTY', 'amount': ?amount});

  final Map<String, Object> body;
}

class PaymentCheckoutDto {
  const PaymentCheckoutDto({required this.orderId, required this.keyId, required this.amountPaise});

  final String orderId;
  final String keyId;
  final int amountPaise;
}

class PaymentRequestDto {
  const PaymentRequestDto({
    required this.status,
    required this.currency,
    this.paymentRequestId,
    this.provider,
    this.checkout,
    this.nextAction,
  });

  factory PaymentRequestDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> checkout = jsonMap(json['checkout']);
    final String? orderId = jsonTextOrNull(checkout['orderId']);
    final String? keyId = jsonTextOrNull(checkout['keyId']);
    final int? amountPaise = jsonIntOrNull(checkout['amountPaise']);
    return PaymentRequestDto(
      paymentRequestId: jsonTextOrNull(json['paymentRequestId']),
      provider: jsonTextOrNull(json['provider']),
      status: jsonText(json['status']),
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      checkout: orderId == null || keyId == null || amountPaise == null
          ? null
          : PaymentCheckoutDto(orderId: orderId, keyId: keyId, amountPaise: amountPaise),
      nextAction: jsonTextOrNull(json['nextAction']),
    );
  }

  final String? paymentRequestId;
  final String? provider;
  final String status;
  final String currency;
  final PaymentCheckoutDto? checkout;
  final String? nextAction;

  bool get isSucceeded => status == 'SUCCEEDED';

  bool get needsSupport =>
      nextAction == 'CONTACT_SUPPORT' || const {'REVIEW_REQUIRED', 'REFUND_PENDING', 'REFUNDED'}.contains(status);

  bool get canRetry => nextAction == 'RETRY_ONLINE_PAYMENT';
}

class PaymentOrdersApi {
  const PaymentOrdersApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/payments/orders';

  Future<Result<PaymentRequestDto>> create(PaymentOrderRequest request) => _client.post<PaymentRequestDto>(
    _base,
    body: request.body,
    parse: (data) => PaymentRequestDto.fromJson(jsonMap(data)),
  );

  Future<Result<PaymentRequestDto>> verifyRazorpay(
    String paymentRequestId, {
    required String orderId,
    required String paymentId,
    required String signature,
  }) => _client.post<PaymentRequestDto>(
    '$_base/$paymentRequestId/verify',
    body: {'razorpayOrderId': orderId, 'razorpayPaymentId': paymentId, 'razorpaySignature': signature},
    parse: (data) => PaymentRequestDto.fromJson(jsonMap(data)),
  );
}
