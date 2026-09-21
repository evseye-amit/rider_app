import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/usecases/allocate_vehicle.dart';
import '../../domain/usecases/get_eligible_fleets.dart';
import '../../domain/usecases/get_pending_rider.dart';
import '../cubit/assign_vehicle_cubit.dart';
import '../widgets/allocation_widgets.dart';

class AssignVehiclePage extends StatelessWidget {
  const AssignVehiclePage({required this.riderId, super.key});

  final String riderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssignVehicleCubit(
        riderId: riderId,
        getPendingRider: GetPendingRider(sl()),
        getEligibleFleets: GetEligibleFleets(sl()),
        allocateVehicle: AllocateVehicle(sl()),
      )..load(),
      child: const _AssignVehicleView(),
    );
  }
}

class _AssignVehicleView extends StatefulWidget {
  const _AssignVehicleView();

  @override
  State<_AssignVehicleView> createState() => _AssignVehicleViewState();
}

class _AssignVehicleViewState extends State<_AssignVehicleView> {
  String? _selectedId;
  int _hubFilter = 0;

  Future<void> _allocate(BuildContext context, AssignVehicleState state, EligibleFleet vehicle) async {
    final PendingRider rider = state.rider!;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Reserve ${vehicle.vehicleNumber}?',
      message: '${vehicle.vehicleNumber} will be reserved for ${rider.name}. The handover — vehicle request, '
          'payment, inspection, training and pairing — then runs from the allocation desk.',
      confirmLabel: 'Allocate vehicle',
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;

    final AssignVehicleCubit cubit = context.read<AssignVehicleCubit>();
    final bool ok = await cubit.allocate(vehicle.id);
    if (!context.mounted) return;
    if (ok) {
      final DeploymentAllocation allocation = cubit.state.allocation!;
      context.go(
        '${Routes.allocationDone}?rider=${Uri.encodeComponent(rider.name)}'
        '&vehicle=${Uri.encodeComponent(vehicle.vehicleNumber)}&id=${allocation.id}',
      );
    } else {
      AppSnack.error(context, cubit.state.message ?? 'Could not allocate the vehicle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignVehicleCubit, AssignVehicleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: PageBody(children: const [
                ShimmerBox(height: 46, borderRadius: Corners.pill),
                Gap.xl(),
                ShimmerBox(height: 150, borderRadius: Corners.brLg),
                Gap.md(),
                ShimmerBox(height: 150, borderRadius: Corners.brLg),
              ]),
            ),
          );
        }
        if (state.status == AssignVehicleStatus.failure || state.rider == null) {
          return AppScaffold(
            title: 'Assign a vehicle',
            body: EmptyState(
              title: 'Could not load available vehicles',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: () => context.read<AssignVehicleCubit>().load(),
            ),
          );
        }

        final List<String> hubs = ['All hubs', ...{for (final v in state.vehicles) v.hubName ?? '—'}.toList()..sort()];
        final int hubFilter = _hubFilter.clamp(0, hubs.length - 1);
        final List<EligibleFleet> filtered = state.vehicles
            .where((v) => hubFilter == 0 || (v.hubName ?? '—') == hubs[hubFilter])
            .toList(growable: false);
        final EligibleFleet? selected = state.vehicles.where((v) => v.id == _selectedId).firstOrNull;

        return HeroScaffold(
          bandColor: AppColors.ink,
          bottomPadding: 130,
          band: _Band(rider: state.rider!),
          bottomNavigationBar: _Footer(
            selected: selected,
            busy: state.isAllocating,
            onContinue: selected == null || state.isAllocating ? null : () => _allocate(context, state, selected),
          ),
          children: [
            OverlapModuleCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilterChipBar(
                    items: hubs,
                    selectedIndex: hubFilter,
                    onChanged: (i) => setState(() => _hubFilter = i),
                    padding: EdgeInsets.zero,
                  ),
                  const Gap.md(),
                  Text(
                    '${state.vehicles.length} vehicle${state.vehicles.length == 1 ? '' : 's'} ready in your hubs',
                    style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Gap.lg(),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: Insets.lg),
                child: ArtBlock(
                  art: BrandArt.empty,
                  artSize: 130,
                  title: 'No vehicles ready',
                  message: 'A vehicle has to be available, onboarded and allocation-enabled in one of your hubs to appear here.',
                ),
              )
            else
              Column(
                children: [
                  for (final v in filtered) ...[
                    _VehicleOptionCard(
                      vehicle: v,
                      selected: v.id == _selectedId,
                      onTap: () => setState(() => _selectedId = v.id),
                    ),
                    if (v != filtered.last) const Gap.md(),
                  ],
                ],
              ),
          ],
        );
      },
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.rider});

  final PendingRider rider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) => InkCircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        const Gap.lg(),
        PhotoPanel(
          photo: BrandPhoto.fleet,
          height: 132,
          title: 'Assign a vehicle',
          subtitle: 'For ${rider.name}${(rider.riderCode ?? '').isEmpty ? '' : ' · ${rider.riderCode}'} · ${Fmt.phone(rider.mobile)}',
        ),
      ],
    );
  }
}

class _VehicleOptionCard extends StatelessWidget {
  const _VehicleOptionCard({required this.vehicle, required this.selected, required this.onTap});

  final EligibleFleet vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool deviceOk = vehicle.hasDevice && vehicle.heartbeatFresh;
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.washFor(AppColors.primary) : AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: selected ? 1.6 : 1),
          boxShadow: selected ? Shadows.lift(AppColors.primary, opacity: 0.16, blur: 18) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const PhotoThumb(photo: BrandPhoto.fleet, size: 44),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.vehicleNumber, style: AppText.titleMedium.copyWith(fontSize: 15.5, letterSpacing: 0.3)),
                      const SizedBox(height: 2),
                      Text('${vehicle.fleetCode} · ${vehicle.hubName ?? '—'}', style: AppText.bodySmall.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: Motion.fast,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: 1.6),
                  ),
                  child: selected ? const Icon(Icons.check_rounded, size: 15, color: Colors.white) : null,
                ),
              ],
            ),
            const SizedBox(height: Insets.md),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                StatusChip(
                  label: vehicle.hasDevice ? 'IoT ${vehicle.iotDeviceNumber}' : 'No IoT device',
                  tone: vehicle.hasDevice ? StatusTone.brand : StatusTone.warning,
                  icon: Icons.sensors_rounded,
                  dense: true,
                ),
                StatusChip(
                  label: deviceOk
                      ? 'Online ${Fmt.relative(vehicle.iotLastHeartbeatAt!)}'
                      : vehicle.hasDevice
                          ? 'Heartbeat stale'
                          : 'Map a device first',
                  tone: deviceOk ? StatusTone.success : StatusTone.warning,
                  dense: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.selected, required this.busy, required this.onContinue});

  final EligibleFleet? selected;
  final bool busy;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, MediaQuery.paddingOf(context).bottom + Insets.md),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: PrimaryButton(
        label: selected == null ? 'Select a vehicle' : 'Allocate ${selected!.vehicleNumber}',
        icon: Icons.swap_horiz_rounded,
        loading: busy,
        onPressed: onContinue,
      ),
    );
  }
}
