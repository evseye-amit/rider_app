import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/active_allocation.dart';
import '../../domain/entities/deallocation_request.dart';

StatusTone priorityTone(String priority) => switch (priority.toLowerCase()) {
      'high' => StatusTone.danger,
      'low' => StatusTone.neutral,
      _ => StatusTone.warning,
    };

String priorityLabel(String priority) => switch (priority.toLowerCase()) {
      'high' => 'High priority',
      'low' => 'Low priority',
      _ => 'Normal priority',
    };

class OverlapModuleCard extends StatelessWidget {
  const OverlapModuleCard({
    required this.child,
    this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.all(Insets.lg),
    super.key,
  });

  final Widget child;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.floating,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleMedium.copyWith(fontSize: 15.5),
                  ),
                ),
                if (actionLabel != null)
                  Pressable(
                    onTap: onAction,
                    child: Row(
                      children: [
                        Text(
                          actionLabel!,
                          style: AppText.titleSmall.copyWith(
                            fontSize: 12.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Insets.lg),
          ],
          child,
        ],
      ),
    );
  }
}

class PendingRiderTile extends StatelessWidget {
  const PendingRiderTile({required this.rider, required this.onAssign, super.key});

  final PendingRider rider;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final DateTime? since = rider.joiningDate ?? rider.createdAt;
    return GlassCard(
      padding: const EdgeInsets.all(Insets.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(name: rider.name, size: 42),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rider.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleMedium.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 3),
                Text(
                  [
                    if ((rider.riderCode ?? '').isNotEmpty) rider.riderCode!,
                    Fmt.phone(rider.mobile),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
                if (since != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Waiting ${Fmt.relative(since)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 11.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: Insets.sm),
          SecondaryButton(
            label: 'Assign',
            icon: Icons.swap_horiz_rounded,
            expand: false,
            size: AppButtonSize.small,
            onPressed: onAssign,
          ),
        ],
      ),
    );
  }
}

class DeploymentRequestTile extends StatelessWidget {
  const DeploymentRequestTile({required this.allocation, required this.onOpen, super.key});

