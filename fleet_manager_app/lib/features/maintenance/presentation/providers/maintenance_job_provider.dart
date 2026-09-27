import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/maintenance_job.dart';
import '../../maintenance_dependencies.dart';

class MaintenanceJobNotifier extends AsyncNotifier<MaintenanceJob> {
  MaintenanceJobNotifier(this._jobId);

  final String _jobId;

  @override
  Future<MaintenanceJob> build() async => (await ref.read(getMaintenanceJobProvider)(_jobId)).getOrThrow();

  void updateStatus(String status) => _update((job) => job.copyWith(status: status));

  void reassignVendor(String vendor) => _update((job) => job.copyWith(assignedTo: vendor));

  void addNote(String note) {
    final String trimmed = note.trim();
    if (trimmed.isEmpty) return;
    _update((job) => job.copyWith(notes: [...job.notes, trimmed]));
  }

  void closeJob() => _update((job) => job.copyWith(status: 'closed', closedOn: DateTime.now()));

  void _update(MaintenanceJob Function(MaintenanceJob job) change) {
    final MaintenanceJob? job = state.value;
    if (job != null) state = AsyncData(change(job));
  }
}

final maintenanceJobProvider = AsyncNotifierProvider.autoDispose.family<MaintenanceJobNotifier, MaintenanceJob, String>(
  MaintenanceJobNotifier.new,
);
