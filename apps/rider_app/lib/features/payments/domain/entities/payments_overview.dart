import 'package:equatable/equatable.dart';

enum AutoPayState { notEnabled, setupRequired, authenticationPending, active, paused, failed, revoked, expired }

class PaymentRecord extends Equatable {
  const PaymentRecord({
    required this.id,
    required this.amount,
    this.method,
    this.status,
    this.receivedAt,
    this.invoiceCount = 0,
  });

  final String id;
  final num amount;
  final String? method;
  final String? status;
  final DateTime? receivedAt;
  final int invoiceCount;

  @override
  List<Object?> get props => [id, amount, method, status, receivedAt, invoiceCount];
}

class DueBalance extends Equatable {
  const DueBalance({required this.currency, required this.amountDue, required this.overdueAmount});

  final String currency;
  final num amountDue;
  final num overdueAmount;

  @override
  List<Object?> get props => [currency, amountDue, overdueAmount];
}

class PaymentsOverview extends Equatable {
  const PaymentsOverview({
    required this.autoPay,
    required this.payNowAvailable,
    required this.recentPayments,
    this.amountDue,
    this.overdueAmount,
    this.currency,
    this.balances = const [],
    this.payNowUnavailableReason,
    this.dueDate,
    this.paymentMethod,
    this.mandateMaxAmount,
    this.mandateExpiresAt,
    this.nextAutoPayDate,
    this.damageDue = 0,
    this.damageCount = 0,
  });

  final num? amountDue;
  final num? overdueAmount;
  final String? currency;
  final List<DueBalance> balances;
  final String? payNowUnavailableReason;
  final AutoPayState autoPay;
  final bool payNowAvailable;
  final List<PaymentRecord> recentPayments;
  final DateTime? dueDate;
  final String? paymentMethod;
  final num? mandateMaxAmount;
  final DateTime? mandateExpiresAt;
  final DateTime? nextAutoPayDate;
  final num damageDue;
  final int damageCount;

  bool get hasMixedCurrencies => amountDue == null && balances.isNotEmpty;

  num get totalDue => amountDue ?? 0;

  num get rentDue => totalDue - damageDue < 0 ? 0 : totalDue - damageDue;

  num get rentOverdue => (overdueAmount ?? 0) - damageDue < 0 ? 0 : (overdueAmount ?? 0) - damageDue;

  bool get isOverdue => hasMixedCurrencies ? balances.any((balance) => balance.overdueAmount > 0) : rentOverdue > 0;

  bool get isSettled => hasMixedCurrencies ? balances.every((balance) => balance.amountDue <= 0) : totalDue <= 0;

  bool get autoPayNeedsAttention => switch (autoPay) {
    AutoPayState.setupRequired ||
    AutoPayState.authenticationPending ||
    AutoPayState.failed ||
    AutoPayState.expired ||
    AutoPayState.revoked => true,
    _ => false,
  };

  @override
  List<Object?> get props => [
    amountDue,
    overdueAmount,
    currency,
    balances,
    payNowUnavailableReason,
    autoPay,
    payNowAvailable,
    recentPayments,
    dueDate,
    paymentMethod,
    mandateMaxAmount,
    mandateExpiresAt,
    nextAutoPayDate,
    damageDue,
    damageCount,
  ];
}
