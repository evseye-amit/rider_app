import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/maintenance_job.dart';

StatusTone jobStatusTone(String status) => switch (status) {
      'overdue' => StatusTone.danger,
      'inProgress' => StatusTone.warning,
      'closed' => StatusTone.success,
      _ => StatusTone.info,
    };

String jobStatusLabel(String status) => switch (status) {
      'overdue' => 'Overdue',
      'inProgress' => 'In progress',
      'closed' => 'Closed',
      _ => 'Open',
    };

StatusTone jobPriorityTone(String priority) => switch (priority.toLowerCase()) {
      'high' => StatusTone.danger,
      'low' => StatusTone.neutral,
      _ => StatusTone.warning,
    };

String jobPriorityLabel(String priority) => switch (priority.toLowerCase()) {
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

class JobRowTile extends StatelessWidget {
  const JobRowTile({required this.job, required this.onTap, super.key});

  final MaintenanceJob job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool overdue = job.isPastDue;

    final Widget card = Container(
      decoration: BoxDecoration(
        color: overdue ? AppColors.dangerWash : AppColors.surface,
        borderRadius: Corners.brLg,
        border: overdue ? Border.all(color: AppColors.danger, width: 1.4) : null,
        boxShadow: overdue ? Shadows.soft : Shadows.card,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (overdue)
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.horizontal(left: Corners.lg),
                ),
              ),
            Expanded(child: Padding(padding: const EdgeInsets.all(Insets.lg), child: _body(overdue))),
          ],
        ),
      ),
    );

    return Pressable(onTap: onTap, scale: 0.99, child: card);
  }

  Widget _body(bool overdue) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                job.id,
                style: AppText.overline.copyWith(color: AppColors.textMuted),
              ),
              StatusChip(label: jobPriorityLabel(job.priority), tone: jobPriorityTone(job.priority), dense: true),
              StatusChip(
                label: jobStatusLabel(job.status),
                tone: jobStatusTone(job.status),
                dense: true,
                solid: overdue,
                icon: overdue ? Icons.warning_amber_rounded : null,
              ),
            ],
          ),
          const SizedBox(height: Insets.sm + 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PhotoThumb(photo: BrandPhoto.service, size: 48),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${job.vehicleNumber} · ${job.model}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSunken,
                              borderRadius: Corners.pill,
                            ),
                            child: Text(
                              job.type,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 10.5, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.sm + 2),
          Text(
            job.issue,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodyMedium.copyWith(fontSize: 12.5, height: 1.4),
          ),
          const SizedBox(height: Insets.md),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          const SizedBox(height: Insets.md),
          Wrap(
            spacing: Insets.md,
            runSpacing: Insets.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_rounded,
                    size: 14,
                    color: overdue ? AppColors.danger : AppColors.textMuted,
                  ),
                  const SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      job.isClosed
                          ? 'Closed ${Fmt.date(job.closedOn ?? job.dueOn)}'
                          : 'Due ${Fmt.date(job.dueOn)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 11.5,
                        fontWeight: overdue ? FontWeight.w800 : FontWeight.w500,
                        color: overdue ? AppColors.danger : null,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.build_rounded, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      job.assignedTo ?? 'Unassigned',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 11.5),
                    ),
                  ),
                ],
              ),
              if (job.bay != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.garage_rounded, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 5),
                    Text(job.bay!, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
                  ],
                ),
            ],
          ),
        ],
      );
  }
}
