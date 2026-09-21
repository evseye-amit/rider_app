import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/maintenance_job.dart';
import '../../domain/usecases/get_maintenance_job.dart';

enum MaintenanceDetailStatus { initial, loading, ready, failure }

class MaintenanceDetailState extends Equatable {
  const MaintenanceDetailState({
    this.status = MaintenanceDetailStatus.initial,
    this.job,
    this.message,
  });

  final MaintenanceDetailStatus status;
  final MaintenanceJob? job;
  final String? message;

  bool get isLoading =>
      status == MaintenanceDetailStatus.loading || status == MaintenanceDetailStatus.initial;

  MaintenanceDetailState copyWith({
    MaintenanceDetailStatus? status,
    MaintenanceJob? job,
    String? message,
  }) =>
      MaintenanceDetailState(
        status: status ?? this.status,
        job: job ?? this.job,
        message: message,
      );

  @override
  List<Object?> get props => [status, job, message];
}

class MaintenanceDetailCubit extends Cubit<MaintenanceDetailState> {
  MaintenanceDetailCubit(this._getJob, this._jobId) : super(const MaintenanceDetailState());

  final GetMaintenanceJob _getJob;
  final String _jobId;

  Future<void> load() async {
    emit(state.copyWith(status: MaintenanceDetailStatus.loading));
    final Result<MaintenanceJob> result = await _getJob(_jobId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: MaintenanceDetailStatus.failure, message: failure.message)),
      (job) => emit(state.copyWith(status: MaintenanceDetailStatus.ready, job: job)),
    );
  }

  void updateStatus(String status) {
    final MaintenanceJob? job = state.job;
    if (job == null) return;
    emit(state.copyWith(job: job.copyWith(status: status)));
  }

  void reassignVendor(String vendor) {
    final MaintenanceJob? job = state.job;
    if (job == null) return;
    emit(state.copyWith(job: job.copyWith(assignedTo: vendor)));
  }

  void addNote(String note) {
    final MaintenanceJob? job = state.job;
    if (job == null || note.trim().isEmpty) return;
    emit(state.copyWith(job: job.copyWith(notes: [...job.notes, note.trim()])));
  }

  void closeJob() {
    final MaintenanceJob? job = state.job;
    if (job == null) return;
    emit(state.copyWith(job: job.copyWith(status: 'closed', closedOn: DateTime.now())));
  }
}
