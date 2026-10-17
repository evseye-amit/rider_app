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
            const IconTile(icon: Icons.electric_scooter_rounded, tone: AppColors.primary, solid: true, size: 44),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.commonScooter,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    v?.vehicleNumber ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(fontSize: 20, color: AppColors.onInk),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            StatusChip(
              label: v == null ? '—' : (v.iot.online ? context.l10n.scooterIotOnline : context.l10n.scooterIotOffline),
              tone: v == null ? StatusTone.neutral : (v.iot.online ? StatusTone.success : StatusTone.danger),
              solid: true,
              dense: true,
            ),
          ],
        ),
        const Gap.xxl(),
        Text(context.l10n.scooterBatteryCharge, style: AppText.label.copyWith(color: AppColors.onInkSecondary)),
        const Gap.sm(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$battery%', style: AppText.numericLarge.copyWith(fontSize: 38, color: AppColors.onInk)),
            if (v?.charging ?? false) ...[
              const SizedBox(width: Insets.md),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: batteryTone.withValues(alpha: 0.18), borderRadius: Corners.pill),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 12, color: batteryTone),
                      const SizedBox(width: 3),
                      Text(
                        context.l10n.scooterCharging,
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
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkStat(
                  label: context.l10n.scooterRange,
                  value: v == null ? '—' : Fmt.distanceKm(v.rangeKm),
                  icon: Icons.near_me_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.scooterHealth,
                  value: v == null ? '—' : '${v.healthPercent}%',
                  icon: Icons.monitor_heart_rounded,
                ),
              ),
              const InkDivider(),
              const SizedBox(width: Insets.md),
              Expanded(
                child: InkStat(
                  label: context.l10n.scooterNextService,
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
