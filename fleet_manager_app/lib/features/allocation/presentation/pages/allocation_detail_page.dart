import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/usecases/ask_payment.dart';
import '../../domain/usecases/bypass_pairing.dart';
import '../../domain/usecases/get_allocation_evidence.dart';
import '../../domain/usecases/get_deployment_request.dart';
import '../../domain/usecases/get_iot_health.dart';
import '../../domain/usecases/request_fleet.dart';
import '../../domain/usecases/submit_pdi.dart';
import '../../domain/usecases/verify_payment.dart';
import '../cubit/deployment_detail_cubit.dart';
import '../widgets/allocation_widgets.dart';

class AllocationDetailPage extends StatelessWidget {
  const AllocationDetailPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentDetailCubit(
        allocationId: requestId,
        getRequest: GetDeploymentRequest(sl()),
        getEvidence: GetAllocationEvidence(sl()),
        getIotHealth: GetIotHealth(sl()),
        requestFleet: RequestFleet(sl()),
        askPayment: AskPayment(sl()),
        verifyPayment: VerifyPayment(sl()),
        submitPdi: SubmitPdi(sl()),
        bypassPairing: BypassPairing(sl()),
      )
        ..load()
        ..startPolling(),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeploymentDetailCubit, DeploymentDetailState>(
      listenWhen: (a, b) => b.message != null && a.message != b.message,
      listener: (context, state) => AppSnack.error(context, state.message!),
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: PageBody(children: const [
                ShimmerBox(height: 120, borderRadius: Corners.brXl),
                Gap.lg(),
                ShimmerBox(height: 220, borderRadius: Corners.brLg),
              ]),
            ),
          );
        }
        if (state.status == DeploymentDetailStatus.failure || state.request == null) {
          return AppScaffold(
            title: context.l10n.commonHandover,
            body: EmptyState(
              title: context.l10n.allocationCouldNotLoadHandover,
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => context.read<DeploymentDetailCubit>().load(),
            ),
          );
        }
        return _Loaded(state: state);
      },
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final DeploymentDetailState state;

  DeploymentAllocation get request => state.request!;
  DeploymentStatus get status => state.deployment;

  @override
  Widget build(BuildContext context) {
    final DeploymentRider? rider = request.rider;
    final DeploymentFleet? fleet = request.fleet;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 120,
      onRefresh: () => context.read<DeploymentDetailCubit>().load(silent: true),
      band: _Band(request: request),
      bottomNavigationBar: _Footer(state: state),
      children: [
        OverlapModuleCard(
          title: context.l10n.allocationRider,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyValueRow(
                label: context.l10n.commonMobile,
                value: rider == null ? '—' : Fmt.phone(rider.mobile),
                icon: Icons.phone_rounded,
                trailing: rider == null
                    ? null
                    : CircleIconButton(
                        icon: Icons.call_rounded,
                        size: 34,
                        iconSize: 16,
                        background: AppColors.primaryWash,
                        foreground: AppColors.primary,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AppSnack.info(context, 'Calling ${Fmt.phone(rider.mobile)}…');
                        },
                      ),
              ),
              KeyValueRow(label: context.l10n.allocationRiderCode, value: (rider?.riderCode ?? '').isEmpty ? '—' : rider!.riderCode!, icon: Icons.badge_rounded),
              KeyValueRow(label: context.l10n.commonCity, value: rider?.city ?? '—', icon: Icons.place_rounded),
              if (request.createdAt != null)
                KeyValueRow(label: context.l10n.allocationReserved2, value: Fmt.dateTime(request.createdAt!), icon: Icons.schedule_rounded),
            ],
          ),
        ),
        const Gap.lg(),

        ModuleCard(
          title: context.l10n.commonVehicle,
          leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(label: context.l10n.allocationNumber, value: fleet?.vehicleNumber ?? '—', icon: Icons.confirmation_number_rounded),
              KeyValueRow(label: context.l10n.commonModel, value: fleet?.modelName ?? '—', icon: Icons.two_wheeler_rounded),
              KeyValueRow(label: context.l10n.allocationFleetCode, value: fleet?.fleetCode ?? '—', icon: Icons.qr_code_rounded),
              KeyValueRow(
                label: context.l10n.allocationIotDevice,
                value: fleet?.iotDeviceNumber ?? context.l10n.allocationNotMapped,
                icon: Icons.sensors_rounded,
                valueColor: fleet?.iotDeviceNumber == null ? AppColors.warning : null,
              ),
            ],
          ),
        ),
        const Gap.lg(),

        ModuleCard(
          title: context.l10n.commonHandover,
          leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
          child: DeploymentTimeline(status: status, workflow: request.workflow),
        ),
        const Gap.lg(),

        if (status == DeploymentStatus.paymentPaid) _EvidenceCard(evidence: state.evidence),
        if (status == DeploymentStatus.devicePairingPending) _IotCard(health: state.iotHealth),
        if (status == DeploymentStatus.pdiPendingRider || status == DeploymentStatus.trainingPending) _RiderTurnCard(status: status),
        if (status.isDeployed)
          ArtBlock(
            art: BrandArt.success,
            artSize: 120,
            title: context.l10n.allocationDeployed,
            message: context.l10n.allocationRiderPairedScooterRoadHandover,
          ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.request});

  final DeploymentAllocation request;

  @override
  Widget build(BuildContext context) {
    final DeploymentStatus status = request.deploymentStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Spacer(),
            StatusChip(
              label: status.label,
              tone: status.isDeployed
                  ? StatusTone.success
                  : status.waitsOnRider
                      ? StatusTone.info
                      : StatusTone.warning,
              icon: status.isDeployed ? Icons.verified_rounded : Icons.hourglass_top_rounded,
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Row(
          children: [
            AppAvatar(name: request.rider?.name ?? '?', size: 60, showRing: status.isDeployed),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.rider?.name ?? context.l10n.allocationRider,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 22, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${request.fleet?.vehicleNumber ?? '—'} · ${request.fleet?.modelName ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.lg(),
        Text(
          status.waitsOnRider
              ? context.l10n.allocationWaitingRiderPageRefreshesIts
              : status.isDeployed
                  ? context.l10n.allocationComplete2
                  : 'Your move: ${_nextActionLabel(status).toLowerCase()}.',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkMuted),
        ),
      ],
    );
  }
}

