import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../allocation_dependencies.dart';
import '../../domain/allocation_repository.dart' show DeallocationStart;
import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/request_deallocation_otp.dart';
import '../../domain/usecases/verify_deallocation_otp.dart';
import '../providers/deallocation_request_provider.dart';

class DeallocationFlowPage extends ConsumerStatefulWidget {
  const DeallocationFlowPage({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<DeallocationFlowPage> createState() => _DeallocationFlowPageState();
}

class _DeallocationFlowPageState extends ConsumerState<DeallocationFlowPage> {
  final DynamicFormController _form = DynamicFormController();
  int _stepIndex = 0;
  bool _busy = false;

  String? _inspectionId;
  OtpChallenge? _riderOtp;
  OtpChallenge? _operatorOtp;

  UiFlowConfig? get _flow => ref.read(deallocationFlowConfigProvider).value;

  DeallocationRequest? get _request => ref.read(deallocationRequestProvider(widget.requestId)).value;

  DynamicUiScope _scopeFor(FleetSession session, DeallocationRequest request) => session.scope(
    form: _form,
    onAction: _handleAction,
    data: {
      'rider': {'name': request.riderName, 'code': request.riderCode, 'mobile': request.mobile},
      'vehicle': {'number': request.vehicleNumber, 'model': request.model},
    },
  );

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UiFlowConfig> flowConfig = ref.watch(deallocationFlowConfigProvider);
    final AsyncValue<DeallocationRequest> request = ref.watch(deallocationRequestProvider(widget.requestId));

    if (flowConfig.hasError) {
      return AppScaffold(
        title: context.l10n.allocationDeAllocateVehicle,
        body: EmptyState(
          title: context.l10n.allocationCouldNotLoadDeAllocation,
          message: context.l10n.allocationCouldNotLoadDeAllocation2,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(deallocationFlowConfigProvider),
        ),
      );
    }

    final UiFlowConfig? flow = flowConfig.value;
    if (flow == null || (request.isLoading && !request.hasValue)) {
      return AppScaffold(
        title: context.l10n.allocationDeAllocateVehicle,
        body: const PageBody(
          children: [
            ShimmerBox(height: 40, borderRadius: Corners.pill),
            Gap.xl(),
            ShimmerBox(height: 140, borderRadius: Corners.brLg),
            Gap.md(),
            ShimmerBox(height: 220, borderRadius: Corners.brLg),
          ],
        ),
      );
    }

    final DeallocationRequest? current = request.value;
    if (request.hasError || current == null) {
      return AppScaffold(
        title: context.l10n.allocationDeAllocateVehicle,
        body: EmptyState(
          title: context.l10n.allocationCouldNotLoadReturn,
          message: request.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(deallocationRequestProvider(widget.requestId)),
        ),
      );
    }

    final FleetSession session = ref.watch(fleetSessionProvider);
    final DynamicUiScope scope = _scopeFor(session, current);
    final UiFlowStep step = flow.steps[_stepIndex];
    final String? stepTitle = step.screen.title == null ? null : scope.interpolate(step.screen.title);

    return Stack(
      children: [
        DynamicScreen(
          config: step.screen,
          scope: scope,
          onBack: _busy ? null : () => _handleBack(current),
          headerSlot: _FlowHeader(
            steps: flow.steps.map((s) => s.shortLabel ?? s.label).toList(growable: false),
            currentIndex: _stepIndex,
            stepTitle: stepTitle ?? step.label,
            riderName: current.riderName,
            vehicleNumber: current.vehicleNumber,
            vehicleModel: current.model,
            note: _stepIndex == flow.steps.length - 1 ? _verificationNote(current, session.mobile) : null,
          ),
        ),
        if (_busy) Positioned.fill(child: LoadingOverlay(message: context.l10n.allocationTalkingServer)),
      ],
    );
  }

  String _verificationNote(DeallocationRequest request, String operatorMobile) {
    if (_riderOtp == null) return context.l10n.allocationCodesSentWhenStepOpens;
    final String operator = operatorMobile.isEmpty ? 'your number' : Fmt.phone(operatorMobile);
    return 'Codes sent to the rider (${Fmt.phone(request.mobile)}) and to you ($operator).';
  }

  void _handleAction(BuildContext context, UiAction action, UiNode node) {
    switch (action.type) {
      case 'next':
        _advance();
      case 'previous' || 'back':
        final DeallocationRequest? request = _request;
        if (request != null) _handleBack(request);
      case 'pickFile':
        _form.setValue(node.fieldKey, 'capture_${DateTime.now().millisecondsSinceEpoch}.jpg');
        AppSnack.success(context, context.l10n.allocationPhotoAttached);
      case 'navigate':
        if (action.target != null) context.push(action.target!);
    }
  }

  Future<void> _advance() async {
    final UiFlowConfig? flow = _flow;
    final DeallocationRequest? request = _request;
    if (_busy || flow == null || request == null) return;

    final UiFlowStep step = flow.steps[_stepIndex];
    final DynamicUiScope scope = _scopeFor(ref.read(fleetSessionProvider), request);
    if (!_form.validateNodes(step.screen.body, isVisible: scope.isVisible)) return;

    if (_stepIndex < flow.steps.length - 1) {
      if (_stepIndex == flow.steps.length - 2) {
        final bool prepared = await _prepareVerification(request);
        if (!prepared || !mounted) return;
      }
      setState(() => _stepIndex++);
      return;
    }

    await _complete(request);
  }

  Future<bool> _prepareVerification(DeallocationRequest request) async {
    setState(() => _busy = true);
    try {
      if (_inspectionId == null) {
        if (request.isInitiated && request.postReturnInspectionId != null) {
          _inspectionId = request.postReturnInspectionId;
        } else {
          final Result<DeallocationStart> started = await ref.read(initiateDeallocationProvider)(request.id);
          if (!mounted) return false;
          switch (started) {
            case Err<DeallocationStart>(:final failure):
              AppSnack.error(context, failure.message);
              return false;
            case Ok<DeallocationStart>(:final value):
              _inspectionId = value.inspectionId;
          }
        }
      }

      final String operatorMobile = ref.read(fleetSessionProvider).mobile;
      final RequestDeallocationOtp requestOtp = ref.read(requestDeallocationOtpProvider);
      final List<Result<OtpChallenge>> codes = await Future.wait([
        requestOtp(DeallocationOtpParams(allocationId: request.id, phone: request.mobile, party: 'RIDER')),
        requestOtp(
          DeallocationOtpParams(
            allocationId: request.id,
            phone: operatorMobile.isEmpty ? request.mobile : operatorMobile,
            party: 'OPERATOR',
          ),
        ),
      ]);
      if (!mounted) return false;
      for (final Result<OtpChallenge> code in codes) {
        if (code case Err<OtpChallenge>(:final failure)) {
          AppSnack.error(context, failure.message);
          return false;
        }
      }
      _riderOtp = codes[0].valueOrNull;
      _operatorOtp = codes[1].valueOrNull;
      AppSnack.success(context, context.l10n.allocationReturnStartedCodesSentRider);
      return true;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete(DeallocationRequest request) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationCompleteDeAllocation,
      message: '${request.vehicleNumber} will be taken back from ${request.riderName} and the allocation closed.',
      confirmLabel: context.l10n.allocationComplete,
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !mounted) return;

    setState(() => _busy = true);
    try {
      final List<(OtpChallenge?, String, String)> codes = [
        (_riderOtp, _form.stringOf('riderOtp'), 'rider'),
        (_operatorOtp, _form.stringOf('teamLeadOtp'), 'operator'),
      ];
      final VerifyDeallocationOtp verifyOtp = ref.read(verifyDeallocationOtpProvider);
      for (final (OtpChallenge? challenge, String code, String who) in codes) {
        if (challenge == null) {
          AppSnack.error(context, 'The $who code was never sent — go back a step and forward again.');
          return;
        }
        final Result<void> verified = await verifyOtp(
          VerifyDeallocationOtpParams(allocationId: request.id, otpRequestId: challenge.otpRequestId, code: code),
        );
        if (!mounted) return;
        if (verified case Err<void>(:final failure)) {
          AppSnack.error(context, 'The $who code was not accepted: ${failure.message}');
          return;
        }
      }

      final String? inspectionId = _inspectionId;
      if (inspectionId != null && inspectionId.isNotEmpty) {
        final Result<void> inspected = await ref.read(completeInspectionProvider)(inspectionId);
        if (!mounted) return;
        if (inspected case Err<void>(:final failure) when failure is! ValidationFailure) {
          AppSnack.error(context, failure.message);
          return;
        }
      }

      final Result<void> done = await ref.read(completeDeallocationProvider)(request.id);
      if (!mounted) return;
      switch (done) {
        case Err<void>(:final failure):
          AppSnack.error(context, failure.message);
        case Ok<void>():
          context.go(Routes.allocations);
          AppSnack.success(context, '${request.vehicleNumber} de-allocated from ${request.riderName}.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _handleBack(DeallocationRequest request) async {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
      return;
    }
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationAbandonDeAllocation,
      message: _inspectionId == null
          ? 'The photos and assessment entered for ${request.vehicleNumber} will be lost.'
          : context.l10n.allocationReturnHasAlreadyBeenStarted,
      confirmLabel: context.l10n.allocationAbandon,
      cancelLabel: context.l10n.allocationKeepGoing,
      destructive: true,
    );
    if (confirmed && mounted) context.pop();
  }
}

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({
    required this.steps,
    required this.currentIndex,
    required this.stepTitle,
    required this.riderName,
    required this.vehicleNumber,
    required this.vehicleModel,
    this.note,
  });

  final List<String> steps;
  final int currentIndex;
  final String stepTitle;
  final String riderName;
  final String vehicleNumber;
  final String vehicleModel;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(color: AppColors.ink, borderRadius: Corners.brLg, boxShadow: Shadows.soft),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step ${currentIndex + 1} of ${steps.length}',
                style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.onInkSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                stepTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(fontSize: 17, color: AppColors.onInk),
              ),
              const SizedBox(height: Insets.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: Corners.brSm,
                  border: Border.all(color: AppColors.inkStroke),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_rounded, size: 14, color: AppColors.onInkMuted),
                    const SizedBox(width: Insets.sm - 2),
                    Expanded(
                      child: Text(
                        riderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInk),
                      ),
                    ),
                    const InkDivider(height: 14),
                    const SizedBox(width: Insets.md),
                    const Icon(Icons.electric_scooter_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: Insets.sm - 2),
                    Flexible(
                      child: Text(
                        '$vehicleNumber · $vehicleModel',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              if (note != null) ...[
                const SizedBox(height: Insets.md),
                Text(note!, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.onInkMuted)),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        StepProgress(steps: steps, currentIndex: currentIndex, compact: true),
      ],
    );
  }
}
