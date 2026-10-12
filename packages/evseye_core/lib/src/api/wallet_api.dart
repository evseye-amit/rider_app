import '../utils/result.dart';
import 'api_client.dart';

num _money(Object? value) => value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _date(Object? value) => value == null ? null : DateTime.tryParse(value.toString());

String _text(Object? value) => value?.toString() ?? '';

class WalletBucket {
  const WalletBucket({
    required this.totalBalance,
    required this.heldBalance,
    required this.availableBalance,
    this.accountType,
  });

  factory WalletBucket.fromJson(Map<String, dynamic> json) => WalletBucket(
    totalBalance: _money(json['totalBalance']),
    heldBalance: _money(json['heldBalance']),
    availableBalance: _money(json['availableBalance']),
    accountType: json['accountType']?.toString(),
  );

  static const WalletBucket zero = WalletBucket(totalBalance: 0, heldBalance: 0, availableBalance: 0);

  final num totalBalance;
  final num heldBalance;
  final num availableBalance;
  final String? accountType;
}

class WalletBalance {
  const WalletBalance({
    required this.currency,
    required this.totalBalance,
    required this.heldBalance,
    required this.availableBalance,
    required this.cash,
    required this.rewards,
    required this.securityDepositBucket,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
    currency: json['currency']?.toString() ?? 'INR',
    totalBalance: _money(json['totalBalance']),
    heldBalance: _money(json['heldBalance']),
    availableBalance: _money(json['availableBalance']),
    cash: _bucket(json['cash']),
    rewards: _bucket(json['rewards']),
    securityDepositBucket: _bucket(json['securityDepositBucket']),
  );

  static WalletBucket _bucket(Object? raw) =>
      raw is Map ? WalletBucket.fromJson(Map<String, dynamic>.from(raw)) : WalletBucket.zero;

  final String currency;
  final num totalBalance;
  final num heldBalance;
  final num availableBalance;
  final WalletBucket cash;
  final WalletBucket rewards;
  final WalletBucket securityDepositBucket;
}

class WalletLedgerEntry {
  const WalletLedgerEntry({
    required this.id,
    required this.transactionNumber,
    required this.transactionType,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.description,
    this.referenceType,
    this.referenceId,
    this.postedAt,
  });

  factory WalletLedgerEntry.fromJson(Map<String, dynamic> json) => WalletLedgerEntry(
    id: _text(json['id']),
    transactionNumber: _text(json['transactionNumber']),
    transactionType: _text(json['transactionType']),
    status: _text(json['status']),
    amount: _money(json['amount']),
    currency: json['currency']?.toString() ?? 'INR',
    createdAt: _date(json['createdAt']) ?? DateTime.now(),
    description: json['description']?.toString(),
    referenceType: json['referenceType']?.toString(),
    referenceId: json['referenceId']?.toString(),
    postedAt: _date(json['postedAt']),
  );

  final String id;
  final String transactionNumber;
  final String transactionType;
  final String status;
  final num amount;
  final String currency;
  final DateTime createdAt;
  final String? description;
  final String? referenceType;
  final String? referenceId;
  final DateTime? postedAt;
}

class WalletSecurityDeposit {
  const WalletSecurityDeposit({
    required this.id,
    required this.status,
    required this.requiredAmount,
    required this.fundedAmount,
    required this.heldAmount,
    required this.refundableAmount,
  });

  factory WalletSecurityDeposit.fromJson(Map<String, dynamic> json) => WalletSecurityDeposit(
    id: _text(json['id']),
    status: _text(json['status']),
    requiredAmount: _money(json['requiredAmount'] ?? json['targetAmount']),
    fundedAmount: _money(json['fundedAmount']),
    heldAmount: _money(json['heldAmount']),
    refundableAmount: _money(json['refundableAmount']),
  );

  final String id;
  final String status;
  final num requiredAmount;
  final num fundedAmount;
  final num heldAmount;
  final num refundableAmount;
}

class RiderWalletSummary {
  const RiderWalletSummary({
    required this.id,
    required this.status,
    required this.balance,
    required this.rewardsEarned,
    required this.rewardsUsedOrExpired,
    required this.rewardsExpiringWithinSevenDays,
    required this.securityDeposits,
    required this.recentTransactions,
  });

