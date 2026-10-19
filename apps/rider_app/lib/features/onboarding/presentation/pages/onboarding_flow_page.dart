import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/referral/pending_referral.dart';
import '../../../../core/referral/referral_link.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../domain/onboarding_flow_builder.dart';
import '../../domain/usecases/apply_referral_code.dart';
import '../../domain/usecases/save_onboarding_step.dart';
import '../../domain/usecases/upload_onboarding_document.dart';
import '../../onboarding_dependencies.dart';
import '../providers/onboarding_draft_provider.dart';

class OnboardingFlowPage extends ConsumerStatefulWidget {
  const OnboardingFlowPage({super.key});

  @override
  ConsumerState<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends ConsumerState<OnboardingFlowPage> {
  static const int _defaultMinAge = 18;
  static final RegExp _ifscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  late final DynamicFormController _form = DynamicFormController(
    initial: Map<String, Object?>.from(ref.read(onboardingDraftProvider)),
  );

  final Set<String> _busy = {};

  ReferralLink? _scanned;
  RiderOnboardingConfig? _config;
  int _stepIndex = 0;
  bool _saving = false;
  String? _loadError;

  RiderSessionNotifier get _session => ref.read(riderSessionProvider.notifier);

  DynamicUiScope _scopeFor(RiderSession session) =>
      session.scope(form: _form, onAction: _handleAction, busyFields: _busy);

  DynamicUiScope get _scope => _scopeFor(ref.read(riderSessionProvider));

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    RiderOnboardingConfig? config = ref.read(riderSessionProvider).onboarding;
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
    _apply(config);
  }

  UiFlowConfig _buildFlow(RiderOnboardingConfig config) => OnboardingFlowBuilder.build(config, context.l10n);

  void _apply(RiderOnboardingConfig config, {int? jumpTo}) {
    final RiderSession session = ref.read(riderSessionProvider);

    for (final MapEntry<String, Object?> entry in config.progress.values.entries) {
      if (_form.valueOf(entry.key) == null && entry.value != null) {
        _form.setValue(entry.key, entry.value, markTouched: false);
      }
    }
    if (config.fieldCodes.contains('MOBILE_NUMBER') && _form.valueOf('MOBILE_NUMBER') == null) {
      _form.setValue('MOBILE_NUMBER', session.mobile, markTouched: false);
    }
    if (config.fieldCodes.contains('FULL_NAME') && _form.valueOf('FULL_NAME') == null) {
      final Object? name = session.profile['name'];
      if (name != null) _form.setValue('FULL_NAME', name, markTouched: false);
    }
    final String? savedReferral = config.value(OnboardingFlowBuilder.referralCodeKey);
    if (savedReferral != null && _form.valueOf(OnboardingFlowBuilder.referralAppliedKey) == null) {
      _form.setValue(OnboardingFlowBuilder.referralAppliedKey, savedReferral, markTouched: false);
    }
    _prefillReferral(config, ref.read(pendingReferralProvider));
    _syncDocuments(config);

    final int resume = jumpTo ?? config.resumeIndex;
    setState(() {
      _config = config;
      _stepIndex = config.steps.isEmpty ? 0 : resume.clamp(0, config.steps.length - 1);
      _loadError = null;
    });
  }

  void _syncDocuments(RiderOnboardingConfig config) {
    for (final OnboardingStepConfig step in config.steps) {
      for (final OnboardingFieldConfig field in step.uploads) {
        final OnboardingDocument? document = config.document(field);
        if (document == null) continue;
        final Object? current = _form.valueOf(field.formKey);
        if (document.isRejected) {
          if (current != null) _form.setValue(field.formKey, null, markTouched: false);
        } else if (current == null) {
          _form.setValue(field.formKey, _documentLabel(document), markTouched: false);
        }
      }
    }
  }

  static String _documentLabel(OnboardingDocument document) => document.status == OnboardingDocumentStatus.approved
      ? ActiveLocale.strings.onboardingDocumentApproved
      : ActiveLocale.strings.onboardingDocumentInReview;

  Future<void> _refreshDocuments() async {
    final Result<RiderOnboardingConfig> result = await _session.loadOnboarding();
    if (!mounted) return;
    if (result case Ok<RiderOnboardingConfig>(:final value)) setState(() => _config = value);
  }

  void _persist() => ref.read(onboardingDraftProvider.notifier).save(_form.values);

