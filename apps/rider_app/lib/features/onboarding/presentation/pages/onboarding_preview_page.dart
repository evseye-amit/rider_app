import 'dart:convert';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../domain/usecases/save_onboarding_step.dart';
import '../../onboarding_dependencies.dart';
import '../providers/onboarding_draft_provider.dart';

class OnboardingPreviewPage extends ConsumerStatefulWidget {
  const OnboardingPreviewPage({super.key});

  @override
  ConsumerState<OnboardingPreviewPage> createState() => _OnboardingPreviewPageState();
}

class _OnboardingPreviewPageState extends ConsumerState<OnboardingPreviewPage> {
  bool _submitting = false;

  void _edit(int stepIndex) => context.pop(stepIndex);

  Future<void> _submit(RiderOnboardingConfig config) async {
    if (_submitting || config.steps.isEmpty) return;
    final OnboardingStepConfig last = config.steps.last;
    final Map<String, Object?> draft = ref.read(onboardingDraftProvider);
    final Map<String, Object?> values = {
      for (final OnboardingFieldConfig field in last.inputs)
        if (draft[field.fieldCode] != null && draft[field.fieldCode].toString().trim().isNotEmpty)
          field.fieldCode: draft[field.fieldCode].toString().trim(),
    };

    setState(() => _submitting = true);
    final Result<RiderOnboardingConfig> result = await ref.read(saveOnboardingStepProvider)(
      SaveStepParams(stepId: last.stepId, values: values),
    );
    if (!mounted) return;

    switch (result) {
      case Ok<RiderOnboardingConfig>(:final value):
        await ref.read(riderSessionProvider.notifier).applyOnboarding(value);
        if (!mounted) return;
        setState(() => _submitting = false);
        if (value.needsResubmission) {
          AppSnack.error(context, context.l10n.onboardingUploadRejectedAgain);
          context.pop(value.resumeIndex);
        } else if (value.isComplete) {
          ref.read(onboardingDraftProvider.notifier).clear();
          AppSnack.success(context, context.l10n.onboardingApplicationSubmitted);
          context.go(ref.read(riderSessionProvider).homeRoute);
        } else {
          AppSnack.error(context, context.l10n.onboardingSomeStepsStillIncompleteGo);
        }
      case Err<RiderOnboardingConfig>(:final failure):
        setState(() => _submitting = false);
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RiderOnboardingConfig? config = ref.watch(riderSessionProvider.select((s) => s.onboarding));
    if (config == null) {
      return AppScaffold(
        title: context.l10n.onboardingReviewApplication,
        body: EmptyState(
          title: context.l10n.onboardingNothingReviewYet,
          message: context.l10n.onboardingStartOnboardingSeeAnswersHere,
          icon: Icons.assignment_outlined,
          actionLabel: context.l10n.onboardingGoOnboarding,
          onAction: () => context.go(Routes.onboarding),
        ),
      );
    }

    final Map<String, Object?> draft = ref.watch(onboardingDraftProvider);
    final Map<String, Object?> saved = config.progress.values;
    Object? valueOf(String key) => draft[key] ?? saved[key];

    final List<OnboardingFieldConfig> allFields = [
      for (final OnboardingStepConfig step in config.steps) ...step.fields,
    ];
    final int total = allFields.where((field) => field.isInput || field.isUpload).length;
    final int filled = allFields.where((field) {
      final Object? value = valueOf(field.formKey);
      return (field.isInput || field.isUpload) && value != null && value.toString().trim().isNotEmpty;
    }).length;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 120,
      pinBand: true,
      band: _Band(packageName: config.packageName, filled: filled, total: total),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          Insets.gutter,
          Insets.md,
          Insets.gutter,
          MediaQuery.paddingOf(context).bottom + Insets.md,
        ),
        decoration: const BoxDecoration(
          color: AppColors.canvas,
          border: Border(top: BorderSide(color: AppColors.stroke)),
        ),
        child: PrimaryButton(
          label: context.l10n.onboardingSubmitApplication,
          icon: Icons.send_rounded,
          loading: _submitting,
          onPressed: _submitting ? null : () => _submit(config),
        ),
      ),
      children: [
        for (int i = 0; i < config.steps.length; i++) ...[
          _StepCard(
            step: config.steps[i],
            valueOf: valueOf,
            isRejected: (field) => config.document(field)?.isRejected ?? false,
            onEdit: () => _edit(i),
          ),
          if (i != config.steps.length - 1) const Gap.lg(),
        ],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.packageName, required this.filled, required this.total});

  final String packageName;
  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) =>
              InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
        ),
        const Gap.xl(),
        Text(
          context.l10n.onboardingReviewApplication,
          style: AppText.displaySmall.copyWith(color: AppColors.onInk, fontSize: 25),
        ),
        const Gap.sm(),
        Text(
          context.l10n.onboardingCheckEverythingBeforeSubmitCan,
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.5),
        ),
        const Gap.lg(),
        Row(
          children: [
            Expanded(
              child: InkStat(
                label: context.l10n.onboardingAnswered,
                value: '$filled of $total',
                icon: Icons.fact_check_rounded,
              ),
            ),
            const InkDivider(),
            const SizedBox(width: Insets.md),
            Expanded(
              child: InkStat(
                label: context.l10n.onboardingPackage,
                value: packageName.isEmpty ? '—' : packageName,
                icon: Icons.inventory_2_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.valueOf, required this.isRejected, required this.onEdit});

  final OnboardingStepConfig step;
  final Object? Function(String key) valueOf;
  final bool Function(OnboardingFieldConfig field) isRejected;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final List<OnboardingFieldConfig> shown = step.fields.where((field) => field.isInput || field.isUpload).toList();

    return ModuleCard(
      title: step.stepName,
      actionLabel: context.l10n.onboardingEdit,
      onAction: onEdit,
      child: shown.isEmpty
          ? Text(
              step.capabilities.isEmpty
                  ? context.l10n.onboardingNothingFillStep
                  : step.capabilities.map((capability) => capability.label).join(' · '),
              style: AppText.bodySmall.copyWith(height: 1.5),
            )
          : Column(children: [for (final OnboardingFieldConfig field in shown) ..._rows(context, field)]),
    );
  }

  List<Widget> _rows(BuildContext context, OnboardingFieldConfig field) {
    final Object? value = _decoded(valueOf(field.formKey));
    if (field.isUpload && value == null && isRejected(field)) {
      return [
        KeyValueRow(
          label: field.label,
          value: context.l10n.commonRejectedUploadAgain,
          icon: Icons.error_outline_rounded,
          valueColor: AppColors.danger,
        ),
      ];
    }

    final List<Map<String, dynamic>> entries = [
      if (value is List)
        for (final Object? item in value)
          if (item is Map) Map<String, dynamic>.from(item),
    ];
    if (entries.isNotEmpty) {
      return [
        for (final (int i, Map<String, dynamic> entry) in entries.indexed)
          KeyValueRow(
            label: entries.length == 1 ? field.label : '${field.label} ${i + 1}',
            value: _entry(context, entry),
          ),
      ];
    }

    final Object? answer = value is List ? (value.isEmpty ? null : value.join(', ')) : value;
    return [
      KeyValueRow(
        label: field.label,
        value: _display(context.l10n, field, answer),
        icon: field.isUpload ? Icons.attach_file_rounded : null,
        valueColor: answer == null ? AppColors.textMuted : null,
      ),
    ];
  }

  static Object? _decoded(Object? value) {
    if (value is! String || !value.trimLeft().startsWith('[')) return value;
    try {
      return jsonDecode(value);
    } on FormatException {
      return value;
    }
  }

  static String _entry(BuildContext context, Map<String, dynamic> entry) {
    String? text(String key) {
      final String value = entry[key]?.toString().trim() ?? '';
      return value.isEmpty ? null : value;
    }

    final String? relation = text('relation');
    final String? mobile = text('mobile');
    final String? share = text('share');
    final String details = [
      if (relation != null) relationLabel(context, relation),
      if (mobile != null) Fmt.phone(mobile),
      if (share != null) '$share%',
    ].join(' · ');
    return [?text('name'), if (details.isNotEmpty) details].join('\n');
  }

  static String _display(AppL10n l10n, OnboardingFieldConfig field, Object? value) {
    if (value == null || value.toString().trim().isEmpty) {
      return field.required || field.isUpload ? l10n.onboardingNotProvided : '—';
    }
    final String text = value.toString();
    if (field.isUpload) return l10n.onboardingAttached;
    if (field.fieldCode.contains('AADHAAR')) return Fmt.maskAadhaar(text);
    if (field.fieldType == 'MOBILE') return Fmt.phone(text);
    if (field.fieldType == 'DATE') {
      final DateTime? date = DateTime.tryParse(text);
      return date == null ? text : Fmt.date(date);
    }
    return text;
  }
}
