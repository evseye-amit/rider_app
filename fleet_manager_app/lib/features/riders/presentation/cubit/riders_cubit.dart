import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/rider.dart';
import '../../domain/usecases/get_riders.dart';

enum RidersStatus { initial, loading, ready, failure }

class RidersState extends Equatable {
  const RidersState({this.status = RidersStatus.initial, this.riders = const [], this.message});

  final RidersStatus status;
  final List<Rider> riders;
  final String? message;

  bool get isLoading => status == RidersStatus.loading || status == RidersStatus.initial;

  RidersState copyWith({RidersStatus? status, List<Rider>? riders, String? message}) =>
      RidersState(
        status: status ?? this.status,
        riders: riders ?? this.riders,
        message: message,
      );

  @override
  List<Object?> get props => [status, riders, message];
}

class RidersCubit extends Cubit<RidersState> {
  RidersCubit(this._getRiders) : super(const RidersState());

  final GetRiders _getRiders;

  Future<void> load() async {
    emit(state.copyWith(status: RidersStatus.loading));
    final Result<List<Rider>> result = await _getRiders(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: RidersStatus.failure, message: failure.message)),
      (riders) => emit(state.copyWith(status: RidersStatus.ready, riders: riders)),
    );
  }

  Future<void> refresh() => load();
}
