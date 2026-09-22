import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';

class ScooterDetailsPage extends StatelessWidget {
  const ScooterDetailsPage({required this.vehicle, super.key});

  final Vehicle vehicle;

  static Future<void> open(BuildContext context, Vehicle vehicle) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (_) => ScooterDetailsPage(vehicle: vehicle)),
      );

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
      title: 'Vehicle details',
      subtitle: vehicle.vehicleNumber,
      body: PageBody(
        children: [
          ModuleCard(
            title: 'Identity',
            leading: const IconTile(icon: Icons.badge_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Vehicle number',
                  value: vehicle.vehicleNumber,
                  icon: Icons.confirmation_number_rounded,
                ),
                KeyValueRow(label: 'Model', value: _or(vehicle.model), icon: Icons.two_wheeler_rounded),
                KeyValueRow(label: 'Colour', value: _or(vehicle.colour), icon: Icons.palette_rounded),
                KeyValueRow(label: 'Chassis / VIN', value: _or(vehicle.vin), icon: Icons.tag_rounded),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'Powertrain',
            leading: const IconTile(icon: Icons.bolt_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Battery type',
                  value: _pretty(vehicle.batteryType),
                  icon: Icons.battery_charging_full_rounded,
                ),
                KeyValueRow(
                  label: 'Battery serial',
                  value: _or(vehicle.batterySerial),
                  icon: Icons.numbers_rounded,
                ),
                KeyValueRow(
                  label: 'Motor number',
                  value: _or(vehicle.motorNumber),
                  icon: Icons.settings_rounded,
                ),
                KeyValueRow(
                  label: 'Controller number',
                  value: _or(vehicle.controllerNumber),
                  icon: Icons.memory_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'Where it belongs',
            leading: const IconTile(icon: Icons.hub_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Allowed from hub',
                  value: _or(vehicle.homeHubName),
                  icon: Icons.warehouse_rounded,
                ),
                KeyValueRow(
                  label: 'Parked at',
                  value: _or(vehicle.currentHubName),
                  icon: Icons.location_on_rounded,
                ),
                KeyValueRow(
                  label: 'Allocated on',
                  value: vehicle.allocatedOn == null ? '—' : Fmt.date(vehicle.allocatedOn!),
                  icon: Icons.event_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'Who looks after you',
            leading: const IconTile(icon: Icons.groups_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Team lead',
                  value: _or(vehicle.teamLeadName),
                  icon: Icons.person_rounded,
                ),
                KeyValueRow(
                  label: 'Cluster manager',
                  value: _or(vehicle.clusterManagerName),
                  icon: Icons.supervisor_account_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'IoT unit',
            leading: const IconTile(icon: Icons.sensors_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Device number',
                  value: _or(vehicle.iot.deviceId),
                  icon: Icons.developer_board_rounded,
                ),
                KeyValueRow(
                  label: 'Status',
                  value: vehicle.iot.online ? 'Online' : 'Offline',
                  icon: Icons.wifi_rounded,
                ),
                KeyValueRow(
                  label: 'Last ping',
                  value: _or(vehicle.iot.lastPing),
                  icon: Icons.schedule_rounded,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'Odometer and service',
            leading: const IconTile(icon: Icons.speed_rounded, solid: true, size: 28),
            child: Column(
              children: [
                KeyValueRow(
                  label: 'Odometer',
                  value: '${Fmt.number(vehicle.odometerKm)} km',
                  icon: Icons.route_rounded,
                ),
                KeyValueRow(
                  label: 'Next service',
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
