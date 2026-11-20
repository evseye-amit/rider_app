import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

final class PaymentOrderRequest {
  const PaymentOrderRequest._(this.body, this.slot);

  factory PaymentOrderRequest.deployment(String allocationId, {DeploymentAutoPayConsent? autoPay}) =>
      PaymentOrderRequest._({
        'purpose': PaymentPurposes.deployment,
        'allocationId': allocationId,
        if (autoPay != null) ...{
          'setupAutoPay': true,
          'email': autoPay.email,
          'autoPayConsent': <String, Object>{
            'accepted': true,
            'version': DeploymentAutoPayConsent.version,
            'maxAmount': autoPay.maxAmount.toStringAsFixed(2),
            'validityDays': autoPay.validityDays,
          },
        },
      }, PaymentSlots.deployment(allocationId));

  factory PaymentOrderRequest.submissionPenalty({String? amount}) => PaymentOrderRequest._({
    'purpose': PaymentPurposes.submissionPenalty,
    'amount': ?amount,
  }, PaymentSlots.submissionPenalty);

  factory PaymentOrderRequest.invoice(String invoiceId, {bool useWallet = true}) => PaymentOrderRequest._({
    'purpose': PaymentPurposes.invoice,
    'invoiceId': invoiceId,
    'useWallet': useWallet,
  }, PaymentSlots.invoice(invoiceId));

  factory PaymentOrderRequest.outstanding({String? amount}) =>
      PaymentOrderRequest._({'purpose': PaymentPurposes.outstanding, 'amount': ?amount}, PaymentSlots.outstanding);

  factory PaymentOrderRequest.topUp(String amount) =>
      PaymentOrderRequest._({'purpose': PaymentPurposes.topUp, 'amount': amount}, PaymentSlots.topUp);

  factory PaymentOrderRequest.restore({required Map<String, Object?> body, required String slot}) =>
      PaymentOrderRequest._({
        for (final MapEntry<String, Object?> entry in body.entries)
          if (entry.value case final Object value) entry.key: value,
      }, slot);

  final Map<String, Object> body;
  final String slot;

  String get purpose => body['purpose']?.toString() ?? '';

  String? get autoPayEmail => body['setupAutoPay'] == true ? body['email']?.toString() : null;
}

final class DeploymentAutoPayConsent {
  const DeploymentAutoPayConsent({required this.email, required this.maxAmount, required this.validityDays});

  static const String version = 'deployment-autopay-v1';

  final String email;
  final num maxAmount;
  final int validityDays;
}

abstract final class PaymentPurposes {
  static const String deployment = 'DEPLOYMENT';
  static const String submissionPenalty = 'SUBMISSION_PENALTY';
  static const String invoice = 'INVOICE';
  static const String outstanding = 'OUTSTANDING';
  static const String topUp = 'TOP_UP';
}

abstract final class PaymentSlots {
  static const String submissionPenalty = PaymentPurposes.submissionPenalty;
  static const String outstanding = PaymentPurposes.outstanding;
  static const String topUp = PaymentPurposes.topUp;

  static String deployment(String allocationId) => '${PaymentPurposes.deployment}:$allocationId';

  static String invoice(String invoiceId) => '${PaymentPurposes.invoice}:$invoiceId';
}

abstract final class PaymentProviders {
  static const String razorpay = 'RAZORPAY';
  static const String wallet = 'WALLET';
}

class PaymentCheckoutDto {
  const PaymentCheckoutDto({
    required this.orderId,
    required this.keyId,
    required this.amountPaise,
    this.customerId,
    this.recurring = false,
  });

  final String orderId;
  final String keyId;
  final int amountPaise;
  final String? customerId;
  final bool recurring;
}

class PaymentAutoPayDto {
  const PaymentAutoPayDto({
    required this.status,
    this.mandateId,
    this.mandateNumber,
    this.maxAmount,
    this.expiresAt,
    this.failureCode,
  });

