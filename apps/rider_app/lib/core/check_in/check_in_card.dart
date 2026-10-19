import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/damage_charges/domain/entities/damage_charge.dart';
import '../../features/damage_charges/presentation/providers/damage_charges_providers.dart';
import '../../features/damage_charges/presentation/widgets/damage_charge_widgets.dart';

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
    final List<SubmissionReportDto> reports = [
      for (final SubmissionReportDto report in submission.reports)
        if (report.status != SubmissionReportStatus.cancelled) report,
    ];
    final int taken = submission.requiredPhotoTypes.length - submission.missingPhotoTypes.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueRow(label: context.l10n.checkInHub, value: submission.hubName, icon: Icons.store_rounded),
        KeyValueRow(
          label: context.l10n.checkInPhotos,
          value: context.l10n.checkInPhotosCount(taken, submission.requiredPhotoTypes.length),
          icon: Icons.photo_library_rounded,
          trailing: submission.photos.isEmpty
              ? null
              : GhostButton(
                  label: context.l10n.checkInViewPhotos,
                  dense: true,
                  onPressed: () => _showPhotos(context, ref),
                ),
        ),
        const Gap.md(),
        if (reports.isEmpty)
          Text(context.l10n.checkInWaitingReport, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))
        else
          for (final SubmissionReportDto report in reports) ...[
            _ReportBlock(report: report),
            if (report != reports.last) const Gap.md(),
          ],
      ],
    );
  }
}

class _ReportBlock extends ConsumerWidget {
  const _ReportBlock({required this.report});

  final SubmissionReportDto report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DamageCharge? charge = report.items.isEmpty
        ? null
        : ref.watch(damageChargesProvider(true)).value?.where((item) => item.reportId == report.id).firstOrNull;
    final (String label, StatusTone tone) = switch (report.status) {
      SubmissionReportStatus.draft => (context.l10n.checkInStatusDraft, StatusTone.neutral),
      SubmissionReportStatus.submitted => (context.l10n.checkInStatusSubmitted, StatusTone.warning),
      SubmissionReportStatus.posted => (context.l10n.checkInStatusPosted, StatusTone.success),
      SubmissionReportStatus.cancelled => (context.l10n.checkInStatusDraft, StatusTone.neutral),
    };
    final String? bypass = report.riderBypassReason;
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(color: AppColors.surfaceMuted, borderRadius: Corners.brLg),
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
          const Gap.sm(),
          Text(report.summary, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.sm(),
          Text(
            report.safeForReuse ? context.l10n.checkInSafe : context.l10n.checkInUnsafe(report.unsafeReason ?? '—'),
            style: AppText.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: report.safeForReuse ? AppColors.success : AppColors.warning,
            ),
          ),
          const Gap.sm(),
          if (report.items.isEmpty)
            Text(context.l10n.checkInNoCharges, style: AppText.bodySmall.copyWith(fontSize: 12))
          else ...[
            for (final SubmissionPenaltyItemDto item in report.items)
              KeyValueRow(
                label: item.quantity > 1 ? '${item.description} × ${item.quantity}' : item.description,
                value: Fmt.money(item.amount),
                icon: item.category == PenaltyCategory.missingItem
                    ? Icons.inventory_2_outlined
                    : Icons.car_crash_outlined,
                dense: true,
              ),
            KeyValueRow(
              label: context.l10n.checkInTotal,
              value: Fmt.money(report.totalAmount),
              icon: Icons.receipt_long_rounded,
              valueStyle: AppText.titleSmall,
              dense: true,
            ),
          ],
          if (charge != null) ...[
            const Gap.sm(),
            if (charge.isOpen)
              PrimaryButton(
                label: context.l10n.damageChargePay(Fmt.money(charge.due, paise: true)),
                icon: Icons.payments_rounded,
                size: AppButtonSize.medium,
                onPressed: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
              )
            else
              GhostButton(
                label: damageChargeStatus(context.l10n, charge.state).$1,
                icon: Icons.receipt_long_rounded,
                dense: true,
                onPressed: () => context.push('${Routes.damageChargeDetail}?id=${charge.id}'),
              ),
          ],
          if (report.status == SubmissionReportStatus.submitted) ...[
            const Gap.sm(),
            Text(context.l10n.checkInOtpHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
          ],
          if (report.status == SubmissionReportStatus.posted) ...[
            const Gap.sm(),
            Text(
              bypass == null ? context.l10n.checkInConfirmedByOtp : context.l10n.checkInConfirmedByManager(bypass),
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
