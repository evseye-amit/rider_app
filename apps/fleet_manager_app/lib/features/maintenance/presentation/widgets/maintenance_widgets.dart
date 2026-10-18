import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
  'OUT_OF_SERVICE' => l10n.fleetStatusOutOfService,
  _ => _spaced(status),
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

class ReportVerdictChip extends StatelessWidget {
  const ReportVerdictChip({required this.report, super.key});

  final MechanicReport? report;

  @override
  Widget build(BuildContext context) {
    final MechanicReport? current = report;
    if (current == null) {
      return StatusChip(label: context.l10n.maintenanceAwaitingReport, tone: StatusTone.neutral, dense: true);
    }
    return current.safeForReuse
        ? StatusChip(label: context.l10n.maintenanceSafeToReuse, tone: StatusTone.success, dense: true)
        : StatusChip(label: context.l10n.maintenanceNotSafe, tone: StatusTone.danger, dense: true);
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
    final MechanicReport? report = vehicle.latestReport;
    final MaintenanceMove? moved = vehicle.movedToMaintenance;
    final MaintenanceHub? hub = vehicle.hub;
    final num? km = vehicle.odometerKm;
    final String model = vehicle.modelLine;

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
                      const SizedBox(height: 2),
                      Text(
                        model.isEmpty ? vehicle.fleetCode : model,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Insets.sm),
                ReportVerdictChip(report: report),
              ],
            ),
            const Gap.md(),
            Wrap(
              spacing: Insets.lg,
              runSpacing: Insets.xs,
              children: [
                MaintenanceFact(icon: Icons.tag_rounded, text: vehicle.fleetCode),
                if (hub != null) MaintenanceFact(icon: Icons.hub_rounded, text: hub.name),
                if (km != null) MaintenanceFact(icon: Icons.speed_rounded, text: '${Fmt.number(km)} km'),
              ],
            ),
            if (moved != null) ...[
              const Gap.sm(),
              MaintenanceFact(icon: Icons.history_rounded, text: context.l10n.maintenanceMovedOn(Fmt.date(moved.at))),
            ],
            if (report != null) ...[
              const Gap.md(),
              Container(
                padding: const EdgeInsets.all(Insets.md),
                decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reportStageLabel(context.l10n, report),
                            style: AppText.titleSmall.copyWith(fontSize: 13),
                          ),
                        ),
                        Text(
                          Fmt.date(report.createdAt),
                          style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    if (report.summary.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        report.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                      ),
                    ],
                    if (report.mechanicName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.submissionReportBy(report.mechanicName),
                        style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
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
    final DateTime? confirmedAt = report.confirmedAt;
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reportStageLabel(context.l10n, report), style: AppText.titleSmall.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (report.mechanicName.isNotEmpty) context.l10n.submissionReportBy(report.mechanicName),
                      Fmt.dateTime(report.createdAt),
                    ].join(' · '),
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            ReportVerdictChip(report: report),
          ],
        ),
        if (report.summary.isNotEmpty) ...[
          const Gap.md(),
          Text(report.summary, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.5)),
        ],
        if (!report.safeForReuse) ...[
          const Gap.md(),
          AccentCard(
            accent: AppColors.danger,
            child: Text(
              context.l10n.checkInUnsafe(report.unsafeReason ?? '—'),
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.danger),
            ),
          ),
        ],
        const Gap.md(),
        MaintenanceFact(
          icon: report.checksComplete ? Icons.task_alt_rounded : Icons.pending_actions_rounded,
          text: report.checksComplete ? context.l10n.submissionChecksComplete : context.l10n.maintenanceChecksOpen,
          color: report.checksComplete ? AppColors.success : AppColors.warning,
        ),
        if (confirmedAt != null) ...[
          const Gap.xs(),
          MaintenanceFact(
            icon: Icons.verified_rounded,
            text: context.l10n.maintenanceConfirmedOn(Fmt.dateTime(confirmedAt)),
          ),
        ],
        if (report.evidencePhotoIds.isNotEmpty) ...[
          const Gap.xs(),
          MaintenanceFact(
            icon: Icons.photo_library_rounded,
            text: context.l10n.maintenancePhotoCount(report.evidencePhotoIds.length),
          ),
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
    final String to = fleetStatusLabel(l10n, change.to);

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
                    from == null ? to : '${fleetStatusLabel(l10n, from)} → $to',
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  if (reason != null) ...[
                    const SizedBox(height: 2),
                    Text(reason, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4)),
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
