import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/maintenance/fleet_condition.dart';
import '../../domain/entities/maintenance_vehicle.dart';
import '../providers/maintenance_providers.dart';

String fleetStatusLabel(AppL10n l10n, String status) => switch (status.toUpperCase()) {
  'IN_TRANSIT' => l10n.fleetStatusInTransit,
  'AVAILABLE' => l10n.fleetStatusAvailable,
  'RESERVED' => l10n.fleetStatusReserved,
  'ALLOCATION_IN_PROGRESS' => l10n.fleetStatusAllocating,
  'ALLOCATED' => l10n.fleetStatusAllocated,
  'IN_USE' => l10n.fleetStatusInUse,
  'DEALLOCATION_IN_PROGRESS' => l10n.fleetStatusReturning,
  'INSPECTION_PENDING' => l10n.fleetStatusInspectionPending,
  'MAINTENANCE' => l10n.fleetStatusMaintenance,
  'BROKEN' => l10n.fleetStatusBroken,
  'AWAITING_PARTS' => l10n.fleetStatusAwaitingParts,
  'OUT_OF_SERVICE' => l10n.fleetStatusOutOfService,
  _ => _spaced(status),
};

String serviceStatusLabel(AppL10n l10n, String status) => switch (MaintenanceFleetStatus.maybe(status)) {
  final MaintenanceFleetStatus condition => fleetConditionLabel(l10n, condition),
  null => fleetStatusLabel(l10n, status),
};

String onboardingStatusLabel(AppL10n l10n, String status) => switch (status.toUpperCase()) {
  'DRAFT' => l10n.fleetOnboardingDraft,
  'IN_PROGRESS' => l10n.fleetOnboardingInProgress,
  'PENDING_REVIEW' => l10n.fleetOnboardingPendingReview,
  'ACTIVE' => l10n.fleetOnboardingActive,
  'REJECTED' => l10n.fleetOnboardingRejected,
  'ARCHIVED' => l10n.fleetOnboardingArchived,
  _ => _spaced(status),
};

String reportStageLabel(AppL10n l10n, MechanicReport report) =>
    report.deep ? l10n.checkInDeepReport : l10n.checkInBasicReport;

String _spaced(String code) {
  final String spaced = code.replaceAll('_', ' ').toLowerCase().trim();
  return spaced.isEmpty ? '—' : '${spaced[0].toUpperCase()}${spaced.substring(1)}';
}

class FleetConditionChip extends StatelessWidget {
  const FleetConditionChip({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final MaintenanceFleetStatus? condition = MaintenanceFleetStatus.maybe(status);
    return StatusChip(
      label: serviceStatusLabel(context.l10n, status),
      tone: condition == null ? StatusTone.warning : fleetConditionTone(condition),
      dense: true,
    );
  }
}

class MaintenanceFact extends StatelessWidget {
  const MaintenanceFact({required this.icon, required this.text, this.color, super.key});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppColors.textMuted),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: color),
          ),
        ),
      ],
    );
  }
}

class MaintenanceVehicleCard extends StatelessWidget {
  const MaintenanceVehicleCard({required this.vehicle, required this.onTap, super.key});

  final MaintenanceVehicle vehicle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final MechanicReport? report = vehicle.latestReport;
    final MaintenanceMove? moved = vehicle.movedToMaintenance;
    final String model = vehicle.modelLine;
    final String subtitle = model.isNotEmpty || vehicle.fleetCode == vehicle.vehicleNumber ? model : vehicle.fleetCode;
    final String? needsWork = report == null || report.safeForReuse ? null : report.unsafeReason;
    final String? findings = report == null || report.summary.isEmpty ? null : report.summary;
    final (String, String)? note = needsWork != null
        ? (l10n.submissionMaintenanceDetails, needsWork)
        : findings != null
        ? (l10n.submissionSummary, findings)
        : null;
    final List<Widget> footer = [
      if (report != null && report.mechanicName.isNotEmpty)
        KeyValueRow(label: l10n.maintenanceReportMechanic, value: report.mechanicName, dense: true),
      if (moved != null) KeyValueRow(label: l10n.maintenanceInServiceSince, value: Fmt.date(moved.at), dense: true),
      if (report == null)
        Text(
          l10n.maintenanceNoReportYet,
          style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.textSecondary),
        ),
    ];

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brLg, boxShadow: Shadows.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const IconTile(icon: Icons.electric_scooter_rounded, tone: AppColors.primary, size: 42),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle.vehicleNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 16),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Insets.sm),
                FleetConditionChip(status: vehicle.status),
              ],
            ),
            if (note case (final String label, final String body)) ...[
              const Gap.md(),
              Text(label, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.45),
              ),
            ],
            if (footer.isNotEmpty) ...[
              Divider(height: Insets.xl, color: AppColors.stroke.withValues(alpha: 0.6)),
              ...footer,
            ],
          ],
        ),
      ),
    );
  }
}

class MechanicReportView extends StatelessWidget {
  const MechanicReportView({required this.report, super.key});

