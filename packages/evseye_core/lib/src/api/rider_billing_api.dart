import '../utils/result.dart';
import 'api_client.dart';
import 'json_fields.dart';

class BillingOverviewDto {
  const BillingOverviewDto({
    required this.currency,
    required this.openCharges,
    required this.availableCredit,
    required this.outstanding,
    required this.overdue,
    required this.futureDue,
    required this.unallocatedPayments,
    required this.depositHeld,
    this.billingMode,
    this.autoPayEnabled = false,
  });

  factory BillingOverviewDto.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> profile = jsonMap(json['profile']);
    return BillingOverviewDto(
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      openCharges: jsonNum(json['openChargeAmount']),
      availableCredit: jsonNum(json['availableCreditAmount']),
      outstanding: jsonNum(json['outstandingInvoiceAmount']),
      overdue: jsonNum(json['overdueAmount']),
      futureDue: jsonNum(json['futureDueAmount']),
      unallocatedPayments: jsonNum(json['unallocatedPaymentAmount']),
      depositHeld: jsonNum(json['refundableDepositHeld']),
      billingMode: jsonTextOrNull(profile['billingMode']),
      autoPayEnabled: jsonBool(profile['autoPayEnabled']),
    );
  }

  final String currency;
  final num openCharges;
  final num availableCredit;
  final num outstanding;
  final num overdue;
  final num futureDue;
  final num unallocatedPayments;
  final num depositHeld;
  final String? billingMode;
  final bool autoPayEnabled;
}

enum BillingInvoiceStatus {
  finalized('FINALIZED'),
  partiallyPaid('PARTIALLY_PAID'),
  paid('PAID'),
  overdue('OVERDUE'),
  voided('VOID'),
  draft('DRAFT');

  const BillingInvoiceStatus(this.wire);

  final String wire;

  static BillingInvoiceStatus parse(Object? value) =>
      BillingInvoiceStatus.values.firstWhere((status) => status.wire == value?.toString(), orElse: () => finalized);

  bool get isOpen => this == finalized || this == partiallyPaid || this == overdue;
}

class InvoiceDto {
  const InvoiceDto({
    required this.id,
    required this.number,
    required this.type,
    required this.status,
    required this.subtotal,
    required this.credit,
    required this.tax,
    required this.total,
    required this.paid,
    required this.settlementCredit,
    required this.outstanding,
    required this.currency,
    required this.createdAt,
    this.periodStart,
    this.periodEnd,
    this.dueDate,
    this.paidAt,
  });

  factory InvoiceDto.fromJson(Map<String, dynamic> json) {
    final DateTime createdAt = jsonDateOr(json['createdAt'], DateTime.now());
    return InvoiceDto(
      id: jsonText(json['id']),
      number: jsonText(json['invoiceNumber']),
      type: jsonText(json['invoiceType']),
      status: BillingInvoiceStatus.parse(json['status']),
      subtotal: jsonNum(json['subtotal']),
      credit: jsonNum(json['creditAmount']),
      tax: jsonNum(json['taxAmount']),
      total: jsonNum(json['totalAmount']),
      paid: jsonNum(json['paidAmount']),
      settlementCredit: jsonNum(json['appliedSettlementCreditAmount']),
      outstanding: jsonNum(json['outstandingAmount']),
      currency: jsonTextOrNull(json['currency']) ?? 'INR',
      createdAt: createdAt,
      periodStart: jsonDate(json['billingPeriodStart']),
      periodEnd: jsonDate(json['billingPeriodEnd']),
      dueDate: jsonDate(json['dueDate']),
      paidAt: jsonDate(json['paidAt']),
    );
  }

  final String id;
  final String number;
  final String type;
  final BillingInvoiceStatus status;
  final num subtotal;
  final num credit;
  final num tax;
  final num total;
  final num paid;
  final num settlementCredit;
  final num outstanding;
  final String currency;
  final DateTime createdAt;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final DateTime? dueDate;
  final DateTime? paidAt;
}

class InvoiceLineDto {
  const InvoiceLineDto({
    required this.id,
    required this.isCredit,
    required this.description,
    required this.amount,
    this.chargeType,
    this.taxAmount,
    this.quantity,
    this.unit,
    this.servicePeriodStart,
    this.servicePeriodEnd,
  });

  factory InvoiceLineDto.fromJson(Map<String, dynamic> json) => InvoiceLineDto(
    id: jsonText(json['id']),
    isCredit: json['kind']?.toString() == 'CREDIT',
    description: jsonText(json['description']),
    amount: jsonNum(json['amount']),
    chargeType: jsonTextOrNull(json['chargeType']),
    taxAmount: jsonNumOrNull(json['taxAmount']),
    quantity: jsonNumOrNull(json['quantity']),
    unit: jsonTextOrNull(json['unit']),
    servicePeriodStart: jsonDate(json['servicePeriodStart']),
    servicePeriodEnd: jsonDate(json['servicePeriodEnd']),
  );

  final String id;
  final bool isCredit;
  final String description;
  final num amount;
  final String? chargeType;
  final num? taxAmount;
  final num? quantity;
  final String? unit;
  final DateTime? servicePeriodStart;
  final DateTime? servicePeriodEnd;
}

class InvoiceDetailDto {
  const InvoiceDetailDto({required this.invoice, required this.lines, required this.walletPaid});