String _nextActionLabel(DeploymentStatus status) => switch (status) {
      DeploymentStatus.riderWaiting => LocaleController.strings.allocationAskPayment,
      DeploymentStatus.fleetRequested => LocaleController.strings.allocationAskPayment,
      DeploymentStatus.paymentPending => LocaleController.strings.allocationVerifyPayment,
      DeploymentStatus.paymentPaid => LocaleController.strings.commonSubmitInspection,
      DeploymentStatus.pdiPendingRider => LocaleController.strings.allocationWaitingRiderAcceptInspection,
      DeploymentStatus.trainingPending => LocaleController.strings.allocationWaitingRiderFinishTraining,
      DeploymentStatus.devicePairingPending => LocaleController.strings.allocationWaitingRiderPairBypass,
      DeploymentStatus.deployed => LocaleController.strings.allocationDeployed,
      DeploymentStatus.unknown => LocaleController.strings.commonRefresh,
    };

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.evidence});

  final AllocationEvidence? evidence;

  @override
  Widget build(BuildContext context) {
    final AllocationEvidence? e = evidence;
    return ModuleCard(
      title: context.l10n.allocationInspectionEvidence,
      leading: IconTile(
        icon: Icons.photo_library_rounded,
        tone: e == null ? AppColors.textMuted : (e.isComplete ? AppColors.success : AppColors.warning),
        solid: true,
        size: 28,
      ),
      child: e == null
          ? const ShimmerBox(height: 40)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.requiredPhotoTypes.isEmpty
                      ? context.l10n.allocationClientRequiresNoInspectionPhotos
                      : e.isComplete
                          ? 'All ${e.requiredPhotoTypes.length} required photos are on file.'
                          : 'Missing: ${e.missingPhotoTypes.join(', ')}. Upload them against the inspection before submitting.',
                  style: AppText.bodySmall.copyWith(height: 1.5),
                ),
              ],
            ),
    );
  }
}

class _IotCard extends StatelessWidget {
  const _IotCard({required this.health});

  final IotHealth? health;