  final DeploymentAllocation allocation;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final DeploymentStatus status = allocation.deploymentStatus;
    final bool mine = !status.waitsOnRider && !status.isDeployed;
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        tint: mine ? AppColors.primaryWash : null,
        borderColor: mine ? AppColors.primary.withValues(alpha: 0.35) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(name: allocation.rider?.name ?? '?', size: 42),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allocation.rider?.name ?? 'Rider',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${allocation.fleet?.vehicleNumber ?? '—'}${(allocation.fleet?.modelName ?? '').isEmpty ? '' : ' · ${allocation.fleet!.modelName}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: Insets.md),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                StatusChip(
                  label: status.label,
                  tone: mine ? StatusTone.warning : StatusTone.info,
                  icon: mine ? Icons.touch_app_rounded : Icons.hourglass_top_rounded,
                  dense: true,
                ),
                Text(
                  mine ? 'Your move' : 'Waiting on the rider',
                  style: AppText.bodySmall.copyWith(fontSize: 11.5, color: mine ? AppColors.primary : AppColors.textMuted),
                ),
                if (allocation.updatedAt != null)
                  Text(
                    '· ${Fmt.relative(allocation.updatedAt!)}',
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeploymentTimeline extends StatelessWidget {
  const DeploymentTimeline({required this.status, this.workflow, super.key});

  final DeploymentStatus status;
  final DeploymentWorkflow? workflow;

  @override
  Widget build(BuildContext context) {
    final List<(DeploymentStatus, String, DateTime?)> rows = [
      (DeploymentStatus.riderWaiting, 'Vehicle reserved', workflow?.createdAt),
      (DeploymentStatus.paymentPending, 'Payment requested', null),
      (DeploymentStatus.paymentPaid, 'Payment verified', workflow?.paymentPaidAt),
      (DeploymentStatus.pdiPendingRider, 'Inspection sent to rider', null),
      (DeploymentStatus.trainingPending, 'Inspection accepted · training', workflow?.riderPdiAcceptedAt),
      (DeploymentStatus.devicePairingPending, 'Training done · pairing', workflow?.trainingCompletedAt),
      (DeploymentStatus.deployed, 'Deployed', workflow?.pairedAt ?? workflow?.pairingBypassedAt),
    ];
    final int current = status == DeploymentStatus.unknown ? -1 : status.step;

    return Column(
      children: [
        for (int i = 0; i < rows.length; i++)
          TimelineRow(
            title: rows[i].$2,
            done: rows[i].$1.step < current || (status.isDeployed && rows[i].$1.isDeployed),
            current: rows[i].$1.step == current && !status.isDeployed,
            time: rows[i].$3 == null ? null : Fmt.dateTime(rows[i].$3!),
            isLast: i == rows.length - 1,
          ),
      ],
    );
  }
}

class ActiveAllocationTile extends StatelessWidget {
  const ActiveAllocationTile({required this.allocation, required this.onOpen, super.key});

  final ActiveAllocation allocation;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final bool riding = allocation.status.toLowerCase() == 'riding';

    return GlassCard(
      padding: const EdgeInsets.all(Insets.lg),
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(name: allocation.riderName, size: 46),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        allocation.riderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                    ),
                    StatusChip(
                      label: riding ? 'Riding' : 'Idle',
                      tone: riding ? StatusTone.brand : StatusTone.neutral,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${allocation.vehicleNumber} · ${allocation.model}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
                const SizedBox(height: Insets.md),
                Row(
                  children: [
                    if (allocation.batteryPercent != null)
                      BatteryBar(percent: allocation.batteryPercent!),
                    const Spacer(),
                    Text(
                      'since ${Fmt.date(allocation.allocatedOn)}',
                      style: AppText.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReturnRequestTile extends StatelessWidget {
  const ReturnRequestTile({
    required this.request,
    required this.onOpen,
    required this.onProcess,
    super.key,
  });

  final DeallocationRequest request;
  final VoidCallback onOpen;
  final VoidCallback onProcess;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Pressable(
            onTap: onOpen,
            scale: 0.99,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(name: request.riderName, size: 42),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: Insets.xs,
                        children: [
                          Text(
                            request.riderName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.titleMedium.copyWith(fontSize: 15),
                          ),
                          StatusChip(
                            label: priorityLabel(request.priority),
                            tone: priorityTone(request.priority),
                            dense: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${request.vehicleNumber} · ${request.model}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        request.reason,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyMedium.copyWith(fontSize: 12.5),
                      ),
                      const SizedBox(height: Insets.sm),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 13, color: AppColors.textMuted),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Raised ${Fmt.relative(request.raisedOn)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const SizedBox(height: Insets.md),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: Insets.sm,
            children: [
              GhostButton(
                label: 'View return',
                icon: Icons.chevron_right_rounded,
                onPressed: onOpen,
                dense: true,
              ),
              SecondaryButton(
                label: 'Process return',
                icon: Icons.assignment_return_rounded,
                expand: false,
                size: AppButtonSize.small,
                onPressed: onProcess,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeskStat {
  const DeskStat({
    required this.label,
    required this.value,
    required this.icon,
    this.alert = false,
  });

  final String label;
  final String value;
  final IconData icon;

  final bool alert;
}

class DeskBand extends StatelessWidget {
  const DeskBand({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.stats,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<DeskStat> stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconTile(icon: icon, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
              ),
            ),
          ],
        ),
        const Gap.sm(),
        Text(
          subtitle,
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.4),
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              for (final stat in stats) ...[
                if (stat != stats.first) ...[
                  const InkDivider(),
                  const SizedBox(width: Insets.md),
                ],
                Expanded(
                  child: InkStat(
                    label: stat.label,
                    value: stat.value,
                    icon: stat.icon,
                    valueColor: stat.alert ? AppColors.onInkAmber : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AllocationBoardSkeleton extends StatelessWidget {
  const AllocationBoardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.floating,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShimmerBox(height: 42, borderRadius: Corners.pill),
          const Gap.lg(),
          const ShimmerBox(height: 46, borderRadius: Corners.pill),
          const Gap.xl(),
          for (int i = 0; i < 3; i++) ...[
            const ShimmerBox(height: 150, borderRadius: Corners.brLg),
            const Gap.md(),
          ],
        ],
      ),
    );
  }
}
