import 'package:equatable/equatable.dart';

import 'maintenance_job.dart';
import 'maintenance_summary.dart';

class MaintenanceBoard extends Equatable {
  const MaintenanceBoard({required this.summary, required this.jobs});

  final MaintenanceSummary summary;
  final List<MaintenanceJob> jobs;

  @override
  List<Object?> get props => [summary, jobs];
}
