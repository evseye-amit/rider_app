import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/check_in/submission_hubs.dart';
import '../../domain/entities/ride_return.dart';
import '../../domain/usecases/ride_return_usecases.dart';
import '../../ride_returns_dependencies.dart';

class RequestReturnPage extends ConsumerStatefulWidget {
  const RequestReturnPage({super.key});

  @override
  ConsumerState<RequestReturnPage> createState() => _RequestReturnPageState();
}

class _RequestReturnPageState extends ConsumerState<RequestReturnPage> {
  static const int _maxDaysAhead = 60;

  final String _idempotencyKey = newIdempotencyKey();
  final TextEditingController _notes = TextEditingController();

  ReturnReason? _reason;
  SubmissionHub? _hub;
  DateTime? _date;
  bool _submitting = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  DateTime get _today {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await AppDateWheel.show(
      context,
      first: _today,
      last: _today.add(const Duration(days: _maxDaysAhead)),
      initial: _date ?? _today,
      title: context.l10n.returnsPickDate,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickHub(SubmissionHub? current) async {
    final SubmissionHub? picked = await SubmissionHubPicker.show(context, selectedId: current?.id);
    if (picked != null) setState(() => _hub = picked);
  }

  Future<void> _submit(SubmissionHub? hub) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final ReturnReason? reason = _reason;
    final DateTime? date = _date;
    if (reason == null || hub == null || date == null) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _submitting = true);
    final Result<RideReturn> result = await ref.read(requestRideReturnProvider)(
      ReturnRequestParams(
        date: date,
        idempotencyKey: _idempotencyKey,
        reasonCode: reason.wire,
        hubId: hub.id,
        notes: _notes.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case Ok<RideReturn>(:final value):
        AppSnack.success(context, context.l10n.returnsRequested);
        context.pop(value.id);
      case Err<RideReturn>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SubmissionChoices> choices = ref.watch(submissionChoicesProvider(null));
    final SubmissionChoices? value = choices.value;
    final SubmissionHub? hub = _hub ?? value?.defaultHub;

    return AppScaffold(
      title: context.l10n.returnsRequestReturn,
      subtitle: context.l10n.returnsRequestSubtitle,
      footer: value == null || !value.hasVehicle
          ? null
          : PrimaryButton(
              label: context.l10n.returnsRequestReturn,
              icon: Icons.send_rounded,
              loading: _submitting,
              onPressed: _submitting ? null : () => _submit(hub),
            ),
      body: switch (value) {
        null when choices.hasError => EmptyState(
          title: context.l10n.returnsCouldNotLoad,
          message: choices.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(submissionChoicesProvider(null)),
        ),
        null => const PageBody(
          children: [
            ShimmerBox(height: 150, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 170, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 130, borderRadius: Corners.brXl),
          ],
        ),
        SubmissionChoices(hasVehicle: false) => EmptyState(
          title: context.l10n.returnsNothingToReturn,
          message: context.l10n.returnsNothingToReturnBody,
          icon: Icons.electric_moped_rounded,
        ),
        SubmissionChoices() => _form(hub),
      },
    );
  }

  Widget _form(SubmissionHub? hub) {
    final DateTime? date = _date;
    return PageBody(
      children: [
        ModuleCard(
          title: context.l10n.returnsWhy,
          leading: const IconTile(icon: Icons.help_outline_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final ReturnReason reason in ReturnReason.values)
                    _ReasonChip(
                      label: returnReasonLabel(context.l10n, reason.wire),
                      selected: _reason == reason,
                      onTap: () => setState(() => _reason = reason),
                    ),
                ],
              ),
              if (_showErrors && _reason == null) ...[
                const Gap.sm(),
                Text(
                  context.l10n.returnsPickReason,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnsWhenWhere,
          leading: const IconTile(icon: Icons.event_rounded, solid: true, size: 28),
          child: Column(
            children: [
              AppPickerField(
                label: context.l10n.returnsDate,
                required: true,
                value: date == null ? null : Fmt.date(date),
                hint: context.l10n.returnsPickDate,
                prefixIcon: Icons.calendar_today_rounded,
                errorText: _showErrors && date == null ? context.l10n.returnsPickDate : null,
                onTap: _pickDate,
              ),
              const Gap.lg(),
              AppPickerField(
                label: context.l10n.returnsHub,
                required: true,
                value: hub?.name,
                hint: context.l10n.returnsPickHub,
                prefixIcon: Icons.store_rounded,
                helper: hub == null || hub.address.isEmpty ? null : hub.address,
                errorText: _showErrors && hub == null ? context.l10n.returnsPickHub : null,
                onTap: () => _pickHub(hub),
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnsNotes,
          leading: const IconTile(icon: Icons.notes_rounded, solid: true, size: 28),
          child: AppTextField(
            controller: _notes,
            hint: context.l10n.returnsNotesHint,
            maxLines: 3,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        const Gap.lg(),
        AccentCard(
          accent: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.commonWhatHappensNext, style: AppText.titleSmall),
              const Gap.sm(),
              for (final String line in [
                context.l10n.returnsNextHandOver,
                context.l10n.returnsNextCheckIn,
                context.l10n.returnsNextConfirm,
              ])
                Padding(
                  padding: const EdgeInsets.only(top: Insets.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(Icons.check_circle_outline_rounded, size: 15, color: AppColors.primary),
                      ),
                      const SizedBox(width: Insets.sm),
                      Expanded(child: Text(line, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
        child: Text(
          label,
          style: AppText.titleSmall.copyWith(
            fontSize: 12.5,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
