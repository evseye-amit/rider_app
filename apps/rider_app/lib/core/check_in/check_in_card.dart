import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/damage_charges/domain/entities/damage_charge.dart';
import '../../features/damage_charges/presentation/providers/damage_charges_providers.dart';
import '../../features/damage_charges/presentation/widgets/damage_charge_widgets.dart';
import '../../features/damage_charges/presentation/widgets/damage_pay_action.dart';

final riderCheckInProvider = FutureProvider.autoDispose.family<VehicleSubmissionDto, String>(
  (ref, id) async => (await ref.watch(vehicleSubmissionApiProvider).riderDetail(id)).getOrThrow(),
);

class CheckInCard extends ConsumerWidget {
  const CheckInCard({required this.submissionId, super.key});

  final String submissionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<VehicleSubmissionDto> checkIn = ref.watch(riderCheckInProvider(submissionId));
    final VehicleSubmissionDto? value = checkIn.value;
    return ModuleCard(
      title: context.l10n.checkInTitle,
      leading: const IconTile(icon: Icons.fact_check_rounded, solid: true, size: 28),
      child: switch (value) {
        final VehicleSubmissionDto submission => _CheckInBody(submission: submission),
        null when checkIn.hasError => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              checkIn.failureMessage ?? context.l10n.checkInCouldNotLoad,
              style: AppText.bodySmall.copyWith(fontSize: 12.5),
            ),
            const Gap.sm(),
            GhostButton(
              label: context.l10n.commonTryAgain,
              icon: Icons.refresh_rounded,
              dense: true,
              onPressed: () => ref.invalidate(riderCheckInProvider(submissionId)),
            ),
          ],
        ),
        null => const ShimmerBox(height: 140, borderRadius: Corners.brLg),
      },
    );
  }
}

class _CheckInBody extends ConsumerWidget {
  const _CheckInBody({required this.submission});

  final VehicleSubmissionDto submission;

  Future<void> _showPhotos(BuildContext context, WidgetRef ref) => AppSheet.show<void>(
    context,
    title: context.l10n.checkInPhotos,
    subtitle: submission.assets.vehicleNumber,
    child: Column(
      children: [
        for (final SubmissionPhotoDto photo in submission.photos) ...[
          AppNavTile(
            title: submissionPhotoLabel(context.l10n, photo.photoType, submission.assets),
            subtitle: photo.uploadedAt == null ? null : Fmt.dateTime(photo.uploadedAt!),
            icon: Icons.photo_rounded,
            onTap: () async {
              final Result<String> url = await ref
                  .read(vehicleSubmissionApiProvider)
                  .riderPhotoUrl(submission.id, photo.id);
              if (!context.mounted) return;
              switch (url) {
                case Ok<String>(:final value) when value.isNotEmpty:
                  await PhotoViewer.show(context, value);
                case _:
                  AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
              }
            },
          ),
          const Gap.sm(),
        ],
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final List<SubmissionReportDto> reports = [
      for (final SubmissionReportDto report in submission.reports)
        if (report.status != SubmissionReportStatus.cancelled) report,
    ];
    final int total = submission.requiredPhotoTypes.length;
    final int taken = total - submission.missingPhotoTypes.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(label: l10n.checkInHub, value: submission.hubName, icon: Icons.store_rounded),
        const Gap.sm(),
        if (submission.photos.isEmpty)
          KeyValueRow(
            label: l10n.checkInPhotos,
            value: l10n.checkInPhotosCount(taken, total),
            icon: Icons.photo_library_rounded,
          )
        else
          _LinkTile(
            icon: Icons.photo_library_rounded,
            title: l10n.checkInPhotos,
            subtitle: l10n.checkInPhotosCount(taken, total),
            onTap: () => _showPhotos(context, ref),
          ),
        if (reports.isEmpty) ...[
          const Gap.lg(),
          _Note(icon: Icons.hourglass_top_rounded, tone: AppColors.info, text: l10n.checkInWaitingReport),
        ] else
          for (final SubmissionReportDto report in reports) _ReportSection(report: report),
      ],
    );
  }
}

class _ReportSection extends ConsumerWidget {
  const _ReportSection({required this.report});

