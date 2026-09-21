import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/get_vehicle.dart';

enum ScooterStatus { initial, loading, ready, failure }

class ScooterState extends Equatable {
  const ScooterState({
    this.status = ScooterStatus.initial,
    this.vehicle,
    this.message,
  });

  final ScooterStatus status;
  final Vehicle? vehicle;
  final String? message;

  bool get isLoading =>
      status == ScooterStatus.loading || status == ScooterStatus.initial;

  ScooterState copyWith({
    ScooterStatus? status,
    Vehicle? vehicle,
    String? message,
  }) => ScooterState(
    status: status ?? this.status,
    vehicle: vehicle ?? this.vehicle,
    message: message,
  );

  @override
  List<Object?> get props => [status, vehicle, message];
}

class ScooterCubit extends Cubit<ScooterState> {
  ScooterCubit(this._getVehicle) : super(const ScooterState());

  final GetVehicle _getVehicle;

  Future<void> load() async {
    emit(state.copyWith(status: ScooterStatus.loading));
    final Result<Vehicle> result = await _getVehicle(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: ScooterStatus.failure, message: failure.message),
      ),
      (vehicle) =>
          emit(state.copyWith(status: ScooterStatus.ready, vehicle: vehicle)),
    );
  }

  Future<void> refresh() => load();
}
