import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

class MaintenanceHub extends Equatable {
  const MaintenanceHub({required this.id, required this.code, required this.name});

  final String id;
  final String code;
  final String name;

  @override
  List<Object?> get props => [id, code, name];
}

class MaintenanceMove extends Equatable {
  const MaintenanceMove({required this.at});

  final DateTime at;

  @override
  List<Object?> get props => [at];
}

class MechanicReport extends Equatable {
  const MechanicReport({
    required this.id,
    required this.deep,
    required this.mechanicName,
    required this.summary,
    required this.safeForReuse,
    required this.checksComplete,
    required this.createdAt,
    this.unsafeReason,
    this.confirmedAt,
    this.evidencePhotoIds = const [],
    this.fleetStatus,
  });

  final String id;
  final bool deep;
  final String mechanicName;
  final String summary;
  final bool safeForReuse;
  final String? unsafeReason;
  final bool checksComplete;
  final List<String> evidencePhotoIds;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final MaintenanceFleetStatus? fleetStatus;

  @override
  List<Object?> get props => [id, safeForReuse, checksComplete, createdAt, confirmedAt, fleetStatus];
}

class MaintenanceVehicle extends Equatable {
  const MaintenanceVehicle({
    required this.id,
    required this.fleetCode,
    required this.vehicleNumber,
    required this.chassisNumber,
    required this.onboardingStatus,
    required this.allocationEnabled,
    this.modelName,
    this.variantName,
    this.colour,
    this.odometerKm,
    this.oemName,
    this.categoryName,
    this.typeName,
    this.hub,
    this.currentHub,
    this.homeHub,
    this.updatedAt,
    this.movedToMaintenance,
    this.latestReport,
    this.status = 'MAINTENANCE',
  });

  final String id;
  final String fleetCode;
  final String vehicleNumber;
  final String chassisNumber;
  final String? modelName;
  final String? variantName;
  final String? colour;
  final String onboardingStatus;
  final bool allocationEnabled;
  final num? odometerKm;
  final String? oemName;
  final String? categoryName;
  final String? typeName;
  final MaintenanceHub? hub;
  final MaintenanceHub? currentHub;
  final MaintenanceHub? homeHub;
  final DateTime? updatedAt;
  final MaintenanceMove? movedToMaintenance;
  final MechanicReport? latestReport;
  final String status;

  String get modelLine => [modelName, variantName, colour].whereType<String>().join(' · ');

  MaintenanceFleetStatus? get condition => MaintenanceFleetStatus.maybe(status);

  @override
  List<Object?> get props => [id, vehicleNumber, updatedAt, movedToMaintenance, latestReport, status];
}

class MaintenanceStatusChange extends Equatable {
  const MaintenanceStatusChange({
    required this.id,
    required this.to,
    required this.at,
    this.from,
    this.reason,
    this.fromReport = false,
  });

  final String id;
  final String? from;
  final String to;
  final String? reason;
  final bool fromReport;
  final DateTime at;

  @override
  List<Object?> get props => [id, from, to, reason, fromReport, at];
}

class EvidencePhoto extends Equatable {
  const EvidencePhoto({required this.id, required this.photoType, this.mimeType, this.uploadedAt});

  final String id;
  final String photoType;
  final String? mimeType;
  final DateTime? uploadedAt;

  bool get isImage => mimeType == null || mimeType!.startsWith('image/');

  @override
  List<Object?> get props => [id, photoType, mimeType, uploadedAt];
}

class MaintenanceVehicleList extends Equatable {
  const MaintenanceVehicleList({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.underMaintenance,
  });

  final List<MaintenanceVehicle> items;
  final int page;
  final int totalPages;
  final int total;
  final int underMaintenance;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [items, page, totalPages, total, underMaintenance];
}

class MaintenanceVehicleDetail extends Equatable {
  const MaintenanceVehicleDetail({
    required this.vehicle,
    required this.history,
    required this.reports,
    required this.photos,
    this.moreHistory = false,
    this.moreReports = false,
    this.historyLimit = 100,
    this.reportLimit = 50,
  });

  final MaintenanceVehicle vehicle;
  final List<MaintenanceStatusChange> history;
  final List<MechanicReport> reports;
  final List<EvidencePhoto> photos;
  final bool moreHistory;
  final bool moreReports;
  final int historyLimit;
  final int reportLimit;

  @override
  List<Object?> get props => [vehicle, history, reports, photos, moreHistory, moreReports];
}
