import 'package:equatable/equatable.dart';

class MaintenanceSummary extends Equatable {
  const MaintenanceSummary({
    required this.open,
    required this.overdue,
    required this.inProgress,
    required this.closedThisWeek,
    required this.averageCloseHours,
  });

  final int open;
  final int overdue;
  final int inProgress;
  final int closedThisWeek;
  final int averageCloseHours;

  @override
  List<Object?> get props => [open, overdue, inProgress, closedThisWeek, averageCloseHours];
}