  @override
  Widget build(BuildContext context) {
    final IotHealth? h = health;
    return ModuleCard(
      title: context.l10n.commonIotUnit,
      leading: IconTile(
        icon: Icons.sensors_rounded,
        tone: h == null ? AppColors.textMuted : (h.isHealthy ? AppColors.success : AppColors.warning),
        solid: true,
        size: 28,
      ),
      actionLabel: context.l10n.commonRefresh,
      onAction: () => context.read<DeploymentDetailCubit>().refreshIotHealth(),
      child: h == null
          ? const ShimmerBox(height: 60)
          : Column(
              children: [
                KeyValueRow(label: context.l10n.allocationDevice, value: h.deviceNumber, icon: Icons.qr_code_2_rounded),
                KeyValueRow(
                  label: context.l10n.allocationHeartbeat,
                  value: h.heartbeatAt == null ? context.l10n.allocationNever : '${Fmt.relative(h.heartbeatAt!)}${h.heartbeatFresh ? '' : ' · stale'}',
                  icon: Icons.favorite_rounded,
                  valueColor: h.heartbeatFresh ? AppColors.success : AppColors.warning,
                ),
                KeyValueRow(label: context.l10n.allocationSim, value: '${h.simStatus}${h.simLastFour == null ? '' : ' · ••${h.simLastFour}'}', icon: Icons.sim_card_rounded),
                KeyValueRow(
                  label: context.l10n.allocationCondition,
                  value: h.isHealthy ? context.l10n.allocationHealthy : context.l10n.allocationAttentionRequired,
                  icon: Icons.health_and_safety_rounded,
                  valueColor: h.isHealthy ? AppColors.success : AppColors.warning,
                ),
              ],
            ),
    );
  }
}

class _RiderTurnCard extends StatelessWidget {
  const _RiderTurnCard({required this.status});

  final DeploymentStatus status;

  @override
  Widget build(BuildContext context) {
    final bool pdi = status == DeploymentStatus.pdiPendingRider;
    return AccentCard(
      accent: AppColors.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(pdi ? Icons.fact_check_rounded : Icons.school_rounded, size: 19, color: AppColors.primary),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(
              pdi
                  ? context.l10n.allocationRiderGoingThroughChecklistTheir
                  : context.l10n.allocationRiderCompletingSafetyTrainingTheir,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final DeploymentDetailState state;

  Future<void> _askPayment(BuildContext context) async {
    final List<PaymentLineItem>? items = await _PaymentSheet.show(context);
    if (items == null || !context.mounted) return;
    final DeploymentDetailCubit cubit = context.read<DeploymentDetailCubit>();
    if (state.deployment == DeploymentStatus.riderWaiting && !await cubit.requestFleet()) return;
    final bool ok = await cubit.askPayment(items);
    if (ok && context.mounted) AppSnack.success(context, context.l10n.allocationPaymentRequestedRiderSeesNow);
  }

  Future<void> _verifyPayment(BuildContext context) async {
    final DeploymentPayment? payment = null;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationPaymentReceived,
      message: payment == null
          ? context.l10n.allocationConfirmHaveReceivedAmountRider
          : 'Confirm ${Fmt.money(payment.amount)} was received.',
      confirmLabel: context.l10n.allocationMarkAsPaid,
      icon: Icons.payments_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;
    final bool ok = await context.read<DeploymentDetailCubit>().verifyPayment();
    if (ok && context.mounted) AppSnack.success(context, context.l10n.allocationPaymentVerified);
  }

  Future<void> _submitPdi(BuildContext context) async {
    final ({String partner, List<PdiChecklistItem> items})? result = await _PdiSheet.show(context);
    if (result == null || !context.mounted) return;
    final bool ok =
        await context.read<DeploymentDetailCubit>().submitPdi(workPartnerName: result.partner, checklist: result.items);
    if (ok && context.mounted) AppSnack.success(context, context.l10n.allocationInspectionSentRider2);
  }

  Future<void> _bypass(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final String? remarks = await AppSheet.show<String>(
      context,
      title: context.l10n.allocationBypassPairing,
      subtitle: context.l10n.allocationCompletesHandoverWithoutRiderPairing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.allocationBypassExplainer,
            style: AppText.bodySmall.copyWith(height: 1.5),
          ),
          const Gap.lg(),
          AppTextField(label: context.l10n.allocationReason, hint: context.l10n.maintenanceHintUnitNotPowering, maxLines: 3, controller: controller, autofocus: true),
        ],
      ),
      footer: PrimaryButton(
        label: context.l10n.allocationBypassDeploy,
        icon: Icons.warning_amber_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
    if (remarks == null || remarks.isEmpty || !context.mounted) {
      if (remarks != null && remarks.isEmpty && context.mounted) AppSnack.error(context, context.l10n.allocationReasonRequiredBypass);
      return;
    }
    final bool ok = await context.read<DeploymentDetailCubit>().bypassPairing(remarks);
    if (ok && context.mounted) AppSnack.success(context, context.l10n.allocationHandoverCompletedWithoutPairing);
  }

  @override
  Widget build(BuildContext context) {
    final DeploymentStatus status = state.deployment;
    final bool evidenceReady = state.evidence == null || state.evidence!.isComplete;

    final (String label, IconData icon, VoidCallback? onPressed) = switch (status) {
      DeploymentStatus.riderWaiting => (context.l10n.allocationAskPayment, Icons.receipt_long_rounded, () => _askPayment(context)),
      DeploymentStatus.fleetRequested => (context.l10n.allocationAskPayment, Icons.receipt_long_rounded, () => _askPayment(context)),
      DeploymentStatus.paymentPending => (context.l10n.allocationVerifyPayment, Icons.payments_rounded, () => _verifyPayment(context)),
      DeploymentStatus.paymentPaid => (
          evidenceReady ? context.l10n.commonSubmitInspection : context.l10n.allocationUploadEvidenceContinue,
          Icons.fact_check_rounded,
          evidenceReady ? () => _submitPdi(context) : null,
        ),
      DeploymentStatus.pdiPendingRider => (context.l10n.allocationWaitingRiderInspection, Icons.hourglass_top_rounded, null),
      DeploymentStatus.trainingPending => (context.l10n.allocationWaitingRiderTraining, Icons.hourglass_top_rounded, null),
      DeploymentStatus.devicePairingPending => (context.l10n.allocationBypassPairing2, Icons.sensors_off_rounded, () => _bypass(context)),
      DeploymentStatus.deployed => (context.l10n.allocationDeployed, Icons.verified_rounded, null),
      DeploymentStatus.unknown => (context.l10n.commonRefresh, Icons.refresh_rounded, () => context.read<DeploymentDetailCubit>().load()),
    };

    return Container(
      padding: EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, MediaQuery.paddingOf(context).bottom + Insets.md),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: PrimaryButton(
        label: label,
        icon: icon,
        loading: state.busy,
        onPressed: state.busy ? null : onPressed,
        fillColor: status == DeploymentStatus.devicePairingPending ? AppColors.warning : null,
      ),
    );
  }
}

class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet();

