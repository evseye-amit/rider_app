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

  static FleetStatusBreakdown combine(Iterable<FleetStatusBreakdown> parts) =>
      FleetStatusBreakdown(
        total: parts.fold(0, (sum, p) => sum + p.total),
        allocated: parts.fold(0, (sum, p) => sum + p.allocated),
        available: parts.fold(0, (sum, p) => sum + p.available),
        inService: parts.fold(0, (sum, p) => sum + p.inService),
        offRoad: parts.fold(0, (sum, p) => sum + p.offRoad),
      );

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

  static HubSummary combine(List<HubSummary> parts) {
    if (parts.length == 1) return parts.first;
    int sum(int Function(HubSummary) pick) => parts.fold(0, (a, p) => a + pick(p));
    double weighted(double Function(HubSummary) pick) {
      final int fleet = sum((p) => p.fleet.total);
      if (fleet == 0) {
        return parts.isEmpty ? 0 : parts.fold<double>(0, (a, p) => a + pick(p)) / parts.length;
      }
      return parts.fold<double>(0, (a, p) => a + pick(p) * p.fleet.total) / fleet;
    }

    final int weeks = parts
        .map((p) => p.weeklyAllocations.length)
        .fold<int>(0, (a, b) => a > b ? a : b);

    return HubSummary(
      hubName: '${parts.length} hubs combined',
      hubCode: parts.map((p) => p.hubCode).join(' · '),
      fleet: FleetStatusBreakdown.combine(parts.map((p) => p.fleet)),
      ridersActive: sum((p) => p.ridersActive),
      ridersPresent: sum((p) => p.ridersPresent),
      ridersOnboarding: sum((p) => p.ridersOnboarding),
      utilisation: weighted((p) => p.utilisation),
      uptime: weighted((p) => p.uptime),
      pendingAllocations: sum((p) => p.pendingAllocations),
      pendingDeallocations: sum((p) => p.pendingDeallocations),
      openMaintenance: sum((p) => p.openMaintenance),
      overdueMaintenance: sum((p) => p.overdueMaintenance),
      batteryHealthAverage: weighted((p) => p.batteryHealthAverage),
      chargingBaysBusy: sum((p) => p.chargingBaysBusy),
      chargingBaysTotal: sum((p) => p.chargingBaysTotal),
      todayAllocations: sum((p) => p.todayAllocations),
      todayDeallocations: sum((p) => p.todayDeallocations),
      weeklyAllocations: [
        for (int i = 0; i < weeks; i++)
          parts.fold<num>(
            0,
            (a, p) => a + (i < p.weeklyAllocations.length ? p.weeklyAllocations[i] : 0),
          ),
      ],
      weeklyLabels: parts
          .firstWhere(
            (p) => p.weeklyLabels.length == weeks,
            orElse: () => parts.first,
          )
          .weeklyLabels,
      alerts: [for (final p in parts) ...p.alerts],
    );
  }

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
