import '../utils/result.dart';
import 'api_client.dart';

num _money(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

String _text(Object? value) => value?.toString() ?? '';

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

class CurrencyBalance {
  const CurrencyBalance({required this.currency, required this.amountDue, required this.overdueAmount});

  factory CurrencyBalance.fromJson(Map<String, dynamic> json) => CurrencyBalance(
    currency: _text(json['currency']).toUpperCase(),
    amountDue: _money(json['amountDue']),
    overdueAmount: _money(json['overdueAmount']),
  );

  final String currency;
  final num amountDue;
  final num overdueAmount;
}

class PaymentsHome {
  const PaymentsHome({
    required this.payNowAvailable,
    required this.recentPayments,
    this.amountDue,
    this.overdueAmount,
    this.currency,
    this.balancesByCurrency = const [],
    this.payNowUnavailableReason,
    this.dueDate,
  });

  factory PaymentsHome.fromJson(Map<String, dynamic> json) => PaymentsHome(
    amountDue: json['amountDue'] == null ? null : _money(json['amountDue']),
    overdueAmount: json['overdueAmount'] == null ? null : _money(json['overdueAmount']),
    currency: json['currency']?.toString(),
    balancesByCurrency: (json['balancesByCurrency'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => CurrencyBalance.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
    payNowUnavailableReason: json['payNowUnavailableReason']?.toString(),
    payNowAvailable: json['payNowAvailable'] == true,
    recentPayments: (json['recentPayments'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => RiderPaymentRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
    dueDate: _date(json['dueDate']),
  );

  final num? amountDue;
  final num? overdueAmount;
  final String? currency;
  final List<CurrencyBalance> balancesByCurrency;
  final String? payNowUnavailableReason;
  final bool payNowAvailable;
  final List<RiderPaymentRecord> recentPayments;
  final DateTime? dueDate;
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
}
