import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/get_deallocation_request.dart';

enum DeallocationFlowStatus { initial, loading, ready, failure }

class DeallocationFlowState extends Equatable {
  const DeallocationFlowState({
    this.status = DeallocationFlowStatus.initial,
    this.request,
    this.message,
  });

  final DeallocationFlowStatus status;
  final DeallocationRequest? request;
  final String? message;

  bool get isLoading =>
      status == DeallocationFlowStatus.loading || status == DeallocationFlowStatus.initial;

  DeallocationFlowState copyWith({
    DeallocationFlowStatus? status,
    DeallocationRequest? request,
    String? message,
  }) =>
      DeallocationFlowState(
        status: status ?? this.status,
        request: request ?? this.request,
        message: message,
      );

  @override
  List<Object?> get props => [status, request, message];
}

class DeallocationFlowCubit extends Cubit<DeallocationFlowState> {
  DeallocationFlowCubit(this._getDeallocationRequest, this._requestId)
      : super(const DeallocationFlowState());

  final GetDeallocationRequest _getDeallocationRequest;
  final String _requestId;

  Future<void> load() async {
    emit(state.copyWith(status: DeallocationFlowStatus.loading));
    final Result<DeallocationRequest> result = await _getDeallocationRequest(_requestId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: DeallocationFlowStatus.failure, message: failure.message)),
      (request) => emit(state.copyWith(status: DeallocationFlowStatus.ready, request: request)),
    );
  }
}
