import 'package:equatable/equatable.dart';

class FleetStatusBreakdown extends Equatable {
  const FleetStatusBreakdown({
    required this.total,
    required this.allocated,
    required this.available,
    required this.inService,
    required this.offRoad,
  });

  final int total;
  final int allocated;
  final int available;
  final int inService;
  final int offRoad;

  double _share(int value) => total == 0 ? 0 : value / total;

  double get allocatedShare => _share(allocated);
  double get availableShare => _share(available);
  double get inServiceShare => _share(inService);
  double get offRoadShare => _share(offRoad);

  @override
  List<Object?> get props => [total, allocated, available, inService, offRoad];
}

class HubAlert extends Equatable {
  const HubAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.tone,
    required this.icon,
  });

  final String id;
  final String title;
  final String message;
  final String tone;
  final String icon;

  @override
  List<Object?> get props => [id, title, message, tone, icon];
}

class HubSummary extends Equatable {
  const HubSummary({
    required this.hubName,
    required this.hubCode,
    required this.fleet,
    required this.ridersActive,
    required this.ridersPresent,
    required this.ridersOnboarding,
    required this.utilisation,
    required this.uptime,
    required this.pendingAllocations,
    required this.pendingDeallocations,
    required this.openMaintenance,
    required this.overdueMaintenance,
    required this.batteryHealthAverage,
    required this.chargingBaysBusy,
    required this.chargingBaysTotal,
    required this.todayAllocations,
    required this.todayDeallocations,
    required this.weeklyAllocations,
    required this.weeklyLabels,
    required this.alerts,
  });

  final String hubName;
  final String hubCode;
  final FleetStatusBreakdown fleet;
  final int ridersActive;
  final int ridersPresent;
  final int ridersOnboarding;

  final double utilisation;

  final double uptime;
  final int pendingAllocations;
  final int pendingDeallocations;
  final int openMaintenance;
  final int overdueMaintenance;

  final double batteryHealthAverage;
  final int chargingBaysBusy;
  final int chargingBaysTotal;
  final int todayAllocations;
  final int todayDeallocations;
  final List<num> weeklyAllocations;
  final List<String> weeklyLabels;
  final List<HubAlert> alerts;

  double get chargingBayOccupancy =>
      chargingBaysTotal == 0 ? 0 : (chargingBaysBusy / chargingBaysTotal).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [
        hubName,
        hubCode,
        fleet,
        ridersActive,
        ridersPresent,
        utilisation,
        uptime,
        pendingAllocations,
        pendingDeallocations,
        openMaintenance,
        alerts,
      ];
}
