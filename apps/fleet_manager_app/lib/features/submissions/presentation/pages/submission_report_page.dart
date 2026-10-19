import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/maintenance/maintenance_issue_widgets.dart';
import '../../domain/entities/damaged_item.dart';
import '../../domain/entities/issue_draft.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/damaged_items_provider.dart';
import '../providers/submission_providers.dart';
import '../widgets/damaged_items.dart';
import '../widgets/issue_editor.dart';
import '../widgets/submission_widgets.dart';

const int _maxReportEvidence = 40;
const int _maxUnsafeReason = 500;

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

  MaintenanceFleetStatus? _status;
  Set<String>? _evidence;
  List<IssueDraft>? _issues;
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

  List<IssueDraft> _issuesFor(VehicleSubmissionDto submission) =>
      _issues ?? [for (final MaintenanceIssueDto issue in submission.maintenanceIssues) IssueDraft.fromDto(issue)];

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

  Future<void> _openIssue(VehicleSubmissionDto submission, [IssueDraft? initial]) async {
    final IssueDraft? saved = await IssueSheet.show(context, submission: submission, initial: initial);
    if (!mounted) return;
    ref.invalidate(submissionProvider(submission.id));
    if (saved == null) return;
    final List<IssueDraft> current = _issuesFor(submission);
    setState(
      () => _issues = [
        for (final IssueDraft issue in current) issue.key == saved.key ? saved : issue,
        if (!current.any((issue) => issue.key == saved.key)) saved,
      ],
    );
  }

  void _removeIssue(VehicleSubmissionDto submission, IssueDraft removed) {
    setState(
      () => _issues = [
        for (final IssueDraft issue in _issuesFor(submission))
          if (issue.key != removed.key) issue,
      ],
    );
  }

  String? _issueProblem(MaintenanceFleetStatus? status, List<IssueDraft> issues) {
    final AppL10n l10n = context.l10n;
    return switch (status) {
      null => null,
      MaintenanceFleetStatus.available =>
        issues.every((issue) => issue.status.isResolved) ? null : l10n.submissionAvailableNeedsResolved,
      _ when issues.isEmpty => l10n.submissionStatusNeedsIssue,
      MaintenanceFleetStatus.awaitingParts when !issues.any((issue) => issue.waitsForParts) =>
        l10n.submissionAwaitingPartsNeedsParts,
      _ => null,
    };
  }

  String _statusHint(MaintenanceFleetStatus status) => switch (status) {
    MaintenanceFleetStatus.available => context.l10n.submissionStatusAvailableHint,
    MaintenanceFleetStatus.maintenance => context.l10n.submissionStatusMaintenanceHint,
    MaintenanceFleetStatus.broken => context.l10n.submissionStatusBrokenHint,
    MaintenanceFleetStatus.awaitingParts => context.l10n.submissionStatusAwaitingPartsHint,
  };

  Future<void> _save(VehicleSubmissionDto submission) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final String mechanic = _mechanic.text.trim();
    final String summary = _summary.text.trim();
    final String notes = _unsafe.text.trim();
    final MaintenanceFleetStatus? status = _status;
    final Set<String> evidence = _evidenceFor(submission);
    final List<IssueDraft> issues = _issuesFor(submission);
    final List<DamagedItem> items = ref.read(damagedItemsProvider(submission.id));
    if (mechanic.isEmpty ||
        summary.isEmpty ||
        status == null ||
        evidence.isEmpty ||
        _issueProblem(status, issues) != null) {
      setState(() => _showErrors = true);
      return;
    }
    final String reason = notes.isNotEmpty ? notes : issues.map((issue) => issue.description).join('; ');
    setState(() => _saving = true);
    final Result<void> result = await ref.read(recordSubmissionReportProvider)(
      RecordReportParams(
        id: submission.id,
        idempotencyKey: _idempotencyKey,
        input: SubmissionReportInput(
          stage: submission.isConfirmed ? SubmissionStage.deep : SubmissionStage.basic,
          mechanicName: mechanic,
          summary: summary,
          fleetStatus: status,
          unsafeReason: status.isAvailable
              ? null
              : (reason.length > _maxUnsafeReason ? reason.substring(0, _maxUnsafeReason) : reason),
          checksComplete: true,
          evidencePhotoIds: [
            for (final SubmissionPhotoDto photo in submission.photos)
              if (evidence.contains(photo.id)) photo.id,
          ],
          issues: [for (final IssueDraft issue in issues) issue.toInput()],
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
    final MaintenanceFleetStatus? status = _status;
    final List<IssueDraft> issues = _issuesFor(submission);
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
              for (final MaintenanceFleetStatus option in MaintenanceFleetStatus.values) ...[
                AppRadioTile(
                  selected: status == option,
                  onTap: () => setState(() => _status = option),
                  title: fleetConditionLabel(context.l10n, option),
                  subtitle: _statusHint(option),
                  leading: IconTile(icon: fleetConditionIcon(option), tone: fleetConditionTone(option).color, size: 36),
                ),
                if (option != MaintenanceFleetStatus.values.last) const Gap.sm(),
              ],
              if (status != null && !status.isAvailable) ...[
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
        IssuesCard(
          issues: issues,
          items: ref.watch(damagedItemsProvider(submission.id)),
          onAdd: () => _openIssue(submission),
          onEdit: (issue) => _openIssue(submission, issue),
          onRemove: (issue) => _removeIssue(submission, issue),
          error: _showErrors ? _issueProblem(status, issues) : null,
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
              for (final (SubmissionPhotoDto photo, String label) in labelledSubmissionPhotos(context.l10n, submission))
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
