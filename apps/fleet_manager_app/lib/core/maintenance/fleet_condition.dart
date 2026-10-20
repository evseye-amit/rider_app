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

String fleetConditionHint(AppL10n l10n, MaintenanceFleetStatus status) => switch (status) {
  MaintenanceFleetStatus.available => l10n.submissionStatusAvailableHint,
  MaintenanceFleetStatus.maintenance => l10n.submissionStatusMaintenanceHint,
  MaintenanceFleetStatus.broken => l10n.submissionStatusBrokenHint,
  MaintenanceFleetStatus.awaitingParts => l10n.submissionStatusAwaitingPartsHint,
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
