import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/onboarding_draft.dart';
import '../../domain/usecases/save_onboarding_step.dart';

class OnboardingPreviewPage extends StatefulWidget {
  const OnboardingPreviewPage({super.key});

  @override
  State<OnboardingPreviewPage> createState() => _OnboardingPreviewPageState();
}

class _OnboardingPreviewPageState extends State<OnboardingPreviewPage> {
  bool _submitting = false;

  SessionController get _session => sl<SessionController>();

  void _edit(int stepIndex) {
    OnboardingDraft.instance.jumpToStepIndex = stepIndex;
    context.go(Routes.onboarding);
  }

  Future<void> _submit(RiderOnboardingConfig config) async {
    if (_submitting || config.steps.isEmpty) return;
    final OnboardingStepConfig last = config.steps.last;
    final Map<String, Object?> draft = OnboardingDraft.instance.values;
    final Map<String, Object?> values = {
      for (final f in last.inputs)
        if (draft[f.fieldCode] != null && draft[f.fieldCode].toString().trim().isNotEmpty)
          f.fieldCode: draft[f.fieldCode].toString().trim(),
    };

    setState(() => _submitting = true);
    final Result<RiderOnboardingConfig> result =
        await SaveOnboardingStep(sl())(SaveStepParams(stepId: last.stepId, values: values));
    if (!mounted) return;

    switch (result) {
      case Ok<RiderOnboardingConfig>(:final value):

        await _session.applyOnboarding(value);
        if (!mounted) return;
        setState(() => _submitting = false);
        if (value.isComplete) {
          OnboardingDraft.instance.values = const {};
          AppSnack.success(context, 'Application submitted');
          context.go(_session.homeRoute);
        } else {
          AppSnack.error(context, 'Some steps are still incomplete. Go back and finish them.');
        }
      case Err<RiderOnboardingConfig>(:final failure):
        setState(() => _submitting = false);
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RiderOnboardingConfig? config = _session.onboarding;
    if (config == null) {
      return AppScaffold(
        title: 'Review your application',
        body: EmptyState(
          title: 'Nothing to review yet',
          message: 'Start onboarding to see your answers here.',
          icon: Icons.assignment_outlined,
          actionLabel: 'Go to onboarding',
          onAction: () => context.go(Routes.onboarding),
        ),
      );
    }

    final Map<String, Object?> draft = OnboardingDraft.instance.values;
    final Map<String, Object?> saved = config.progress.values;
    Object? valueOf(String key) => draft[key] ?? saved[key];

    final List<OnboardingFieldConfig> allFields = [for (final s in config.steps) ...s.fields];
    final int total = allFields.where((f) => f.isInput || f.isUpload).length;
    final int filled = allFields.where((f) {
      final Object? v = valueOf(f.formKey);
      return (f.isInput || f.isUpload) && v != null && v.toString().trim().isNotEmpty;
    }).length;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 120,
      band: _Band(packageName: config.packageName, filled: filled, total: total),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, MediaQuery.paddingOf(context).bottom + Insets.md),
        decoration: const BoxDecoration(
          color: AppColors.canvas,
          border: Border(top: BorderSide(color: AppColors.stroke)),
        ),
        child: PrimaryButton(
          label: 'Submit application',
          icon: Icons.send_rounded,
          loading: _submitting,
          onPressed: _submitting ? null : () => _submit(config),
        ),
      ),
      children: [
        for (int i = 0; i < config.steps.length; i++) ...[
          _StepCard(step: config.steps[i], valueOf: valueOf, onEdit: () => _edit(i)),
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
          builder: (context) => InkCircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        const Gap.xl(),
        Text('Review your application', style: AppText.displaySmall.copyWith(color: AppColors.onInk, fontSize: 25)),
        const Gap.sm(),
        Text(
          'Check everything before you submit. You can still edit any step.',
          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.5),
        ),
        const Gap.lg(),

        Row(
          children: [
            Expanded(
              child: InkStat(label: 'Answered', value: '$filled of $total', icon: Icons.fact_check_rounded),
            ),
            const InkDivider(),
            const SizedBox(width: Insets.md),
            Expanded(
              child: InkStat(
                label: 'Package',
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
  const _StepCard({required this.step, required this.valueOf, required this.onEdit});

  final OnboardingStepConfig step;
  final Object? Function(String key) valueOf;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final List<OnboardingFieldConfig> shown = step.fields.where((f) => f.isInput || f.isUpload).toList();
    return ModuleCard(
      title: step.stepName,
      actionLabel: 'Edit',
      onAction: onEdit,
      child: shown.isEmpty
          ? Text(
              step.capabilities.isEmpty
                  ? 'Nothing to fill in on this step.'
                  : step.capabilities.map((c) => c.label).join(' · '),
              style: AppText.bodySmall.copyWith(height: 1.5),
            )
          : Column(
              children: [
                for (final f in shown)
                  KeyValueRow(
                    label: f.label,
                    value: _display(f, valueOf(f.formKey)),
                    icon: f.isUpload ? Icons.attach_file_rounded : null,
                    valueColor: valueOf(f.formKey) == null ? AppColors.textMuted : null,
                  ),
              ],
            ),
    );
  }

  static String _display(OnboardingFieldConfig f, Object? value) {
    if (value == null || value.toString().trim().isEmpty) return f.required || f.isUpload ? 'Not provided' : '—';
    final String s = value.toString();
    if (f.isUpload) return 'Attached';
    if (f.fieldCode.contains('AADHAAR')) return Fmt.maskAadhaar(s);
    if (f.fieldType == 'MOBILE') return Fmt.phone(s);
    if (f.fieldType == 'DATE') {
      final DateTime? d = DateTime.tryParse(s);
      return d == null ? s : Fmt.date(d);
    }
    return s;
  }
}
