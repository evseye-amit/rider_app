import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../maintenance/presentation/widgets/maintenance_widgets.dart';

StatusTone fleetStatusTone(String status) => switch (status.toUpperCase()) {
  'AVAILABLE' => StatusTone.success,
  'ALLOCATED' || 'IN_USE' => StatusTone.info,
  'MAINTENANCE' || 'AWAITING_PARTS' => StatusTone.warning,
  'BROKEN' || 'OUT_OF_SERVICE' => StatusTone.danger,
  _ => StatusTone.neutral,
};

String allocationStateLabel(AppL10n l10n, String status) => switch (status) {
  'ACTIVE' => l10n.fleetSearchAllocationActive,
  'DEALLOCATION_INITIATED' => l10n.fleetSearchAllocationReturning,
  'COMPLETED' => l10n.fleetSearchAllocationReturned,
  'CANCELLED' => l10n.fleetSearchAllocationCancelled,
  _ => l10n.fleetSearchAllocationHandover,
};

StatusTone allocationStateTone(String status) => switch (status) {
  'ACTIVE' => StatusTone.success,
  'DEALLOCATION_INITIATED' => StatusTone.warning,
  'COMPLETED' => StatusTone.neutral,
  'CANCELLED' => StatusTone.danger,
  _ => StatusTone.info,
};

class ScooterResultTile extends StatelessWidget {
  const ScooterResultTile({required this.fleet, required this.onTap, super.key});

  final GlobalFleetDto fleet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String model = fleet.modelLine;
    final String? hub = fleet.hubName;

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brLg, boxShadow: Shadows.card),
        child: Row(
          children: [
            const IconTile(icon: Icons.electric_scooter_rounded, tone: AppColors.primary, size: 42),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fleet.vehicleNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleMedium.copyWith(fontSize: 16),
                  ),
                  if (model.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      model,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                  const Gap.sm(),
                  Wrap(
                    spacing: Insets.lg,
                    runSpacing: Insets.xs,
                    children: [
                      if (fleet.fleetCode.isNotEmpty) MaintenanceFact(icon: Icons.tag_rounded, text: fleet.fleetCode),
                      if (hub != null) MaintenanceFact(icon: Icons.hub_rounded, text: hub),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusChip(
                  label: fleetStatusLabel(l10n, fleet.status),
                  tone: fleetStatusTone(fleet.status),
                  dense: true,
                ),
                if (!fleet.canManage) ...[
                  const Gap.xs(),
                  StatusChip(
                    label: l10n.fleetSearchOtherHub,
                    icon: Icons.lock_outline_rounded,
                    showDot: false,
                    dense: true,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
