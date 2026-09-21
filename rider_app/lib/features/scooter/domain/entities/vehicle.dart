import 'package:equatable/equatable.dart';

class VehicleIot extends Equatable {
  const VehicleIot({
    required this.deviceId,
    required this.online,
    required this.signal,
    required this.lastPing,
    required this.firmware,
  });

  final String deviceId;
  final bool online;

  final int signal;
  final String lastPing;
  final String firmware;

  @override
  List<Object?> get props => [deviceId, online, signal, lastPing, firmware];
}

class VehicleDocument extends Equatable {
  const VehicleDocument({
    required this.key,
    required this.label,
    required this.validTill,
    required this.status,
  });

  final String key;
  final String label;
  final DateTime? validTill;

  final String status;

  bool get isExpiring => status == 'expiring';
  bool get isExpired => status == 'expired';

  @override
  List<Object?> get props => [key, label, validTill, status];
}

class VehicleAccessory extends Equatable {
  const VehicleAccessory({
    required this.key,
    required this.label,
    required this.present,
  });

  final String key;
  final String label;
  final bool present;

  @override
  List<Object?> get props => [key, label, present];
}

class VehicleTrip extends Equatable {
  const VehicleTrip({
    required this.id,
    required this.from,
    required this.to,
    required this.distanceKm,
    required this.durationMin,
    required this.earning,
    required this.at,
  });

  final String id;
  final String from;
  final String to;
  final double distanceKm;
  final int durationMin;
  final num earning;
  final DateTime at;

  @override
  List<Object?> get props => [
    id,
    from,
    to,
    distanceKm,
    durationMin,
    earning,
    at,
  ];
}

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
    required this.lastServiceKm,
    required this.nextServiceKm,
    required this.tyrePressureFront,
    required this.tyrePressureRear,
    required this.iot,
    required this.documents,
    required this.accessories,
    required this.recentTrips,
    this.motorNumber,
    this.controllerNumber,
    this.batteryType,
    this.batterySerial,
    this.homeHubName,
    this.currentHubName,
    this.teamLeadName,
    this.clusterManagerName,
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
  final int lastServiceKm;
  final int nextServiceKm;
  final int tyrePressureFront;
  final int tyrePressureRear;
  final VehicleIot iot;
  final List<VehicleDocument> documents;
  final List<VehicleAccessory> accessories;
  final List<VehicleTrip> recentTrips;
  final String? motorNumber;
  final String? controllerNumber;
  final String? batteryType;
  final String? batterySerial;
  final String? homeHubName;
  final String? currentHubName;
  final String? teamLeadName;
  final String? clusterManagerName;

  int get kmToNextService =>
      (nextServiceKm - odometerKm).clamp(0, nextServiceKm);

  double get serviceProgress {
    final int span = nextServiceKm - lastServiceKm;
    if (span <= 0) return 1;
    return ((odometerKm - lastServiceKm) / span).clamp(0.0, 1.0);
  }

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
    lastServiceKm,
    nextServiceKm,
    tyrePressureFront,
    tyrePressureRear,
    iot,
    documents,
    accessories,
    recentTrips,
  ];
}