  Future<void> _confirmExit() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.onboardingExitOnboarding,
      message: context.l10n.onboardingEveryStepHaveCompletedSaved,
      confirmLabel: context.l10n.onboardingExit,
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
    for (final OnboardingFieldConfig field in step.inputs)
      if (_wireValue(field) case final Object value) field.fieldCode: value,
    if (OnboardingFlowBuilder.isBankStep(step))
      for (final MapEntry<String, String> entry in OnboardingFlowBuilder.bankFieldCodes.entries)
        if (step.fields.any((field) => field.fieldCode == entry.key))
          if (_form.stringOf(entry.value).trim() case final String value when value.isNotEmpty) entry.key: value,
  };

  Object? _wireValue(OnboardingFieldConfig field) {
    final Object? raw = _form.valueOf(field.fieldCode);
    if (raw == null) return null;
    if (field.fieldType == 'REFERENCE') {
      if (raw is List) return raw.isEmpty ? null : raw;
      final String text = raw.toString().trim();
      if (text.isEmpty) return null;
      final Object? decoded = jsonDecode(text);
      return decoded is List && decoded.isNotEmpty ? decoded : null;
    }
    final String text = raw.toString().trim();
    return text.isEmpty ? null : text;
  }

  String? _ageCheck(OnboardingStepConfig step) {
    final OnboardingFieldConfig? gate = step.fields
        .where((field) => field.featureCode.toUpperCase().contains('AGE_VERIFICATION'))
        .firstOrNull;
    if (gate == null) return null;

    final int minAge = _minAgeOf(gate);
    final String dob = (_form.valueOf('DATE_OF_BIRTH') ?? _config?.value('DATE_OF_BIRTH') ?? '').toString().trim();
    if (dob.isEmpty) return context.l10n.onboardingAddDateBirthFirstStep;
    final DateTime? born = DateTime.tryParse(dob);
    if (born == null) return context.l10n.onboardingDateBirthNotValid;

    final DateTime now = DateTime.now();
    int age = now.year - born.year;
    if (now.month < born.month || (now.month == born.month && now.day < born.day)) age--;
    return age < minAge ? 'You must be at least $minAge years old to ride' : null;
  }

  int _minAgeOf(OnboardingFieldConfig field) {
    for (final String key in const ['minAge', 'minimumAge']) {
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

  Future<void> _advance() async {
    if (_saving) return;
    final RiderOnboardingConfig config = _config!;
    final UiFlowConfig flow = _buildFlow(config);
    final UiFlowStep step = flow.steps[_stepIndex];
    final bool valid = _form.validateNodes([...step.screen.body, ...step.screen.footer], isVisible: _scope.isVisible);
    if (!valid) {
      AppSnack.error(context, context.l10n.onboardingPleaseFixHighlightedFieldsBefore);
      return;
    }

    final String? ageProblem = _ageCheck(config.steps[_stepIndex]);
    if (ageProblem != null) {
      AppSnack.error(context, ageProblem);
      return;
    }
    _persist();

    if (_stepIndex == flow.steps.length - 1) {
      final int? editStep = await context.push<int>(Routes.onboardingPreview);
      if (!mounted || editStep == null) return;
      setState(() => _stepIndex = editStep.clamp(0, flow.steps.length - 1));
      return;
    }

    final OnboardingStepConfig apiStep = config.steps[_stepIndex];
    setState(() => _saving = true);
    final Result<RiderOnboardingConfig> result = await ref.read(saveOnboardingStepProvider)(
      SaveStepParams(stepId: apiStep.stepId, values: _stepValues(apiStep)),
    );
    if (!mounted) return;
    setState(() => _saving = false);

    switch (result) {
      case Ok<RiderOnboardingConfig>(:final value):
        await _session.applyOnboarding(value);
        if (!mounted) return;
        _apply(value, jumpTo: value.needsResubmission ? null : _stepIndex + 1);
      case Err<RiderOnboardingConfig>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _capture(UiNode node) async {
    final String key = node.fieldKey;
    final String fieldCode = (node.props['fieldCode'] ?? node.props['featureCode'] ?? '').toString();
    if (fieldCode.isEmpty) return;

    final File? file = await PhotoSourceSheet.pick(
      context,
      subtitle: context.l10n.onboardingTakePhotoDocumentChooseOne,
    );
    if (file == null || !mounted) return;

    setState(() => _busy.add(key));
    final Result<RemotePhoto> result = await ref.read(uploadOnboardingDocumentProvider)(
      UploadDocumentParams(fieldCode: fieldCode, file: file),
    );
    if (!mounted) return;
    setState(() => _busy.remove(key));

    switch (result) {
      case Ok<RemotePhoto>():
        _form.setValue(key, file.uri.pathSegments.last);
        AppSnack.success(context, context.l10n.commonUploaded);
        if (node.props['rejected'] != null) unawaited(_refreshDocuments());
      case Err<RemotePhoto>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  bool get _referralLocked => _form.valueOf(OnboardingFlowBuilder.referralLockedKey) == true;

  void _prefillReferral(RiderOnboardingConfig config, PendingReferral? pending) {
    if (pending == null || !config.fieldCodes.contains(OnboardingFlowBuilder.referralCodeKey)) return;
    if (_form.valueOf(OnboardingFlowBuilder.referralAppliedKey) != null) return;
    _form.setValue(OnboardingFlowBuilder.referralCodeKey, pending.link.code, markTouched: false);
    _form.setValue(OnboardingFlowBuilder.referralLockedKey, true, markTouched: false);
    _form.setError(OnboardingFlowBuilder.referralCodeKey, null);
  }

  Future<void> _scanReferral(UiNode node) async {
    if (_referralLocked || _busy.contains(node.fieldKey)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final ReferralLink? link = await context.push<ReferralLink>(Routes.onboardingReferralScan);
    if (link == null || !mounted) return;
    _scanned = link;
    _form.setValue(node.fieldKey, link.code);
    _form.setError(node.fieldKey, null);
    AppSnack.success(context, context.l10n.referScanFound(link.code));
  }

  Future<void> _applyReferral(UiNode node) async {
    final String key = node.fieldKey;
    final String code = _form.stringOf(key).trim();
    final List<ValidationRule> format = [
      for (final ValidationRule rule in node.validations)
        if (rule.type != 'match') rule,
    ];
    final String? problem = validateValue(code, format, label: node.label);
    if (problem != null) {
      _form.setError(key, problem);
      return;
    }

    final bool locked = _referralLocked;
    final PendingReferral? pending = locked ? ref.read(pendingReferralProvider) : null;
    final ReferralLink? scanned = _scanned?.code == code.toUpperCase() ? _scanned : null;
    final ReferralLink? link = pending?.link.code == code.toUpperCase() ? pending?.link : scanned;
    final ReferralSource source = switch ((pending, scanned)) {
      (final PendingReferral from, _) => from.source,
      (null, final ReferralLink _) => ReferralSource.qrCode,
      (null, null) => ReferralSource.referralCode,
    };

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _busy.add(key));
    final Result<void> result = await ref.read(applyReferralCodeProvider)(
      ReferralApplication(
        input: code,
        source: source,
        inviteToken: link?.inviteToken,
        campaignCode: link?.campaignCode,
      ),
    );
    if (!mounted) return;
    setState(() => _busy.remove(key));

    switch (result) {
      case Ok<void>():
        _form.setValue(OnboardingFlowBuilder.referralAppliedKey, code);
        _form.setError(key, null);
        if (locked) ref.read(pendingReferralProvider.notifier).clear();
        _persist();
        AppSnack.success(context, context.l10n.onboardingReferralCodeApplied);
      case Err<void>(:final failure):
        final bool transient =
            failure is NetworkFailure ||
            failure is RateLimitFailure ||
            (failure is ServerFailure && (failure.status ?? 500) >= 500);
        if (locked && !transient) {
          _form.setValue(OnboardingFlowBuilder.referralLockedKey, null);
          ref.read(pendingReferralProvider.notifier).clear();
          _persist();
        }
        _form.setError(key, failure.message);
    }
  }

  Future<void> _lookupIfsc(UiNode node) async {
    final String key = node.fieldKey;
    final String ifsc = _form.stringOf(key).trim().toUpperCase();
    if (!_ifscPattern.hasMatch(ifsc) || _busy.contains(key)) return;
    setState(() => _busy.add(key));
    final Result<IfscBankDetails> result = await ref.read(lookupIfscProvider)(ifsc);
    if (!mounted) return;
    setState(() => _busy.remove(key));

    final String current = _form.stringOf(key).trim().toUpperCase();
    if (current != ifsc) {
      if (_ifscPattern.hasMatch(current)) unawaited(_lookupIfsc(node));
      return;
    }
    final IfscBankDetails? details = result.valueOrNull;
    for (final (String field, String? value) in [
      (OnboardingFlowBuilder.bankNameKey, details?.bankName),
      (OnboardingFlowBuilder.bankBranchKey, details?.branch),
      (OnboardingFlowBuilder.bankCityKey, details?.city),
      (OnboardingFlowBuilder.bankStateKey, details?.state),
    ]) {
      _form.setValue(field, value?.trim() ?? '');
    }
    _form.setValue(OnboardingFlowBuilder.bankIfscVerifiedKey, details == null ? null : ifsc);
    _form.setValue(OnboardingFlowBuilder.bankIfscNoteKey, switch (result) {
      Ok<IfscBankDetails>() => null,
      Err<IfscBankDetails>(failure: NotFoundFailure()) => context.l10n.onboardingBankIfscNotFound,
      Err<IfscBankDetails>() => context.l10n.onboardingBankIfscFailed,
    });
    _form.setValue(OnboardingFlowBuilder.bankIfscCheckedKey, ifsc);
    _persist();
  }

  void _handleAction(BuildContext context, UiAction action, UiNode node) {
    switch (action.type) {
      case 'next':
        _advance();
      case 'previous' || 'back':
        _back();
      case 'pickFile':
        _capture(node);
      case 'applyReferral':
        _applyReferral(node);
      case 'scanReferral':
        _scanReferral(node);
      case 'lookupIfsc':
        _lookupIfsc(node);
      case 'navigate':
        if (action.target != null) context.push(action.target!);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pendingReferralProvider, (_, next) {
      final RiderOnboardingConfig? loaded = _config;
      if (loaded != null && next != null && !_busy.contains(OnboardingFlowBuilder.referralCodeKey)) {
        _prefillReferral(loaded, next);
      }
    });
    final RiderOnboardingConfig? config = _config;
    if (config == null) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: _loadError != null
              ? EmptyState(
                  title: context.l10n.onboardingCouldNotLoadOnboarding,
                  message: _loadError,
                  icon: Icons.cloud_off_rounded,
                  tone: AppColors.danger,
                  actionLabel: context.l10n.commonRetry,
                  onAction: () {
                    setState(() => _loadError = null);
                    _load();
                  },
                )
              : Center(child: LoadingOverlay(message: context.l10n.onboardingLoadingOnboardingForm)),
        ),
      );
    }

    final UiFlowConfig flow = _buildFlow(config);
    if (flow.steps.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.onboardingNothingFill,
            message: context.l10n.onboardingNoStepsConfigured,
            icon: Icons.assignment_outlined,
            actionLabel: context.l10n.commonRefresh,
            onAction: _load,
          ),
        ),
      );
    }

    final DynamicUiScope scope = _scopeFor(ref.watch(riderSessionProvider));
    final UiFlowStep step = flow.steps[_stepIndex];
    final List<String> labels = flow.steps.map((s) => s.shortLabel ?? s.label).toList(growable: false);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: DynamicUiProvider(
        scope: scope,
        child: Stack(
          children: [
            Column(
              children: [
                HeroBand(
                  bottomRadius: 0,
                  padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, Insets.sm + 2),
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
                        scope.interpolate(step.screen.title),
                        style: AppText.displaySmall.copyWith(color: AppColors.onInk, fontSize: 25),
                      ),
                      if (step.screen.subtitle != null && step.screen.subtitle!.isNotEmpty) ...[
                        const Gap.sm(),
                        Text(
                          scope.interpolate(step.screen.subtitle),
                          style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary, height: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned(top: 0, left: 0, right: 0, height: 22, child: HeroBandEdge()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.lg),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: Corners.brXl,
                          boxShadow: Shadows.floating,
                        ),
                        child: StepProgress(steps: labels, currentIndex: _stepIndex, compact: true),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.lg, Insets.gutter, Insets.xl),
                    child: ModuleCard(
                      child: DynamicNodeList(nodes: step.screen.body, scope: scope),
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
                        child: DynamicNodeList(nodes: step.screen.footer, scope: scope, gap: Insets.md),
                      ),
                    ),
                  ),
              ],
            ),
            if (_saving) Positioned.fill(child: LoadingOverlay(message: context.l10n.onboardingSaving)),
          ],
        ),
      ),
    );
  }
}
