import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/damaged_item.dart';
import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/damaged_items_provider.dart';
import '../providers/submission_providers.dart';
import 'submission_widgets.dart';

const int _maxItemPhotos = 20;
const int _maxQuantity = 20;

bool _damageable(PenaltyPriceDto part) => part.isSpare || part.category == PenaltyCategory.damage;

class DamagedItemsCard extends ConsumerWidget {
  const DamagedItemsCard({required this.submission, super.key});

  final VehicleSubmissionDto submission;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final PenaltyPriceDto? part = await SparePartPicker.show(
      context,
      submissionId: submission.id,
      addedIds: {for (final DamagedItem item in ref.read(damagedItemsProvider(submission.id))) item.part.id},
    );
    if (part == null || !context.mounted) return;
    final DamagedItem? existing = ref
        .read(damagedItemsProvider(submission.id))
        .where((item) => item.part.id == part.id)
        .firstOrNull;
    await _edit(context, ref, part, existing);
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, PenaltyPriceDto part, DamagedItem? initial) async {
    final DamagedItem? item = await DamagedItemSheet.show(
      context,
      inspectionId: submission.inspectionId,
      part: part,
      initial: initial,
    );
    if (!context.mounted) return;
    ref.invalidate(submissionProvider(submission.id));
    if (item != null) ref.read(damagedItemsProvider(submission.id).notifier).save(item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<DamagedItem> items = ref.watch(damagedItemsProvider(submission.id));
    return ModuleCard(
      title: context.l10n.submissionDamagedItems,
      leading: const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.submissionDamagedItemsHint,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          if (items.isNotEmpty) ...[
            const Gap.sm(),
            DamagedItemList(
              items: items,
              onTap: (item) => _edit(context, ref, item.part, item),
              onRemove: (item) => ref.read(damagedItemsProvider(submission.id).notifier).remove(item.part.id),
            ),
            ChargesTotal(total: items.fold<num>(0, (sum, item) => sum + item.amount)),
          ],
          const Gap.md(),
          GhostButton(
            label: context.l10n.submissionAddDamagedItem,
            icon: Icons.add_rounded,
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
    );
  }
}

class DamagedItemList extends StatelessWidget {
  const DamagedItemList({required this.items, this.showPhotos = false, this.onTap, this.onRemove, super.key});

  final List<DamagedItem> items;
  final bool showPhotos;
  final ValueChanged<DamagedItem>? onTap;
  final ValueChanged<DamagedItem>? onRemove;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<DamagedItem>? onTap = this.onTap;
    final ValueChanged<DamagedItem>? onRemove = this.onRemove;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (int i, DamagedItem item) in items.indexed) ...[
          PenaltyLineRow(
            description: item.part.name,
            details: item.note,
            missing: false,
            quantity: item.quantity,
            evidenceCount: item.photos.length,
            amount: item.amount,
            onTap: onTap == null ? null : () => onTap(item),
            onRemove: onRemove == null ? null : () => onRemove(item),
          ),
          if (showPhotos && item.photos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 34 + Insets.md, bottom: Insets.sm),
              child: Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final DamagePhoto photo in item.photos)
                    Pressable(
                      onTap: () => PhotoViewer.showImage(context, FileImage(photo.file)),
                      scale: 0.96,
                      child: ClipRRect(
                        borderRadius: Corners.brMd,
                        child: Image.file(photo.file, width: 56, height: 56, fit: BoxFit.cover, cacheWidth: 168),
                      ),
                    ),
                ],
              ),
            ),
          if (i != items.length - 1) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        ],
      ],
    );
  }
}

class SparePartPicker extends ConsumerStatefulWidget {
  const SparePartPicker({required this.submissionId, required this.addedIds, super.key});

  final String submissionId;
  final Set<String> addedIds;

