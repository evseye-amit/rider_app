import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/maintenance_vehicle.dart';
import '../maintenance_repository.dart';

class MaintenanceQuery extends Equatable {
  const MaintenanceQuery({this.hubId, this.search = '', this.page = 1});

  final String? hubId;
  final String search;
  final int page;

  @override
  List<Object?> get props => [hubId, search, page];
}

class GetMaintenanceVehicles extends UseCase<MaintenanceVehicleList, MaintenanceQuery> {
  const GetMaintenanceVehicles(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<MaintenanceVehicleList>> call(MaintenanceQuery query) => _repository.vehicles(query);
}

class GetMaintenanceVehicle extends UseCase<MaintenanceVehicleDetail, String> {
  const GetMaintenanceVehicle(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<MaintenanceVehicleDetail>> call(String fleetId) => _repository.vehicle(fleetId);
}

class GetEvidencePhotoUrl extends UseCase<String, String> {
  const GetEvidencePhotoUrl(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<String>> call(String photoId) => _repository.photoUrl(photoId);
}

class StatusChangeRequest extends Equatable {
  const StatusChangeRequest({required this.fleetId, required this.status});

  final String fleetId;
  final String status;

  @override
  List<Object?> get props => [fleetId, status];
}

class ChangeVehicleStatus extends UseCase<void, StatusChangeRequest> {
  const ChangeVehicleStatus(this._repository);

  final MaintenanceRepository _repository;

  @override
  Future<Result<void>> call(StatusChangeRequest request) => _repository.changeStatus(request.fleetId, request.status);
}
