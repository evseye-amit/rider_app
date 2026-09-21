import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/get_deallocation_request.dart';

enum DeallocationDetailStatus { initial, loading, ready, failure }

class DeallocationDetailState extends Equatable {
  const DeallocationDetailState({
    this.status = DeallocationDetailStatus.initial,
    this.request,
    this.message,
  });

  final DeallocationDetailStatus status;
  final DeallocationRequest? request;
  final String? message;

  bool get isLoading =>
      status == DeallocationDetailStatus.loading || status == DeallocationDetailStatus.initial;

  DeallocationDetailState copyWith({
    DeallocationDetailStatus? status,
    DeallocationRequest? request,
    String? message,
  }) =>
      DeallocationDetailState(
        status: status ?? this.status,
        request: request ?? this.request,
        message: message,
      );

  @override
  List<Object?> get props => [status, request, message];
}

class DeallocationDetailCubit extends Cubit<DeallocationDetailState> {
  DeallocationDetailCubit(this._getDeallocationRequest, this._requestId)
      : super(const DeallocationDetailState());

  final GetDeallocationRequest _getDeallocationRequest;
  final String _requestId;

  Future<void> load() async {
    emit(state.copyWith(status: DeallocationDetailStatus.loading));
    final Result<DeallocationRequest> result = await _getDeallocationRequest(_requestId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: DeallocationDetailStatus.failure, message: failure.message)),
      (request) => emit(state.copyWith(status: DeallocationDetailStatus.ready, request: request)),
    );
  }
}
