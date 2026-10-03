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

class PaymentsOverview extends Equatable {
  const PaymentsOverview({
    required this.amountDue,
    required this.overdueAmount,
    required this.currency,
    required this.autoPay,
    required this.payNowAvailable,
    required this.recentPayments,
    this.dueDate,
    this.paymentMethod,
    this.mandateMaxAmount,
    this.mandateExpiresAt,
    this.nextAutoPayDate,
  });

  final num amountDue;
  final num overdueAmount;
  final String currency;
  final AutoPayState autoPay;
  final bool payNowAvailable;
  final List<PaymentRecord> recentPayments;
  final DateTime? dueDate;
  final String? paymentMethod;
  final num? mandateMaxAmount;
  final DateTime? mandateExpiresAt;
  final DateTime? nextAutoPayDate;

  bool get isOverdue => overdueAmount > 0;

  bool get isSettled => amountDue <= 0;

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
    autoPay,
    payNowAvailable,
    recentPayments,
    dueDate,
    paymentMethod,
    mandateMaxAmount,
    mandateExpiresAt,
    nextAutoPayDate,
  ];
}

class PaymentAttemptDetail extends Equatable {
  const PaymentAttemptDetail({
    required this.id,
    required this.status,
    required this.amount,
    this.method,
    this.startedAt,
    this.completedAt,
  });

  final String id;
  final String status;
  final num amount;
  final String? method;
  final DateTime? startedAt;
  final DateTime? completedAt;

  @override
  List<Object?> get props => [id, status, amount, method, startedAt, completedAt];
}
