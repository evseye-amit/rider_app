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
    this.workPartner,
    this.dailyRent,
    this.workingDays,
    this.damageDue = 0,
    this.damageCount = 0,
  });

  final num? rentDue;
  final num rentOverdue;
  final DateTime? rentDueDate;
  final num? paidToDate;
  final AutoPayStatus? autoPay;
  final DateTime? nextDebitDate;
  final num? lastPaymentAmount;
  final DateTime? lastPaymentAt;
  final String? workPartner;
  final num? dailyRent;
  final int? workingDays;
  final num damageDue;
  final int damageCount;

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
    workPartner,
    dailyRent,
    workingDays,
    damageDue,
    damageCount,
  ];
}
