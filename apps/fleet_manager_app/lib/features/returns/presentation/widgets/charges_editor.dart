import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/return_case.dart';
import '../providers/return_desk_providers.dart';
import 'return_desk_widgets.dart';

class ChargesEditor extends ConsumerStatefulWidget {
  const ChargesEditor({required this.item, required this.busy, required this.onSave, super.key});

  final ReturnCase item;
  final bool busy;
  final Future<void> Function(List<PenaltyLine> lines, {required bool send}) onSave;

  @override
  ConsumerState<ChargesEditor> createState() => _ChargesEditorState();
}

class _ChargesEditorState extends ConsumerState<ChargesEditor> {
  late final List<PenaltyLine> _lines = [...?widget.item.penalty?.lines];

  Future<void> _edit(List<PenaltyPrice> prices, InspectionSheet? sheet, {int? index}) async {
    if (sheet == null) {
      final String? inspectionId = widget.item.inspectionId;
      if (inspectionId != null && ref.read(inspectionSheetProvider(inspectionId)).hasError) {
        ref.invalidate(inspectionSheetProvider(inspectionId));
      }
      AppSnack.info(context, context.l10n.returnDeskLoadingPhotos);
      return;
    }
    final PenaltyLine? line = await AppSheet.show<PenaltyLine>(
      context,
      title: index == null ? context.l10n.returnDeskAddCharge : context.l10n.returnDeskEditCharge,
      maxHeightFactor: 0.9,
      child: _ChargeForm(prices: prices, sheet: sheet, initial: index == null ? null : _lines[index]),
    );
    if (line == null || !mounted) return;
    setState(() {
      if (index == null) {
        _lines.add(line);
      } else {
        _lines[index] = line;
      }
    });
  }

