import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/allocation_repository.dart' show DeallocationStart;
import '../../domain/entities/deallocation_request.dart';
import '../../domain/usecases/complete_deallocation.dart';
import '../../domain/usecases/complete_inspection.dart';
import '../../domain/usecases/get_deallocation_request.dart';
import '../../domain/usecases/initiate_deallocation.dart';
import '../../domain/usecases/request_deallocation_otp.dart';
import '../../domain/usecases/verify_deallocation_otp.dart';
import '../cubit/deallocation_flow_cubit.dart';

class DeallocationFlowPage extends StatelessWidget {
  const DeallocationFlowPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeallocationFlowCubit(GetDeallocationRequest(sl()), requestId)..load(),
      child: const _DeallocationFlowView(),
    );
  }
}

class _DeallocationFlowView extends StatefulWidget {
  const _DeallocationFlowView();

  @override
  State<_DeallocationFlowView> createState() => _DeallocationFlowViewState();
}

class _DeallocationFlowViewState extends State<_DeallocationFlowView> {
  final DynamicFormController _form = DynamicFormController();
  UiFlowConfig? _flow;
  String? _flowError;
  int _stepIndex = 0;
  bool _busy = false;
  late DynamicUiScope _scope;

  String? _inspectionId;
  OtpChallenge? _riderOtp;
  OtpChallenge? _operatorOtp;

  @override
  void initState() {
    super.initState();
    _loadFlow();
  }

