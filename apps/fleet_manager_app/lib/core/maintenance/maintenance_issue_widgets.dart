import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

const List<MaintenanceFleetStatus> reportStatusOrder = [
  MaintenanceFleetStatus.available,
  MaintenanceFleetStatus.awaitingParts,
  MaintenanceFleetStatus.broken,
  MaintenanceFleetStatus.maintenance,
];

String fleetConditionLabel(AppL10n l10n, MaintenanceFleetStatus status) => switch (status) {
  MaintenanceFleetStatus.available => l10n.reportStatusReadyForAllotment,
  MaintenanceFleetStatus.awaitingParts => l10n.reportStatusMechanicallyOk,
  MaintenanceFleetStatus.broken => l10n.reportStatusUnderRepairMajor,
  MaintenanceFleetStatus.maintenance => l10n.reportStatusUnderRepairMinor,
};

StatusTone fleetConditionTone(MaintenanceFleetStatus status) => switch (status) {
  MaintenanceFleetStatus.available => StatusTone.success,
  MaintenanceFleetStatus.maintenance => StatusTone.warning,
  MaintenanceFleetStatus.broken => StatusTone.danger,
  MaintenanceFleetStatus.awaitingParts => StatusTone.info,
};

IconData fleetConditionIcon(MaintenanceFleetStatus status) => switch (status) {
  MaintenanceFleetStatus.available => Icons.check_circle_rounded,
  MaintenanceFleetStatus.maintenance => Icons.build_circle_rounded,
  MaintenanceFleetStatus.broken => Icons.car_repair_rounded,
  MaintenanceFleetStatus.awaitingParts => Icons.inventory_2_rounded,
};

String issueCategoryLabel(AppL10n l10n, MaintenanceIssueCategory category) => switch (category) {
  MaintenanceIssueCategory.powertrain => l10n.issueCategoryPowertrain,
  MaintenanceIssueCategory.battery => l10n.issueCategoryBattery,
  MaintenanceIssueCategory.electrical => l10n.issueCategoryElectrical,
  MaintenanceIssueCategory.brakes => l10n.issueCategoryBrakes,
  MaintenanceIssueCategory.tyresWheels => l10n.issueCategoryTyresWheels,
  MaintenanceIssueCategory.suspensionSteering => l10n.issueCategorySuspensionSteering,
  MaintenanceIssueCategory.bodyChassis => l10n.issueCategoryBodyChassis,
  MaintenanceIssueCategory.accessories => l10n.issueCategoryAccessories,
  MaintenanceIssueCategory.other => l10n.issueCategoryOther,
};

IconData issueCategoryIcon(MaintenanceIssueCategory category) => switch (category) {
  MaintenanceIssueCategory.powertrain => Icons.settings_rounded,
  MaintenanceIssueCategory.battery => Icons.battery_alert_rounded,
  MaintenanceIssueCategory.electrical => Icons.electrical_services_rounded,
  MaintenanceIssueCategory.brakes => Icons.album_rounded,
  MaintenanceIssueCategory.tyresWheels => Icons.trip_origin_rounded,
  MaintenanceIssueCategory.suspensionSteering => Icons.swap_vert_rounded,
  MaintenanceIssueCategory.bodyChassis => Icons.electric_moped_rounded,
  MaintenanceIssueCategory.accessories => Icons.extension_rounded,
  MaintenanceIssueCategory.other => Icons.build_rounded,
};

String issueStatusLabel(AppL10n l10n, MaintenanceIssueStatus status) => switch (status) {
  MaintenanceIssueStatus.open => l10n.issueStatusOpen,
  MaintenanceIssueStatus.inProgress => l10n.issueStatusInProgress,
  MaintenanceIssueStatus.resolved => l10n.issueStatusResolved,
};

StatusTone issueStatusTone(MaintenanceIssueStatus status) => switch (status) {
  MaintenanceIssueStatus.open => StatusTone.danger,
  MaintenanceIssueStatus.inProgress => StatusTone.warning,
  MaintenanceIssueStatus.resolved => StatusTone.success,
};

class MaintenanceIssueRow extends StatelessWidget {
  const MaintenanceIssueRow({
    required this.category,
    required this.description,
    required this.status,
    required this.photoCount,
    this.requiredParts,
    this.charge,
    this.onTap,
    this.onRemove,
    super.key,
  });

  final MaintenanceIssueCategory category;
  final String description;
  final MaintenanceIssueStatus status;
  final int photoCount;
  final String? requiredParts;
  final String? charge;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? parts = requiredParts;
    final String? charge = this.charge;
    final VoidCallback? remove = onRemove;
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: issueCategoryIcon(category), tone: AppColors.primary, size: 34),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        issueCategoryLabel(l10n, category),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleSmall.copyWith(fontSize: 13.5),
                      ),
                    ),
                    const SizedBox(width: Insets.sm),
                    StatusChip(label: issueStatusLabel(l10n, status), tone: issueStatusTone(status), dense: true),
                  ],
                ),
                const SizedBox(height: 2),
                Text(description, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.4)),
                if (parts != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.submissionIssuePartsLine(parts),
                    style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
                if (charge != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.receipt_long_rounded, size: 13, color: AppColors.primary),
                      const SizedBox(width: Insets.xs),
                      Flexible(
                        child: Text(charge, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.primary)),
                      ),
                    ],
                  ),
                ],
                if (photoCount > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.maintenancePhotoCount(photoCount),
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
          if (remove != null)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              color: AppColors.textMuted,
              visualDensity: VisualDensity.compact,
              onPressed: remove,
            ),
        ],
      ),
    );
    final VoidCallback? tap = onTap;
    return tap == null ? row : Pressable(onTap: tap, scale: 0.99, child: row);
  }
}
