import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';

class VehicleBand extends StatelessWidget {
  const VehicleBand({required this.vehicle, super.key});

  final Vehicle? vehicle;

  @override
  Widget build(BuildContext context) {
    final Vehicle? v = vehicle;
    final int battery = v?.batteryPercent ?? 0;
    final Color batteryTone = battery >= 60
        ? AppColors.mint
        : battery >= 30
        ? AppColors.warning
        : AppColors.danger;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const IconTile(
              icon: Icons.electric_scooter_rounded,
              tone: AppColors.primary,
              solid: true,
              size: 44,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your scooter',
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.onInkSecondary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    v?.vehicleNumber ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(
                      fontSize: 20,
                      color: AppColors.onInk,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            StatusChip(
              label: v == null
                  ? '—'
                  : (v.iot.online ? 'IoT online' : 'IoT offline'),
              tone: v == null
                  ? StatusTone.neutral
                  : (v.iot.online ? StatusTone.success : StatusTone.danger),
              solid: true,
              dense: true,
            ),
          ],
        ),
        const Gap.xxl(),
        Text(
          'Battery charge',
          style: AppText.label.copyWith(color: AppColors.onInkSecondary),
        ),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$battery%',
              style: AppText.numericLarge.copyWith(
                fontSize: 38,
                color: AppColors.onInk,
              ),
            ),
            if (v?.charging ?? false) ...[
              const SizedBox(width: Insets.md),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: batteryTone.withValues(alpha: 0.18),
                    borderRadius: Corners.pill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 12, color: batteryTone),
                      const SizedBox(width: 3),
                      Text(
                        'Charging',
                        style: AppText.bodySmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: batteryTone,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.md,
            horizontal: Insets.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: 'Range',
                  value: v == null ? '—' : Fmt.distanceKm(v.rangeKm),
                  icon: Icons.near_me_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Health',
                  value: v == null ? '—' : '${v.healthPercent}%',
                  icon: Icons.monitor_heart_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: 'Next service',
                  value: v == null ? '—' : '${v.kmToNextService} km',
                  icon: Icons.build_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class IotPanel extends StatelessWidget {
  const IotPanel({required this.vehicle, super.key});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final VehicleIot iot = vehicle.iot;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Signal strength',
              style: AppText.bodySmall.copyWith(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            _SignalBars(strength: iot.signal),
          ],
        ),
        const SizedBox(height: Insets.sm),
        KeyValueRow(
          label: 'Device ID',
          value: iot.deviceId,
          icon: Icons.memory_rounded,
        ),
        KeyValueRow(
          label: 'Last ping',
          value: iot.lastPing,
          icon: Icons.sensors_rounded,
        ),
        KeyValueRow(
          label: 'Firmware',
          value: 'v${iot.firmware}',
          icon: Icons.system_update_rounded,
        ),
      ],
    );
  }
}

class _SignalBars extends StatelessWidget {
  const _SignalBars({required this.strength});

  final int strength;

  @override
  Widget build(BuildContext context) {
    final Color tone = strength >= 3
        ? AppColors.success
        : strength >= 1
        ? AppColors.warning
        : AppColors.danger;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        final bool active = i < strength;
        return Container(
          width: 4,
          height: 8.0 + i * 4,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: active ? tone : AppColors.stroke,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
