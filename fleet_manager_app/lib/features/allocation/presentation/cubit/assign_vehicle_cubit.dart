import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/allocate_vehicle.dart';
import '../../domain/usecases/get_eligible_fleets.dart';
import '../../domain/usecases/get_pending_rider.dart';

enum AssignVehicleStatus { initial, loading, ready, allocating, allocated, failure }

class AssignVehicleState extends Equatable {
  const AssignVehicleState({
    this.status = AssignVehicleStatus.initial,
    this.rider,
    this.vehicles = const [],
    this.allocation,
    this.message,
  });

  final AssignVehicleStatus status;
  final PendingRider? rider;
  final List<EligibleFleet> vehicles;

  final DeploymentAllocation? allocation;
  final String? message;

  bool get isLoading => status == AssignVehicleStatus.loading || status == AssignVehicleStatus.initial;
  bool get isAllocating => status == AssignVehicleStatus.allocating;

  AssignVehicleState copyWith({
    AssignVehicleStatus? status,
    PendingRider? rider,
    List<EligibleFleet>? vehicles,
    DeploymentAllocation? allocation,
    String? message,
  }) =>
      AssignVehicleState(
        status: status ?? this.status,
        rider: rider ?? this.rider,
        vehicles: vehicles ?? this.vehicles,
        allocation: allocation ?? this.allocation,
        message: message,
      );

  @override
  List<Object?> get props => [status, rider, vehicles, allocation?.id, message];
}

class AssignVehicleCubit extends Cubit<AssignVehicleState> {
  AssignVehicleCubit({
    required this.riderId,
    required GetPendingRider getPendingRider,
    required GetEligibleFleets getEligibleFleets,
    required AllocateVehicle allocateVehicle,
  })  : _getPendingRider = getPendingRider,
        _getEligibleFleets = getEligibleFleets,
        _allocateVehicle = allocateVehicle,
        super(const AssignVehicleState());

  final String riderId;
  final GetPendingRider _getPendingRider;
  final GetEligibleFleets _getEligibleFleets;
  final AllocateVehicle _allocateVehicle;

  Future<void> load() async {
    emit(state.copyWith(status: AssignVehicleStatus.loading));
    final results = await Future.wait<Result<dynamic>>([
      _getPendingRider(riderId),
      _getEligibleFleets(const NoParams()),
    ]);
    final Result<PendingRider> rider = results[0] as Result<PendingRider>;
    final Result<List<EligibleFleet>> vehicles = results[1] as Result<List<EligibleFleet>>;
    if (rider case Err<PendingRider>(:final failure)) {
      emit(state.copyWith(status: AssignVehicleStatus.failure, message: failure.message));
      return;
    }
    if (vehicles case Err<List<EligibleFleet>>(:final failure)) {
      emit(state.copyWith(status: AssignVehicleStatus.failure, message: failure.message));
      return;
    }
    emit(state.copyWith(
      status: AssignVehicleStatus.ready,
      rider: rider.valueOrNull,
      vehicles: vehicles.valueOrNull,
    ));
  }

  Future<bool> allocate(String fleetId) async {
    if (state.isAllocating) return false;
    emit(state.copyWith(status: AssignVehicleStatus.allocating));
    final Result<DeploymentAllocation> result =
        await _allocateVehicle(AllocateParams(riderId: riderId, fleetId: fleetId));
    return result.fold(
      (failure) {
        emit(state.copyWith(status: AssignVehicleStatus.ready, message: failure.message));
        return false;
      },
      (allocation) {
        emit(state.copyWith(status: AssignVehicleStatus.allocated, allocation: allocation));
        return true;
      },
    );
  }
}