  final MechanicReport report;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? confirmedAt = report.confirmedAt;
    final MaintenanceFleetStatus? status = report.fleetStatus;
    final String? needsWork = report.safeForReuse ? null : report.unsafeReason;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconTile(
              icon: report.deep ? Icons.fact_check_rounded : Icons.build_circle_rounded,
              tone: AppColors.primary,
              size: 36,
            ),
            const SizedBox(width: Insets.md),
            Expanded(child: Text(reportStageLabel(l10n, report), style: AppText.titleSmall.copyWith(fontSize: 14))),
          ],
        ),
        const Gap.sm(),
        KeyValueRow(
          label: l10n.maintenanceReportStatus,
          value: status == null
              ? (report.safeForReuse ? l10n.maintenanceSafeToReuse : l10n.maintenanceNotSafe)
              : fleetConditionLabel(l10n, status),
          valueColor: status == null
              ? (report.safeForReuse ? AppColors.success : AppColors.danger)
              : fleetConditionTone(status).color,
          dense: true,
        ),
        if (report.mechanicName.isNotEmpty)
          KeyValueRow(label: l10n.maintenanceReportMechanic, value: report.mechanicName, dense: true),
        KeyValueRow(label: l10n.maintenanceReportRecorded, value: Fmt.dateTime(report.createdAt), dense: true),
        if (confirmedAt != null)
          KeyValueRow(label: l10n.maintenanceReportConfirmed, value: Fmt.dateTime(confirmedAt), dense: true),
        if (report.evidencePhotoIds.isNotEmpty)
          KeyValueRow(label: l10n.maintenanceReportPhotos, value: '${report.evidencePhotoIds.length}', dense: true),
        if (!report.checksComplete) ...[
          const Gap.xs(),
          MaintenanceFact(
            icon: Icons.pending_actions_rounded,
            text: l10n.maintenanceChecksOpen,
            color: AppColors.warning,
          ),
        ],
        if (report.summary.isNotEmpty) ...[
          const Gap.md(),
          GroupLabel(l10n.submissionSummary),
          const Gap.xs(),
          Text(report.summary, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.5)),
        ],
        if (needsWork != null) ...[
          const Gap.md(),
          GroupLabel(l10n.submissionMaintenanceDetails),
          const Gap.xs(),
          Text(needsWork, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.5)),
        ],
      ],
    );
  }
}

class StatusTimeline extends StatelessWidget {
  const StatusTimeline({required this.changes, super.key});

  final List<MaintenanceStatusChange> changes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < changes.length; i++)
          _TimelineRow(change: changes[i], first: i == 0, last: i == changes.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.change, required this.first, required this.last});

  final MaintenanceStatusChange change;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? from = change.from;
    final String? reason = change.reason;
    final Color tone = change.to.toUpperCase() == 'MAINTENANCE' ? AppColors.warning : AppColors.primary;
    final String to = serviceStatusLabel(l10n, change.to);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(width: 2, height: 5, color: first ? Colors.transparent : AppColors.stroke),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: first ? tone : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: tone, width: 2),
                  ),
                ),
                Expanded(child: Container(width: 2, color: last ? Colors.transparent : AppColors.stroke)),
              ],
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : Insets.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    from == null ? to : '${serviceStatusLabel(l10n, from)} → $to',
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  if (reason != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      change.fromReport ? l10n.maintenanceReasonFromReport(reason) : l10n.maintenanceReasonLine(reason),
                      style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    Fmt.dateTime(change.at),
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EvidencePhotoGrid extends StatelessWidget {
  const EvidencePhotoGrid({required this.photos, super.key});

  final List<EvidencePhoto> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: Insets.sm,
      crossAxisSpacing: Insets.sm,
      children: [for (final EvidencePhoto photo in photos) _EvidenceTile(photo: photo)],
    );
  }
}

class _EvidenceTile extends ConsumerWidget {
  const _EvidenceTile({required this.photo});

  final EvidencePhoto photo;

  Future<void> _open(BuildContext context, String? url) async {
    if (url == null) {
      AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
      return;
    }
    if (photo.isImage) return PhotoViewer.show(context, url);
    final bool opened = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> url = ref.watch(evidencePhotoUrlProvider(photo.id));
    final String? link = url.value;
    final Widget content = link == null
        ? (url.hasError ? const _TileIcon(icon: Icons.image_not_supported_rounded) : const _TileSpinner())
        : photo.isImage
        ? Image.network(
            link,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) => progress == null ? child : const _TileSpinner(),
            errorBuilder: (_, _, _) => const _TileIcon(icon: Icons.image_not_supported_rounded),
          )
        : const _TileIcon(icon: Icons.description_rounded);

    return Pressable(
      onTap: url.isLoading ? null : () => _open(context, link),
      scale: 0.97,
      child: ClipRRect(
        borderRadius: Corners.brMd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surfaceMuted),
            content,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 14, 6, 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                  ),
                ),
                child: Text(
                  submissionPhotoLabel(context.l10n, photo.photoType),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(child: Icon(icon, color: AppColors.textMuted));
}

class _TileSpinner extends StatelessWidget {
  const _TileSpinner();

  @override
  Widget build(BuildContext context) => const Center(
    child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
  );
}
