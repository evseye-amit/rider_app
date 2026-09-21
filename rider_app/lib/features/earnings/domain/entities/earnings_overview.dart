import 'package:equatable/equatable.dart';

enum EarningsPeriod { daily, weekly, monthly }

extension EarningsPeriodX on EarningsPeriod {
  String get label => switch (this) {
    EarningsPeriod.daily => 'Daily',
    EarningsPeriod.weekly => 'Weekly',
    EarningsPeriod.monthly => 'Monthly',
  };
}

class EarningsBar extends Equatable {
  const EarningsBar({
    required this.label,
    required this.amount,
    required this.trips,
    required this.date,
  });

  final String label;
  final num amount;
  final int trips;
  final DateTime date;

  @override
  List<Object?> get props => [label, amount, trips, date];
}

class EarningsBreakdown extends Equatable {
  const EarningsBreakdown({
    required this.baseFare,
    required this.distancePay,
    required this.surge,
    required this.incentives,
    required this.deductions,
  });

  final num baseFare;
  final num distancePay;
  final num surge;
  final num incentives;
  final num deductions;

  num get gross => baseFare + distancePay + surge + incentives;
  num get net => gross - deductions;

  @override
  List<Object?> get props => [
    baseFare,
    distancePay,
    surge,
    incentives,
    deductions,
  ];
}

class EarningsOverview extends Equatable {
  const EarningsOverview({
    required this.bars,
    required this.breakdowns,
    required this.dailyEntries,
  });

  final Map<EarningsPeriod, List<EarningsBar>> bars;
  final Map<EarningsPeriod, EarningsBreakdown> breakdowns;

  final List<EarningsBar> dailyEntries;

  List<EarningsBar> barsFor(EarningsPeriod period) => bars[period] ?? const [];

  EarningsBreakdown breakdownFor(EarningsPeriod period) =>
      breakdowns[period] ??
      const EarningsBreakdown(
        baseFare: 0,
        distancePay: 0,
        surge: 0,
        incentives: 0,
        deductions: 0,
      );

  @override
  List<Object?> get props => [bars, breakdowns, dailyEntries];
}
