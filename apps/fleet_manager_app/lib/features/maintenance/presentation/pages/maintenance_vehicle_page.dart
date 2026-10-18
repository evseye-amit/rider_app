import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/maintenance_vehicle.dart';
import '../providers/maintenance_providers.dart';
import '../widgets/maintenance_widgets.dart';

class MaintenanceVehiclePage extends ConsumerWidget {
  const MaintenanceVehiclePage({required this.fleetId, super.key});

  final String fleetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MaintenanceVehicleDetail> detail = ref.watch(maintenanceVehicleProvider(fleetId));
    final MaintenanceVehicleDetail? data = detail.value;

    if (data == null && detail.hasError) {
      return AppScaffold(
        title: context.l10n.maintenanceVehicleTitle,
        body: EmptyState(
          title: context.l10n.maintenanceVehicleCouldNotLoad,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(maintenanceVehicleProvider(fleetId)),
        ),
      );
    }

    return HeroScaffold(
      onRefresh: () => ref.refreshQuietly(maintenanceVehicleProvider(fleetId)),
      band: _Band(vehicle: data?.vehicle),
      children: data == null ? const [_DetailSkeleton()] : _sections(context, data),
    );
  }

  List<Widget> _sections(BuildContext context, MaintenanceVehicleDetail data) {
    final AppL10n l10n = context.l10n;
    final MaintenanceVehicle vehicle = data.vehicle;
    final MechanicReport? latest = vehicle.latestReport;
    final List<MechanicReport> earlier = [
      for (final MechanicReport report in data.reports)
        if (report.id != latest?.id) report,
    ];

    return [
      ModuleCard(
        title: l10n.maintenanceLatestReport,
        child: latest == null
            ? _EmptyLine(icon: Icons.assignment_late_rounded, text: l10n.maintenanceNoReportYet)
            : MechanicReportView(report: latest),
      ),
      if (data.photos.isNotEmpty) ...[
        const Gap.lg(),
        ModuleCard(
          title: l10n.maintenanceEvidence,
          child: EvidencePhotoGrid(photos: data.photos),
        ),
      ],
      const Gap.lg(),
      ModuleCard(
        title: l10n.maintenanceVehicleDetails,
        child: _VehicleFacts(vehicle: vehicle),
      ),
      const Gap.lg(),
      ModuleCard(
        title: l10n.maintenanceHistory,
        child: data.history.isEmpty
            ? _EmptyLine(icon: Icons.history_toggle_off_rounded, text: l10n.maintenanceNoHistory)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatusTimeline(changes: data.history),
                  if (data.moreHistory) _LimitNote(text: l10n.maintenanceHistoryLimit(data.historyLimit)),
                ],
              ),
      ),
      if (earlier.isNotEmpty) ...[
        const Gap.lg(),
        ModuleCard(
          title: l10n.maintenanceEarlierReports,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final MechanicReport report in earlier) ...[
                Container(
                  padding: const EdgeInsets.all(Insets.md),
                  decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brLg),
                  child: MechanicReportView(report: report),
                ),
                if (report != earlier.last) const Gap.md(),
              ],
              if (data.moreReports) _LimitNote(text: l10n.maintenanceReportsLimit(data.reportLimit)),
            ],
          ),
        ),
      ],
    ];
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.vehicle});

  final MaintenanceVehicle? vehicle;

  @override
  Widget build(BuildContext context) {
    final MaintenanceVehicle? current = vehicle;
    final MaintenanceHub? hub = current?.hub;
    final MaintenanceMove? moved = current?.movedToMaintenance;
    final String? reason = moved?.reason;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
        const Gap.xl(),
        Text(
          current?.vehicleNumber ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.displaySmall.copyWith(fontSize: 26, color: AppColors.onInk),
        ),
        if (current != null && current.modelLine.isNotEmpty) ...[
          const Gap.xs(),
          Text(current.modelLine, style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary)),
        ],
        const Gap.lg(),
        Wrap(
          spacing: Insets.sm,
          runSpacing: Insets.sm,
          children: [
            _InkPill(icon: Icons.build_rounded, text: context.l10n.fleetStatusMaintenance, color: AppColors.onInkAmber),
            if (hub != null) _InkPill(icon: Icons.hub_rounded, text: hub.name),
            if (current != null && current.fleetCode.isNotEmpty)
              _InkPill(icon: Icons.tag_rounded, text: current.fleetCode),
          ],
        ),
        if (moved != null) ...[
          const Gap.md(),
          Text(
            [context.l10n.maintenanceMovedOn(Fmt.dateTime(moved.at)), ?reason].join(' · '),
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.onInkSecondary),
          ),
        ],
      ],
    );
  }
}

class _InkPill extends StatelessWidget {
  const _InkPill({required this.icon, required this.text, this.color = AppColors.onInk});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: Corners.pill,
        border: Border.all(color: AppColors.inkStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleFacts extends StatelessWidget {
  const _VehicleFacts({required this.vehicle});

  final MaintenanceVehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final num? km = vehicle.odometerKm;
    final List<(String, String?)> rows = [
      (l10n.maintenanceFleetCode, vehicle.fleetCode),
      (l10n.maintenanceChassis, vehicle.chassisNumber),
      (l10n.maintenanceModel, vehicle.modelName),
      (l10n.maintenanceVariant, vehicle.variantName),
      (l10n.maintenanceColour, vehicle.colour),
      (l10n.maintenanceMaker, vehicle.oemName),
      (l10n.maintenanceCategory, vehicle.categoryName),
      (l10n.maintenanceVehicleType, vehicle.typeName),
      (l10n.maintenanceOdometer, km == null ? null : '${Fmt.number(km)} km'),
      (l10n.maintenanceCurrentHub, vehicle.currentHub?.name),
      (l10n.maintenanceHomeHub, vehicle.homeHub?.name),
      (l10n.maintenanceOnboarding, onboardingStatusLabel(l10n, vehicle.onboardingStatus)),
      (
        l10n.maintenanceAllocation,
        vehicle.allocationEnabled ? l10n.maintenanceAllocationOn : l10n.maintenanceAllocationOff,
      ),
    ];

    return Column(
      children: [
        for (final (String label, String? value) in rows)
          if (value != null && value.isNotEmpty) KeyValueRow(label: label, value: value),
      ],
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: Insets.sm),
        Expanded(
          child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _LimitNote extends StatelessWidget {
  const _LimitNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.md),
      child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 220, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 140, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 320, borderRadius: Corners.brXl),
      ],
    );
  }
}