  final SubmissionReportDto report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final DamageCharge? charge = report.items.isEmpty
        ? null
        : ref.watch(damageChargesProvider).value?.where((item) => item.reportId == report.id).firstOrNull;
    final (String label, StatusTone tone) = switch (report.status) {
      SubmissionReportStatus.draft => (l10n.checkInStatusDraft, StatusTone.neutral),
      SubmissionReportStatus.submitted => (l10n.checkInStatusSubmitted, StatusTone.warning),
      SubmissionReportStatus.posted => (l10n.checkInStatusPosted, StatusTone.success),
      SubmissionReportStatus.cancelled => (l10n.checkInStatusDraft, StatusTone.neutral),
    };
    final String? bypass = report.riderBypassReason;
    final Color verdictColor = report.safeForReuse ? AppColors.success : AppColors.warning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.md),
          child: Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: 1),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                report.stage == SubmissionStage.basic ? l10n.checkInBasicReport : l10n.checkInDeepReport,
                style: AppText.titleSmall.copyWith(fontSize: 15),
              ),
            ),
            StatusChip(label: label, tone: tone, dense: true),
          ],
        ),
        if (report.summary.isNotEmpty) ...[
          const Gap.sm(),
          Text(report.summary, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.45)),
        ],
        const Gap.sm(),
        _Note(
          icon: report.safeForReuse ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
          tone: verdictColor,
          text: report.safeForReuse ? l10n.checkInSafe : l10n.checkInUnsafe(report.unsafeReason ?? '—'),
          strong: true,
        ),
        if (report.status == SubmissionReportStatus.submitted) ...[
          const Gap.sm(),
          _Note(icon: Icons.sms_rounded, tone: AppColors.info, text: l10n.checkInOtpHint),
        ],
        const Gap.md(),
        if (report.items.isEmpty)
          _Note(icon: Icons.verified_rounded, tone: AppColors.success, text: l10n.checkInNoCharges, strong: true)
        else
          _ChargesBox(report: report),
        if (charge != null) ...[
          const Gap.sm(),
          _LinkTile(
            icon: Icons.receipt_long_rounded,
            title: l10n.damageChargeViewDetails,
            trailing: charge.isOpen
                ? null
                : StatusChip(
                    label: damageChargeStatus(l10n, charge.state).$1,
                    tone: damageChargeStatus(l10n, charge.state).$2,
                    dense: true,
                  ),
            onTap: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
          ),
          if (charge.isOpen) ...[const Gap.md(), DamagePayAction(charge: charge)],
        ],
        if (report.status == SubmissionReportStatus.posted) ...[
          const Gap.md(),
          _Note(
            icon: Icons.verified_user_rounded,
            tone: AppColors.textMuted,
            text: bypass == null ? l10n.checkInConfirmedByOtp : l10n.checkInConfirmedByManager(bypass),
          ),
        ],
      ],
    );
  }
}

class _ChargesBox extends StatelessWidget {
  const _ChargesBox({required this.report});

  final SubmissionReportDto report;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brMd,
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final SubmissionPenaltyItemDto item in report.items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Insets.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.quantity > 1 ? '${item.description} × ${item.quantity}' : item.description,
                      style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.35, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Text(
                    Fmt.money(item.amount, paise: true),
                    style: AppText.bodyMedium.copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: Insets.md),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.xs),
            child: Row(
              children: [
                Expanded(child: Text(context.l10n.checkInTotal, style: AppText.titleSmall.copyWith(fontSize: 14))),
                Text(
                  Fmt.money(report.totalAmount, paise: true),
                  style: AppText.titleSmall.copyWith(fontSize: 16, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.title, required this.onTap, this.subtitle, this.trailing});

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String? subtitle = this.subtitle;
    final Widget? trailing = this.trailing;
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brMd,
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: AppColors.primaryWash, borderRadius: Corners.brSm),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.titleSmall.copyWith(fontSize: 14)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppText.bodySmall.copyWith(fontSize: 12)),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[trailing, const SizedBox(width: Insets.xs)],
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.tone, required this.text, this.strong = false});

  final IconData icon;
  final Color tone;
  final String text;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 16, color: tone),
        ),
        const SizedBox(width: Insets.sm),
        Expanded(
          child: Text(
            text,
            style: AppText.bodySmall.copyWith(
              fontSize: 12.5,
              height: 1.45,
              fontWeight: strong ? FontWeight.w700 : null,
              color: strong ? tone : null,
            ),
          ),
        ),
      ],
    );
  }
}
