import 'package:equatable/equatable.dart';

class InvoiceLineItem extends Equatable {
  const InvoiceLineItem({required this.label, required this.amount});

  final String label;
  final num amount;

  @override
  List<Object?> get props => [label, amount];
}

enum InvoiceStatus { paid, due, failed }

class RentalInvoice extends Equatable {
  const RentalInvoice({
    required this.id,
    required this.periodLabel,
    required this.amount,
    required this.dueDate,
    required this.paidOn,
    required this.status,
    required this.items,
  });

  final String id;
  final String periodLabel;
  final num amount;
  final DateTime dueDate;
  final DateTime? paidOn;
  final InvoiceStatus status;
  final List<InvoiceLineItem> items;

  num get itemsTotal => items.fold<num>(0, (a, b) => a + b.amount);

  @override
  List<Object?> get props => [
    id,
    periodLabel,
    amount,
    dueDate,
    paidOn,
    status,
    items,
  ];
}

class RentalPlan extends Equatable {
  const RentalPlan({
    required this.name,
    required this.weeklyRent,
    required this.nextDebitDate,
    required this.autoDebitEnabled,
    required this.mandateStatus,
    required this.mandateRef,
  });

  final String name;
  final num weeklyRent;
  final DateTime nextDebitDate;
  final bool autoDebitEnabled;

  final String mandateStatus;
  final String mandateRef;

  Duration get timeToDebit => nextDebitDate.difference(DateTime.now());

  @override
  List<Object?> get props => [
    name,
    weeklyRent,
    nextDebitDate,
    autoDebitEnabled,
    mandateStatus,
    mandateRef,
  ];
}

class RentalsOverview extends Equatable {
  const RentalsOverview({required this.plan, required this.invoices});

  final RentalPlan plan;
  final List<RentalInvoice> invoices;

  @override
  List<Object?> get props => [plan, invoices];
}
