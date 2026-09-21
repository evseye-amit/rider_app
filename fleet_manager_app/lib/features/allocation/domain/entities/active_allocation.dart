import 'package:equatable/equatable.dart';

class ActiveAllocation extends Equatable {
  const ActiveAllocation({
    required this.id,
    required this.riderName,
    required this.riderCode,
    required this.mobile,
    required this.vehicleNumber,
    required this.model,
    required this.allocatedOn,
    required this.teamLead,
    required this.plan,
    required this.batteryPercent,
    required this.status,
  });

  final String id;
  final String riderName;
  final String riderCode;
  final String mobile;
  final String vehicleNumber;
  final String model;
  final DateTime allocatedOn;
  final String teamLead;
  final String plan;

  final int? batteryPercent;

  final String status;

  @override
  List<Object?> get props => [
        id,
        riderName,
        riderCode,
        mobile,
        vehicleNumber,
        model,
        allocatedOn,
        teamLead,
        plan,
        batteryPercent,
        status,
      ];
}
