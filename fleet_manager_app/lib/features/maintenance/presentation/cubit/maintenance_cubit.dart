import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/maintenance_board.dart';
import '../../domain/usecases/get_maintenance_board.dart';

enum MaintenanceStatus { initial, loading, ready, failure }

class MaintenanceState extends Equatable {
  const MaintenanceState({this.status = MaintenanceStatus.initial, this.board, this.message});

  final MaintenanceStatus status;
  final MaintenanceBoard? board;
  final String? message;

  bool get isLoading => status == MaintenanceStatus.loading || status == MaintenanceStatus.initial;

  MaintenanceState copyWith({MaintenanceStatus? status, MaintenanceBoard? board, String? message}) =>
      MaintenanceState(
        status: status ?? this.status,
        board: board ?? this.board,
        message: message,
      );

  @override
  List<Object?> get props => [status, board, message];
}

class MaintenanceCubit extends Cubit<MaintenanceState> {
  MaintenanceCubit(this._getBoard) : super(const MaintenanceState());

  final GetMaintenanceBoard _getBoard;

  Future<void> load() async {
    emit(state.copyWith(status: MaintenanceStatus.loading));
    final Result<MaintenanceBoard> result = await _getBoard(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: MaintenanceStatus.failure, message: failure.message)),
      (board) => emit(state.copyWith(status: MaintenanceStatus.ready, board: board)),
    );
  }

  Future<void> refresh() => load();
}