  static Future<PenaltyPriceDto?> show(
    BuildContext context, {
    required String submissionId,
    required Set<String> addedIds,
  }) => AppSheet.show<PenaltyPriceDto>(
    context,
    title: context.l10n.submissionChooseSparePart,
    subtitle: context.l10n.submissionChooseSparePartHint,
    maxHeightFactor: 0.9,
    child: SparePartPicker(submissionId: submissionId, addedIds: addedIds),
  );

  @override
  ConsumerState<SparePartPicker> createState() => _SparePartPickerState();
}

class _SparePartPickerState extends ConsumerState<SparePartPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PenaltyPriceDto>> prices = ref.watch(penaltyPricesProvider(widget.submissionId));
    final List<PenaltyPriceDto>? all = prices.value?.where(_damageable).toList(growable: false);
    final String query = _search.toLowerCase();
    final List<PenaltyPriceDto> parts = [
      for (final PenaltyPriceDto part in all ?? const <PenaltyPriceDto>[])
        if (query.isEmpty || part.name.toLowerCase().contains(query) || part.code.toLowerCase().contains(query)) part,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(
          hint: context.l10n.submissionSearchSpareParts,
          onChanged: (value) => setState(() => _search = value.trim()),
        ),
        const Gap.lg(),
        if (all == null && prices.hasError)
          EmptyState(
            title: context.l10n.submissionCouldNotLoadParts,
            message: prices.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(penaltyPricesProvider(widget.submissionId)),
            compact: true,
          )
        else if (all == null)
          for (int i = 0; i < 5; i++) ...[const ShimmerBox(height: 64, borderRadius: Corners.brLg), const Gap.sm()]
        else if (all.isEmpty)
          Text(
            context.l10n.submissionNoPrices,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
          )
        else if (parts.isEmpty)
          EmptyState(title: context.l10n.submissionNoSparePartMatch, icon: Icons.search_off_rounded, compact: true)
        else
          for (final PenaltyPriceDto part in parts) ...[
            AppRadioTile(
              selected: widget.addedIds.contains(part.id),
              onTap: () => Navigator.of(context).pop(part),
              title: part.name,
              subtitle: '${Fmt.money(part.amount, paise: true)} · ${part.code}',
              trailing: part.evidenceRequired
                  ? const Icon(Icons.photo_camera_rounded, size: 18, color: AppColors.textMuted)
                  : null,
            ),
            const Gap.sm(),
          ],
        const Gap.sm(),
      ],
    );
  }
}

class DamagedItemSheet extends ConsumerStatefulWidget {
  const DamagedItemSheet({required this.inspectionId, required this.part, this.initial, super.key});

  final String inspectionId;
  final PenaltyPriceDto part;
  final DamagedItem? initial;

  static Future<DamagedItem?> show(
    BuildContext context, {
    required String inspectionId,
    required PenaltyPriceDto part,
    DamagedItem? initial,
  }) => AppSheet.show<DamagedItem>(
    context,
    title: part.name,
    subtitle: '${part.code} · ${Fmt.money(part.amount, paise: true)}',
    maxHeightFactor: 0.92,
    child: DamagedItemSheet(inspectionId: inspectionId, part: part, initial: initial),
  );

  @override
  ConsumerState<DamagedItemSheet> createState() => _DamagedItemSheetState();
}

