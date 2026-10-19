import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../maintenance/presentation/widgets/maintenance_widgets.dart';
import '../providers/fleet_search_providers.dart';
import '../widgets/fleet_search_widgets.dart';

class ScooterDetailPage extends ConsumerWidget {
  const ScooterDetailPage({required this.fleetId, super.key});

  final String fleetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GlobalFleetDetailDto> detail = ref.watch(scooterProvider(fleetId));
    final GlobalFleetDetailDto? data = detail.value;

    if (data == null && detail.hasError) {
      return AppScaffold(
        title: context.l10n.fleetSearchTitle,
        body: EmptyState(
          title: context.l10n.fleetSearchCouldNotLoadScooter,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(scooterProvider(fleetId)),
        ),
      );
    }

    return HeroScaffold(
      onRefresh: () {
        ref.invalidate(scooterRidersProvider(fleetId));
        return ref.refreshQuietly(scooterProvider(fleetId));
      },
      band: _Band(fleet: data?.fleet),
      children: data == null ? const [_DetailSkeleton()] : _sections(context, data),
    );
  }

  List<Widget> _sections(BuildContext context, GlobalFleetDetailDto data) {
    final AppL10n l10n = context.l10n;
    final GlobalFleetAllocationDto? allocation = data.allocation;
    final GlobalFleetSubmissionDto? submission = data.submission;

    return [
      ModuleCard(
        title: l10n.maintenanceVehicleDetails,
        child: _VehicleFacts(fleet: data.fleet, photoUrl: data.frontPhotoUrl),
      ),
      const Gap.lg(),
      ModuleCard(
        title: l10n.fleetSearchCurrentRider,
        child: allocation == null
            ? _EmptyLine(icon: Icons.person_off_outlined, text: l10n.fleetSearchNoRider)
            : _CurrentRider(allocation: allocation),
      ),
      const Gap.lg(),
      ModuleCard(
        title: l10n.fleetSearchLatestSubmission,
        child: submission == null
            ? _EmptyLine(icon: Icons.assignment_outlined, text: l10n.fleetSearchNoSubmission)
            : _LatestSubmission(submission: submission),
      ),
      const Gap.lg(),
      ModuleCard(
        title: l10n.fleetSearchRiderHistory,
        child: data.fleet.canManage
            ? _RiderHistory(fleetId: fleetId)
            : _EmptyLine(icon: Icons.lock_outline_rounded, text: l10n.fleetSearchRiderHistoryOtherHub),
      ),
    ];
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.fleet});

  final GlobalFleetDto? fleet;

  @override
  Widget build(BuildContext context) {
    final GlobalFleetDto? current = fleet;
    final String? hub = current?.hubName;

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
        if (current != null) ...[
          const Gap.lg(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              _InkPill(icon: Icons.electric_scooter_rounded, text: fleetStatusLabel(context.l10n, current.status)),
              if (hub != null) _InkPill(icon: Icons.hub_rounded, text: hub),
              if (current.fleetCode.isNotEmpty) _InkPill(icon: Icons.tag_rounded, text: current.fleetCode),
              if (!current.canManage)
                _InkPill(
                  icon: Icons.lock_outline_rounded,
                  text: context.l10n.fleetSearchOtherHub,
                  color: AppColors.onInkAmber,
                ),
            ],
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
  const _VehicleFacts({required this.fleet, required this.photoUrl});

  final GlobalFleetDto fleet;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? photo = photoUrl;
    final List<(String, String?)> rows = [
      (l10n.maintenanceFleetCode, fleet.fleetCode),
      (l10n.maintenanceChassis, fleet.chassisNumber),
      (l10n.maintenanceModel, fleet.modelName),
      (l10n.maintenanceVariant, fleet.variantName),
      (l10n.maintenanceColour, fleet.colour),
      (l10n.maintenanceMaker, fleet.oemName),
      (l10n.maintenanceVehicleType, fleet.vehicleTypeName),
      (l10n.commonStatus, fleetStatusLabel(l10n, fleet.status)),
      (l10n.maintenanceCurrentHub, [?fleet.hubName, ?fleet.hubCity].join(' · ')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (photo != null) ...[_ScooterPhoto(url: photo), const Gap.md()],
        for (final (String label, String? value) in rows)
          if (value != null && value.isNotEmpty) KeyValueRow(label: label, value: value),
      ],
    );
  }
}

class _ScooterPhoto extends StatelessWidget {
  const _ScooterPhoto({required this.url});

