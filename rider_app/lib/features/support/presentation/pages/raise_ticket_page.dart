import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/support_overview.dart';
import '../../domain/usecases/get_support_overview.dart';
import '../../domain/usecases/raise_ticket.dart';
import '../cubit/raise_ticket_cubit.dart';
import '../widgets/support_widgets.dart';

class RaiseTicketPage extends StatelessWidget {
  const RaiseTicketPage({this.categoryKey, super.key});

  final String? categoryKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RaiseTicketCubit(GetSupportOverview(sl()), RaiseTicket(sl()))..load(),
      child: _RaiseTicketView(initialCategory: categoryKey),
    );
  }
}

class _RaiseTicketView extends StatefulWidget {
  const _RaiseTicketView({this.initialCategory});

  final String? initialCategory;

  @override
  State<_RaiseTicketView> createState() => _RaiseTicketViewState();
}

class _RaiseTicketViewState extends State<_RaiseTicketView> {
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final List<bool> _photoCaptured = [false, false, false];

  String? _categoryKey;
  bool _vehicleAffected = false;
  String? _categoryError;
  String? _subjectError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
    _categoryKey = widget.initialCategory;
  }

  @override
  void dispose() {
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  SupportCategory? _categoryOf(List<SupportCategory> categories, String? key) {
    for (final category in categories) {
      if (category.key == key) return category;
    }
    return null;
  }

  bool _validate() {
    setState(() {
      _categoryError = _categoryKey == null ? context.l10n.supportChooseCategory : null;
      _subjectError = _subject.text.trim().isEmpty
          ? context.l10n.supportTellUsWhatAbout
          : null;
      _descriptionError = _description.text.trim().length < 10
          ? context.l10n.supportAddFewMoreDetails10
          : null;
    });
    return _categoryError == null &&
        _subjectError == null &&
        _descriptionError == null;
  }

  Future<void> _pickCategory(List<SupportCategory> categories) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.supportChooseCategory,
      subtitle: context.l10n.supportDecidesWhoPicksUpTicket,
      child: Column(
        children: [
          for (final c in categories) ...[
            AppRadioTile(
              selected: c.key == _categoryKey,
              onTap: () => Navigator.of(context).pop(c.key),
              title: c.label,
              subtitle: c.sla,
              leading: IconTile(
                icon: NodeTokens.icon(c.icon),
                tone: categoryTileTone(c.key),
                solid: true,
                size: 36,
              ),
            ),
            if (c != categories.last) const Gap.sm(),
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

  void _togglePhoto(int index) =>
      setState(() => _photoCaptured[index] = !_photoCaptured[index]);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RaiseTicketCubit, RaiseTicketState>(
      listener: (context, state) {
        if (state.status == RaiseTicketStatus.submitted &&
            state.createdTicketId != null) {
          Navigator.of(context).pop();
          AppSnack.success(
            context,
            'Ticket ${state.createdTicketId} raised. Our team is on it.',
          );
        } else if (state.status == RaiseTicketStatus.failure &&
            state.message != null) {
          AppSnack.error(context, state.message!);
        }
      },
      builder: (context, state) {
        final SupportCategory? selected = _categoryOf(
          state.categories,
          _categoryKey,
        );
        final bool submitting = state.status == RaiseTicketStatus.submitting;
        final bool loadingCategories =
            state.status == RaiseTicketStatus.loading;
        final Color selectedTone = selected == null
            ? AppColors.primary
            : categoryTileTone(selected.key);

        return AppScaffold(
          title: context.l10n.supportRaiseTicket,
          subtitle: context.l10n.supportMoreDetailGiveFasterCan,
          footer: PrimaryButton(
            label: context.l10n.supportSubmitTicket,
            icon: Icons.send_rounded,
            loading: submitting,
            onPressed: loadingCategories
                ? null
                : () {
                    if (!_validate()) return;
                    context.read<RaiseTicketCubit>().submit(
                      categoryKey: _categoryKey!,
                      subject: _subject.text.trim(),
                      description: _description.text.trim(),
                      vehicleAffected: _vehicleAffected,
                      photoCount: _photoCaptured.where((c) => c).length,
                    );
                  },
          ),
          body: loadingCategories
              ? const _RaiseTicketSkeleton()
              : PageBody(
                  children: [
                    ModuleCard(
                      title: context.l10n.supportWhatsTheIssue,
                      leading: IconTile(
                        icon: selected == null
                            ? Icons.category_rounded
                            : NodeTokens.icon(selected.icon),
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
                            onTap: () => _pickCategory(state.categories),
                            prefixIcon: selected == null
                                ? Icons.category_rounded
                                : NodeTokens.icon(selected.icon),
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
                              if (_subjectError != null) {
                                setState(() => _subjectError = null);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap.lg(),
                    ModuleCard(
                      title: context.l10n.supportTellUsMore,
                      leading: const IconTile(
                        icon: Icons.notes_rounded,
                        tone: AppColors.primary,
                        solid: true,
                      ),
                      child: AppTextField(
                        label: context.l10n.supportDescription,
                        required: true,
                        controller: _description,
                        hint: context.l10n.supportWhatHappenedSinceWhen,
                        maxLines: 5,
                        errorText: _descriptionError,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) {
                          if (_descriptionError != null) {
                            setState(() => _descriptionError = null);
                          }
                        },
                      ),
                    ),
                    const Gap.lg(),
                    ModuleCard(
                      title: context.l10n.supportPhotosOptional,
                      leading: const IconTile(
                        icon: Icons.photo_camera_rounded,
                        tone: AppColors.primary,
                        solid: true,
                      ),
                      child: Row(
                        children: [
                          for (var i = 0; i < _photoCaptured.length; i++) ...[
                            Expanded(
                              child: PhotoSlot(
                                label: 'Photo ${i + 1}',
                                captured: _photoCaptured[i],
                                required: false,
                                onTap: () => _togglePhoto(i),
                                onRetake: () => _togglePhoto(i),
                              ),
                            ),
                            if (i != _photoCaptured.length - 1)
                              const SizedBox(width: Insets.md),
                          ],
                        ],
                      ),
                    ),
                    const Gap.lg(),
                    ModuleCard(
                      title: context.l10n.supportVehicleImpact,
                      leading: const IconTile(
                        icon: Icons.warning_amber_rounded,
                        tone: AppColors.amber,
                        solid: true,
                      ),
                      child: AppCheckTile(
                        value: _vehicleAffected,
                        onChanged: (v) => setState(() => _vehicleAffected = v),
                        title: context.l10n.supportVehicleAffected,
                        subtitle: context.l10n.supportTurnIfCannotRideSafely,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _RaiseTicketSkeleton extends StatelessWidget {
  const _RaiseTicketSkeleton();

  @override
  Widget build(BuildContext context) {
    return PageBody(
      children: [
        const ShimmerBox(height: 190, borderRadius: Corners.brLg),
        const Gap.xl(),
        const ShimmerBox(height: 150, borderRadius: Corners.brLg),
        const Gap.xl(),
        const ShimmerBox(height: 130, borderRadius: Corners.brLg),
        const Gap.xl(),
        const ShimmerBox(height: 96, borderRadius: Corners.brLg),
      ],
    );
  }
}
