import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/maintenance/maintenance_issue_widgets.dart';
import '../../domain/entities/damaged_item.dart';
import '../../domain/entities/issue_draft.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/damaged_items_provider.dart';
import 'submission_widgets.dart';

const int _maxIssuePhotos = 20;

class IssuesCard extends StatelessWidget {
  const IssuesCard({
    required this.issues,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
    this.error,
    super.key,
  });

  final List<IssueDraft> issues;
  final List<DamagedItem> items;
  final VoidCallback onAdd;
  final ValueChanged<IssueDraft> onEdit;
  final ValueChanged<IssueDraft> onRemove;
  final String? error;

  String? _charge(AppL10n l10n, IssueDraft issue) {
    final String? findingId = issue.penaltyFindingId;
    if (findingId == null) return null;
    final DamagedItem? item = items.where((entry) => entry.findingId == findingId).firstOrNull;
    return item == null ? l10n.issueChargeLinked : l10n.issueChargeLine(item.part.name);
  }

  @override
  Widget build(BuildContext context) {
    final String? error = this.error;
    return ModuleCard(
      title: context.l10n.submissionIssues,
      leading: const IconTile(icon: Icons.report_problem_rounded, tone: AppColors.warning, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.submissionIssuesHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.sm(),
          if (issues.isEmpty)
            Text(
              context.l10n.submissionNoIssues,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.textMuted),
            )
          else
            for (final (int i, IssueDraft issue) in issues.indexed) ...[
              MaintenanceIssueRow(
                category: issue.category,
                description: issue.description,
                status: issue.status,
                photoCount: issue.photoIds.length,
                requiredParts: issue.requiredParts,
                charge: _charge(context.l10n, issue),
                onTap: () => onEdit(issue),
                onRemove: issue.isSaved ? null : () => onRemove(issue),
              ),
              if (i != issues.length - 1) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
            ],
          if (error != null) ...[const Gap.sm(), _ErrorText(error)],
          const Gap.md(),
          GhostButton(label: context.l10n.submissionAddIssue, icon: Icons.add_rounded, onPressed: onAdd),
        ],
      ),
    );
  }
}

class IssueSheet extends ConsumerStatefulWidget {
  const IssueSheet({required this.submission, this.initial, super.key});

  final VehicleSubmissionDto submission;
  final IssueDraft? initial;

  static Future<IssueDraft?> show(
    BuildContext context, {
    required VehicleSubmissionDto submission,
    IssueDraft? initial,
  }) => AppSheet.show<IssueDraft>(
    context,
    title: initial == null ? context.l10n.submissionNewIssue : context.l10n.submissionEditIssue,
    maxHeightFactor: 0.92,
    child: IssueSheet(submission: submission, initial: initial),
  );

  @override
  ConsumerState<IssueSheet> createState() => _IssueSheetState();
}

class _IssueSheetState extends ConsumerState<IssueSheet> {
  late MaintenanceIssueCategory? _category = widget.initial?.category;
  late MaintenanceIssueStatus _status = widget.initial?.status ?? MaintenanceIssueStatus.open;
  late final TextEditingController _description = TextEditingController(text: widget.initial?.description);
  late final TextEditingController _parts = TextEditingController(text: widget.initial?.requiredParts);
  late final Set<String> _photoIds = {...?widget.initial?.photoIds};
  late String? _findingId = widget.initial?.penaltyFindingId;
  final List<String> _taken = [];
  final List<File> _uploading = [];
  bool _showErrors = false;

  @override
  void dispose() {
    _description.dispose();
    _parts.dispose();
    super.dispose();
  }

  bool _atPhotoLimit() {
    if (_photoIds.length < _maxIssuePhotos) return false;
    AppSnack.warning(context, context.l10n.submissionEvidenceLimit(_maxIssuePhotos));
    return true;
  }

  void _togglePhoto(String id) {
    if (_photoIds.contains(id)) {
      setState(() => _photoIds.remove(id));
    } else if (!_atPhotoLimit()) {
      setState(() => _photoIds.add(id));
    }
  }

