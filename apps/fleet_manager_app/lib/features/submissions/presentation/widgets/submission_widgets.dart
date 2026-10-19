import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../../../core/maintenance/maintenance_issue_widgets.dart';

List<(SubmissionPhotoDto, String)> labelledSubmissionPhotos(AppL10n l10n, VehicleSubmissionDto submission) {
  int damage = 0;
  return [
    for (final SubmissionPhotoDto photo in submission.photos)
      (
        photo,
        photo.photoType.startsWith(damagePhotoPrefix)
            ? '${l10n.submissionPhotoDamage} ${++damage}'
            : submissionPhotoLabel(l10n, photo.photoType, submission.assets),
      ),
  ];
}

class SubmissionStageStyle {
  const SubmissionStageStyle._(this.label, this.tone, this.icon, {this.needsAction = false});

  factory SubmissionStageStyle.of(AppL10n l10n, SubmissionSummaryDto? submission) => switch (submission) {
    null => SubmissionStageStyle._(
      l10n.submissionStageScheduled,
      StatusTone.info,
      Icons.event_available_rounded,
      needsAction: true,
    ),
    SubmissionSummaryDto(isConfirmed: false) => SubmissionStageStyle._(
      l10n.submissionStageCheckingIn,
      StatusTone.warning,
      Icons.fact_check_rounded,
      needsAction: true,
    ),
    SubmissionSummaryDto(mechanicChecksComplete: false) => SubmissionStageStyle._(
      l10n.submissionStageFinalChecks,
      StatusTone.info,
      Icons.build_circle_rounded,
      needsAction: true,
    ),
    SubmissionSummaryDto() => SubmissionStageStyle._(
      l10n.submissionStageDone,
      StatusTone.success,
      Icons.check_circle_rounded,
    ),
  };

  final String label;
  final StatusTone tone;
  final IconData icon;
  final bool needsAction;
}

String submissionReasonLabel(AppL10n l10n, SubmissionRequestDto request) {
  final String code = request.reasonCode ?? '';
  return switch ((request.source, code)) {
    (SubmissionSource.exchange, 'VEHICLE_BREAKDOWN') => l10n.exchangeReasonBreakdown,
    (SubmissionSource.exchange, 'VEHICLE_UNSAFE') => l10n.exchangeReasonUnsafe,
    (SubmissionSource.exchange, 'SAFETY_EXCHANGE') => l10n.exchangeReasonSafety,
    (SubmissionSource.exchange, 'UPGRADE') => l10n.exchangeReasonUpgrade,
    (SubmissionSource.exchange, _) => l10n.commonOther,
    (SubmissionSource.returns, _) => returnReasonLabel(l10n, code),
  };
}

String submissionNextNote(AppL10n l10n, VehicleSubmissionDto submission) => switch (submission.nextAction) {
  SubmissionNextAction.capturePhotos when submission.missingPhotoTypes.isNotEmpty => l10n.submissionNextPhotos(
    submission.missingPhotoTypes.length,
  ),
  SubmissionNextAction.capturePhotos => l10n.submissionNextReport,
  SubmissionNextAction.reviewAndImpose => l10n.submissionNextReview,
  SubmissionNextAction.collectOtps => l10n.submissionNextOtps,
  SubmissionNextAction.deepCheck => l10n.submissionNextDeep,
  SubmissionNextAction.complete => l10n.submissionNextComplete,
};

StatusTone submissionNextTone(SubmissionNextAction action) => switch (action) {
  SubmissionNextAction.complete => StatusTone.success,
  SubmissionNextAction.deepCheck => StatusTone.info,
  _ => StatusTone.warning,
};

class SubmissionRequestTile extends StatelessWidget {
  const SubmissionRequestTile({required this.request, required this.hubName, required this.onOpen, super.key});

