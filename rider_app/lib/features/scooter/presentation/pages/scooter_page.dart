import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/usecases/get_vehicle.dart';
import '../cubit/scooter_cubit.dart';
import '../widgets/scooter_widgets.dart';

class ScooterPage extends StatelessWidget {
  const ScooterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScooterCubit(GetVehicle(sl()))..load(),
      child: const _ScooterView(),
    );
  }
}

class _ScooterView extends StatelessWidget {
  const _ScooterView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScooterCubit, ScooterState>(
      builder: (context, state) {
        if (state.status == ScooterStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: EmptyState(
                title: 'Could not load your vehicle',
                message: state.message,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: 'Try again',
                onAction: () => context.read<ScooterCubit>().refresh(),
              ),
            ),
          );
        }

        final Vehicle? vehicle = state.vehicle;

        return HeroScaffold(
          bottomPadding: 120,
          onRefresh: () => context.read<ScooterCubit>().refresh(),
          band: VehicleBand(vehicle: vehicle),
          children: vehicle == null
              ? const [_ScooterSkeleton()]
              : _content(context, vehicle),
        );
      },
    );
  }

  List<Widget> _content(BuildContext context, Vehicle vehicle) {
    return [
      _VehicleCard(vehicle: vehicle),
      const Gap.lg(),

      ModuleCard(
        title: 'IoT unit',
        child: IotPanel(vehicle: vehicle),
      ),
    ];
  }
}

class _ScooterSkeleton extends StatelessWidget {
  const _ScooterSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
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
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.card,
      ),
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
                  label: vehicle.charging ? 'Charging' : 'On road',
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
                  style: AppText.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