  Future<void> _send({required bool empty}) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: empty ? context.l10n.returnDeskCloseNoCharges : context.l10n.returnDeskSendToRider,
      message: empty ? context.l10n.returnDeskCloseNoChargesBody : context.l10n.returnDeskSendToRiderBody,
      confirmLabel: empty ? context.l10n.returnDeskCloseNoCharges : context.l10n.returnDeskSendToRider,
      icon: empty ? Icons.task_alt_rounded : Icons.send_rounded,
      tone: empty ? AppColors.success : AppColors.primary,
    );
    if (!confirmed || !mounted) return;
    await widget.onSave(List.of(_lines), send: true);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PenaltyPrice>> prices = ref.watch(penaltyPricesProvider);
    final String? inspectionId = widget.item.inspectionId;
    final InspectionSheet? sheet = inspectionId == null ? null : ref.watch(inspectionSheetProvider(inspectionId)).value;
    final List<PenaltyPrice> priceList = prices.value ?? const [];
    final Map<String, PenaltyPrice> byId = {for (final PenaltyPrice price in priceList) price.id: price};
    final List<PenaltyLine> priced = [for (final PenaltyLine line in _lines) line.priced(byId[line.priceId])];
    final num total = priced.fold<num>(0, (sum, line) => sum + (line.amount ?? 0));
    final String? dispute = widget.item.penalty?.stage == PenaltyStage.disputed
        ? widget.item.penalty?.disputeReason
        : null;

    return ModuleCard(
      title: context.l10n.returnsCharges,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (dispute != null) ...[
            KeyValueRow(label: context.l10n.returnDeskRiderDispute, value: dispute, icon: Icons.gavel_rounded),
            const Gap.sm(),
          ],
          Text(
            dispute != null ? context.l10n.returnDeskReviseHint : context.l10n.returnDeskChargesHint,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          const Gap.md(),
          if (prices.hasError && priceList.isEmpty)
            Text(
              prices.failureMessage ?? context.l10n.commonSomethingWentWrongPleaseTry,
              style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
            )
          else if (prices.hasValue && priceList.isEmpty)
            Text(
              context.l10n.returnDeskNoPrices,
              style: AppText.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 12),
            ),
          for (final (int i, PenaltyLine line) in priced.indexed) ...[
            PenaltyLineRow(
              line: line,
              onTap: widget.busy ? null : () => _edit(priceList, sheet, index: i),
              onRemove: widget.busy ? null : () => setState(() => _lines.removeAt(i)),
            ),
            if (i != priced.length - 1) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          ],
          if (priced.isNotEmpty) ...[const Gap.sm(), ChargesTotal(total: total)],
          if (priceList.isNotEmpty) ...[
            const Gap.sm(),
            GhostButton(
              label: context.l10n.returnDeskAddCharge,
              icon: Icons.add_rounded,
              onPressed: widget.busy ? null : () => _edit(priceList, sheet),
            ),
          ],
          const Gap.md(),
          if (_lines.isEmpty)
            PrimaryButton(
              label: context.l10n.returnDeskCloseNoCharges,
              icon: Icons.task_alt_rounded,
              fillColor: AppColors.success,
              loading: widget.busy,
              onPressed: widget.busy ? null : () => _send(empty: true),
            )
          else
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: context.l10n.returnDeskSaveDraft,
                    size: AppButtonSize.medium,
                    onPressed: widget.busy ? null : () => widget.onSave(List.of(_lines), send: false),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: PrimaryButton(
                    label: context.l10n.returnDeskSendToRider,
                    icon: Icons.send_rounded,
                    size: AppButtonSize.medium,
                    loading: widget.busy,
                    onPressed: widget.busy ? null : () => _send(empty: false),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ChargeForm extends StatefulWidget {
  const _ChargeForm({required this.prices, required this.sheet, this.initial});

  final List<PenaltyPrice> prices;
  final InspectionSheet sheet;
  final PenaltyLine? initial;

  @override
  State<_ChargeForm> createState() => _ChargeFormState();
}

class _ChargeFormState extends State<_ChargeForm> {
  late final TextEditingController _details = TextEditingController(text: widget.initial?.details);
  late PenaltyPrice? _price = widget.prices.where((price) => price.id == widget.initial?.priceId).firstOrNull;
  late final Set<String> _evidence = {...?widget.initial?.evidencePhotoIds};
  String? _error;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  void _save() {
    final PenaltyPrice? price = _price;
    final String details = _details.text.trim();
    final bool hasChecklist = widget.sheet.photos.any(
      (photo) => _evidence.contains(photo.id) && photo.photoType == checklistPhotoType,
    );
    final String? error = price == null
        ? context.l10n.returnDeskPickCharge
        : details.isEmpty
        ? context.l10n.returnDeskDetailsNeeded
        : _evidence.isEmpty
        ? context.l10n.returnDeskEvidenceNeeded
        : price.kind == PenaltyKind.missingItem && !hasChecklist
        ? context.l10n.returnDeskChecklistNeeded
        : null;
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(
      PenaltyLine(
        priceId: price!.id,
        details: details,
        evidencePhotoIds: [
          for (final InspectionPhoto photo in widget.sheet.photos)
            if (_evidence.contains(photo.id)) photo.id,
        ],
        description: price.description,
        kind: price.kind,
        amount: price.amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PenaltyPrice> damage = [
      for (final PenaltyPrice price in widget.prices)
        if (price.kind == PenaltyKind.damage) price,
    ];
    final List<PenaltyPrice> missing = [
      for (final PenaltyPrice price in widget.prices)
        if (price.kind == PenaltyKind.missingItem) price,
    ];
    int damageIndex = 0;
    final List<(InspectionPhoto, String)> photos = [
      for (final InspectionPhoto photo in widget.sheet.photos)
        (
          photo,
          photo.photoType.startsWith(damagePhotoPrefix)
              ? '${context.l10n.returnDeskDamagePhoto} ${++damageIndex}'
              : photoTypeLabel(context.l10n, photo.photoType, slots: widget.sheet.slots),
        ),
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (String title, List<PenaltyPrice> group) in [
            (context.l10n.returnsKindDamage, damage),
            (context.l10n.returnsKindMissing, missing),
          ])
            if (group.isNotEmpty) ...[
              GroupLabel(title),
              const Gap.sm(),
              for (final PenaltyPrice price in group) ...[
                AppRadioTile(
                  selected: _price?.id == price.id,
                  onTap: () => setState(() {
                    _price = price;
                    _error = null;
                  }),
                  title: price.description,
                  subtitle: '${Fmt.money(price.amount, paise: true)} · ${price.code}',
                ),
                const Gap.sm(),
              ],
              const Gap.sm(),
            ],
          AppTextField(
            label: context.l10n.returnDeskChargeDetails,
            required: true,
            controller: _details,
            hint: context.l10n.returnDeskChargeDetailsHint,
            maxLines: 3,
            maxLength: 1000,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          const Gap.lg(),
          GroupLabel(context.l10n.returnDeskEvidence),
          const Gap.sm(),
          if (photos.isEmpty)
            Text(
              context.l10n.returnDeskNoPhotosYet,
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            )
          else
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                for (final (InspectionPhoto photo, String label) in photos)
                  _EvidenceChip(
                    label: label,
                    selected: _evidence.contains(photo.id),
                    onTap: () => setState(() {
                      if (!_evidence.remove(photo.id)) _evidence.add(photo.id);
                      _error = null;
                    }),
                  ),
              ],
            ),
          if (_price?.kind == PenaltyKind.missingItem) ...[
            const Gap.sm(),
            Text(
              context.l10n.returnDeskChecklistNeeded,
              style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ],
          if (_error != null) ...[
            const Gap.md(),
            Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
          ],
          const Gap.lg(),
          PrimaryButton(label: context.l10n.returnDeskSaveCharge, icon: Icons.check_rounded, onPressed: _save),
          const Gap.md(),
        ],
      ),
    );
  }
}

class _EvidenceChip extends StatelessWidget {
  const _EvidenceChip({required this.label, required this.selected, required this.onTap});

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
