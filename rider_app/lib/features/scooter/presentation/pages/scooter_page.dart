import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../widgets/scooter_widgets.dart';
import 'scooter_details_page.dart';

class ScooterPage extends ConsumerWidget {
  const ScooterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Vehicle> vehicle = ref.watch(vehicleProvider);

    if (vehicle.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.scooterCouldNotLoadVehicle,
            message: vehicle.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(vehicleProvider),
          ),
        ),
      );
    }

    final Vehicle? data = vehicle.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.refreshQuietly(vehicleProvider),
      band: VehicleBand(vehicle: data),
      children: data == null
          ? const [_ScooterSkeleton()]
          : [
              _VehicleCard(vehicle: data),
              const Gap.lg(),
              ModuleCard(
                title: context.l10n.commonIotUnit,
                child: IotPanel(vehicle: data),
              ),
            ],
    );
  }
}

class _ScooterSkeleton extends StatelessWidget {
  const _ScooterSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 116, borderRadius: Corners.brXl),
        Gap.xxl(),
        ShimmerBox(height: 200, borderRadius: Corners.brXl),
      ],
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => ScooterDetailsPage.open(context, vehicle),
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.card),
        child: Row(
          children: [
            const BrandIllustration(art: BrandArt.scooter, size: 84),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusChip(
                    label: vehicle.charging ? context.l10n.scooterCharging : context.l10n.allocationRoad,
                    tone: vehicle.charging ? StatusTone.info : StatusTone.success,
                    dense: true,
                  ),
                  const SizedBox(height: Insets.sm + 2),
                  Text(
                    vehicle.vehicleNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleLarge.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    vehicle.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5),
                  ),
                  Text(
                    vehicle.colour,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: Insets.sm),
                  Row(
                    children: [
                      Text(
                        context.l10n.scooterViewFullDetails,
                        style: AppText.bodySmall.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
