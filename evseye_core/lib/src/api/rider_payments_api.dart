import '../utils/result.dart';
import 'api_client.dart';

num _money(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

String _text(Object? value) => value?.toString() ?? '';

enum AutoPayStatus {
  notEnabled('NOT_ENABLED'),
  setupRequired('SETUP_REQUIRED'),
  authenticationPending('AUTHENTICATION_PENDING'),
  active('ACTIVE'),
  paused('PAUSED'),
  failed('FAILED'),
  revoked('REVOKED'),
  expired('EXPIRED');

  const AutoPayStatus(this.wire);

  final String wire;

  static AutoPayStatus parse(Object? value) => AutoPayStatus.values.firstWhere(
    (status) => status.wire == value?.toString(),
    orElse: () => AutoPayStatus.notEnabled,
  );

  bool get isActive => this == AutoPayStatus.active;

  bool get needsAttention =>
      this == AutoPayStatus.setupRequired ||
      this == AutoPayStatus.authenticationPending ||
      this == AutoPayStatus.failed ||
      this == AutoPayStatus.expired ||
      this == AutoPayStatus.revoked;
}

class RiderPaymentRecord {
  const RiderPaymentRecord({
    required this.id,
    required this.amount,
    this.currency = 'INR',
    this.method,
    this.status,
    this.receivedAt,
    this.allocations = const [],
  });

  factory RiderPaymentRecord.fromJson(Map<String, dynamic> json) => RiderPaymentRecord(
    id: _text(json['id']),
    amount: _money(json['amount']),
    currency: json['currency']?.toString() ?? 'INR',
    method: json['method']?.toString(),
    status: json['status']?.toString(),
    receivedAt: _date(json['receivedAt']),
    allocations: (json['allocations'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => PaymentAllocation.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  final String id;
  final num amount;
  final String currency;
  final String? method;
  final String? status;
  final DateTime? receivedAt;
  final List<PaymentAllocation> allocations;
}

class PaymentAllocation {
  const PaymentAllocation({required this.invoiceId, required this.amount});

  factory PaymentAllocation.fromJson(Map<String, dynamic> json) =>
      PaymentAllocation(invoiceId: _text(json['invoiceId']), amount: _money(json['amount']));

  final String invoiceId;
  final num amount;
}

class PaymentsHome {
  const PaymentsHome({
    required this.amountDue,
    required this.overdueAmount,
    required this.currency,
    required this.autoPayStatus,
    required this.payNowAvailable,
    required this.recentPayments,
    this.dueDate,
    this.paymentMethod,
    this.mandateStatus,
    this.mandateMaxAmount,
    this.mandateExpiresAt,
    this.nextAutoPayDate,
  });

  factory PaymentsHome.fromJson(Map<String, dynamic> json) => PaymentsHome(
    amountDue: _money(json['amountDue']),
    overdueAmount: _money(json['overdueAmount']),
    currency: json['currency']?.toString() ?? 'INR',
    autoPayStatus: AutoPayStatus.parse(json['autoPayStatus']),
    payNowAvailable: json['payNowAvailable'] == true,
    recentPayments: (json['recentPayments'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => RiderPaymentRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
    dueDate: _date(json['dueDate']),
    paymentMethod: json['paymentMethod']?.toString(),
    mandateStatus: json['mandateStatus']?.toString(),
    mandateMaxAmount: json['mandateMaxAmount'] == null ? null : _money(json['mandateMaxAmount']),
    mandateExpiresAt: _date(json['mandateExpiresAt']),
    nextAutoPayDate: _date(json['nextAutoPayDate']),
  );

  final num amountDue;
  final num overdueAmount;
  final String currency;
  final AutoPayStatus autoPayStatus;
  final bool payNowAvailable;
  final List<RiderPaymentRecord> recentPayments;
  final DateTime? dueDate;
  final String? paymentMethod;
  final String? mandateStatus;
  final num? mandateMaxAmount;
  final DateTime? mandateExpiresAt;
  final DateTime? nextAutoPayDate;

  bool get isOverdue => overdueAmount > 0;
}

class PaymentAttempt {
  const PaymentAttempt({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    this.method,
    this.startedAt,
    this.completedAt,
  });

  factory PaymentAttempt.fromJson(Map<String, dynamic> json) => PaymentAttempt(
    id: _text(json['id']),
    status: _text(json['status']),
    amount: _money(json['amount']),
    currency: json['currency']?.toString() ?? 'INR',
    method: json['method']?.toString(),
    startedAt: _date(json['createdAt'] ?? json['scheduledAt']),
    completedAt: _date(json['completedAt']),
  );

  final String id;
  final String status;
  final num amount;
  final String currency;
  final String? method;
  final DateTime? startedAt;
  final DateTime? completedAt;
}

class RiderPaymentsApi {
  const RiderPaymentsApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/payments';

  Future<Result<PaymentsHome>> home() => _client.get<PaymentsHome>(
    '$_base/home',
    parse: (data) => PaymentsHome.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<List<RiderPaymentRecord>>> history() => _client.get<List<RiderPaymentRecord>>(
    '$_base/history',
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => RiderPaymentRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  Future<Result<PaymentAttempt>> attempt(String id) => _client.get<PaymentAttempt>(
    '$_base/attempts/$id',
    parse: (data) => PaymentAttempt.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<List<PaymentAttempt>>> refunds() => _client.get<List<PaymentAttempt>>(
    '$_base/refunds',
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => PaymentAttempt.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );
}