  static Future<List<PaymentLineItem>?> show(BuildContext context) => AppSheet.show<List<PaymentLineItem>>(
        context,
        title: context.l10n.allocationAskPayment,
        subtitle: context.l10n.allocationWhatRiderPaysBeforeHandover,
        child: const _PaymentSheet(),
      );

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  final List<(TextEditingController, TextEditingController)> _rows = [
    (TextEditingController(), TextEditingController(text: '700')),
    (TextEditingController(), TextEditingController(text: '3000')),
    (TextEditingController(), TextEditingController(text: '500')),
  ];
  bool _seeded = false;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final AppL10n l10n = context.l10n;
    _rows[0].$1.text = l10n.allocationRentalFeeWeek;
    _rows[1].$1.text = l10n.allocationSecurityDeposit;
    _rows[2].$1.text = l10n.allocationOnboardingFee;
  }

  @override
  void dispose() {
    for (final (a, b) in _rows) {
      a.dispose();
      b.dispose();
    }
    super.dispose();
  }

  num get _total => _rows.fold<num>(0, (sum, r) => sum + (num.tryParse(r.$2.text.trim()) ?? 0));

  void _submit() {
    final List<PaymentLineItem> items = [];
    for (final (label, amount) in _rows) {
      final String l = label.text.trim();
      final num? a = num.tryParse(amount.text.trim());
      if (l.isEmpty && (amount.text.trim().isEmpty)) continue;
      if (l.isEmpty || a == null || a <= 0) {
        setState(() => _error = context.l10n.allocationEveryLineNeedsLabelAmount);
        return;
      }
      items.add(PaymentLineItem(label: l, amount: a));
    }
    if (items.isEmpty) {
      setState(() => _error = context.l10n.allocationAddLeastOneLine);
      return;
    }
    Navigator.of(context).pop(items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _rows.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: AppTextField(label: context.l10n.allocationItem, controller: _rows[i].$1, onChanged: (_) => setState(() => _error = null))),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 2,
                child: AppTextField(
                  label: context.l10n.allocationAmount,
                  controller: _rows[i].$2,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixText: '₹',
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
            ],
          ),
          const Gap.md(),
        ],
        GhostButton(
          label: context.l10n.allocationAddLine,
          icon: Icons.add_rounded,
          onPressed: () => setState(() => _rows.add((TextEditingController(), TextEditingController()))),
        ),
        Gap.md(),
        KeyValueRow(label: context.l10n.commonTotal, value: Fmt.money(_total), valueStyle: AppText.titleMedium),
        if (_error != null) ...[
          Gap.sm(),
          Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger)),
        ],
        Gap.lg(),
        PrimaryButton(label: context.l10n.allocationSendPaymentRequest, icon: Icons.send_rounded, onPressed: _submit),
        Gap.md(),
      ],
    );
  }
}