class _DamagedItemSheetState extends ConsumerState<DamagedItemSheet> {
  late final TextEditingController _note = TextEditingController(text: widget.initial?.note);
  late int _quantity = widget.initial?.quantity ?? 1;
  late final List<DamagePhoto> _photos = [...?widget.initial?.photos];
  final List<File> _uploading = [];
  String? _error;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() {
      _error = null;
      _uploading.add(file);
    });
    final Result<RemotePhoto> result = await ref.read(uploadSubmissionPhotoProvider)(
      UploadSubmissionPhotoParams(
        inspectionId: widget.inspectionId,
        photoType: '$damagePhotoPrefix${DateTime.now().millisecondsSinceEpoch}',
        file: file,
      ),
    );
    if (!mounted) return;
    setState(() {
      _uploading.remove(file);
      if (result case Ok<RemotePhoto>(:final value)) _photos.add(DamagePhoto(id: value.id, file: file));
    });
    if (result case Err<RemotePhoto>(:final failure)) AppSnack.error(context, failure.message);
  }

  Future<void> _openPhoto(DamagePhoto photo) async {
    final bool? remove = await AppSheet.show<bool>(
      context,
      title: context.l10n.submissionPhotoDamage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppNavTile(
            title: context.l10n.submissionViewPhoto,
            icon: Icons.visibility_rounded,
            onTap: () => Navigator.of(context).pop(false),
          ),
          AppNavTile(
            title: context.l10n.submissionRemovePhoto,
            icon: Icons.delete_outline_rounded,
            iconColor: AppColors.danger,
            onTap: () => Navigator.of(context).pop(true),
          ),
          const Gap.md(),
        ],
      ),
    );
    if (remove == null || !mounted) return;
    if (remove) {
      setState(() => _photos.remove(photo));
    } else {
      await PhotoViewer.showImage(context, FileImage(photo.file));
    }
  }

  void _save() {
    if (widget.part.evidenceRequired && _photos.isEmpty) {
      setState(() => _error = context.l10n.submissionItemPhotoNeeded);
      return;
    }
    Navigator.of(context).pop(
      DamagedItem(
        findingId: widget.initial?.findingId ?? newUuid(),
        part: widget.part,
        quantity: _quantity,
        note: _note.text.trim(),
        photos: List.unmodifiable(_photos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PenaltyPriceDto part = widget.part;
    final bool uploading = _uploading.isNotEmpty;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GroupLabel(context.l10n.submissionEvidence),
          const Gap.xs(),
          Text(
            part.evidenceRequired
                ? context.l10n.submissionItemPhotoRequiredHint
                : context.l10n.submissionItemPhotoOptionalHint,
            style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45),
          ),
          const Gap.md(),
          SubmissionPhotoGrid(
            children: [
              for (final (int i, DamagePhoto photo) in _photos.indexed)
                SubmissionPhotoTile(
                  label: '${context.l10n.submissionPhotoDamage} ${i + 1}',
                  captured: true,
                  required: false,
                  uploading: false,
                  file: photo.file,
                  onTap: uploading ? null : () => _openPhoto(photo),
                ),
              for (final File file in _uploading)
                SubmissionPhotoTile(
                  label: context.l10n.submissionPhotoDamage,
                  captured: true,
                  required: false,
                  uploading: true,
                  file: file,
                  onTap: null,
                ),
              if (_photos.length + _uploading.length < _maxItemPhotos)
                PhotoSlot(
                  label: context.l10n.commonAddPhoto,
                  icon: Icons.add_a_photo_rounded,
                  required: part.evidenceRequired && _photos.isEmpty,
                  onTap: _addPhoto,
                ),
            ],
          ),
          const Gap.lg(),
          Row(
            children: [
              Expanded(child: Text(context.l10n.submissionQuantity, style: AppText.titleSmall)),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded),
                color: AppColors.primary,
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              ),
              SizedBox(
                width: 32,
                child: Text('$_quantity', textAlign: TextAlign.center, style: AppText.titleMedium),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded),
                color: AppColors.primary,
                onPressed: _quantity < _maxQuantity ? () => setState(() => _quantity++) : null,
              ),
            ],
          ),
          Text(
            '${context.l10n.commonTotal}: ${Fmt.money(part.amount * _quantity, paise: true)}',
            textAlign: TextAlign.end,
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
          ),
          const Gap.md(),
          AppTextField(
            label: context.l10n.submissionItemNote,
            controller: _note,
            hint: context.l10n.submissionItemNoteHint,
            maxLines: 3,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
          ),
          if (_error case final String error) ...[
            const Gap.md(),
            Text(error, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
          ],
          const Gap.lg(),
          PrimaryButton(
            label: context.l10n.submissionSaveItem,
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
