import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

class HomeSummary extends Equatable {
  const HomeSummary({
    required this.rentOverdue,
    this.rentDue,
    this.rentDueDate,
    this.paidToDate,
    this.autoPay,
    this.nextDebitDate,
    this.lastPaymentAmount,
    this.lastPaymentAt,
    this.category,
    this.dailyRent,
    this.workingDays,
  });

  final num? rentDue;
  final num rentOverdue;
  final DateTime? rentDueDate;
  final num? paidToDate;
  final AutoPayStatus? autoPay;
  final DateTime? nextDebitDate;
  final num? lastPaymentAmount;
  final DateTime? lastPaymentAt;
  final String? category;
  final num? dailyRent;
  final int? workingDays;

  bool get isOverdue => rentOverdue > 0;

  @override
  List<Object?> get props => [
    rentDue,
    rentOverdue,
    rentDueDate,
    paidToDate,
    autoPay,
    nextDebitDate,
    lastPaymentAmount,
    lastPaymentAt,
    category,
    dailyRent,
    workingDays,
  ];
}
