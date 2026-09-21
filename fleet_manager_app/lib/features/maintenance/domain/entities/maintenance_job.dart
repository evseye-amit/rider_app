import 'package:equatable/equatable.dart';

class MaintenanceJob extends Equatable {
  const MaintenanceJob({
    required this.id,
    required this.vehicleNumber,
    required this.model,
    required this.type,
    required this.priority,
    required this.status,
    required this.openedOn,
    required this.dueOn,
    required this.odometerKm,
    required this.issue,
    this.closedOn,
    this.assignedTo,
    this.rider,
    this.bay,
    this.notes = const [],
  });

  final String id;
  final String vehicleNumber;
  final String model;
  final String type;

  final String priority;

  final String status;
  final DateTime openedOn;
  final DateTime dueOn;
  final DateTime? closedOn;
  final int odometerKm;
  final String issue;
  final String? assignedTo;
  final String? rider;
  final String? bay;
  final List<String> notes;

  bool get isClosed => status == 'closed';

  bool get isPastDue => !isClosed && DateTime.now().isAfter(dueOn);

  MaintenanceJob copyWith({
    String? status,
    DateTime? closedOn,
    String? assignedTo,
    List<String>? notes,
  }) =>
      MaintenanceJob(
        id: id,
        vehicleNumber: vehicleNumber,
        model: model,
        type: type,
        priority: priority,
        status: status ?? this.status,
        openedOn: openedOn,
        dueOn: dueOn,
        odometerKm: odometerKm,
        issue: issue,
        closedOn: closedOn ?? this.closedOn,
        assignedTo: assignedTo ?? this.assignedTo,
        rider: rider,
        bay: bay,
        notes: notes ?? this.notes,
      );

  @override
  List<Object?> get props => [
        id,
        vehicleNumber,
        model,
        type,
        priority,
        status,
        openedOn,
        dueOn,
        closedOn,
        odometerKm,
        issue,
        assignedTo,
        rider,
        bay,
        notes,
      ];
}
