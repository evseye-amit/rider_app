import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';

class ScooterDetailsPage extends StatelessWidget {
  const ScooterDetailsPage({required this.vehicle, super.key});

  final Vehicle vehicle;

  static Future<void> open(BuildContext context, Vehicle vehicle) =>
      Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => ScooterDetailsPage(vehicle: vehicle)));

  String _or(String? value) => (value == null || value.trim().isEmpty) ? '—' : value.trim();

  String _pretty(String? value) {
    final String raw = (value ?? '').trim();
    if (raw.isEmpty) return '—';
    return raw
        .split(RegExp(r'[_\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.scooterVehicleDetails,
      subtitle: vehicle.vehicleNumber,
      body: PageBody(
        children: [
          ModuleCard(
            title: context.l10n.scooterIdentity,
            leading: const IconTile(icon: Icons.badge_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.scooterVehicleNumber,
                  value: vehicle.vehicleNumber,
                  icon: Icons.confirmation_number_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.commonModel,
                  value: _or(vehicle.model),
                  icon: Icons.two_wheeler_rounded,
                ),
                KeyValueRow(label: context.l10n.commonColour, value: _or(vehicle.colour), icon: Icons.palette_rounded),
                KeyValueRow(label: 'Chassis / VIN', value: _or(vehicle.vin), icon: Icons.tag_rounded),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.scooterPowertrain,
            leading: const IconTile(icon: Icons.bolt_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.scooterBatteryType,
                  value: _pretty(vehicle.batteryType),
                  icon: Icons.battery_charging_full_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterBatterySerial,
                  value: _or(vehicle.batterySerial),
                  icon: Icons.numbers_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterMotorNumber,
                  value: _or(vehicle.motorNumber),
                  icon: Icons.settings_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterControllerNumber,
                  value: _or(vehicle.controllerNumber),
                  icon: Icons.memory_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.scooterWhereBelongs,
            leading: const IconTile(icon: Icons.hub_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.scooterAllowedFromHub,
                  value: _or(vehicle.homeHubName),
                  icon: Icons.warehouse_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterParked,
                  value: _or(vehicle.currentHubName),
                  icon: Icons.location_on_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.commonAllocated,
                  value: vehicle.allocatedOn == null ? '—' : Fmt.date(vehicle.allocatedOn!),
                  icon: Icons.event_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.scooterWhoLooksAfter,
            leading: const IconTile(icon: Icons.groups_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.commonTeamLead,
                  value: _or(vehicle.teamLeadName),
                  icon: Icons.person_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterClusterManager,
                  value: _or(vehicle.clusterManagerName),
                  icon: Icons.supervisor_account_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.commonIotUnit,
            leading: const IconTile(icon: Icons.sensors_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.scooterDeviceNumber,
                  value: _or(vehicle.iot.deviceId),
                  icon: Icons.developer_board_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.commonStatus,
                  value: vehicle.iot.online ? context.l10n.homeOnline : context.l10n.commonOffline,
                  icon: Icons.wifi_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterLastPing,
                  value: _or(vehicle.iot.lastPing),
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.scooterOdometerService,
            leading: const IconTile(icon: Icons.speed_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: context.l10n.commonOdometer,
                  value: '${Fmt.number(vehicle.odometerKm)} km',
                  icon: Icons.route_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.scooterNextService,
                  value: '${Fmt.number(vehicle.nextServiceKm)} km',
                  icon: Icons.build_rounded,
                ),
              ],
            ),
          ),
          const Gap.x3l(),
        ],
      ),
    );
  }
}
