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
      _categoryError = _categoryKey == null ? 'Choose a category' : null;
      _subjectError = _subject.text.trim().isEmpty
          ? 'Tell us what this is about'
          : null;
      _descriptionError = _description.text.trim().length < 10
          ? 'Add a few more details (10+ characters)'
          : null;
    });
    return _categoryError == null &&
        _subjectError == null &&
        _descriptionError == null;
  }

  Future<void> _pickCategory(List<SupportCategory> categories) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: 'Choose a category',
      subtitle: 'This decides who picks up your ticket and how fast',
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
          title: 'Raise a ticket',
          subtitle: 'The more detail you give, the faster we can help',
          footer: PrimaryButton(
            label: 'Submit ticket',
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
                      title: "What's the issue",
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
                            label: 'Category',
                            required: true,
                            value: selected?.label,
                            hint: 'Select a category',
                            errorText: _categoryError,
                            onTap: () => _pickCategory(state.categories),
                            prefixIcon: selected == null
                                ? Icons.category_rounded
                                : NodeTokens.icon(selected.icon),
                          ),
                          const Gap.lg(),
                          AppTextField(
                            label: 'Subject',
                            required: true,
                            controller: _subject,
                            hint: 'One line that sums up the issue',
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
                      title: 'Tell us more',
                      leading: const IconTile(
                        icon: Icons.notes_rounded,
                        tone: AppColors.primary,
                        solid: true,
                      ),
                      child: AppTextField(
                        label: 'Description',
                        required: true,
                        controller: _description,
                        hint: 'What happened, and since when?',
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
                      title: 'Photos (optional)',
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
                      title: 'Vehicle impact',
                      leading: const IconTile(
                        icon: Icons.warning_amber_rounded,
                        tone: AppColors.amber,
                        solid: true,
                      ),
                      child: AppCheckTile(
                        value: _vehicleAffected,
                        onChanged: (v) => setState(() => _vehicleAffected = v),
                        title: 'The vehicle is affected',
                        subtitle:
                            'Turn this on if you cannot ride safely until this is fixed',
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