  final String url;

  static const double _height = 180;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: Corners.brLg,
      child: Image.network(
        url,
        height: _height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : const ShimmerBox(height: _height, borderRadius: Corners.brLg),
        errorBuilder: (_, _, _) => Container(
          height: _height,
          color: AppColors.surfaceMuted,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_rounded, size: 28, color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _CurrentRider extends StatelessWidget {
  const _CurrentRider({required this.allocation});

  final GlobalFleetAllocationDto allocation;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? allocatedAt = allocation.allocatedAt;

    return Column(
      children: [
        KeyValueRow(
          label: l10n.allocationRider,
          value: [allocation.riderName ?? '—', ?allocation.riderCode].join(' · '),
        ),
        if (allocatedAt != null) KeyValueRow(label: l10n.commonAllocated, value: Fmt.date(allocatedAt)),
        KeyValueRow(label: l10n.commonStatus, value: allocationStateLabel(l10n, allocation.status)),
      ],
    );
  }
}

class _LatestSubmission extends StatelessWidget {
  const _LatestSubmission({required this.submission});

  final GlobalFleetSubmissionDto submission;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? confirmedAt = submission.confirmedAt;
    final (String label, StatusTone tone) = submission.isCancelled
        ? (l10n.submissionStatusCancelled, StatusTone.danger)
        : submission.isDone
        ? (l10n.fleetSearchSubmissionDone, StatusTone.success)
        : (l10n.fleetSearchSubmissionOpen, StatusTone.warning);

    return Row(
      children: [
        IconTile(
          icon: submission.isExchange ? Icons.swap_horiz_rounded : Icons.assignment_return_rounded,
          tone: AppColors.primary,
        ),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submission.isExchange ? l10n.submissionSourceExchange : l10n.submissionSourceReturn,
                style: AppText.titleSmall.copyWith(fontSize: 14),
              ),
              if (confirmedAt != null) ...[
                const SizedBox(height: 2),
                Text(
                  Fmt.date(confirmedAt),
                  style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: Insets.sm),
        StatusChip(label: label, tone: tone, dense: true),
      ],
    );
  }
}

class _RiderHistory extends ConsumerWidget {
  const _RiderHistory({required this.fleetId});

  final String fleetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GlobalFleetRiderDto>> riders = ref.watch(scooterRidersProvider(fleetId));
    final List<GlobalFleetRiderDto>? items = riders.value;

    if (items == null) {
      if (riders.hasError) {
        return EmptyState(
          title: context.l10n.fleetSearchCouldNotLoadRiderHistory,
          message: riders.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(scooterRidersProvider(fleetId)),
          compact: true,
        );
      }
      return const ShimmerBox(height: 120, borderRadius: Corners.brMd);
    }

    if (items.isEmpty) {
      return _EmptyLine(icon: Icons.history_toggle_off_rounded, text: context.l10n.fleetSearchNoRiderHistory);
    }

    return Column(
      children: [
        for (int i = 0; i < items.length; i++) _RiderRow(record: items[i], first: i == 0, last: i == items.length - 1),
      ],
    );
  }
}

class _RiderRow extends StatelessWidget {
  const _RiderRow({required this.record, required this.first, required this.last});

  final GlobalFleetRiderDto record;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final StatusTone tone = allocationStateTone(record.status);
    final String? period = _period(l10n);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 18,
            child: Column(
              children: [
                Container(width: 2, height: 6, color: first ? Colors.transparent : AppColors.stroke),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: first ? tone.color : AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: tone.color, width: 2),
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          [record.riderName, ?record.riderCode].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleSmall.copyWith(fontSize: 13.5),
                        ),
                      ),
                      const SizedBox(width: Insets.sm),
                      StatusChip(label: allocationStateLabel(l10n, record.status), tone: tone, dense: true),
                    ],
                  ),
                  if (period != null) ...[
                    const SizedBox(height: 2),
                    Text(period, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _period(AppL10n l10n) {
    final DateTime? from = record.from;
    final DateTime? to = record.to;
    if (from == null) return to == null ? null : Fmt.date(to);
    if (to != null) return '${Fmt.date(from)} – ${Fmt.date(to)}';
    final bool ended = record.status == 'COMPLETED' || record.status == 'CANCELLED';
    return ended ? Fmt.date(from) : l10n.fleetSearchSince(Fmt.date(from));
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

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 320, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 140, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 110, borderRadius: Corners.brXl),
      ],
    );
  }
}