  factory InvoiceDetailDto.fromJson(Map<String, dynamic> json) {
    num walletPaid = 0;
    for (final Map<String, dynamic> allocation in jsonMaps(json['walletAllocations'])) {
      final num amount = jsonNum(allocation['amount']);
      walletPaid += allocation['kind']?.toString() == 'REVERSAL' ? -amount : amount;
    }
    return InvoiceDetailDto(
      invoice: InvoiceDto.fromJson(json),
      lines: [for (final Map<String, dynamic> line in jsonMaps(json['lines'])) InvoiceLineDto.fromJson(line)],
      walletPaid: walletPaid,
    );
  }

  final InvoiceDto invoice;
  final List<InvoiceLineDto> lines;
  final num walletPaid;
}

class LedgerEntryDto {
  const LedgerEntryDto({
    required this.id,
    required this.entryType,
    required this.isDepositLiability,
    required this.sourceType,
    required this.description,
    required this.debit,
    required this.credit,
    required this.currency,
    required this.effectiveAt,
  });

  factory LedgerEntryDto.fromJson(Map<String, dynamic> json) => LedgerEntryDto(
    id: jsonText(json['id']),
    entryType: jsonText(json['entryType']),
    isDepositLiability: json['category']?.toString() == 'REFUNDABLE_DEPOSIT_LIABILITY',
    sourceType: jsonText(json['sourceType']),
    description: jsonText(json['description']),
    debit: jsonNum(json['debitAmount']),
    credit: jsonNum(json['creditAmount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    effectiveAt: jsonDateOr(json['effectiveAt'], DateTime.now()),
  );

  final String id;
  final String entryType;
  final bool isDepositLiability;
  final String sourceType;
  final String description;
  final num debit;
  final num credit;
  final String currency;
  final DateTime effectiveAt;
}

class PaymentReceiptDto {
  const PaymentReceiptDto({
    required this.id,
    required this.amount,
    required this.unallocated,
    required this.refunded,
    required this.currency,
    required this.method,
    required this.status,
    required this.receivedAt,
    required this.invoiceCount,
    this.reference,
  });

  factory PaymentReceiptDto.fromJson(Map<String, dynamic> json) => PaymentReceiptDto(
    id: jsonText(json['id']),
    amount: jsonNum(json['amount']),
    unallocated: jsonNum(json['unallocatedAmount']),
    refunded: jsonNum(json['refundedAmount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    method: jsonText(json['method']),
    status: jsonText(json['status']),
    receivedAt: jsonDateOr(json['receivedAt'], DateTime.now()),
    invoiceCount: jsonMaps(json['allocations']).length,
    reference: jsonTextOrNull(json['externalReference']),
  );

  final String id;
  final num amount;
  final num unallocated;
  final num refunded;
  final String currency;
  final String method;
  final String status;
  final DateTime receivedAt;
  final int invoiceCount;
  final String? reference;

  bool get isConfirmed => status == 'CONFIRMED';
}

class InvoiceCheckoutDto {
  const InvoiceCheckoutDto({
    required this.status,
    required this.amount,
    required this.currency,
    required this.method,
    this.collectionId,
    this.paymentSessionId,
    this.orderId,
    this.failureCode,
  });

  factory InvoiceCheckoutDto.fromJson(Map<String, dynamic> json) => InvoiceCheckoutDto(
    status: jsonText(json['status']),
    amount: jsonNum(json['amount']),
    currency: jsonTextOrNull(json['currency']) ?? 'INR',
    method: jsonText(json['method']),
    collectionId: jsonTextOrNull(json['collectionId']),
    paymentSessionId: jsonTextOrNull(json['paymentSessionId']),
    orderId: jsonTextOrNull(json['orderId']),
    failureCode: jsonTextOrNull(json['failureCode']),
  );

  final String status;
  final num amount;
  final String currency;
  final String method;
  final String? collectionId;
  final String? paymentSessionId;
  final String? orderId;
  final String? failureCode;

  bool get isPaid => status == 'PAID';
}

class RiderBillingApi {
  const RiderBillingApi(this._client);

  final ApiClient _client;

  static const String _base = '/rider-app/billing';

  Future<Result<BillingOverviewDto>> overview() =>
      _client.get<BillingOverviewDto>(_base, parse: (data) => BillingOverviewDto.fromJson(jsonMap(data)));

  Future<Result<List<InvoiceDto>>> invoices() => _client.get<List<InvoiceDto>>(
    '$_base/invoices',
    parse: (data) => [for (final Map<String, dynamic> row in jsonMaps(data)) InvoiceDto.fromJson(row)],
  );

  Future<Result<InvoiceDetailDto>> invoice(String id) =>
      _client.get<InvoiceDetailDto>('$_base/invoices/$id', parse: (data) => InvoiceDetailDto.fromJson(jsonMap(data)));

  Future<Result<InvoiceCheckoutDto>> payInvoice(String id, {required String idempotencyKey, bool useWallet = true}) =>
      _client.post<InvoiceCheckoutDto>(
        '$_base/invoices/$id/pay',
        headers: {'Idempotency-Key': idempotencyKey},
        body: {'useWallet': useWallet},
        parse: (data) => InvoiceCheckoutDto.fromJson(jsonMap(data)),
      );

  Future<Result<List<LedgerEntryDto>>> ledger() => _client.get<List<LedgerEntryDto>>(
    '$_base/ledger',
    parse: (data) => [for (final Map<String, dynamic> row in jsonMaps(data)) LedgerEntryDto.fromJson(row)],
  );

  Future<Result<List<PaymentReceiptDto>>> paymentReceipts() => _client.get<List<PaymentReceiptDto>>(
    '$_base/payment-receipts',
    parse: (data) => [for (final Map<String, dynamic> row in jsonMaps(data)) PaymentReceiptDto.fromJson(row)],
  );
}
