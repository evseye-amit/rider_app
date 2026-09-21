import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/raise_job_input.dart';
import '../../domain/entities/vehicle_option.dart';
import '../../domain/entities/vendor_option.dart';
import '../../domain/usecases/get_vehicle_options.dart';
import '../../domain/usecases/get_vendor_options.dart';
import '../../domain/usecases/raise_maintenance_job.dart';

enum RaiseMaintenanceStatus { initial, loading, ready, failure }

class RaiseMaintenanceState extends Equatable {
  const RaiseMaintenanceState({
    this.status = RaiseMaintenanceStatus.initial,
    this.vehicles = const [],
    this.vendors = const [],
    this.submitting = false,
    this.message,
  });

  final RaiseMaintenanceStatus status;
  final List<VehicleOption> vehicles;
  final List<VendorOption> vendors;
  final bool submitting;
  final String? message;

  bool get isLoading =>
      status == RaiseMaintenanceStatus.loading || status == RaiseMaintenanceStatus.initial;

  RaiseMaintenanceState copyWith({
    RaiseMaintenanceStatus? status,
    List<VehicleOption>? vehicles,
    List<VendorOption>? vendors,
    bool? submitting,
    String? message,
  }) =>
      RaiseMaintenanceState(
        status: status ?? this.status,
        vehicles: vehicles ?? this.vehicles,
        vendors: vendors ?? this.vendors,
        submitting: submitting ?? this.submitting,
        message: message,
      );

  @override
  List<Object?> get props => [status, vehicles, vendors, submitting, message];
}

class RaiseMaintenanceCubit extends Cubit<RaiseMaintenanceState> {
  RaiseMaintenanceCubit(this._getVehicleOptions, this._getVendorOptions, this._raiseJob)
      : super(const RaiseMaintenanceState());

  final GetVehicleOptions _getVehicleOptions;
  final GetVendorOptions _getVendorOptions;
  final RaiseMaintenanceJob _raiseJob;

  Future<void> load() async {
    emit(state.copyWith(status: RaiseMaintenanceStatus.loading));
    final results = await Future.wait([
      _getVehicleOptions(const NoParams()),
      _getVendorOptions(const NoParams()),
    ]);
    final Result<List<VehicleOption>> vehiclesResult = results[0] as Result<List<VehicleOption>>;
    final Result<List<VendorOption>> vendorsResult = results[1] as Result<List<VendorOption>>;

    if (vehiclesResult.isErr) {
      emit(state.copyWith(
        status: RaiseMaintenanceStatus.failure,
        message: vehiclesResult.failureOrNull!.message,
      ));
      return;
    }
    if (vendorsResult.isErr) {
      emit(state.copyWith(
        status: RaiseMaintenanceStatus.failure,
        message: vendorsResult.failureOrNull!.message,
      ));
      return;
    }
    emit(state.copyWith(
      status: RaiseMaintenanceStatus.ready,
      vehicles: vehiclesResult.valueOrNull,
      vendors: vendorsResult.valueOrNull,
    ));
  }

  Future<Result<String>> submit(RaiseJobInput input) async {
    emit(state.copyWith(submitting: true));
    final Result<String> result = await _raiseJob(input);
    emit(state.copyWith(submitting: false));
    return result;
  }
}
