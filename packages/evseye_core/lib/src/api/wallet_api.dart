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
    this.outstandingAmount = 0,
    this.lockedAmount = 0,
    this.deductedAmount = 0,
    this.refundedAmount = 0,
    this.returns = const [],
  });

  factory WalletSecurityDeposit.fromJson(Map<String, dynamic> json) => WalletSecurityDeposit(
    id: _text(json['id']),
    status: _text(json['status']),
    requiredAmount: _money(json['requiredAmount']),
    fundedAmount: _money(json['fundedAmount']),
    heldAmount: _money(json['heldAmount']),
    refundableAmount: _money(json['refundableAmount']),
    outstandingAmount: _money(json['outstandingAmount']),
    lockedAmount: _money(json['lockedAmount']),
    deductedAmount: _money(json['deductedAmount']),
    refundedAmount: _money(json['refundedAmount']),
    returns: (json['returns'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => WalletDepositReturn.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  final String id;
  final String status;
  final num requiredAmount;
  final num fundedAmount;
  final num heldAmount;
  final num refundableAmount;
  final num outstandingAmount;
  final num lockedAmount;
  final num deductedAmount;
  final num refundedAmount;
  final List<WalletDepositReturn> returns;
}

class WalletDepositReturn {
  const WalletDepositReturn({
    required this.id,
    required this.amount,
    required this.status,
    required this.toWallet,
    required this.requestedAt,
    this.completedAt,
  });

  factory WalletDepositReturn.fromJson(Map<String, dynamic> json) => WalletDepositReturn(
    id: _text(json['id']),
    amount: _money(json['amount']),
    status: _text(json['status']),
    toWallet: json['destinationType']?.toString() == 'WALLET_CASH',
    requestedAt: _date(json['requestedAt']) ?? DateTime.now(),
    completedAt: _date(json['completedAt']),
  );

  final String id;
  final num amount;
  final String status;
  final bool toWallet;
  final DateTime requestedAt;
  final DateTime? completedAt;

  bool get isReturned => status == 'RETURNED';
}

class WalletStatementTotals {
  const WalletStatementTotals({
    required this.opening,
    required this.credits,
    required this.debits,
    required this.closing,
  });

  factory WalletStatementTotals.fromJson(Object? raw) {
    final Map<String, dynamic> json = raw is Map ? Map<String, dynamic>.from(raw) : const {};
    return WalletStatementTotals(
      opening: _money(json['opening']),
      credits: _money(json['credits']),
      debits: _money(json['debits']),
      closing: _money(json['closing']),
    );
  }

  final num opening;
  final num credits;
  final num debits;
  final num closing;
}

class WalletStatementEntry {
  const WalletStatementEntry({
    required this.id,
    required this.number,
    required this.type,
    required this.reversed,
    required this.description,
    required this.postedAt,
    required this.spendableChange,
    required this.depositChange,
    this.referenceType,
  });

  factory WalletStatementEntry.fromJson(Map<String, dynamic> json) {
    num spendable = 0;
    num deposit = 0;
    for (final Object? raw in json['movements'] as List<dynamic>? ?? const []) {
      if (raw is! Map) continue;
      final num amount = _money(raw['amount']);
      if (raw['bucket']?.toString() == 'SECURITY_DEPOSIT') {
        deposit += amount;
      } else {
        spendable += amount;
      }
    }
    return WalletStatementEntry(
      id: _text(json['id']),
      number: _text(json['number']),
      type: _text(json['type']),
      reversed: json['status']?.toString() == 'REVERSED',
      description: _text(json['description']),
      postedAt: _date(json['postedAt'])?.toLocal() ?? DateTime.now(),
      spendableChange: spendable,
      depositChange: deposit,
      referenceType: json['referenceType']?.toString(),
    );
  }

  final String id;
  final String number;
  final String type;
  final bool reversed;
  final String description;
  final DateTime postedAt;
  final num spendableChange;
  final num depositChange;
  final String? referenceType;
}

class WalletStatement {
  const WalletStatement({
    required this.reference,
    required this.currency,
    required this.spendable,
    required this.deposit,
    required this.entries,
    required this.total,
  });

  factory WalletStatement.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> buckets = json['buckets'] is Map
        ? Map<String, dynamic>.from(json['buckets'] as Map)
        : const {};
    final Map<String, dynamic> meta = json['meta'] is Map ? Map<String, dynamic>.from(json['meta'] as Map) : const {};
    return WalletStatement(
      reference: _text(json['reference']),
      currency: json['currency']?.toString() ?? 'INR',
      spendable: WalletStatementTotals.fromJson(json['spendable']),
      deposit: WalletStatementTotals.fromJson(buckets['SECURITY_DEPOSIT']),
      entries: (json['transactions'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => WalletStatementEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(growable: false),
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }

  final String reference;
  final String currency;
  final WalletStatementTotals spendable;
  final WalletStatementTotals deposit;
  final List<WalletStatementEntry> entries;
  final int total;
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

  Future<Result<WalletStatement>> statement({
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 50,
  }) => _client.get<WalletStatement>(
    '$_base/statements',
    query: {'from': _day(from), 'to': _day(to), 'page': page, 'pageSize': pageSize},
    parse: (data) => WalletStatement.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  Future<Result<List<WalletSecurityDeposit>>> securityDeposits() => _client.get<List<WalletSecurityDeposit>>(
    '$_base/security-deposits',
    parse: (data) => (data as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => WalletSecurityDeposit.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false),
  );

  Future<Result<WalletSecurityDeposit>> securityDeposit(String id) => _client.get<WalletSecurityDeposit>(
    '$_base/security-deposits/$id',
    parse: (data) => WalletSecurityDeposit.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  static String _day(DateTime value) {
    final DateTime utc = DateTime.utc(value.year, value.month, value.day);
    return '${utc.year.toString().padLeft(4, '0')}-${utc.month.toString().padLeft(2, '0')}-${utc.day.toString().padLeft(2, '0')}';
  }

  Future<Result<WalletReceipt>> receipt(WalletReceiptKind kind, String id) => _client.get<WalletReceipt>(
    '$_base/receipts/${kind.path}/$id',
    parse: (data) => WalletReceipt.fromJson(Map<String, dynamic>.from(data as Map)),
  );

  static List<WalletLedgerEntry> _entries(dynamic data) => (data as List<dynamic>? ?? const [])
      .whereType<Map>()
      .map((e) => WalletLedgerEntry.fromJson(Map<String, dynamic>.from(e)))
      .toList(growable: false);
}
