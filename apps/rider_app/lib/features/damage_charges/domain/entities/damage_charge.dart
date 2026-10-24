import 'package:equatable/equatable.dart';

enum DamageChargeState { unpaid, partlyPaid, paid, cancelled }

class DamageChargeLine extends Equatable {
  const DamageChargeLine({
    required this.name,
    required this.quantity,
    required this.unitAmount,
    required this.amount,
    required this.note,
    required this.photoIds,
  });

  final String name;
  final int quantity;
  final num unitAmount;
  final num amount;
  final String note;
  final List<String> photoIds;

  @override
  List<Object?> get props => [name, quantity, unitAmount, amount, note, photoIds];
}

class DamageCharge extends Equatable {
  const DamageCharge({
    required this.id,
    required this.total,
    required this.paid,
    required this.credit,
    required this.due,
    required this.state,
    required this.finalCheck,
    required this.summary,
    required this.lines,
    this.raisedAt,
    this.reportId,
    this.submissionId,
  });

  final String id;
  final num total;
  final num paid;
  final num credit;
  final num due;
  final DamageChargeState state;
  final bool finalCheck;
  final String summary;
  final List<DamageChargeLine> lines;
  final DateTime? raisedAt;
  final String? reportId;
  final String? submissionId;

  bool get isOpen => due > 0 && state != DamageChargeState.cancelled;

  @override
  List<Object?> get props => [
    id,
    total,
    paid,
    credit,
    due,
    state,
    finalCheck,
    summary,
    lines,
    raisedAt,
    reportId,
    submissionId,
  ];
}

class DamageChargesSummary extends Equatable {
  const DamageChargesSummary({
    required this.total,
    required this.paid,
    required this.credit,
    required this.due,
    required this.unpaidCount,
    this.processingAmount,
  });

  final num total;
  final num paid;
  final num credit;
  final num due;
  final int unpaidCount;
  final num? processingAmount;

  bool get canPay => due > 0 && processingAmount == null;

  @override
  List<Object?> get props => [total, paid, credit, due, unpaidCount, processingAmount];
}
