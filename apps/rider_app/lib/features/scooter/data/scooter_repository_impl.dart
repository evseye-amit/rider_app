import 'package:evseye_core/evseye_core.dart';

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
          return Result.err(NotFoundFailure(ActiveLocale.strings.scooterNoScooterHasBeenAllocated));
        }
        return Result.ok(_vehicle(allocation, fleet));
    }
  }

  static Vehicle _vehicle(DeploymentAllocation allocation, DeploymentFleet fleet) {
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
      frontPhotoUrl: fleet.frontPhotoUrl,
      odometerKm: odometer,
      batteryPercent: 0,
      charging: false,
      rangeKm: 0,
      healthPercent: 0,
      nextServiceKm: 0,
    );
  }

  static String _plate(String raw) {
    final RegExpMatch? m = RegExp(r'^([A-Z]{2})(\d{1,2})([A-Z]{1,3})(\d{4})$').firstMatch(raw.toUpperCase());
    return m == null ? raw : '${m[1]} ${m[2]} ${m[3]} ${m[4]}';
  }
}