  static PaymentAutoPayDto? fromJson(Object? value) {
    final Map<String, dynamic> json = jsonMap(value);
    if (json.isEmpty || json['requested'] == false) return null;
    return PaymentAutoPayDto(
      status: jsonText(json['status']).toUpperCase(),
      mandateId: jsonTextOrNull(json['mandateId']),
      mandateNumber: jsonTextOrNull(json['mandateNumber']),
      maxAmount: jsonNumOrNull(json['maxAmount']),
      expiresAt: jsonDate(json['expiresAt']),
      failureCode: jsonTextOrNull(json['failureCode']),
    );
  }

  final String status;
  final String? mandateId;
  final String? mandateNumber;
  final num? maxAmount;
  final DateTime? expiresAt;
  final String? failureCode;

  bool get isActive => status == 'ACTIVE';

  bool get isActivating => const {'NOT_STARTED', 'AUTHORIZATION_PENDING', 'UNKNOWN'}.contains(status);
}

class PaymentRequestDto {
  const PaymentRequestDto({
    required this.status,
    required this.currency,
    this.paymentRequestId,
    this.purpose,
    this.provider,
    this.amount,
    this.refundedAmount,
    this.paymentMethod,
    this.failureCode,
    this.checkout,
    this.hasCheckout = false,
    this.nextAction,
    this.autoPay,
  });

  factory PaymentRequestDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> checkout = jsonMap(json['checkout']);
    final String? type = jsonTextOrNull(checkout['type'])?.toUpperCase();
    final String? orderId = jsonTextOrNull(checkout['orderId']);
    final String? keyId = jsonTextOrNull(checkout['keyId']);
    final int? amountPaise = jsonIntOrNull(checkout['amountPaise']);
    final bool razorpay = type == null || type == PaymentProviders.razorpay;
    return PaymentRequestDto(
      paymentRequestId: jsonTextOrNull(json['paymentRequestId']),
      purpose: jsonTextOrNull(json['purpose']),
      provider: jsonTextOrNull(json['provider'])?.toUpperCase(),
      status: jsonText(json['status']).toUpperCase(),
      amount: jsonTextOrNull(json['amount']),
      refundedAmount: jsonTextOrNull(json['refundedAmount']),
      paymentMethod: jsonTextOrNull(json['paymentMethod'])?.toUpperCase(),
      failureCode: jsonTextOrNull(json['failureCode']),
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      checkout: !razorpay || orderId == null || keyId == null || amountPaise == null
          ? null
          : PaymentCheckoutDto(
              orderId: orderId,
              keyId: keyId,
              amountPaise: amountPaise,
              customerId: jsonTextOrNull(checkout['customerId']),
              recurring: checkout['recurring'] == true,
            ),
      hasCheckout: checkout.isNotEmpty,
      nextAction: jsonTextOrNull(json['nextAction']),
      autoPay: PaymentAutoPayDto.fromJson(json['autoPay']),
    );
  }

  final String? paymentRequestId;
  final String? purpose;
  final String? provider;
  final String status;
  final String? amount;
  final String? refundedAmount;
  final String? paymentMethod;
  final String? failureCode;
  final String currency;
  final PaymentCheckoutDto? checkout;
  final bool hasCheckout;
  final String? nextAction;
  final PaymentAutoPayDto? autoPay;

  bool get isSucceeded => status == 'SUCCEEDED';

  bool get isPending => const {'CREATING', 'PENDING', 'UNKNOWN'}.contains(status);

  bool get isRefunded => status == 'REFUNDED';

  bool get isRefundPending => status == 'REFUND_PENDING';

  bool get isCancelled => status == 'CANCELLED';

  bool get needsSupport => status == 'REVIEW_REQUIRED' || nextAction == 'CONTACT_SUPPORT';

  bool get isUnresolved => isPending || isRefundPending || needsSupport;

  bool get isClosed => const {'FAILED', 'CANCELLED', 'EXPIRED'}.contains(status);

  bool get canRetry => nextAction == 'RETRY_ONLINE_PAYMENT';

  bool get isRazorpay => provider == null || provider == PaymentProviders.razorpay;
}

