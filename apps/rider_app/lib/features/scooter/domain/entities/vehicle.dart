import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  const Vehicle({
    required this.vehicleNumber,
    required this.model,
    required this.vin,
    required this.colour,
    required this.allocatedOn,
    required this.batteryPercent,
    required this.charging,
    required this.rangeKm,
    required this.odometerKm,
    required this.healthPercent,
    required this.nextServiceKm,
    this.motorNumber,
    this.controllerNumber,
    this.batteryType,
    this.batterySerial,
    this.homeHubName,
    this.currentHubName,
    this.teamLeadName,
    this.clusterManagerName,
    this.frontPhotoUrl,
  });

  final String vehicleNumber;
  final String model;
  final String vin;
  final String colour;
  final DateTime? allocatedOn;
  final int batteryPercent;
  final bool charging;
  final int rangeKm;
  final int odometerKm;
  final int healthPercent;
  final int nextServiceKm;
  final String? motorNumber;
  final String? controllerNumber;
  final String? batteryType;
  final String? batterySerial;
  final String? homeHubName;
  final String? currentHubName;
  final String? teamLeadName;
  final String? clusterManagerName;
  final String? frontPhotoUrl;

  int get kmToNextService => (nextServiceKm - odometerKm).clamp(0, nextServiceKm);

  @override
  List<Object?> get props => [
    vehicleNumber,
    model,
    vin,
    colour,
    allocatedOn,
    batteryPercent,
    charging,
    rangeKm,
    odometerKm,
    healthPercent,
    nextServiceKm,
    frontPhotoUrl,
  ];
}
