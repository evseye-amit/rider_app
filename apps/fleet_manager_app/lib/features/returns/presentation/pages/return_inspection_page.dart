import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/return_case.dart';
import '../../domain/usecases/return_desk_usecases.dart';
import '../../return_desk_dependencies.dart';
import '../providers/return_desk_providers.dart';
import '../widgets/return_desk_widgets.dart';

class ReturnInspectionPage extends ConsumerStatefulWidget {
  const ReturnInspectionPage({required this.inspectionId, this.vehicleLabel, super.key});

  final String inspectionId;
  final String? vehicleLabel;

  @override
  ConsumerState<ReturnInspectionPage> createState() => _ReturnInspectionPageState();
}

class _ReturnInspectionPageState extends ConsumerState<ReturnInspectionPage> {
  final Map<String, File> _local = {};
  final Set<String> _uploading = {};
  final List<String> _damageTypes = [];
  final TextEditingController _reason = TextEditingController();

  bool? _safe;
  bool _finishing = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _capture(String photoType, {bool damage = false}) async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() {
      _uploading.add(photoType);
      if (damage) _damageTypes.add(photoType);
    });
    final Result<InspectionPhoto> result = await ref.read(uploadInspectionPhotoProvider)(
      InspectionPhotoParams(inspectionId: widget.inspectionId, photoType: photoType, photo: file),
    );
    if (!mounted) return;
    setState(() {
      _uploading.remove(photoType);
      if (result.isOk) {
        _local[photoType] = file;
      } else if (damage) {
        _damageTypes.remove(photoType);
      }
    });
    if (result case Err<InspectionPhoto>(:final failure)) {
      AppSnack.error(context, failure.message);
      return;
    }
    await ref.refresh(inspectionSheetProvider(widget.inspectionId).future).then<void>((_) {}, onError: (_) {});
  }

  Future<void> _finish(InspectionSheet sheet) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final bool? safe = _safe;
    final String reason = _reason.text.trim();
    if (_missing(sheet).isNotEmpty || safe == null || (!safe && reason.isEmpty)) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _finishing = true);
    final Result<void> result = await ref.read(completeReturnInspectionProvider)(
      CompleteReturnInspectionParams(
        inspectionId: widget.inspectionId,
        safeForReuse: safe,
        unsafeReason: safe ? null : reason,
      ),
    );
    if (!mounted) return;
    setState(() => _finishing = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.returnDeskInspectionDone);
        context.pop(true);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Set<String> _uploaded(InspectionSheet sheet) => {
    for (final InspectionPhoto photo in sheet.photos) photo.photoType,
    ..._local.keys,
  };

  List<InspectionSlot> _missing(InspectionSheet sheet) {
    final Set<String> uploaded = _uploaded(sheet);
    return [
      for (final InspectionSlot slot in sheet.slots)
        if (slot.required && !uploaded.contains(slot.photoType)) slot,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<InspectionSheet> sheet = ref.watch(inspectionSheetProvider(widget.inspectionId));
    final InspectionSheet? value = sheet.value;

    return AppScaffold(
      title: context.l10n.returnDeskInspectTitle,
      subtitle: widget.vehicleLabel,
      footer: value == null
          ? null
          : PrimaryButton(
              label: context.l10n.returnDeskFinishInspection,
              icon: Icons.task_alt_rounded,
              loading: _finishing,
              onPressed: _finishing || _uploading.isNotEmpty ? null : () => _finish(value),
            ),
      body: switch (sheet) {
        _ when value != null => _form(value),
        AsyncError() => EmptyState(
          title: context.l10n.returnDeskCouldNotLoadInspection,
          message: sheet.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(inspectionSheetProvider(widget.inspectionId)),
        ),
        _ => const PageBody(
          children: [
            ShimmerBox(height: 220, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 160, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 160, borderRadius: Corners.brXl),
          ],
        ),
      },
    );
  }

  Widget _form(InspectionSheet sheet) {
    final Set<String> uploaded = _uploaded(sheet);
    final List<InspectionSlot> slots = [
      for (final InspectionSlot slot in sheet.slots)
        if (slot.photoType != checklistPhotoType && !slot.photoType.startsWith(damagePhotoPrefix)) slot,
    ];
    final bool checklistRequired = sheet.slots.any((slot) => slot.photoType == checklistPhotoType && slot.required);
    final List<String> damage = [
      for (final InspectionPhoto photo in sheet.photos)
        if (photo.photoType.startsWith(damagePhotoPrefix)) photo.photoType,
      for (final String type in _damageTypes)
        if (!sheet.photos.any((photo) => photo.photoType == type)) type,
    ];
    final List<InspectionSlot> missing = _missing(sheet);
    final bool? safe = _safe;

    return PageBody(
      children: [
        ModuleCard(
          title: context.l10n.returnDeskPhotos,
          leading: const IconTile(icon: Icons.photo_camera_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                slots.isEmpty ? context.l10n.returnDeskNoPhotoRules : context.l10n.returnDeskPhotosHint,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
              ),
              if (slots.isNotEmpty) ...[
                const Gap.md(),
                _Grid(
                  children: [
                    for (final InspectionSlot slot in slots)
                      _PhotoTile(
                        label: slot.label,
                        required: slot.required,
                        file: _local[slot.photoType],
                        uploaded: uploaded.contains(slot.photoType),
                        uploading: _uploading.contains(slot.photoType),
                        onTap: () => _capture(slot.photoType),
                      ),
                  ],
                ),
              ],
              if (_showErrors && missing.isNotEmpty) ...[
                const Gap.sm(),
                Text(
                  context.l10n.returnDeskPhotosMissing(missing.map((slot) => slot.label).join(', ')),
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnDeskChecklistPhoto,
          leading: const IconTile(icon: Icons.checklist_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.returnDeskChecklistHint,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
              ),
              const Gap.md(),
              _Grid(
                children: [
                  _PhotoTile(
                    label: context.l10n.returnDeskChecklistPhoto,
                    required: checklistRequired,
                    file: _local[checklistPhotoType],
                    uploaded: uploaded.contains(checklistPhotoType),
                    uploading: _uploading.contains(checklistPhotoType),
                    onTap: () => _capture(checklistPhotoType),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnDeskDamagePhotos,
          leading: const IconTile(icon: Icons.car_crash_rounded, tone: AppColors.danger, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.returnDeskDamageHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
              const Gap.md(),
              _Grid(
                children: [
                  for (final String type in damage)
                    _PhotoTile(
                      label: context.l10n.returnDeskDamagePhoto,
                      required: false,
                      file: _local[type],
                      uploaded: true,
                      uploading: _uploading.contains(type),
                      onTap: () => _capture(type),
                    ),
                  PhotoSlot(
                    label: context.l10n.commonAddPhoto,
                    icon: Icons.add_a_photo_rounded,
                    required: false,
                    onTap: () => _capture('$damagePhotoPrefix${DateTime.now().millisecondsSinceEpoch}', damage: true),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnDeskSafety,
          leading: const IconTile(icon: Icons.health_and_safety_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppRadioTile(
                selected: safe == true,
                onTap: () => setState(() => _safe = true),
                title: context.l10n.returnDeskSafeYes,
                subtitle: context.l10n.returnDeskSafeYesHint,
                leading: const IconTile(icon: Icons.check_circle_rounded, tone: AppColors.success, size: 36),
              ),
              const Gap.sm(),
              AppRadioTile(
                selected: safe == false,
                onTap: () => setState(() => _safe = false),
                title: context.l10n.returnDeskSafeNo,
                subtitle: context.l10n.returnDeskSafeNoHint,
                leading: const IconTile(icon: Icons.build_circle_rounded, tone: AppColors.danger, size: 36),
              ),
              if (safe == false) ...[
                const Gap.md(),
                AppTextField(
                  label: context.l10n.returnDeskUnsafeReason,
                  required: true,
                  controller: _reason,
                  maxLines: 3,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  errorText: _showErrors && _reason.text.trim().isEmpty
                      ? context.l10n.returnDeskUnsafeReasonNeeded
                      : null,
                  onChanged: (_) {
                    if (_showErrors) setState(() {});
                  },
                ),
              ],
              if (_showErrors && safe == null) ...[
                const Gap.sm(),
                Text(
                  context.l10n.returnDeskSafetyNeeded,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.children});

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

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.label,
    required this.required,
    required this.file,
    required this.uploaded,
    required this.uploading,
    required this.onTap,
  });

  final String label;
  final bool required;
  final File? file;
  final bool uploaded;
  final bool uploading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final File? local = file;
    final Widget tile = local == null
        ? PhotoSlot(
            label: label,
            captured: uploaded,
            required: required,
            onTap: uploading ? null : onTap,
            onRetake: uploading ? null : onTap,
          )
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
