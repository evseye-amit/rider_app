import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/maintenance_vehicle.dart';
import '../maintenance_repository.dart';

class MaintenanceQuery extends Equatable {
  const MaintenanceQuery({this.hubId, this.search = '', this.page = 1, this.fleetStatus, this.category});

  final String? hubId;
  final String search;
  final int page;
  final MaintenanceFleetStatus? fleetStatus;
  final MaintenanceIssueCategory? category;

  @override
  List<Object?> get props => [hubId, search, page, fleetStatus, category];
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
