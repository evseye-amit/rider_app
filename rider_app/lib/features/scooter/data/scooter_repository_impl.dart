import 'package:evseye_core/evseye_core.dart';

import '../../../core/demo/demo_data.dart';
import '../domain/entities/vehicle.dart';
import '../domain/scooter_repository.dart';

class ScooterRepositoryImpl implements ScooterRepository {
  const ScooterRepositoryImpl(this._api);

  final DeploymentApi _api;

  @override
  Future<Result<Vehicle>> getVehicle() async {
    final Result<RiderDeployment> result = await _api.riderCurrent();
    switch (result) {
      case Err<RiderDeployment>(:final failure):
        return Result.err(failure);
      case Ok<RiderDeployment>(:final value):
        final DeploymentAllocation? allocation = value.allocation;
        final DeploymentFleet? fleet = allocation?.fleet;
        if (allocation == null || fleet == null) {
          return const Result.err(NotFoundFailure('No scooter has been allocated to you yet.'));
        }
        return Result.ok(_vehicle(allocation, fleet, value.status));
    }
  }

  static Vehicle _vehicle(DeploymentAllocation allocation, DeploymentFleet fleet, DeploymentStatus status) {
    final int odometer = fleet.odometerKm?.round() ?? 0;
    return Vehicle(
      vehicleNumber: _plate(fleet.vehicleNumber),
      model: fleet.modelName ?? '—',
      vin: fleet.vinNumber?.isNotEmpty == true ? fleet.vinNumber! : fleet.chassisNumber,
      motorNumber: fleet.motorNumber,
      controllerNumber: fleet.controllerNumber,
      batteryType: fleet.batteryType,
      batterySerial: fleet.batterySerial,
      homeHubName: fleet.homeHubName,
      currentHubName: fleet.currentHubName,
      teamLeadName: allocation.rider?.teamLeadName,
      colour: fleet.colour ?? '—',
      allocatedOn: allocation.allocatedAt ?? allocation.createdAt,
      odometerKm: odometer,

      batteryPercent: 68,
      charging: false,
      rangeKm: 61,
      healthPercent: 94,
      lastServiceKm: (odometer ~/ 5000) * 5000,
      nextServiceKm: (odometer ~/ 5000) * 5000 + 5000,
      tyrePressureFront: 32,
      tyrePressureRear: 36,
      iot: VehicleIot(
        deviceId: fleet.iotDeviceNumber ?? (status.isDeployed ? 'Paired' : '—'),
        online: status.isDeployed,
        signal: status.isDeployed ? 3 : 0,
        lastPing: status.isDeployed ? 'a moment ago' : '—',
        firmware: '—',
      ),
      documents: [
        VehicleDocument(
          key: 'rc',
          label: 'Registration certificate',
          validTill: DateTime(Demo.now.year + 4, 3, 31),
          status: 'valid',
        ),
        VehicleDocument(
          key: 'insurance',
          label: 'Insurance',
          validTill: Demo.today().add(const Duration(days: 23)),
          status: 'expiring',
        ),
        VehicleDocument(
          key: 'permit',
          label: 'Commercial permit',
          validTill: DateTime(Demo.now.year + 1, 11, 30),
          status: 'valid',
        ),
        VehicleDocument(
          key: 'puc',
          label: 'Fitness certificate',
          validTill: DateTime(Demo.now.year + 2, 6, 15),
          status: 'valid',
        ),
      ],
      accessories: const [
        VehicleAccessory(key: 'helmet', label: 'Helmet', present: true),
        VehicleAccessory(key: 'charger', label: 'Charger', present: true),
        VehicleAccessory(key: 'toolkit', label: 'Toolkit', present: true),
        VehicleAccessory(key: 'phone_mount', label: 'Phone mount', present: true),
        VehicleAccessory(key: 'delivery_box', label: 'Delivery box', present: false),
      ],
      recentTrips: _trips(),
    );
  }

  static String _plate(String raw) {
    final RegExpMatch? m = RegExp(r'^([A-Z]{2})(\d{1,2})([A-Z]{1,3})(\d{4})$').firstMatch(raw.toUpperCase());
    return m == null ? raw : '${m[1]} ${m[2]} ${m[3]} ${m[4]}';
  }

  static List<VehicleTrip> _trips() => [
        VehicleTrip(id: 'trip_884', from: 'Okhla Phase II', to: 'Nehru Place', distanceKm: 6.4, durationMin: 22, earning: 95, at: Demo.hoursAgo(2)),
        VehicleTrip(id: 'trip_883', from: 'Kalkaji', to: 'Greater Kailash II', distanceKm: 4.1, durationMin: 16, earning: 78, at: Demo.hoursAgo(3)),
        VehicleTrip(id: 'trip_882', from: 'Jasola Vihar', to: 'Sarita Vihar', distanceKm: 5.8, durationMin: 19, earning: 88, at: Demo.hoursAgo(5)),
        VehicleTrip(id: 'trip_881', from: 'Okhla Phase I', to: 'Lajpat Nagar', distanceKm: 8.2, durationMin: 31, earning: 124, at: Demo.hoursAgo(7)),
        VehicleTrip(id: 'trip_880', from: 'Okhla Phase II', to: 'Ashram', distanceKm: 7.1, durationMin: 26, earning: 106, at: Demo.hoursAgo(9)),
      ];
}