  Future<void> _takePhoto() async {
    if (_atPhotoLimit()) return;
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() => _uploading.add(file));
    final Result<RemotePhoto> result = await ref.read(uploadSubmissionPhotoProvider)(
      UploadSubmissionPhotoParams(
        inspectionId: widget.submission.inspectionId,
        photoType: '$damagePhotoPrefix${DateTime.now().millisecondsSinceEpoch}',
        file: file,
      ),
    );
    if (!mounted) return;
    setState(() {
      _uploading.remove(file);
      if (result case Ok<RemotePhoto>(:final value)) {
        _taken.add(value.id);
        _photoIds.add(value.id);
      }
    });
    if (result case Err<RemotePhoto>(:final failure)) AppSnack.error(context, failure.message);
  }

  void _save() {
    final MaintenanceIssueCategory? category = _category;
    final String description = _description.text.trim();
    if (category == null || description.isEmpty || _photoIds.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    final String parts = _parts.text.trim();
    Navigator.of(context).pop(
      IssueDraft(
        key: widget.initial?.key ?? 'new-${DateTime.now().microsecondsSinceEpoch}',
        issueId: widget.initial?.issueId,
        category: category,
        description: description,
        status: _status,
        photoIds: List.unmodifiable(_photoIds),
        requiredParts: parts.isEmpty ? null : parts,
        penaltyFindingId: _findingId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final MaintenanceIssueCategory? category = _category;
    final bool uploading = _uploading.isNotEmpty;
    final int damagePhotos = widget.submission.photos
        .where((photo) => photo.photoType.startsWith(damagePhotoPrefix))
        .length;
    final List<DamagedItem> items = ref.watch(damagedItemsProvider(widget.submission.id));
    final String? findingId = _findingId;
    final bool earlierCharge = findingId != null && !items.any((item) => item.findingId == findingId);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupLabel(l10n.submissionIssueCategory),
          const Gap.sm(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final MaintenanceIssueCategory option in MaintenanceIssueCategory.values)
                _ChoicePill(
                  label: issueCategoryLabel(l10n, option),
                  icon: issueCategoryIcon(option),
                  selected: option == category,
                  onTap: () => setState(() => _category = option),
                ),
            ],
          ),
          if (_showErrors && category == null) ...[const Gap.xs(), _ErrorText(l10n.submissionIssueCategoryNeeded)],
          const Gap.lg(),
          AppTextField(
            label: l10n.submissionIssueDescription,
            required: true,
            controller: _description,
            maxLines: 3,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            errorText: _showErrors && _description.text.trim().isEmpty ? l10n.submissionIssueDescriptionNeeded : null,
            onChanged: (_) {
              if (_showErrors) setState(() {});
            },
          ),
          const Gap.md(),
          GroupLabel(l10n.submissionIssueProgress),
          const Gap.sm(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final MaintenanceIssueStatus option in MaintenanceIssueStatus.values)
                _ChoicePill(
                  label: issueStatusLabel(l10n, option),
                  selected: option == _status,
                  onTap: () => setState(() => _status = option),
                ),
            ],
          ),
          const Gap.lg(),
          AppTextField(
            label: l10n.submissionIssueParts,
            controller: _parts,
            hint: l10n.submissionIssuePartsHint,
            maxLines: 2,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
          ),
          const Gap.md(),
          if (earlierCharge) ...[
            GroupLabel(l10n.submissionIssueCharge),
            const Gap.xs(),
            Text(l10n.submissionIssueChargeEarlier, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
            const Gap.lg(),
          ] else if (items.isNotEmpty) ...[
            GroupLabel(l10n.submissionIssueCharge),
            const Gap.xs(),
            Text(l10n.submissionIssueChargeHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
            const Gap.sm(),
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                _ChoicePill(
                  label: l10n.submissionIssueNoCharge,
                  selected: findingId == null,
                  onTap: () => setState(() => _findingId = null),
                ),
                for (final DamagedItem item in items)
                  _ChoicePill(
                    label: item.part.name,
                    icon: Icons.receipt_long_rounded,
                    selected: item.findingId == findingId,
                    onTap: () => setState(() => _findingId = item.findingId),
                  ),
              ],
            ),
            const Gap.lg(),
          ],
          GroupLabel(l10n.submissionEvidence),
          const Gap.xs(),
          Text(l10n.submissionIssuePhotosHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
          const Gap.md(),
          Wrap(
            spacing: Insets.sm,
            runSpacing: Insets.sm,
            children: [
              for (final (SubmissionPhotoDto photo, String label) in labelledSubmissionPhotos(l10n, widget.submission))
                EvidenceChip(label: label, selected: _photoIds.contains(photo.id), onTap: () => _togglePhoto(photo.id)),
              for (final (int i, String id) in _taken.indexed)
                EvidenceChip(
                  label: '${l10n.submissionPhotoDamage} ${damagePhotos + i + 1}',
                  selected: _photoIds.contains(id),
                  onTap: () => _togglePhoto(id),
                ),
              _AddPhotoChip(uploading: uploading, onTap: uploading ? null : _takePhoto),
            ],
          ),
          if (_showErrors && _photoIds.isEmpty) ...[const Gap.xs(), _ErrorText(l10n.submissionIssuePhotoNeeded)],
          const Gap.lg(),
          PrimaryButton(
            label: l10n.submissionSaveIssue,
            icon: Icons.check_rounded,
            loading: uploading,
            onPressed: uploading ? null : _save,
          ),
          const Gap.md(),
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.selected, required this.onTap, this.icon});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color tone = selected ? AppColors.primary : AppColors.textSecondary;
    final IconData? icon = this.icon;
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
            if (icon != null) ...[Icon(icon, size: 15, color: tone), const SizedBox(width: Insets.xs + 2)],
            Text(label, style: AppText.titleSmall.copyWith(fontSize: 12.5, color: tone)),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoChip extends StatelessWidget {
  const _AddPhotoChip({required this.uploading, required this.onTap});

  final bool uploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (uploading)
              const SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              )
            else
              const Icon(Icons.add_a_photo_rounded, size: 15, color: AppColors.primary),
            const SizedBox(width: Insets.xs + 2),
            Text(
              context.l10n.commonAddPhoto,
              style: AppText.titleSmall.copyWith(fontSize: 12.5, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12));
  }
}
