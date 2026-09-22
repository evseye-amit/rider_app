import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/onboarding_draft.dart';
import '../../domain/onboarding_flow_builder.dart';
import '../../domain/usecases/save_onboarding_step.dart';
import '../../domain/usecases/upload_onboarding_document.dart';

class OnboardingFlowPage extends StatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  State<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends State<OnboardingFlowPage> {
  late final DynamicFormController _form =
      DynamicFormController(initial: Map<String, Object?>.from(OnboardingDraft.instance.values));

  RiderOnboardingConfig? _config;
  UiFlowConfig? _flow;
  int _stepIndex = 0;
  bool _saving = false;
  String? _loadError;

  final Set<String> _uploading = <String>{};

  DynamicUiScope get _scope =>
      _session.scope(form: _form, onAction: _handleAction, busyFields: _uploading);

  SessionController get _session => sl<SessionController>();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    RiderOnboardingConfig? config = _session.onboarding;
    if (config == null) {
      final Result<RiderOnboardingConfig> result = await _session.loadOnboarding();
      if (!mounted) return;
      switch (result) {
        case Ok<RiderOnboardingConfig>(:final value):
          config = value;
        case Err<RiderOnboardingConfig>(:final failure):
          setState(() => _loadError = failure.message);
          return;
      }
    }
    if (!mounted) return;
    _apply(config, jumpTo: OnboardingDraft.instance.jumpToStepIndex);
    OnboardingDraft.instance.jumpToStepIndex = null;
  }

  void _apply(RiderOnboardingConfig config, {int? jumpTo}) {
    final UiFlowConfig flow = OnboardingFlowBuilder.build(config);
    for (final entry in config.progress.values.entries) {
      if (_form.valueOf(entry.key) == null && entry.value != null) {
        _form.setValue(entry.key, entry.value, markTouched: false);
      }
    }

    if (config.fieldCodes.contains('MOBILE_NUMBER') && _form.valueOf('MOBILE_NUMBER') == null) {
      _form.setValue('MOBILE_NUMBER', _session.mobile, markTouched: false);
    }
    if (config.fieldCodes.contains('FULL_NAME') && _form.valueOf('FULL_NAME') == null) {
      final Object? name = _session.profile['name'];
      if (name != null) _form.setValue('FULL_NAME', name, markTouched: false);
    }

    final int resume = jumpTo ?? config.resumeIndex;
    setState(() {
      _config = config;
      _flow = flow;
      _stepIndex = flow.steps.isEmpty ? 0 : resume.clamp(0, flow.steps.length - 1);
      _loadError = null;
    });
  }

  void _persist() => OnboardingDraft.instance.save(_form.values);

  Future<void> _confirmExit() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Exit onboarding?',
      message: 'Every step you have completed is saved. You can pick up exactly where you left off next time you sign in.',
      confirmLabel: 'Exit',
      icon: Icons.logout_rounded,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await _session.signOut();
    if (mounted) context.go(Routes.login);
  }

  void _back() {
    if (_stepIndex == 0) {
      _confirmExit();
      return;
    }
    _persist();
    setState(() => _stepIndex -= 1);
  }

  Map<String, Object?> _stepValues(OnboardingStepConfig step) => {
        for (final f in step.inputs)
          if (_form.valueOf(f.fieldCode) != null && _form.valueOf(f.fieldCode).toString().trim().isNotEmpty)
            f.fieldCode: _form.valueOf(f.fieldCode).toString().trim(),
      };


  static const int _defaultMinAge = 18;

  String? _ageCheck(OnboardingStepConfig step) {
    OnboardingFieldConfig? gate;
    for (final f in step.fields) {
      if (f.featureCode.toUpperCase().contains('AGE_VERIFICATION')) {
        gate = f;
        break;
      }
    }
    if (gate == null) return null;

    final int minAge = _minAgeOf(gate);
    final String dob = (_form.valueOf('DATE_OF_BIRTH') ??
            _config?.value('DATE_OF_BIRTH') ??
            '')
        .toString()
        .trim();
    if (dob.isEmpty) {
      return 'Add your date of birth on the first step before continuing';
    }
    final DateTime? born = DateTime.tryParse(dob);
    if (born == null) return 'That date of birth is not valid';

    final DateTime now = DateTime.now();
    int age = now.year - born.year;
    if (now.month < born.month || (now.month == born.month && now.day < born.day)) age--;
    return age < minAge ? 'You must be at least $minAge years old to ride' : null;
  }

  int _minAgeOf(OnboardingFieldConfig field) {
    for (final key in const ['minAge', 'minimumAge']) {
      final Object? direct = field.configuration[key] ?? field.validation[key];
      final int? parsed = direct is int ? direct : int.tryParse(direct?.toString() ?? '');
      if (parsed != null && parsed > 0) return parsed;
    }
    final Object? collection = field.configuration['dataCollection'];
    if (collection is Map) {
      final Object? dob = collection['dateOfBirth'];
      if (dob is Map) {
        final Object? raw = dob['minAge'] ?? dob['minimumAge'];
        final int? parsed = raw is int ? raw : int.tryParse(raw?.toString() ?? '');
        if (parsed != null && parsed > 0) return parsed;
      }
    }
    return _defaultMinAge;
  }

  Future<void> _advance(BuildContext context) async {
    if (_saving) return;
    final RiderOnboardingConfig config = _config!;
    final UiFlowStep step = _flow!.steps[_stepIndex];
    final bool ok = _form.validateNodes(step.screen.body, isVisible: _scope.isVisible);
    if (!ok) {
      AppSnack.error(context, 'Please fix the highlighted fields before continuing');
      return;
    }

    final String? ageProblem = _ageCheck(config.steps[_stepIndex]);
    if (ageProblem != null) {
      AppSnack.error(context, ageProblem);
      return;
    }
    _persist();

    if (_stepIndex == _flow!.steps.length - 1) {
      context.push(Routes.onboardingPreview);
      return;
    }

    final OnboardingStepConfig apiStep = config.steps[_stepIndex];
    setState(() => _saving = true);
    final Result<RiderOnboardingConfig> result =
        await SaveOnboardingStep(sl())(SaveStepParams(stepId: apiStep.stepId, values: _stepValues(apiStep)));
    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok<RiderOnboardingConfig>(:final value):
        await _session.applyOnboarding(value);
        if (!mounted) return;
        _apply(value, jumpTo: _stepIndex + 1);
      case Err<RiderOnboardingConfig>(:final failure):
        AppSnack.error(this.context, failure.message);
    }
  }

  Future<void> _capture(BuildContext context, UiNode node) async {
    final String key = node.fieldKey;
    final String fieldCode = (node.props['fieldCode'] ?? node.props['featureCode'] ?? '').toString();
    if (fieldCode.isEmpty) return;

    final File? file = await PhotoSourceSheet.pick(
      context,
      subtitle: 'Take a photo of the document, or choose one you already have',
    );
    if (file == null || !mounted) return;

    setState(() => _uploading.add(key));
    final Result<RemotePhoto> result =
        await UploadOnboardingDocument(sl())(UploadDocumentParams(fieldCode: fieldCode, file: file));
    if (!mounted) return;
    setState(() => _uploading.remove(key));

    switch (result) {
      case Ok<RemotePhoto>():
        _form.setValue(key, file.uri.pathSegments.last);
        AppSnack.success(this.context, 'Uploaded');
      case Err<RemotePhoto>(:final failure):
        AppSnack.error(this.context, failure.message);
    }
  }

  void _handleAction(BuildContext context, UiAction action, UiNode node) {
    switch (action.type) {
      case 'next':
        _advance(context);
        break;
      case 'previous':
      case 'back':
        _back();
        break;
      case 'pickFile':
        _capture(context, node);
        break;
      case 'navigate':
        if (action.target != null) context.push(action.target!);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flow == null) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: _loadError != null
              ? EmptyState(
                  title: 'Could not load onboarding',
                  message: _loadError,
                  icon: Icons.cloud_off_rounded,
                  tone: AppColors.danger,
                  actionLabel: 'Retry',
                  onAction: () {
                    setState(() => _loadError = null);
                    _load();
                  },
                )
              : const Center(child: LoadingOverlay(message: 'Loading your onboarding form…')),
        ),
      );
    }

    final UiFlowConfig flow = _flow!;
    if (flow.steps.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: 'Nothing to fill in',
            message: 'Your fleet operator\'s package has no onboarding steps configured yet. '
                'Ask them to set up rider onboarding, then sign in again.',
            icon: Icons.assignment_outlined,
            actionLabel: 'Refresh',
            onAction: _load,
          ),
        ),
      );
    }

    final UiFlowStep step = flow.steps[_stepIndex];
    final List<String> labels = flow.steps.map((s) => s.shortLabel ?? s.label).toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: DynamicUiProvider(
        scope: _scope,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeroBand(
                          padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, Insets.x3l),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkCircleButton(icon: Icons.arrow_back_rounded, onTap: _back),
                                  const Spacer(),
                                  Text(
                                    'STEP ${_stepIndex + 1} OF ${flow.steps.length}',
                                    style: AppText.overline.copyWith(color: AppColors.onInkMuted),
                                  ),
                                ],
                              ),
                              const Gap.xl(),
                              Text(
                                _scope.interpolate(step.screen.title),
                                style: AppText.displaySmall.copyWith(color: AppColors.onInk, fontSize: 25),
                              ),
                              if (step.screen.subtitle != null && step.screen.subtitle!.isNotEmpty) ...[
                                const Gap.sm(),
                                Text(
                                  _scope.interpolate(step.screen.subtitle),
                                  style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.5),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -22),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.lg),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: Corners.brXl,
                                    boxShadow: Shadows.floating,
                                  ),
                                  child: StepProgress(steps: labels, currentIndex: _stepIndex, compact: true),
                                ),
                                const Gap.lg(),
                                ModuleCard(
                                  child: DynamicNodeList(nodes: step.screen.body, scope: _scope),
                                ),
                                const Gap.xl(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (step.screen.footer.isNotEmpty)
                  Container(
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
                    child: IgnorePointer(
                      ignoring: _saving,
                      child: Opacity(
                        opacity: _saving ? 0.6 : 1,
                        child: DynamicNodeList(nodes: step.screen.footer, scope: _scope, gap: Insets.md),
                      ),
                    ),
                  ),
              ],
            ),
            if (_saving) const Positioned.fill(child: LoadingOverlay(message: 'Saving…')),
          ],
        ),
      ),
    );
  }
}