class _PdiSheet extends StatefulWidget {
  const _PdiSheet();

  static Future<({String partner, List<PdiChecklistItem> items})?> show(BuildContext context) =>
      AppSheet.show<({String partner, List<PdiChecklistItem> items})>(
        context,
        title: context.l10n.commonPreDeliveryInspection,
        subtitle: context.l10n.allocationChecklistRiderWillAcceptItem,
        child: _PdiSheet(),
      );

  @override
  State<_PdiSheet> createState() => _PdiSheetState();
}

class _PdiSheetState extends State<_PdiSheet> {
  static List<String> get _defaults => [
    LocaleController.strings.commonBrakes,
    LocaleController.strings.allocationTyresPressure,
    LocaleController.strings.allocationLightsIndicators,
    LocaleController.strings.allocationHornMirrors,
    LocaleController.strings.allocationBatteryChargeCharger,
    LocaleController.strings.allocationBodyPaintwork,
    LocaleController.strings.allocationHelmetHandedOver,
  ];

  final TextEditingController _partner = TextEditingController();
  final Map<String, bool> _items = {for (final d in _defaults) d: true};
  final TextEditingController _custom = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _partner.dispose();
    _custom.dispose();
    super.dispose();
  }

  static String _code(String label) => label.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '');

  void _submit() {
    final String partner = _partner.text.trim();
    if (partner.isEmpty) {
      setState(() => _error = context.l10n.allocationNameWorkPartnerWorkshopInspected);
      return;
    }
    final List<PdiChecklistItem> items = [
      for (final e in _items.entries) PdiChecklistItem(code: _code(e.key), label: e.key, mandatory: e.value),
    ];
    if (items.isEmpty) {
      setState(() => _error = context.l10n.allocationAddLeastOneItem);
      return;
    }
    Navigator.of(context).pop((partner: partner, items: items));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: context.l10n.allocationWorkPartner,
          hint: context.l10n.allocationHintWorkPartner,
          helper: context.l10n.allocationWorkshopTechnicianWhoInspectedVehicle,
          controller: _partner,
          onChanged: (_) => setState(() => _error = null),
        ),
        const Gap.lg(),
        GroupLabel(context.l10n.allocationChecklistTapToggleMandatory),
        const Gap.md(),
        for (final label in _items.keys.toList()) ...[
          AppCheckTile(
            value: _items[label]!,
            onChanged: (v) => setState(() => _items[label] = v),
            title: label,
            subtitle: _items[label]! ? context.l10n.commonMandatory : context.l10n.commonOptional,
          ),
          const Gap.sm(),
        ],
        Row(
          children: [
            Expanded(child: AppTextField(label: context.l10n.allocationAddItem, controller: _custom)),
            const SizedBox(width: Insets.md),
            CircleIconButton(
              icon: Icons.add_rounded,
              onTap: () {
                final String v = _custom.text.trim();
                if (v.isEmpty) return;
                setState(() {
                  _items[v] = true;
                  _custom.clear();
                });
              },
            ),
          ],
        ),
        if (_error != null) ...[
          const Gap.sm(),
          Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger)),
        ],
        const Gap.lg(),
        PrimaryButton(label: context.l10n.allocationSendRider, icon: Icons.send_rounded, onPressed: _submit),
        const Gap.md(),
      ],
    );
  }
}
