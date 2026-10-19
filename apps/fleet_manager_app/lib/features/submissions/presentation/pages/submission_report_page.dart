import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/damaged_item.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/damaged_items_provider.dart';
import '../providers/submission_providers.dart';
import '../widgets/damaged_items.dart';
import '../widgets/submission_widgets.dart';

const int _maxReportEvidence = 40;

List<(SubmissionPhotoDto, String)> _labelledPhotos(AppL10n l10n, VehicleSubmissionDto submission) {
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

class SubmissionReportPage extends ConsumerStatefulWidget {
  const SubmissionReportPage({required this.submissionId, super.key});

  final String submissionId;

  @override
  ConsumerState<SubmissionReportPage> createState() => _SubmissionReportPageState();
}

class _SubmissionReportPageState extends ConsumerState<SubmissionReportPage> {
  final String _idempotencyKey = newIdempotencyKey();
  final TextEditingController _mechanic = TextEditingController();
  final TextEditingController _summary = TextEditingController();
  final TextEditingController _unsafe = TextEditingController();

  _ScooterStatus? _status;
  Set<String>? _evidence;
  bool _saving = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _mechanic.dispose();
    _summary.dispose();
    _unsafe.dispose();
    super.dispose();
  }

  Set<String> _evidenceFor(VehicleSubmissionDto submission) =>
      _evidence ??
      {for (final SubmissionPhotoDto photo in submission.photos.reversed.take(_maxReportEvidence)) photo.id};

  void _toggleEvidence(VehicleSubmissionDto submission, String photoId) {
    final Set<String> next = {..._evidenceFor(submission)};
    if (!next.remove(photoId)) {
      if (next.length >= _maxReportEvidence) {
        AppSnack.warning(context, context.l10n.submissionEvidenceLimit(_maxReportEvidence));
        return;
      }
      next.add(photoId);
    }
    setState(() => _evidence = next);
  }

  Future<void> _save(VehicleSubmissionDto submission) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final String mechanic = _mechanic.text.trim();
    final String summary = _summary.text.trim();
    final String unsafe = _unsafe.text.trim();
    final _ScooterStatus? status = _status;
    final Set<String> evidence = _evidenceFor(submission);
    final List<DamagedItem> items = ref.read(damagedItemsProvider(submission.id));
    if (mechanic.isEmpty || summary.isEmpty || status == null || evidence.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _saving = true);
    final Result<void> result = await ref.read(recordSubmissionReportProvider)(
      RecordReportParams(
        id: submission.id,
        idempotencyKey: _idempotencyKey,
        input: SubmissionReportInput(
          stage: submission.isConfirmed ? SubmissionStage.deep : SubmissionStage.basic,
          mechanicName: mechanic,
          summary: summary,
          safeForReuse: status.safe,
          unsafeReason: status.safe ? null : [status.code, if (unsafe.isNotEmpty) unsafe].join(' — '),
          checksComplete: true,
          evidencePhotoIds: [
            for (final SubmissionPhotoDto photo in submission.photos)
              if (evidence.contains(photo.id)) photo.id,
          ],
          items: [for (final DamagedItem item in items) item.toInput()],
        ),
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok<void>():
        ref.read(damagedItemsProvider(submission.id).notifier).clear();
        AppSnack.success(context, context.l10n.submissionReportSaved);
        context.pop(true);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VehicleSubmissionDto> detail = ref.watch(submissionProvider(widget.submissionId));
    final VehicleSubmissionDto? submission = detail.value;
    final bool deep = submission?.isConfirmed ?? false;

    return AppScaffold(
      title: deep ? context.l10n.checkInDeepReport : context.l10n.checkInBasicReport,
      subtitle: submission?.assets.vehicleNumber,
      footer: submission == null
          ? null
          : PrimaryButton(
              label: context.l10n.submissionSaveReport,
              icon: Icons.save_rounded,
              loading: _saving,
              onPressed: _saving ? null : () => _save(submission),
            ),
      body: switch (submission) {
        final VehicleSubmissionDto value => _form(value),
        null when detail.hasError => EmptyState(
          title: context.l10n.submissionCouldNotLoad,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(submissionProvider(widget.submissionId)),
        ),
        null => const PageBody(
          children: [
            ShimmerBox(height: 220, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 180, borderRadius: Corners.brXl),
          ],
        ),
      },
    );
  }

  Widget _form(VehicleSubmissionDto submission) {
    final _ScooterStatus? status = _status;
    return PageBody(
      children: [
        ModuleCard(
          title: context.l10n.submissionFindings,
          leading: const IconTile(icon: Icons.engineering_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: context.l10n.submissionMechanicName,
                required: true,
                controller: _mechanic,
                maxLength: 150,
                textCapitalization: TextCapitalization.words,
                errorText: _showErrors && _mechanic.text.trim().isEmpty ? context.l10n.submissionNameNeeded : null,
                onChanged: (_) {
                  if (_showErrors) setState(() {});
                },
              ),
              const Gap.md(),
              AppTextField(
                label: context.l10n.submissionSummary,
                required: true,
                controller: _summary,
                hint: context.l10n.submissionSummaryHint,
                maxLines: 5,
                maxLength: 4000,
                textCapitalization: TextCapitalization.sentences,
                errorText: _showErrors && _summary.text.trim().isEmpty ? context.l10n.submissionSummaryNeeded : null,
                onChanged: (_) {
                  if (_showErrors) setState(() {});
                },
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.submissionSafeQuestion,
          leading: const IconTile(icon: Icons.health_and_safety_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (_ScooterStatus option, String title, String hint, IconData icon, Color tone) in [
                (
                  _ScooterStatus.umMajor,
                  context.l10n.submissionStatusUmMajor,
                  context.l10n.submissionStatusUmMajorHint,
                  Icons.car_repair_rounded,
                  AppColors.danger,
                ),
                (
                  _ScooterStatus.umMinor,
                  context.l10n.submissionStatusUmMinor,
                  context.l10n.submissionStatusUmMinorHint,
                  Icons.build_circle_rounded,
                  AppColors.warning,
                ),
                (
                  _ScooterStatus.mok,
                  context.l10n.submissionStatusMok,
                  context.l10n.submissionStatusMokHint,
                  Icons.verified_rounded,
                  AppColors.info,
                ),
                (
                  _ScooterStatus.rfd,
                  context.l10n.submissionStatusRfd,
                  context.l10n.submissionStatusRfdHint,
                  Icons.check_circle_rounded,
                  AppColors.success,
                ),
              ]) ...[
                AppRadioTile(
                  selected: status == option,
                  onTap: () => setState(() => _status = option),
                  title: title,
                  subtitle: hint,
                  leading: IconTile(icon: icon, tone: tone, size: 36),
                ),
                if (option != _ScooterStatus.rfd) const Gap.sm(),
              ],
              if (status != null && !status.safe) ...[
                const Gap.md(),
                AppTextField(
                  label: context.l10n.submissionMaintenanceDetails,
                  controller: _unsafe,
                  maxLines: 3,
                  maxLength: 480,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
              if (_showErrors && status == null) ...[
                const Gap.sm(),
                Text(
                  context.l10n.submissionSafetyNeeded,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        _summaryCard(submission),
      ],
    );
  }

  Widget _summaryCard(VehicleSubmissionDto submission) {
    final Set<String> evidence = _evidenceFor(submission);
    final List<DamagedItem> items = ref.watch(damagedItemsProvider(submission.id));
    return ModuleCard(
      title: context.l10n.submissionReportSummary,
      leading: const IconTile(icon: Icons.summarize_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.submissionReportSummaryHint,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          const Gap.lg(),
          GroupLabel(context.l10n.submissionEvidence),
          const Gap.xs(),
          Text(context.l10n.submissionEvidenceHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
          const Gap.md(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final (SubmissionPhotoDto photo, String label) in _labelledPhotos(context.l10n, submission))
                EvidenceChip(
                  label: label,
                  selected: evidence.contains(photo.id),
                  onTap: () => _toggleEvidence(submission, photo.id),
                ),
            ],
          ),
          if (_showErrors && evidence.isEmpty) ...[
            const Gap.sm(),
            Text(
              context.l10n.submissionEvidenceNeeded,
              style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
            ),
          ],
          const Gap.lg(),
          GroupLabel(context.l10n.submissionCharges),
          const Gap.xs(),
          if (items.isEmpty)
            Text(
              context.l10n.submissionNoDamagedItems,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
            )
          else ...[
            DamagedItemList(items: items, showPhotos: true),
            ChargesTotal(total: items.fold<num>(0, (sum, item) => sum + item.amount)),
          ],
        ],
      ),
    );
  }
}

enum _ScooterStatus {
  umMajor('UM major'),
  umMinor('UM minor'),
  mok('MOK'),
  rfd('RFD');

  const _ScooterStatus(this.code);

  final String code;

  bool get safe => this == mok || this == rfd;
}