class PaymentCapabilityDto {
  const PaymentCapabilityDto({
    required this.enabled,
    required this.platforms,
    this.provider,
    this.reason,
    this.autoPaySetup = false,
  });

  factory PaymentCapabilityDto.fromJson(Map<String, dynamic> json) => PaymentCapabilityDto(
    enabled: json['enabled'] == true,
    provider: jsonTextOrNull(json['provider'])?.toUpperCase(),
    platforms: [for (final String platform in jsonStrings(json['platforms'])) platform.toUpperCase()],
    reason: jsonTextOrNull(json['reason']),
    autoPaySetup: json['autoPaySetup'] == true,
  );

  final bool enabled;
  final String? provider;
  final List<String> platforms;
  final String? reason;
  final bool autoPaySetup;
}

class PaymentCapabilitiesDto {
  const PaymentCapabilitiesDto({required this.purposes});

  factory PaymentCapabilitiesDto.fromJson(Map<String, dynamic> json) => PaymentCapabilitiesDto(
    purposes: {
      for (final MapEntry<String, dynamic> entry in jsonMap(json['purposes']).entries)
        entry.key.toUpperCase(): PaymentCapabilityDto.fromJson(jsonMap(entry.value)),
    },
  );

  final Map<String, PaymentCapabilityDto> purposes;

  bool allows(String purpose, {required String platform, required Set<String> providers}) {
    final PaymentCapabilityDto? capability = purposes[purpose];
    return capability != null &&
        capability.enabled &&
        providers.contains(capability.provider) &&
        capability.platforms.contains(platform);
  }

  bool allowsAutoPaySetup(String purpose, {required String platform, required Set<String> providers}) =>
      allows(purpose, platform: platform, providers: providers) && (purposes[purpose]?.autoPaySetup ?? false);
}

class PaymentOrdersApi {
  const PaymentOrdersApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/payments/orders';

  static String _path(String paymentRequestId) => '$_base/${Uri.encodeComponent(paymentRequestId)}';

  static PaymentRequestDto _request(dynamic data) => PaymentRequestDto.fromJson(jsonMap(data));

  Future<Result<PaymentCapabilitiesDto>> capabilities() => _client.get<PaymentCapabilitiesDto>(
    '$_base/capabilities',
    parse: (data) => PaymentCapabilitiesDto.fromJson(jsonMap(data)),
  );

  Future<Result<PaymentRequestDto>> create(PaymentOrderRequest request, {required String idempotencyKey}) =>
      _client.post<PaymentRequestDto>(
        _base,
        body: request.body,
        headers: {'Idempotency-Key': idempotencyKey},
        parse: _request,
      );

  Future<Result<List<PaymentRequestDto>>> pending() => _client.get<List<PaymentRequestDto>>(
    '$_base/pending',
    parse: (data) => [for (final Map<String, dynamic> row in jsonMaps(data)) PaymentRequestDto.fromJson(row)],
  );

  Future<Result<PaymentRequestDto>> detail(String paymentRequestId) =>
      _client.get<PaymentRequestDto>(_path(paymentRequestId), parse: _request);

  Future<Result<PaymentRequestDto>> verifyRazorpay(
    String paymentRequestId, {
    required String orderId,
    required String paymentId,
    required String signature,
  }) => _client.post<PaymentRequestDto>(
    '${_path(paymentRequestId)}/verify',
    body: {'razorpayOrderId': orderId, 'razorpayPaymentId': paymentId, 'razorpaySignature': signature},
    parse: _request,
  );

  Future<Result<PaymentRequestDto>> reconcile(String paymentRequestId) => _client.post<PaymentRequestDto>(
    '${_path(paymentRequestId)}/reconcile',
    body: const <String, Object>{},
    parse: _request,
  );

  Future<Result<PaymentRequestDto>> abandon(String paymentRequestId) => _client.post<PaymentRequestDto>(
    '${_path(paymentRequestId)}/abandon',
    body: const <String, Object>{},
    parse: _request,
  );
}