  factory RiderWalletSummary.fromJson(Map<String, dynamic> json) => RiderWalletSummary(
    id: _text(json['id']),
    status: _text(json['status']),
    balance: WalletBalance.fromJson(json),
    rewardsEarned: _money(json['rewardsEarned']),
    rewardsUsedOrExpired: _money(json['rewardsUsedOrExpired']),
    rewardsExpiringWithinSevenDays: _money(json['rewardsExpiringWithinSevenDays']),
    securityDeposits: (json['securityDeposits'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => WalletSecurityDeposit.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
    recentTransactions: (json['recentTransactions'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => WalletLedgerEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  final String id;
  final String status;
  final WalletBalance balance;
  final num rewardsEarned;
  final num rewardsUsedOrExpired;
  final num rewardsExpiringWithinSevenDays;
  final List<WalletSecurityDeposit> securityDeposits;
  final List<WalletLedgerEntry> recentTransactions;
}

class WithdrawalEligibility {
  const WithdrawalEligibility({
    required this.eligible,
    required this.cashAvailable,
    required this.rewardRefundable,
    required this.securityDepositReturnSeparate,
    this.reason,
  });

  factory WithdrawalEligibility.fromJson(Map<String, dynamic> json) => WithdrawalEligibility(
    eligible: json['eligible'] == true,
    cashAvailable: _money(json['cashAvailable']),
    rewardRefundable: json['rewardRefundable'] == true,
    securityDepositReturnSeparate: json['securityDepositReturnSeparate'] == true,
    reason: json['reason']?.toString(),
  );

  final bool eligible;
  final num cashAvailable;
  final bool rewardRefundable;
  final bool securityDepositReturnSeparate;
  final String? reason;
}

class WalletReceipt {
  const WalletReceipt({
    required this.receiptNumber,
    required this.type,
    required this.amount,
    required this.currency,
    this.method,
    this.reference,
    this.destination,
    this.issuedAt,
    this.invoices = const [],
  });

  factory WalletReceipt.fromJson(Map<String, dynamic> json) => WalletReceipt(
    receiptNumber: _text(json['receiptNumber']),
    type: _text(json['type']),
    amount: _money(json['amount']),
    currency: json['currency']?.toString() ?? 'INR',
    method: json['method']?.toString(),
    reference: json['reference']?.toString(),
    destination: json['destination']?.toString(),
    issuedAt: _date(json['issuedAt']),
    invoices: (json['invoices'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => ReceiptInvoice.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  final String receiptNumber;
  final String type;
  final num amount;
  final String currency;
  final String? method;
  final String? reference;
  final String? destination;
  final DateTime? issuedAt;
  final List<ReceiptInvoice> invoices;
}

class ReceiptInvoice {
  const ReceiptInvoice({required this.number, required this.amount});

  factory ReceiptInvoice.fromJson(Map<String, dynamic> json) =>
      ReceiptInvoice(number: _text(json['number']), amount: _money(json['amount']));

  final String number;
  final num amount;
}

enum WalletReceiptKind {
  payment('payments'),
  refund('refunds'),
  depositReturn('deposit-returns');

  const WalletReceiptKind(this.path);

  final String path;
}

class WalletApi {
  const WalletApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/wallet';

  Future<Result<RiderWalletSummary>> summary() => _client.get<RiderWalletSummary>(
    _base,
    parse: (data) => RiderWalletSummary.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<WalletBalance>> balance() => _client.get<WalletBalance>(
    '$_base/balance',
    parse: (data) => WalletBalance.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<WithdrawalEligibility>> withdrawalEligibility() => _client.get<WithdrawalEligibility>(
    '$_base/withdrawal-eligibility',
    parse: (data) => WithdrawalEligibility.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<List<WalletLedgerEntry>>> transactions({int page = 1, int pageSize = 20}) =>
      _client.get<List<WalletLedgerEntry>>(
        '$_base/transactions',
        query: {'page': page, 'pageSize': pageSize},
        parse: _entries,
      );

  Future<Result<WalletLedgerEntry>> transaction(String id) => _client.get<WalletLedgerEntry>(
    '$_base/transactions/$id',
    parse: (data) => WalletLedgerEntry.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<List<WalletLedgerEntry>>> statement({DateTime? from, DateTime? to, int page = 1, int pageSize = 50}) =>
      _client.get<List<WalletLedgerEntry>>(
        '$_base/statements',
        query: {
          if (from != null) 'from': from.toIso8601String(),
          if (to != null) 'to': to.toIso8601String(),
          'page': page,
          'pageSize': pageSize,
        },
        parse: (data) => _entries(data is Map ? (data['entries'] ?? data['transactions'] ?? const []) : data),
      );

  Future<Result<WalletReceipt>> receipt(WalletReceiptKind kind, String id) => _client.get<WalletReceipt>(
    '$_base/receipts/${kind.path}/$id',
    parse: (data) => WalletReceipt.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  static List<WalletLedgerEntry> _entries(dynamic data) => (data as List<dynamic>? ?? const [])
      .whereType<Map>()
      .map((e) => WalletLedgerEntry.fromJson(Map<String, dynamic>.from(e)))
      .toList(growable: false);
}
