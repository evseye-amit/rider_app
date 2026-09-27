import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/support_overview.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/usecases/raise_ticket.dart';
import '../../support_dependencies.dart';
import '../providers/support_overview_provider.dart';
import '../widgets/support_widgets.dart';

class RaiseTicketPage extends ConsumerStatefulWidget {
  const RaiseTicketPage({this.categoryKey, super.key});

  final String? categoryKey;

  @override
  ConsumerState<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends ConsumerState<RaiseTicketPage> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final List<bool> _photoCaptured = [false, false, false];

  late String? _categoryKey = widget.categoryKey;
  bool _vehicleAffected = false;
  bool _submitting = false;
  String? _categoryError;
  String? _subjectError;
  String? _descriptionError;

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  SupportCategory? _categoryOf(List<SupportCategory> categories, String? key) =>
      categories.where((category) => category.key == key).firstOrNull;

  bool _validate() {
    setState(() {
      _categoryError = _categoryKey == null ? context.l10n.supportChooseCategory : null;
      _subjectError = _subject.text.trim().isEmpty ? context.l10n.supportTellUsWhatAbout : null;
      _descriptionError = _description.text.trim().length < 10 ? context.l10n.supportAddFewMoreDetails10 : null;
    });
    return _categoryError == null && _subjectError == null && _descriptionError == null;
  }

  Future<void> _pickCategory(List<SupportCategory> categories) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.supportChooseCategory,
      subtitle: context.l10n.supportDecidesWhoPicksUpTicket,
      child: Column(
        children: [
          for (final SupportCategory category in categories) ...[
            AppRadioTile(
              selected: category.key == _categoryKey,
              onTap: () => Navigator.of(context).pop(category.key),
              title: category.label,
              subtitle: category.sla,
              leading: IconTile(
                icon: NodeTokens.icon(category.icon),
                tone: categoryTileTone(category.key),
                solid: true,
                size: 36,
              ),
            ),
            if (category != categories.last) const Gap.sm(),
          ],
        ],
      ),
    );
    if (picked != null) {
      setState(() {
        _categoryKey = picked;
        _categoryError = null;
      });
    }
  }

  void _togglePhoto(int index) => setState(() => _photoCaptured[index] = !_photoCaptured[index]);

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _submitting = true);

    final Result<SupportTicket> result = await ref.read(raiseTicketProvider)(
      RaiseTicketParams(
        categoryKey: _categoryKey!,
        subject: _subject.text.trim(),
        description: _description.text.trim(),
        vehicleAffected: _vehicleAffected,
        photoCount: _photoCaptured.where((captured) => captured).length,
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<SupportTicket>(:final value):
        Navigator.of(context).pop();
        AppSnack.success(context, 'Ticket ${value.id} raised. Our team is on it.');
      case Err<SupportTicket>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(supportOverviewProvider, (_, next) {
      final String? message = next.failureMessage;
      if (message != null) AppSnack.error(context, message);
    });

    final AsyncValue<SupportOverview> overview = ref.watch(supportOverviewProvider);
    final List<SupportCategory> categories = overview.value?.categories ?? const [];
    final bool loadingCategories = overview.isLoading && !overview.hasValue;
    final SupportCategory? selected = _categoryOf(categories, _categoryKey);
    final Color selectedTone = selected == null ? AppColors.primary : categoryTileTone(selected.key);

    return AppScaffold(
      title: context.l10n.supportRaiseTicket,
      subtitle: context.l10n.supportMoreDetailGiveFasterCan,
      footer: PrimaryButton(
        label: context.l10n.supportSubmitTicket,
        icon: Icons.send_rounded,
        loading: _submitting,
        onPressed: loadingCategories || _submitting ? null : _submit,
      ),
      body: loadingCategories
          ? const _RaiseTicketSkeleton()
          : PageBody(
              children: [
                ModuleCard(
                  title: context.l10n.supportWhatsTheIssue,
                  leading: IconTile(
                    icon: selected == null ? Icons.category_rounded : NodeTokens.icon(selected.icon),
                    tone: selectedTone,
                    solid: true,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppPickerField(
                        label: context.l10n.commonCategory,
                        required: true,
                        value: selected?.label,
                        hint: context.l10n.supportSelectCategory,
                        errorText: _categoryError,
                        onTap: () => _pickCategory(categories),
                        prefixIcon: selected == null ? Icons.category_rounded : NodeTokens.icon(selected.icon),
                      ),
                      const Gap.lg(),
                      AppTextField(
                        label: context.l10n.supportSubject,
                        required: true,
                        controller: _subject,
                        hint: context.l10n.supportOneLineSumsUpIssue,
                        errorText: _subjectError,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) {
                          if (_subjectError != null) setState(() => _subjectError = null);
                        },
                      ),
                    ],
                  ),
                ),
                const Gap.lg(),
                ModuleCard(
                  title: context.l10n.supportTellUsMore,
                  leading: const IconTile(icon: Icons.notes_rounded, tone: AppColors.primary, solid: true),
                  child: AppTextField(
                    label: context.l10n.supportDescription,
                    required: true,
                    controller: _description,
                    hint: context.l10n.supportWhatHappenedSinceWhen,
                    maxLines: 5,
                    errorText: _descriptionError,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) {
                      if (_descriptionError != null) setState(() => _descriptionError = null);
                    },
                  ),
                ),
                const Gap.lg(),
                ModuleCard(
                  title: context.l10n.supportPhotosOptional,
                  leading: const IconTile(icon: Icons.photo_camera_rounded, tone: AppColors.primary, solid: true),
                  child: Row(
                    children: [
                      for (int i = 0; i < _photoCaptured.length; i++) ...[
                        Expanded(
                          child: PhotoSlot(
                            label: 'Photo ${i + 1}',
                            captured: _photoCaptured[i],
                            required: false,
                            onTap: () => _togglePhoto(i),
                            onRetake: () => _togglePhoto(i),
                          ),
                        ),
                        if (i != _photoCaptured.length - 1) const SizedBox(width: Insets.md),
                      ],
                    ],
                  ),
                ),
                const Gap.lg(),
                ModuleCard(
                  title: context.l10n.supportVehicleImpact,
                  leading: const IconTile(icon: Icons.warning_amber_rounded, tone: AppColors.amber, solid: true),
                  child: AppCheckTile(
                    value: _vehicleAffected,
                    onChanged: (value) => setState(() => _vehicleAffected = value),
                    title: context.l10n.supportVehicleAffected,
                    subtitle: context.l10n.supportTurnIfCannotRideSafely,
                  ),
                ),
              ],
            ),
    );
  }
}

class _RaiseTicketSkeleton extends StatelessWidget {
  const _RaiseTicketSkeleton();

  @override
  Widget build(BuildContext context) {
    return const PageBody(
      children: [
        ShimmerBox(height: 190, borderRadius: Corners.brLg),
        Gap.xl(),
        ShimmerBox(height: 150, borderRadius: Corners.brLg),
        Gap.xl(),
        ShimmerBox(height: 130, borderRadius: Corners.brLg),
        Gap.xl(),
        ShimmerBox(height: 96, borderRadius: Corners.brLg),
      ],
    );
  }
}
