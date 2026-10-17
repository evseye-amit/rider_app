import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/submission_usecases.dart';
import '../../submission_dependencies.dart';
import '../providers/submission_providers.dart';
import '../widgets/submission_widgets.dart';

const int _maxReportEvidence = 40;
const int _maxChargeEvidence = 20;
const int _maxQuantity = 20;

class _Charge {
  const _Charge({required this.price, required this.quantity, required this.details, required this.evidencePhotoIds});

  final PenaltyPriceDto price;
  final int quantity;
  final String details;
  final List<String> evidencePhotoIds;

  num get amount => price.amount * quantity;
}

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
  final List<_Charge> _charges = [];

  bool? _safe;
  bool _checksComplete = false;
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

  Future<void> _editCharge(VehicleSubmissionDto submission, List<PenaltyPriceDto> prices, {int? index}) async {
    final _Charge? charge = await AppSheet.show<_Charge>(
      context,
      title: index == null ? context.l10n.submissionAddCharge : context.l10n.submissionEditCharge,
      maxHeightFactor: 0.92,
      child: _ChargeForm(
        prices: prices,
        photos: _labelledPhotos(context.l10n, submission),
        initial: index == null ? null : _charges[index],
      ),
    );
    if (charge == null || !mounted) return;
    setState(() {
      if (index == null) {
        _charges.add(charge);
      } else {
        _charges[index] = charge;
      }
    });
  }

  Future<void> _save(VehicleSubmissionDto submission) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final String mechanic = _mechanic.text.trim();
    final String summary = _summary.text.trim();
    final String unsafe = _unsafe.text.trim();
    final bool? safe = _safe;
    final Set<String> evidence = _evidenceFor(submission);
    if (mechanic.isEmpty || summary.isEmpty || safe == null || (!safe && unsafe.isEmpty) || evidence.isEmpty) {
      setState(() => _showErrors = true);
      return;
    }
    if (_checksComplete) {
      final bool confirmed = await AppDialog.confirm(
        context,
        title: context.l10n.submissionChecksComplete,
        message: context.l10n.submissionChecksCompleteConfirm,
        confirmLabel: context.l10n.submissionSaveReport,
        icon: Icons.task_alt_rounded,
      );
      if (!confirmed || !mounted) return;
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
          safeForReuse: safe,
          unsafeReason: safe ? null : unsafe,
          checksComplete: _checksComplete,
          evidencePhotoIds: [
            for (final SubmissionPhotoDto photo in submission.photos)
              if (evidence.contains(photo.id)) photo.id,
          ],
          items: [
            for (final _Charge charge in _charges)
              SubmissionPenaltyInput(
                priceId: charge.price.id,
                quantity: charge.quantity,
                details: charge.details,
                evidencePhotoIds: charge.evidencePhotoIds,
              ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok<void>():
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
    final bool? safe = _safe;
    final Set<String> evidence = _evidenceFor(submission);
    final List<(SubmissionPhotoDto, String)> photos = _labelledPhotos(context.l10n, submission);
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
              AppRadioTile(
                selected: safe == true,
                onTap: () => setState(() => _safe = true),
                title: context.l10n.submissionSafeYes,
                subtitle: context.l10n.submissionSafeYesHint,
                leading: const IconTile(icon: Icons.check_circle_rounded, tone: AppColors.success, size: 36),
              ),
              const Gap.sm(),
              AppRadioTile(
                selected: safe == false,
                onTap: () => setState(() => _safe = false),
                title: context.l10n.submissionSafeNo,
                subtitle: context.l10n.submissionSafeNoHint,
                leading: const IconTile(icon: Icons.build_circle_rounded, tone: AppColors.danger, size: 36),
              ),
              if (safe == false) ...[
                const Gap.md(),
                AppTextField(
                  label: context.l10n.submissionUnsafeReason,
                  required: true,
                  controller: _unsafe,
                  maxLines: 3,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  errorText: _showErrors && _unsafe.text.trim().isEmpty
                      ? context.l10n.submissionUnsafeReasonNeeded
                      : null,
                  onChanged: (_) {
                    if (_showErrors) setState(() {});
                  },
                ),
              ],
              if (_showErrors && safe == null) ...[
                const Gap.sm(),
                Text(
                  context.l10n.submissionSafetyNeeded,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
              const Gap.md(),
              SwitchListTile.adaptive(
                value: _checksComplete,
                onChanged: (value) => setState(() => _checksComplete = value),
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.submissionChecksComplete, style: AppText.titleSmall),
                subtitle: Text(
                  context.l10n.submissionChecksCompleteHint,
                  style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.submissionEvidence,
          leading: const IconTile(icon: Icons.photo_library_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.submissionEvidenceHint,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
              ),
              const Gap.md(),
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final (SubmissionPhotoDto photo, String label) in photos)
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
            ],
          ),
        ),
        const Gap.lg(),
        _ChargesCard(
          charges: _charges,
          busy: _saving,
          onAdd: (prices) => _editCharge(submission, prices),
          onEdit: (prices, index) => _editCharge(submission, prices, index: index),
          onRemove: (index) => setState(() => _charges.removeAt(index)),
        ),
      ],
    );
  }
}

