import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/allocation_board.dart';
import '../../domain/usecases/get_allocation_board.dart';

enum AllocationsStatus { initial, loading, ready, failure }

class AllocationsState extends Equatable {
  const AllocationsState({this.status = AllocationsStatus.initial, this.board, this.message});

  final AllocationsStatus status;
  final AllocationBoard? board;
  final String? message;

  bool get isLoading => status == AllocationsStatus.loading || status == AllocationsStatus.initial;

  AllocationsState copyWith({AllocationsStatus? status, AllocationBoard? board, String? message}) =>
      AllocationsState(
        status: status ?? this.status,
        board: board ?? this.board,
        message: message,
      );

  @override
  List<Object?> get props => [status, board, message];
}

class AllocationsCubit extends Cubit<AllocationsState> {
  AllocationsCubit(this._getBoard) : super(const AllocationsState());

  final GetAllocationBoard _getBoard;

  Future<void> load() async {
    emit(state.copyWith(status: AllocationsStatus.loading));
    final Result<AllocationBoard> result = await _getBoard(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: AllocationsStatus.failure, message: failure.message)),
      (board) => emit(state.copyWith(status: AllocationsStatus.ready, board: board)),
    );
  }

  Future<void> refresh() => load();
}
