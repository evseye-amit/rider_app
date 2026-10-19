import 'package:equatable/equatable.dart';

class HubQueue extends Equatable {
  const HubQueue({
    required this.allotments,
    required this.submissions,
    required this.readyForDeployment,
    required this.underMaintenance,
  });

  final int allotments;
  final int submissions;
  final int readyForDeployment;
  final int underMaintenance;

  static HubQueue? combine(List<HubQueue?> parts) {
    if (parts.isEmpty || parts.contains(null)) return null;
    final List<HubQueue> queues = parts.whereType<HubQueue>().toList();
    int sum(int Function(HubQueue) pick) => queues.fold(0, (total, queue) => total + pick(queue));
    return HubQueue(
      allotments: sum((q) => q.allotments),
      submissions: sum((q) => q.submissions),
      readyForDeployment: sum((q) => q.readyForDeployment),
      underMaintenance: sum((q) => q.underMaintenance),
    );
  }

  @override
  List<Object?> get props => [allotments, submissions, readyForDeployment, underMaintenance];
}

class HubSummary extends Equatable {
  const HubSummary({
    required this.hubName,
    required this.hubCode,
    required this.fleetAllocated,
    required this.fleetTotal,
    required this.ridersPresent,
    required this.ridersActive,
    required this.queue,
    this.gstin,
    this.supportNumber,
  });

  final String hubName;
  final String hubCode;
  final int fleetAllocated;
  final int fleetTotal;
  final int ridersPresent;
  final int ridersActive;
  final HubQueue? queue;
  final String? gstin;
  final String? supportNumber;

  double? get utilisation => fleetTotal == 0 ? null : fleetAllocated / fleetTotal;

  static HubSummary combine(List<HubSummary> parts) {
    if (parts.length == 1) return parts.first;
    int sum(int Function(HubSummary) pick) => parts.fold(0, (a, p) => a + pick(p));

    return HubSummary(
      hubName: '${parts.length} hubs combined',
      hubCode: parts.map((p) => p.hubCode).join(' · '),
      fleetAllocated: sum((p) => p.fleetAllocated),
      fleetTotal: sum((p) => p.fleetTotal),
      ridersPresent: sum((p) => p.ridersPresent),
      ridersActive: sum((p) => p.ridersActive),
      queue: HubQueue.combine([for (final HubSummary p in parts) p.queue]),
      gstin: parts.map((p) => p.gstin).nonNulls.firstOrNull,
      supportNumber: parts.map((p) => p.supportNumber).nonNulls.firstOrNull,
    );
  }

  @override
  List<Object?> get props => [
    hubName,
    hubCode,
    fleetAllocated,
    fleetTotal,
    ridersPresent,
    ridersActive,
    queue,
    gstin,
    supportNumber,
  ];
}