class _ChargesCard extends ConsumerWidget {
  const _ChargesCard({
    required this.charges,
    required this.busy,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  final List<_Charge> charges;
  final bool busy;
  final ValueChanged<List<PenaltyPriceDto>> onAdd;
  final void Function(List<PenaltyPriceDto> prices, int index) onEdit;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PenaltyPriceDto>> prices = ref.watch(penaltyPricesProvider);
    final List<PenaltyPriceDto> list = prices.value ?? const [];
    final num total = charges.fold<num>(0, (sum, charge) => sum + charge.amount);
    return ModuleCard(
      title: context.l10n.submissionCharges,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.submissionChargesHint, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
          const Gap.sm(),
          if (prices.hasError && list.isEmpty)
            Row(
              children: [
                Expanded(
                  child: Text(
                    prices.failureMessage ?? context.l10n.commonSomethingWentWrongPleaseTry,
                    style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                  ),
                ),
                GhostButton(
                  label: context.l10n.commonTryAgain,
                  dense: true,
                  onPressed: () => ref.invalidate(penaltyPricesProvider),
                ),
              ],
            )
          else if (prices.hasValue && list.isEmpty)
            Text(
              context.l10n.submissionNoPrices,
              style: AppText.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
            ),
          for (final (int i, _Charge charge) in charges.indexed) ...[
            PenaltyLineRow(
              description: charge.price.description,
              details: charge.details,
              missing: charge.price.category == PenaltyCategory.missingItem,
              quantity: charge.quantity,
              evidenceCount: charge.evidencePhotoIds.length,
              amount: charge.amount,
              onTap: busy || list.isEmpty ? null : () => onEdit(list, i),
              onRemove: busy ? null : () => onRemove(i),
            ),
            if (i != charges.length - 1) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          ],
          if (charges.isNotEmpty) ChargesTotal(total: total),
          if (list.isNotEmpty) ...[
            const Gap.sm(),
            GhostButton(
              label: context.l10n.submissionAddCharge,
              icon: Icons.add_rounded,
              onPressed: busy ? null : () => onAdd(list),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChargeForm extends StatefulWidget {
  const _ChargeForm({required this.prices, required this.photos, this.initial});

  final List<PenaltyPriceDto> prices;
  final List<(SubmissionPhotoDto, String)> photos;
  final _Charge? initial;

  @override
  State<_ChargeForm> createState() => _ChargeFormState();
}

class _ChargeFormState extends State<_ChargeForm> {
  late final TextEditingController _details = TextEditingController(text: widget.initial?.details);
  late PenaltyPriceDto? _price = widget.prices.where((price) => price.id == widget.initial?.price.id).firstOrNull;
  late int _quantity = widget.initial?.quantity ?? 1;
  late final Set<String> _evidence = {...?widget.initial?.evidencePhotoIds};
  String? _error;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  void _toggle(String photoId) {
    setState(() {
      _error = null;
      if (_evidence.remove(photoId)) return;
      if (_evidence.length >= _maxChargeEvidence) {
        _error = context.l10n.submissionEvidenceLimit(_maxChargeEvidence);
        return;
      }
      _evidence.add(photoId);
    });
  }

  void _save() {
    final PenaltyPriceDto? price = _price;
    final String details = _details.text.trim();
    final bool hasChecklist = widget.photos.any(
      (entry) => _evidence.contains(entry.$1.id) && entry.$1.photoType == returnChecklistPhotoType,
    );
    final String? error = price == null
        ? context.l10n.submissionPickCharge
        : details.isEmpty
        ? context.l10n.submissionDetailsNeeded
        : _evidence.isEmpty
        ? context.l10n.submissionChargeEvidenceNeeded
        : price.category == PenaltyCategory.missingItem && !hasChecklist
        ? context.l10n.submissionChecklistNeeded
        : null;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(
      _Charge(
        price: price!,
        quantity: _quantity,
        details: details,
        evidencePhotoIds: [
          for (final (SubmissionPhotoDto photo, String _) in widget.photos)
            if (_evidence.contains(photo.id)) photo.id,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PenaltyPriceDto? price = _price;
    final List<PenaltyPriceDto> damage = [
      for (final PenaltyPriceDto price in widget.prices)
        if (price.category != PenaltyCategory.missingItem) price,
    ];
    final List<PenaltyPriceDto> missing = [
      for (final PenaltyPriceDto price in widget.prices)
        if (price.category == PenaltyCategory.missingItem) price,
    ];
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (String title, List<PenaltyPriceDto> group) in [
            (context.l10n.returnsKindDamage, damage),
            (context.l10n.returnsKindMissing, missing),
          ])
            if (group.isNotEmpty) ...[
              GroupLabel(title),
              const Gap.sm(),
              for (final PenaltyPriceDto option in group) ...[
                AppRadioTile(
                  selected: price?.id == option.id,
                  onTap: () => setState(() {
                    _price = option;
                    _error = null;
                  }),
                  title: option.description,
                  subtitle: '${Fmt.money(option.amount, paise: true)} · ${option.code}',
                ),
                const Gap.sm(),
              ],
              const Gap.sm(),
            ],
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
          if (price != null)
            Text(
              '${context.l10n.commonTotal}: ${Fmt.money(price.amount * _quantity, paise: true)}',
              textAlign: TextAlign.end,
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
          const Gap.md(),
          AppTextField(
            label: context.l10n.submissionChargeDetails,
            required: true,
            controller: _details,
            hint: context.l10n.submissionChargeDetailsHint,
            maxLines: 3,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const Gap.lg(),
          GroupLabel(context.l10n.submissionEvidence),
          const Gap.sm(),
          if (widget.photos.isEmpty)
            Text(
              context.l10n.submissionNoPhotosYet,
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            )
          else
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                for (final (SubmissionPhotoDto photo, String label) in widget.photos)
                  EvidenceChip(label: label, selected: _evidence.contains(photo.id), onTap: () => _toggle(photo.id)),
              ],
            ),
          if (price?.category == PenaltyCategory.missingItem) ...[
            const Gap.sm(),
            Text(
              context.l10n.submissionChecklistNeeded,
              style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ],
          if (_error != null) ...[
            const Gap.md(),
            Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
          ],
          const Gap.lg(),
          PrimaryButton(label: context.l10n.submissionSaveCharge, icon: Icons.check_rounded, onPressed: _save),
          const Gap.md(),
        ],
      ),
    );
  }
}
