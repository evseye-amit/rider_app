import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../allocation_dependencies.dart';
import '../../domain/usecases/allocate_vehicle.dart';
import '../providers/assign_vehicle_options_provider.dart';
import '../widgets/allocation_widgets.dart';

class AssignVehiclePage extends ConsumerStatefulWidget {
  const AssignVehiclePage({required this.riderId, super.key});

  final String riderId;

  @override
  ConsumerState<AssignVehiclePage> createState() => _AssignVehiclePageState();
}

class _AssignVehiclePageState extends ConsumerState<AssignVehiclePage> {
  String? _selectedId;
  int _hubFilter = 0;
  bool _allocating = false;

  Future<void> _allocate(PendingRider rider, EligibleFleet vehicle) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Reserve ${vehicle.vehicleNumber}?',
      message:
          '${vehicle.vehicleNumber} will be reserved for ${rider.name}. The handover — vehicle request, '
          'payment, inspection, training and pairing — then runs from the allocation desk.',
      confirmLabel: context.l10n.allocationAllocateVehicle,
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !mounted) return;

    setState(() => _allocating = true);
    final Result<DeploymentAllocation> result = await ref.read(allocateVehicleProvider)(
      AllocateParams(riderId: widget.riderId, fleetId: vehicle.id),
    );
    if (!mounted) return;
    setState(() => _allocating = false);

    switch (result) {
      case Ok<DeploymentAllocation>(:final value):
        context.go(
          '${Routes.allocationDone}?rider=${Uri.encodeComponent(rider.name)}'
          '&vehicle=${Uri.encodeComponent(vehicle.vehicleNumber)}&id=${value.id}',
        );
      case Err<DeploymentAllocation>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AssignVehicleOptions> options = ref.watch(assignVehicleOptionsProvider(widget.riderId));

    if (options.isLoading && !options.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: PageBody(
            children: [
              ShimmerBox(height: 46, borderRadius: Corners.pill),
              Gap.xl(),
              ShimmerBox(height: 150, borderRadius: Corners.brLg),
              Gap.md(),
              ShimmerBox(height: 150, borderRadius: Corners.brLg),
            ],
          ),
        ),
      );
    }

    final AssignVehicleOptions? data = options.value;
    if (options.hasError || data == null) {
      return AppScaffold(
        title: context.l10n.allocationAssignVehicle,
        body: EmptyState(
          title: context.l10n.allocationCouldNotLoadAvailableVehicles,
          message: options.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(assignVehicleOptionsProvider(widget.riderId)),
        ),
      );
    }

    final List<String> hubs = [
      context.l10n.allocationAllHubs,
      ...{for (final EligibleFleet vehicle in data.vehicles) vehicle.hubName ?? '—'}.toList()..sort(),
    ];
    final int hubFilter = _hubFilter.clamp(0, hubs.length - 1);
    final List<EligibleFleet> filtered = data.vehicles
        .where((vehicle) => hubFilter == 0 || (vehicle.hubName ?? '—') == hubs[hubFilter])
        .toList(growable: false);
    final EligibleFleet? selected = data.vehicles.where((vehicle) => vehicle.id == _selectedId).firstOrNull;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 130,
      band: _Band(rider: data.rider),
      bottomNavigationBar: _Footer(
        selected: selected,
        busy: _allocating,
        onContinue: selected == null || _allocating ? null : () => _allocate(data.rider, selected),
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
                '${data.vehicles.length} vehicle${data.vehicles.length == 1 ? '' : 's'} ready in your hubs',
                style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const Gap.lg(),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.lg),
            child: ArtBlock(
              art: BrandArt.empty,
              artSize: 130,
              title: context.l10n.allocationNoVehiclesReady,
              message: context.l10n.allocationVehicleHasAvailableOnboardedAllocation,
            ),
          )
        else
          Column(
            children: [
              for (final EligibleFleet vehicle in filtered) ...[
                _VehicleOptionCard(
                  vehicle: vehicle,
                  selected: vehicle.id == _selectedId,
                  onTap: () => setState(() => _selectedId = vehicle.id),
                ),
                if (vehicle != filtered.last) const Gap.md(),
              ],
            ],
          ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.rider});

  final PendingRider rider;

  @override
  Widget build(BuildContext context) {
    final String riderCode = (rider.riderCode ?? '').isEmpty ? '' : ' · ${rider.riderCode}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) =>
              InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
        ),
        const Gap.lg(),
        PhotoPanel(
          photo: BrandPhoto.fleet,
          height: 132,
          title: context.l10n.allocationAssignVehicle,
          subtitle: 'For ${rider.name}$riderCode · ${Fmt.phone(rider.mobile)}',
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
                      Text(
                        vehicle.vehicleNumber,
                        style: AppText.titleMedium.copyWith(fontSize: 15.5, letterSpacing: 0.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${vehicle.fleetCode} · ${vehicle.hubName ?? '—'}',
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
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
                  label: vehicle.hasDevice ? 'IoT ${vehicle.iotDeviceNumber}' : context.l10n.allocationNoIotDevice,
                  tone: vehicle.hasDevice ? StatusTone.brand : StatusTone.warning,
                  icon: Icons.sensors_rounded,
                  dense: true,
                ),
                StatusChip(
                  label: deviceOk
                      ? 'Online ${Fmt.relative(vehicle.iotLastHeartbeatAt!)}'
                      : vehicle.hasDevice
                      ? context.l10n.allocationHeartbeatStale
                      : context.l10n.allocationMapDeviceFirst,
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
      padding: EdgeInsets.fromLTRB(
        Insets.gutter,
        Insets.md,
        Insets.gutter,
        MediaQuery.paddingOf(context).bottom + Insets.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: PrimaryButton(
        label: selected == null ? context.l10n.maintenanceSelectVehicle : 'Allocate ${selected!.vehicleNumber}',
        icon: Icons.swap_horiz_rounded,
        loading: busy,
        onPressed: onContinue,
      ),
    );
  }
}
