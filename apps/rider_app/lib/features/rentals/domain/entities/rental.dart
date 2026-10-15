import 'package:equatable/equatable.dart';

enum BillStatus { due, partlyPaid, paid, overdue, voided, draft }

enum LedgerKind { charge, credit, payment, refund, adjustment, reversal }

class RentalPlan extends Equatable {
  const RentalPlan({required this.agreementNumber, required this.rent, this.period, this.scooterName});

  final String agreementNumber;
  final num rent;
  final String? period;
  final String? scooterName;

  @override
  List<Object?> get props => [agreementNumber, rent, period, scooterName];
}

class BillingSummary extends Equatable {
  const BillingSummary({
    required this.outstanding,
    required this.overdue,
    required this.dueLater,
    required this.credit,
    required this.depositHeld,
    required this.unallocated,
    required this.autoPay,
  });

  final num outstanding;
  final num overdue;
  final num dueLater;
  final num credit;
  final num depositHeld;
  final num unallocated;
  final bool autoPay;

  @override
  List<Object?> get props => [outstanding, overdue, dueLater, credit, depositHeld, unallocated, autoPay];
}

class Bill extends Equatable {
  const Bill({
    required this.id,
    required this.number,
    required this.status,
    required this.total,
    required this.paid,
    required this.outstanding,
    required this.createdAt,
    this.dueDate,
    this.paidAt,
    this.periodStart,
    this.periodEnd,
  });

  final String id;
  final String number;
  final BillStatus status;
  final num total;
  final num paid;
  final num outstanding;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final DateTime? periodStart;
  final DateTime? periodEnd;

  @override
  List<Object?> get props => [
    id,
    number,
    status,
    total,
    paid,
    outstanding,
    createdAt,
    dueDate,
    paidAt,
    periodStart,
    periodEnd,
  ];
}

class BillLine extends Equatable {
  const BillLine({required this.description, required this.amount, required this.isCredit, this.tax});

  final String description;
  final num amount;
  final bool isCredit;
  final num? tax;

  @override
  List<Object?> get props => [description, amount, isCredit, tax];
}

class BillDetail extends Equatable {
  const BillDetail({
    required this.bill,
    required this.lines,
    required this.subtotal,
    required this.credit,
    required this.tax,
    required this.walletPaid,
    required this.settlementCredit,
  });

  final Bill bill;
  final List<BillLine> lines;
  final num subtotal;
  final num credit;
  final num tax;
  final num walletPaid;
  final num settlementCredit;

  @override
  List<Object?> get props => [bill, lines, subtotal, credit, tax, walletPaid, settlementCredit];
}

class LedgerLine extends Equatable {
  const LedgerLine({
    required this.id,
    required this.kind,
    required this.description,
    required this.debit,
    required this.credit,
    required this.at,
    required this.isDeposit,
  });

  final String id;
  final LedgerKind kind;
  final String description;
  final num debit;
  final num credit;
  final DateTime at;
  final bool isDeposit;

  num get net => credit - debit;

  @override
  List<Object?> get props => [id, kind, description, debit, credit, at, isDeposit];
}

class PaymentReceipt extends Equatable {
  const PaymentReceipt({
    required this.id,
    required this.amount,
    required this.method,
    required this.confirmed,
    required this.receivedAt,
    required this.invoiceCount,
    required this.refunded,
    this.reference,
  });

  final String id;
  final num amount;
  final String method;
  final bool confirmed;
  final DateTime receivedAt;
  final int invoiceCount;
  final num refunded;
  final String? reference;

  @override
  List<Object?> get props => [id, amount, method, confirmed, receivedAt, invoiceCount, refunded, reference];
}

class RentalsOverview extends Equatable {
  const RentalsOverview({required this.summary, required this.bills, this.plan});

  final RentalPlan? plan;
  final BillingSummary summary;
  final List<Bill> bills;

  @override
  List<Object?> get props => [plan, summary, bills];
}