  Future<void> _loadFlow() async {
    try {
      final UiFlowConfig flow = await sl<UiConfigService>().loadFlow('deallocation_flow');
      if (!mounted) return;
      setState(() => _flow = flow);
    } on Object {
      if (!mounted) return;
      setState(() => _flowError = 'Could not load the de-allocation flow.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_flowError != null) {
      return AppScaffold(
        title: 'De-allocate vehicle',
        body: EmptyState(
          title: 'Could not load the de-allocation flow',
          message: _flowError,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: 'Try again',
          onAction: () {
            setState(() => _flowError = null);
            _loadFlow();
          },
        ),
      );
    }

    return BlocBuilder<DeallocationFlowCubit, DeallocationFlowState>(
      builder: (context, state) {
        if (_flow == null || state.isLoading) {
          return AppScaffold(
            title: 'De-allocate vehicle',
            body: PageBody(children: const [
              ShimmerBox(height: 40, borderRadius: Corners.pill),
              Gap.xl(),
              ShimmerBox(height: 140, borderRadius: Corners.brLg),
              Gap.md(),
              ShimmerBox(height: 220, borderRadius: Corners.brLg),
            ]),
          );
        }
        if (state.status == DeallocationFlowStatus.failure || state.request == null) {
          return AppScaffold(
            title: 'De-allocate vehicle',
            body: EmptyState(
              title: 'Could not load this return',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: () => context.read<DeallocationFlowCubit>().load(),
            ),
          );
        }

        final UiFlowConfig flow = _flow!;
        final DeallocationRequest request = state.request!;
        final UiFlowStep step = flow.steps[_stepIndex];
        final SessionController session = sl<SessionController>();

        _scope = session.scope(
          form: _form,
          onAction: _handleAction,
          data: {
            'rider': {'name': request.riderName, 'code': request.riderCode, 'mobile': request.mobile},
            'vehicle': {'number': request.vehicleNumber, 'model': request.model},
          },
        );

        final String? stepTitle = step.screen.title == null ? null : _scope.interpolate(step.screen.title);

        return Stack(
          children: [
            DynamicScreen(
              config: step.screen,
              scope: _scope,
              onBack: _busy ? null : () => _handleBack(context, request),
              headerSlot: _FlowHeader(
                steps: flow.steps.map((s) => s.shortLabel ?? s.label).toList(growable: false),
                currentIndex: _stepIndex,
                stepTitle: stepTitle ?? step.label,
                riderName: request.riderName,
                vehicleNumber: request.vehicleNumber,
                vehicleModel: request.model,
                note: _stepIndex == flow.steps.length - 1 ? _verificationNote(request) : null,
              ),
            ),
            if (_busy) const Positioned.fill(child: LoadingOverlay(message: 'Talking to the server…')),
          ],
        );
      },
    );
  }

  String _verificationNote(DeallocationRequest request) {
    final String me = sl<SessionController>().mobile;
    return _riderOtp == null
        ? 'Codes are sent when this step opens.'
        : 'Codes sent to the rider (${Fmt.phone(request.mobile)}) and to you (${me.isEmpty ? 'your number' : Fmt.phone(me)}).';
  }

  void _handleAction(BuildContext context, UiAction action, UiNode node) {
    switch (action.type) {
      case 'next':
        _advance(context);
        break;
      case 'previous':
      case 'back':
        final DeallocationFlowState state = context.read<DeallocationFlowCubit>().state;
        if (state.request != null) _handleBack(context, state.request!);
        break;
      case 'pickFile':

        _form.setValue(node.fieldKey, 'capture_${DateTime.now().millisecondsSinceEpoch}.jpg');
        AppSnack.success(context, 'Photo attached');
        break;
      case 'navigate':
        if (action.target != null) context.push(action.target!);
        break;
      default:
        break;
    }
  }

  Future<void> _advance(BuildContext context) async {
    if (_busy) return;
    final UiFlowConfig flow = _flow!;
    final UiFlowStep step = flow.steps[_stepIndex];
    final bool ok = _form.validateNodes(step.screen.body, isVisible: _scope.isVisible);
    if (!ok) return;

    final DeallocationRequest request = context.read<DeallocationFlowCubit>().state.request!;

    if (_stepIndex < flow.steps.length - 1) {
      if (_stepIndex == flow.steps.length - 2) {
        final bool prepared = await _prepareVerification(context, request);
        if (!prepared || !context.mounted) return;
      }
      setState(() => _stepIndex++);
      return;
    }

    await _complete(context, request);
  }

  Future<bool> _prepareVerification(BuildContext context, DeallocationRequest request) async {
    setState(() => _busy = true);
    try {
      if (_inspectionId == null) {
        if (request.isInitiated && request.postReturnInspectionId != null) {
          _inspectionId = request.postReturnInspectionId;
        } else {
          final Result<DeallocationStart> started = await InitiateDeallocation(sl())(request.id);
          if (!context.mounted) return false;
          switch (started) {
            case Err<DeallocationStart>(:final failure):
              AppSnack.error(context, failure.message);
              return false;
            case Ok<DeallocationStart>(:final value):
              _inspectionId = value.inspectionId;
          }
        }
      }

      final String operatorMobile = sl<SessionController>().mobile;
      final List<Result<OtpChallenge>> codes = await Future.wait([
        RequestDeallocationOtp(sl())(DeallocationOtpParams(allocationId: request.id, phone: request.mobile, party: 'RIDER')),
        RequestDeallocationOtp(sl())(
          DeallocationOtpParams(allocationId: request.id, phone: operatorMobile.isEmpty ? request.mobile : operatorMobile, party: 'OPERATOR'),
        ),
      ]);
      if (!context.mounted) return false;
      for (final r in codes) {
        if (r case Err<OtpChallenge>(:final failure)) {
          AppSnack.error(context, failure.message);
          return false;
        }
      }
      _riderOtp = codes[0].valueOrNull;
      _operatorOtp = codes[1].valueOrNull;
      AppSnack.success(context, 'Return started — codes sent to the rider and to you');
      return true;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _complete(BuildContext context, DeallocationRequest request) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Complete this de-allocation?',
      message: '${request.vehicleNumber} will be taken back from ${request.riderName} and the allocation closed.',
      confirmLabel: 'Complete',
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;

    setState(() => _busy = true);
    try {
      final List<(OtpChallenge?, String, String)> codes = [
        (_riderOtp, _form.stringOf('riderOtp'), 'rider'),
        (_operatorOtp, _form.stringOf('teamLeadOtp'), 'operator'),
      ];
      for (final (challenge, code, who) in codes) {
        if (challenge == null) {
          AppSnack.error(context, 'The $who code was never sent — go back a step and forward again.');
          return;
        }
        final Result<void> verified = await VerifyDeallocationOtp(sl())(
          VerifyDeallocationOtpParams(allocationId: request.id, otpRequestId: challenge.otpRequestId, code: code),
        );
        if (!context.mounted) return;
        if (verified case Err<void>(:final failure)) {
          AppSnack.error(context, 'The $who code was not accepted: ${failure.message}');
          return;
        }
      }

      if (_inspectionId != null && _inspectionId!.isNotEmpty) {
        final Result<void> inspected = await CompleteInspection(sl())(_inspectionId!);
        if (!context.mounted) return;

        if (inspected case Err<void>(:final failure) when failure is! ValidationFailure) {
          AppSnack.error(context, failure.message);
          return;
        }
      }

      final Result<void> done = await CompleteDeallocation(sl())(request.id);
      if (!context.mounted) return;
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

  Future<void> _handleBack(BuildContext context, DeallocationRequest request) async {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
      return;
    }
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Abandon this de-allocation?',
      message: _inspectionId == null
          ? 'The photos and assessment entered for ${request.vehicleNumber} will be lost.'
          : 'The return has already been started on the server. You can finish it later from the Returns tab.',
      confirmLabel: 'Abandon',
      cancelLabel: 'Keep going',
      destructive: true,
    );
    if (confirmed && context.mounted) context.pop();
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
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: Corners.brLg,
            boxShadow: Shadows.soft,
          ),
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