  final SubmissionRequestDto request;
  final String? hubName;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final SubmissionStageStyle style = SubmissionStageStyle.of(context.l10n, request.submission);
    final DateTime? planned = request.plannedDate;
    return Pressable(
      onTap: onOpen,
      scale: 0.99,
      child: GlassCard(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const IconTile(icon: Icons.electric_scooter_rounded, size: 40),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        [request.vehicleNumber ?? '—', ?request.vehicleModel].join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.titleMedium.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        [
                          if (request.riderName.isNotEmpty) request.riderName,
                          submissionReasonLabel(context.l10n, request),
                          ?hubName,
                        ].join(' · '),
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
            Row(
              children: [
                StatusChip(
                  label: style.label,
                  tone: style.tone,
                  icon: style.needsAction ? Icons.touch_app_rounded : null,
                  dense: true,
                ),
                const SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    planned == null
                        ? Fmt.relative(request.createdAt)
                        : context.l10n.submissionsDropOff(Fmt.date(planned)),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubmissionPhotoGrid extends StatelessWidget {
  const SubmissionPhotoGrid({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      mainAxisSpacing: Insets.md,
      crossAxisSpacing: Insets.md,
      children: children,
    );
  }
}

class SubmissionPhotoTile extends StatelessWidget {
  const SubmissionPhotoTile({
    required this.label,
    required this.captured,
    required this.uploading,
    required this.onTap,
    this.file,
    this.required = true,
    super.key,
  });

  final String label;
  final bool captured;
  final bool uploading;
  final VoidCallback? onTap;
  final File? file;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final File? local = file;
    final Widget tile = local == null
        ? captured
              ? _CapturedBox(label: label, onTap: uploading ? null : onTap)
              : PhotoSlot(label: label, required: required, onTap: uploading ? null : onTap)
        : Pressable(
            onTap: uploading ? null : onTap,
            scale: 0.96,
            child: ClipRRect(
              borderRadius: Corners.brMd,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(local, fit: BoxFit.cover, cacheWidth: 400),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 10.5, color: Colors.white),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success),
                  ),
                ],
              ),
            ),
          );
    if (!uploading) return tile;
    return Stack(
      fit: StackFit.expand,
      children: [
        tile,
        DecoratedBox(
          decoration: BoxDecoration(color: Colors.black38, borderRadius: Corners.brMd),
          child: const Center(
            child: SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _CapturedBox extends StatelessWidget {
  const _CapturedBox({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.successWash,
          borderRadius: Corners.brMd,
          border: Border.all(color: AppColors.success.withValues(alpha: 0.35), width: 1.3),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 26, color: AppColors.success),
                  const SizedBox(height: Insets.sm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 11, height: 1.2, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: StatusChip(label: context.l10n.checkInViewPhotos, dense: true, showDot: false),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmissionReportCard extends StatelessWidget {
  const SubmissionReportCard({required this.report, this.actions = const [], super.key});

  final SubmissionReportDto report;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final (String label, StatusTone tone) = switch (report.status) {
      SubmissionReportStatus.draft => (context.l10n.checkInStatusDraft, StatusTone.warning),
      SubmissionReportStatus.submitted => (context.l10n.checkInStatusSubmitted, StatusTone.info),
      SubmissionReportStatus.posted => (context.l10n.checkInStatusPosted, StatusTone.success),
      SubmissionReportStatus.cancelled => (context.l10n.submissionStatusCancelled, StatusTone.neutral),
    };
    final String? riderBypass = report.riderBypassReason;
    final String? teamLeadBypass = report.teamLeadBypassReason;
    final String? cancelled = report.cancellationReason;
    final String? unsafeReason = report.unsafeReason;
    String? charge(MaintenanceIssueDto issue) {
      final String? findingId = issue.penaltyFindingId;
      if (findingId == null) return null;
      final SubmissionPenaltyItemDto? item = report.items.where((entry) => entry.findingId == findingId).firstOrNull;
      return item == null ? context.l10n.issueChargeLinked : context.l10n.issueChargeLine(item.description);
    }

    final bool muted = report.status == SubmissionReportStatus.cancelled;
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: muted ? AppColors.surfaceMuted.withValues(alpha: 0.5) : AppColors.surfaceMuted,
        borderRadius: Corners.brLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  report.stage == SubmissionStage.basic
                      ? context.l10n.checkInBasicReport
                      : context.l10n.checkInDeepReport,
                  style: AppText.titleSmall.copyWith(fontSize: 14),
                ),
              ),
              StatusChip(label: label, tone: tone, dense: true),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            [context.l10n.submissionReportBy(report.mechanicName), Fmt.dateTime(report.createdAt)].join(' · '),
            style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
          ),
          const Gap.sm(),
          Text(report.summary, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.sm(),
          if (report.fleetStatus case final MaintenanceFleetStatus status) ...[
            Text(
              context.l10n.submissionScooterStatusLine(fleetConditionLabel(context.l10n, status)),
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: fleetConditionTone(status).color,
              ),
            ),
            if (!report.safeForReuse && unsafeReason != null) ...[
              const SizedBox(height: 2),
              Text(unsafeReason, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ] else
            Text(
              report.safeForReuse ? context.l10n.checkInSafe : context.l10n.checkInUnsafe(unsafeReason ?? '—'),
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: report.safeForReuse ? AppColors.success : AppColors.warning,
              ),
            ),
          if (report.issues.isNotEmpty) ...[
            const Gap.xs(),
            for (final MaintenanceIssueDto issue in report.issues)
              MaintenanceIssueRow(
                category: issue.category,
                description: issue.description,
                status: issue.status,
                photoCount: issue.evidencePhotoIds.length,
                requiredParts: issue.requiredParts,
                charge: charge(issue),
              ),
          ],
          if (report.checksComplete) ...[
            const SizedBox(height: 2),
            Text(
              context.l10n.submissionChecksComplete,
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
          const Gap.sm(),
          if (report.items.isEmpty)
            Text(context.l10n.checkInNoCharges, style: AppText.bodySmall.copyWith(fontSize: 12))
          else ...[
            for (final SubmissionPenaltyItemDto item in report.items)
              PenaltyLineRow(
                description: item.description,
                details: item.details == item.description ? '' : item.details,
                missing: item.category == PenaltyCategory.missingItem,
                quantity: item.quantity,
                evidenceCount: item.evidencePhotoIds.length,
                amount: item.amount,
              ),
            ChargesTotal(total: report.totalAmount),
          ],
          if (report.riderVerified || riderBypass != null || report.teamLeadVerified || teamLeadBypass != null) ...[
            const Gap.sm(),
            if (report.riderVerified) _Line(icon: Icons.verified_rounded, text: context.l10n.submissionVerifiedRider),
            if (riderBypass != null)
              _Line(icon: Icons.report_outlined, text: context.l10n.submissionBypassRider(riderBypass)),
            if (report.teamLeadVerified)
              _Line(icon: Icons.verified_rounded, text: context.l10n.submissionVerifiedTeamLead),
            if (teamLeadBypass != null)
              _Line(icon: Icons.report_outlined, text: context.l10n.submissionBypassTeamLead(teamLeadBypass)),
          ],
          if (cancelled != null && muted) ...[
            const Gap.sm(),
            _Line(icon: Icons.cancel_outlined, text: context.l10n.submissionCancelledBecause(cancelled)),
          ],
          if (actions.isNotEmpty) ...[const Gap.md(), ...actions],
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: AppColors.textMuted),
          ),
          const SizedBox(width: Insets.xs + 2),
          Expanded(
            child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class PenaltyLineRow extends StatelessWidget {
  const PenaltyLineRow({
    required this.description,
    required this.details,
    required this.missing,
    required this.quantity,
    required this.evidenceCount,
    this.amount,
    this.onTap,
    this.onRemove,
    super.key,
  });

  final String description;
  final String details;
  final bool missing;
  final int quantity;
  final int evidenceCount;
  final num? amount;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final num? amount = this.amount;
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: missing ? Icons.inventory_2_rounded : Icons.car_crash_rounded,
            tone: missing ? AppColors.amber : AppColors.danger,
            size: 34,
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quantity > 1 ? '$description × $quantity' : description,
                  style: AppText.titleSmall.copyWith(fontSize: 13.5),
                ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(details, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4)),
                ],
                const SizedBox(height: 4),
                Text(
                  [
                    missing ? context.l10n.returnsKindMissing : context.l10n.returnsKindDamage,
                    context.l10n.returnsEvidenceCount(evidenceCount),
                  ].join(' · '),
                  style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          if (amount != null) ...[
            const SizedBox(width: Insets.sm),
            Text(Fmt.money(amount, paise: true), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
          ],
          if (onRemove != null)
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
              onPressed: onRemove,
            ),
        ],
      ),
    );
    return onTap == null ? row : Pressable(onTap: onTap, scale: 0.99, child: row);
  }
}

class EvidenceChip extends StatelessWidget {
  const EvidenceChip({required this.label, required this.selected, required this.onTap, super.key});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = selected ? AppColors.primary : AppColors.textSecondary;
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? Icons.check_circle_rounded : Icons.photo_outlined, size: 15, color: tone),
            const SizedBox(width: Insets.xs + 2),
            Text(label, style: AppText.titleSmall.copyWith(fontSize: 12.5, color: tone)),
          ],
        ),
      ),
    );
  }
}

class ChargesTotal extends StatelessWidget {
  const ChargesTotal({required this.total, super.key});

  final num total;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Insets.xs),
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brMd),
      child: Row(
        children: [
          Expanded(child: Text(context.l10n.commonTotal, style: AppText.titleSmall)),
          Text(Fmt.money(total, paise: true), style: AppText.numeric.copyWith(fontSize: 17)),
        ],
      ),
    );
  }
}
