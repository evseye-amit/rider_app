import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/submission_providers.dart';
import '../widgets/submission_widgets.dart';

class SubmissionPage extends ConsumerStatefulWidget {
  const SubmissionPage({required this.submissionId, super.key});

  final String submissionId;

  @override
  ConsumerState<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends ConsumerState<SubmissionPage> {
  final Map<String, File> _local = {};
  final Set<String> _uploading = {};
  final List<String> _pendingExtra = [];
  bool _busy = false;

  Future<void> _refresh() =>
      ref.refresh(submissionProvider(widget.submissionId).future).then<void>((_) {}, onError: (_) {});

  Future<void> _capture(VehicleSubmissionDto submission, String photoType, {bool extra = false}) async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() {
      _uploading.add(photoType);
      if (extra && !_pendingExtra.contains(photoType)) _pendingExtra.add(photoType);
    });
    final Result<RemotePhoto> result = await ref.read(uploadSubmissionPhotoProvider)(
      UploadSubmissionPhotoParams(inspectionId: submission.inspectionId, photoType: photoType, file: file),
    );
    if (!mounted) return;
    setState(() {
      _uploading.remove(photoType);
      if (result.isOk) {
        _local[photoType] = file;
      } else if (extra) {
        _pendingExtra.remove(photoType);
      }
    });
    if (result case Err<RemotePhoto>(:final failure)) {
      AppSnack.error(context, failure.message);
      return;
    }
    await _refresh();
  }

  Future<void> _view(VehicleSubmissionDto submission, String photoType) async {
    final File? file = _local[photoType];
    if (file != null) {
      await PhotoViewer.showImage(context, FileImage(file));
      return;
    }
    final SubmissionPhotoDto? photo = submission.photoFor(photoType);
    if (photo == null) return;
    final Result<String> url = await ref.read(getSubmissionPhotoUrlProvider)(
      SubmissionPhotoParams(id: submission.id, photoId: photo.id),
    );
    if (!mounted) return;
    switch (url) {
      case Ok<String>(:final value) when value.isNotEmpty:
        await PhotoViewer.show(context, value);
      case _:
        AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
    }
  }

  Future<void> _openCaptured(VehicleSubmissionDto submission, String photoType, {required bool canRetake}) async {
    if (!canRetake) return _view(submission, photoType);
    final bool? retake = await AppSheet.show<bool>(
      context,
      title: submissionPhotoLabel(context.l10n, photoType, submission.assets),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppNavTile(
            title: context.l10n.submissionViewPhoto,
            icon: Icons.visibility_rounded,
            onTap: () => Navigator.of(context).pop(false),
          ),
          AppNavTile(
            title: context.l10n.commonRetake,
            icon: Icons.photo_camera_rounded,
            onTap: () => Navigator.of(context).pop(true),
          ),
          const Gap.md(),
        ],
      ),
    );
    if (retake == null || !mounted) return;
    if (retake) {
      await _capture(submission, photoType);
    } else {
      await _view(submission, photoType);
    }
  }

  Future<void> _record() async {
    await context.push<bool>('${Routes.submissionReport}?id=${widget.submissionId}');
    await _refresh();
  }

  Future<void> _collect() async {
    await context.push<bool>('${Routes.submissionConfirm}?id=${widget.submissionId}');
    await _refresh();
  }

  Future<void> _impose(SubmissionReportDto report) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.submissionImposeTitle,
      message: context.l10n.submissionImposeBody,
      confirmLabel: context.l10n.submissionImpose,
      icon: Icons.gavel_rounded,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final Result<void> result = await ref.read(imposeSubmissionReportProvider)(report.id);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.submissionImposed);
        await _refresh();
        if (mounted) await _collect();
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
        await _refresh();
    }
  }

  Future<void> _cancel(SubmissionReportDto report) async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await AppSheet.show<String>(
      context,
      title: context.l10n.submissionCancelReportTitle,
      subtitle: context.l10n.submissionCancelReportHint,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AppTextField(
          label: context.l10n.submissionCancelReason,
          maxLines: 3,
          maxLength: 500,
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      footer: Builder(
        builder: (sheet) => PrimaryButton(
          label: context.l10n.submissionCancelReport,
          icon: Icons.close_rounded,
          fillColor: AppColors.danger,
          onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
        ),
      ),
    );
    controller.dispose();
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.submissionCancelReasonNeeded);
      return;
    }
    setState(() => _busy = true);
    final Result<void> result = await ref.read(cancelSubmissionReportProvider)(
      CancelReportParams(reportId: report.id, reason: reason),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.submissionReportCancelled);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  List<String> _missing(VehicleSubmissionDto submission) => [
    for (final String type in submission.missingPhotoTypes)
      if (!_local.containsKey(type)) type,
  ];

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VehicleSubmissionDto> detail = ref.watch(submissionProvider(widget.submissionId));
    final VehicleSubmissionDto? submission = detail.value;

    if (submission == null) {
      return AppScaffold(
        title: context.l10n.checkInTitle,
        body: detail.hasError
            ? EmptyState(
                title: context.l10n.submissionCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(submissionProvider(widget.submissionId)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 150, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 90, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 260, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    final SubmissionReportDto? open = submission.openReport;
    final List<String> missing = _missing(submission);
    final bool canCapture = submission.nextAction == SubmissionNextAction.capturePhotos;

    return AppScaffold(
      title: context.l10n.checkInTitle,
      subtitle: submission.assets.vehicleNumber,
      footer: _footer(submission, open, missing),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _HeaderCard(submission: submission),
            const Gap.lg(),
            AccentCard(
              accent: submissionNextTone(submission.nextAction).color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusChip(
                    label: context.l10n.submissionNextLabel,
                    tone: submissionNextTone(submission.nextAction),
                    dense: true,
                    solid: true,
                  ),
                  const Gap.md(),
                  Text(
                    canCapture && missing.isEmpty
                        ? context.l10n.submissionNextReport
                        : submissionNextNote(context.l10n, submission),
                    style: AppText.bodyMedium.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const Gap.lg(),
            _requiredPhotos(submission, canRetake: canCapture),
            const Gap.lg(),
            _extraPhotos(submission),
            if (submission.reports.isNotEmpty) ...[
              const Gap.lg(),
              ModuleCard(
                title: context.l10n.submissionReports,
                leading: const IconTile(icon: Icons.assignment_rounded, solid: true, size: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final SubmissionReportDto report in submission.reports.reversed) ...[
                      SubmissionReportCard(report: report),
                      if (report != submission.reports.first) const Gap.md(),
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

  Widget? _footer(VehicleSubmissionDto submission, SubmissionReportDto? open, List<String> missing) {
    return switch (submission.nextAction) {
      SubmissionNextAction.capturePhotos => PrimaryButton(
        label: context.l10n.submissionRecordReport,
        icon: Icons.assignment_rounded,
        onPressed: missing.isEmpty && _uploading.isEmpty && !_busy ? _record : null,
      ),
      SubmissionNextAction.reviewAndImpose || SubmissionNextAction.collectOtps when open != null => Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: context.l10n.submissionCancelReport,
              size: AppButtonSize.medium,
              color: AppColors.danger,
              onPressed: _busy ? null : () => _cancel(open),
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: submission.nextAction == SubmissionNextAction.reviewAndImpose
                ? PrimaryButton(
                    label: context.l10n.submissionImpose,
                    icon: Icons.gavel_rounded,
                    size: AppButtonSize.medium,
                    loading: _busy,
                    onPressed: _busy ? null : () => _impose(open),
                  )
                : PrimaryButton(
                    label: context.l10n.submissionCollect,
                    icon: Icons.verified_user_rounded,
                    size: AppButtonSize.medium,
                    onPressed: _busy ? null : _collect,
                  ),
          ),
        ],
      ),
      SubmissionNextAction.deepCheck => PrimaryButton(
        label: context.l10n.submissionRecordFinal,
        icon: Icons.build_circle_rounded,
        onPressed: _busy || _uploading.isNotEmpty ? null : _record,
      ),
      SubmissionNextAction.reviewAndImpose || SubmissionNextAction.collectOtps || SubmissionNextAction.complete => null,
    };
  }

  Widget _requiredPhotos(VehicleSubmissionDto submission, {required bool canRetake}) {
    final Set<String> missing = submission.missingPhotoTypes.toSet();
    return ModuleCard(
      title: context.l10n.submissionPhotos,
      leading: const IconTile(icon: Icons.photo_camera_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.submissionPhotosHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.md(),
          SubmissionPhotoGrid(
            children: [
              for (final String type in submission.requiredPhotoTypes)
                SubmissionPhotoTile(
                  label: submissionPhotoLabel(context.l10n, type, submission.assets),
                  captured: !missing.contains(type) || _local.containsKey(type),
                  file: _local[type],
                  uploading: _uploading.contains(type),
                  onTap: !missing.contains(type) || _local.containsKey(type)
                      ? () => _openCaptured(submission, type, canRetake: canRetake)
                      : () => _capture(submission, type),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _extraPhotos(VehicleSubmissionDto submission) {
    final Set<String> required = submission.requiredPhotoTypes.toSet();
    final List<String> types = [
      for (final SubmissionPhotoDto photo in submission.photos)
        if (!required.contains(photo.photoType)) photo.photoType,
    ];
    final List<String> extra = [
      ...{...types, ..._pendingExtra},
    ];
    final bool canAdd = submission.nextAction != SubmissionNextAction.complete;
    if (extra.isEmpty && !canAdd) return const SizedBox.shrink();
    return ModuleCard(
      title: context.l10n.submissionExtraPhotos,
      leading: const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.submissionExtraPhotosHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.md(),
          SubmissionPhotoGrid(
            children: [
              for (final (int i, String type) in extra.indexed)
                SubmissionPhotoTile(
                  label: type.startsWith(damagePhotoPrefix)
                      ? '${context.l10n.submissionPhotoDamage} ${i + 1}'
                      : submissionPhotoLabel(context.l10n, type, submission.assets),
                  captured: true,
                  required: false,
                  file: _local[type],
                  uploading: _uploading.contains(type),
                  onTap: () => _view(submission, type),
                ),
              if (canAdd)
                PhotoSlot(
                  label: context.l10n.commonAddPhoto,
                  icon: Icons.add_a_photo_rounded,
                  required: false,
                  onTap: () =>
                      _capture(submission, '$damagePhotoPrefix${DateTime.now().millisecondsSinceEpoch}', extra: true),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.submission});

  final VehicleSubmissionDto submission;

  @override
  Widget build(BuildContext context) {
    final SubmissionAssets assets = submission.assets;
    final String? chassis = assets.chassisNumber;
    return ModuleCard(
      title: submission.riderName.isEmpty ? '—' : submission.riderName,
      leading: AppAvatar(name: submission.riderName.isEmpty ? '—' : submission.riderName, size: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(
            label: submission.source == SubmissionSource.returns
                ? context.l10n.submissionSourceReturn
                : context.l10n.submissionSourceExchange,
            tone: StatusTone.brand,
            icon: submission.source == SubmissionSource.returns
                ? Icons.assignment_return_rounded
                : Icons.published_with_changes_rounded,
            dense: true,
          ),
          const Gap.sm(),
          if (submission.riderMobile.isNotEmpty)
            KeyValueRow(
              label: context.l10n.commonMobile,
              value: Fmt.phone(submission.riderMobile),
              icon: Icons.call_rounded,
            ),
          KeyValueRow(
            label: context.l10n.commonVehicle,
            value: assets.vehicleNumber ?? '—',
            icon: Icons.electric_scooter_rounded,
          ),
          if (chassis != null)
            KeyValueRow(label: context.l10n.submissionChassis, value: chassis, icon: Icons.qr_code_rounded),
          KeyValueRow(
            label: context.l10n.checkInHub,
            value: submission.hubName.isEmpty ? '—' : submission.hubName,
            icon: Icons.store_rounded,
          ),
          KeyValueRow(
            label: context.l10n.submissionStartedAt,
            value: Fmt.dateTime(submission.createdAt),
            icon: Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }
}
