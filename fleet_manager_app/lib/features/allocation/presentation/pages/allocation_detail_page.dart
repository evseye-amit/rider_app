import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deployment_detail_provider.dart';
import '../widgets/allocation_widgets.dart';

class AllocationDetailPage extends ConsumerWidget {
  const AllocationDetailPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<DeploymentDetail> detail = ref.watch(deploymentDetailProvider(requestId));

    if (detail.isLoading && !detail.hasValue) {
      return const Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: PageBody(
            children: [
              ShimmerBox(height: 120, borderRadius: Corners.brXl),
              Gap.lg(),
              ShimmerBox(height: 220, borderRadius: Corners.brLg),
            ],
          ),
        ),
      );
    }

    final DeploymentDetail? current = detail.value;
    if (detail.hasError || current == null) {
      return AppScaffold(
        title: context.l10n.commonHandover,
        body: EmptyState(
          title: context.l10n.allocationCouldNotLoadHandover,
          message: detail.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.read(deploymentDetailProvider(requestId).notifier).refresh(),
        ),
      );
    }

    return _Loaded(allocationId: requestId, detail: current);
  }
}

class _Loaded extends ConsumerWidget {
  const _Loaded({required this.allocationId, required this.detail});

  final String allocationId;
  final DeploymentDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeploymentAllocation request = detail.request;
    final DeploymentStatus status = detail.status;
    final DeploymentRider? rider = request.rider;
    final DeploymentFleet? fleet = request.fleet;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: 120,
      onRefresh: () => ref.read(deploymentDetailProvider(allocationId).notifier).refresh(silent: true),
      band: _Band(request: request),
      bottomNavigationBar: _Footer(allocationId: allocationId, detail: detail),
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
              KeyValueRow(
                label: context.l10n.allocationRiderCode,
                value: (rider?.riderCode ?? '').isEmpty ? '—' : rider!.riderCode!,
                icon: Icons.badge_rounded,
              ),
              KeyValueRow(label: context.l10n.commonCity, value: rider?.city ?? '—', icon: Icons.place_rounded),
              if (request.createdAt != null)
                KeyValueRow(
                  label: context.l10n.allocationReserved2,
                  value: Fmt.dateTime(request.createdAt!),
                  icon: Icons.schedule_rounded,
                ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.commonVehicle,
          leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(
                label: context.l10n.allocationNumber,
                value: fleet?.vehicleNumber ?? '—',
                icon: Icons.confirmation_number_rounded,
              ),
              KeyValueRow(
                label: context.l10n.commonModel,
                value: fleet?.modelName ?? '—',
                icon: Icons.two_wheeler_rounded,
              ),
              KeyValueRow(
                label: context.l10n.allocationFleetCode,
                value: fleet?.fleetCode ?? '—',
                icon: Icons.qr_code_rounded,
              ),
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
        if (status == DeploymentStatus.paymentPaid) _EvidenceCard(evidence: detail.evidence),
        if (status == DeploymentStatus.devicePairingPending)
          _IotCard(allocationId: allocationId, health: detail.iotHealth),
        if (status == DeploymentStatus.pdiPendingRider || status == DeploymentStatus.trainingPending)
          _RiderTurnCard(status: status),
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

String _nextActionLabel(AppL10n l10n, DeploymentStatus status) => switch (status) {
  DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested => l10n.allocationAskPayment,
  DeploymentStatus.paymentPending => l10n.allocationVerifyPayment,
  DeploymentStatus.paymentPaid => l10n.commonSubmitInspection,
  DeploymentStatus.pdiPendingRider => l10n.allocationWaitingRiderAcceptInspection,
  DeploymentStatus.trainingPending => l10n.allocationWaitingRiderFinishTraining,
  DeploymentStatus.devicePairingPending => l10n.allocationWaitingRiderPairBypass,
  DeploymentStatus.deployed => l10n.allocationDeployed,
  DeploymentStatus.unknown => l10n.commonRefresh,
};

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
              builder: (context) =>
                  InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
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
              : 'Your move: ${_nextActionLabel(context.l10n, status).toLowerCase()}.',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkMuted),
        ),
      ],
    );
  }
}

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.evidence});

  final AllocationEvidence? evidence;

  @override
  Widget build(BuildContext context) {
    final AllocationEvidence? current = evidence;
    return ModuleCard(
      title: context.l10n.allocationInspectionEvidence,
      leading: IconTile(
        icon: Icons.photo_library_rounded,
        tone: current == null ? AppColors.textMuted : (current.isComplete ? AppColors.success : AppColors.warning),
        solid: true,
        size: 28,
      ),
      child: current == null
          ? const ShimmerBox(height: 40)
          : Text(
              current.requiredPhotoTypes.isEmpty
                  ? context.l10n.allocationClientRequiresNoInspectionPhotos
                  : current.isComplete
                  ? 'All ${current.requiredPhotoTypes.length} required photos are on file.'
                  : 'Missing: ${current.missingPhotoTypes.join(', ')}. Upload them against the inspection before submitting.',
              style: AppText.bodySmall.copyWith(height: 1.5),
            ),
    );
  }
}

class _IotCard extends ConsumerWidget {
  const _IotCard({required this.allocationId, required this.health});

  final String allocationId;
  final IotHealth? health;

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final Result<IotHealth> result = await ref.read(deploymentDetailProvider(allocationId).notifier).refreshIotHealth();
    if (!context.mounted) return;
    if (result case Err<IotHealth>(:final failure)) AppSnack.error(context, failure.message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IotHealth? current = health;
    return ModuleCard(
      title: context.l10n.commonIotUnit,
      leading: IconTile(
        icon: Icons.sensors_rounded,
        tone: current == null ? AppColors.textMuted : (current.isHealthy ? AppColors.success : AppColors.warning),
        solid: true,
        size: 28,
      ),
      actionLabel: context.l10n.commonRefresh,
      onAction: () => _refresh(context, ref),
      child: current == null
          ? const ShimmerBox(height: 60)
          : Column(
              children: [
                KeyValueRow(
                  label: context.l10n.allocationDevice,
                  value: current.deviceNumber,
                  icon: Icons.qr_code_2_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.allocationHeartbeat,
                  value: current.heartbeatAt == null
                      ? context.l10n.allocationNever
                      : '${Fmt.relative(current.heartbeatAt!)}${current.heartbeatFresh ? '' : ' · stale'}',
                  icon: Icons.favorite_rounded,
                  valueColor: current.heartbeatFresh ? AppColors.success : AppColors.warning,
                ),
                KeyValueRow(
                  label: context.l10n.allocationSim,
                  value: '${current.simStatus}${current.simLastFour == null ? '' : ' · ••${current.simLastFour}'}',
                  icon: Icons.sim_card_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.allocationCondition,
                  value: current.isHealthy ? context.l10n.allocationHealthy : context.l10n.allocationAttentionRequired,
                  icon: Icons.health_and_safety_rounded,
                  valueColor: current.isHealthy ? AppColors.success : AppColors.warning,
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

class _Footer extends ConsumerWidget {
  const _Footer({required this.allocationId, required this.detail});

  final String allocationId;
  final DeploymentDetail detail;

  DeploymentDetailNotifier _notifier(WidgetRef ref) => ref.read(deploymentDetailProvider(allocationId).notifier);

  void _announce(BuildContext context, Result<void> result, String successMessage) {
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, successMessage);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _askPayment(BuildContext context, WidgetRef ref) async {
    final List<PaymentLineItem>? items = await _PaymentSheet.show(context);
    if (items == null || !context.mounted) return;

    final DeploymentDetailNotifier notifier = _notifier(ref);
    if (detail.status == DeploymentStatus.riderWaiting) {
      final Result<void> requested = await notifier.requestFleet();
      if (!context.mounted) return;
      if (requested case Err<void>(:final failure)) {
        AppSnack.error(context, failure.message);
        return;
      }
    }
    final Result<void> asked = await notifier.askPayment(items);
    if (context.mounted) _announce(context, asked, context.l10n.allocationPaymentRequestedRiderSeesNow);
  }

  Future<void> _verifyPayment(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationPaymentReceived,
      message: context.l10n.allocationConfirmHaveReceivedAmountRider,
      confirmLabel: context.l10n.allocationMarkAsPaid,
      icon: Icons.payments_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;
    final Result<void> verified = await _notifier(ref).verifyPayment();
    if (context.mounted) _announce(context, verified, context.l10n.allocationPaymentVerified);
  }

  Future<void> _submitPdi(BuildContext context, WidgetRef ref) async {
    final ({String partner, List<PdiChecklistItem> items})? result = await _PdiSheet.show(context);
    if (result == null || !context.mounted) return;
    final Result<void> submitted = await _notifier(ref)
        .submitPdi(workPartnerName: result.partner, checklist: result.items);
    if (context.mounted) _announce(context, submitted, context.l10n.allocationInspectionSentRider2);
  }

  Future<void> _bypass(BuildContext context, WidgetRef ref) async {
    final TextEditingController controller = TextEditingController();
    final String? remarks = await AppSheet.show<String>(
      context,
      title: context.l10n.allocationBypassPairing,
      subtitle: context.l10n.allocationCompletesHandoverWithoutRiderPairing,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.allocationBypassExplainer, style: AppText.bodySmall.copyWith(height: 1.5)),
          const Gap.lg(),
          AppTextField(
            label: context.l10n.allocationReason,
            hint: context.l10n.maintenanceHintUnitNotPowering,
            maxLines: 3,
            controller: controller,
            autofocus: true,
          ),
        ],
      ),
      footer: PrimaryButton(
        label: context.l10n.allocationBypassDeploy,
        icon: Icons.warning_amber_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
    if (remarks == null || !context.mounted) return;
    if (remarks.isEmpty) {
      AppSnack.error(context, context.l10n.allocationReasonRequiredBypass);
      return;
    }
    final Result<void> bypassed = await _notifier(ref).bypassPairing(remarks);
    if (context.mounted) _announce(context, bypassed, context.l10n.allocationHandoverCompletedWithoutPairing);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeploymentStatus status = detail.status;
    final bool evidenceReady = detail.evidence == null || detail.evidence!.isComplete;

    final (String label, IconData icon, VoidCallback? onPressed) = switch (status) {
      DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested => (
        context.l10n.allocationAskPayment,
        Icons.receipt_long_rounded,
        () => _askPayment(context, ref),
      ),
      DeploymentStatus.paymentPending => (
        context.l10n.allocationVerifyPayment,
        Icons.payments_rounded,
        () => _verifyPayment(context, ref),
      ),
      DeploymentStatus.paymentPaid => (
        evidenceReady ? context.l10n.commonSubmitInspection : context.l10n.allocationUploadEvidenceContinue,
        Icons.fact_check_rounded,
        evidenceReady ? () => _submitPdi(context, ref) : null,
      ),
      DeploymentStatus.pdiPendingRider => (
        context.l10n.allocationWaitingRiderInspection,
        Icons.hourglass_top_rounded,
        null,
      ),
      DeploymentStatus.trainingPending => (
        context.l10n.allocationWaitingRiderTraining,
        Icons.hourglass_top_rounded,
        null,
      ),
      DeploymentStatus.devicePairingPending => (
        context.l10n.allocationBypassPairing2,
        Icons.sensors_off_rounded,
        () => _bypass(context, ref),
      ),
      DeploymentStatus.deployed => (context.l10n.allocationDeployed, Icons.verified_rounded, null),
      DeploymentStatus.unknown => (context.l10n.commonRefresh, Icons.refresh_rounded, () => _notifier(ref).refresh()),
    };

    return Container(
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
        label: label,
        icon: icon,
        loading: detail.busy,
        onPressed: detail.busy ? null : onPressed,
        fillColor: status == DeploymentStatus.devicePairingPending ? AppColors.warning : null,
      ),
    );
  }
}

class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet({required this.labels});

  final List<String> labels;

  static Future<List<PaymentLineItem>?> show(BuildContext context) => AppSheet.show<List<PaymentLineItem>>(
    context,
    title: context.l10n.allocationAskPayment,
    subtitle: context.l10n.allocationWhatRiderPaysBeforeHandover,
    child: _PaymentSheet(
      labels: [
        context.l10n.allocationRentalFeeWeek,
        context.l10n.allocationSecurityDeposit,
        context.l10n.allocationOnboardingFee,
      ],
    ),
  );

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  static const List<String> _defaultAmounts = ['700', '3000', '500'];

  late final List<(TextEditingController, TextEditingController)> _rows = [
    for (final (int i, String label) in widget.labels.indexed)
      (TextEditingController(text: label), TextEditingController(text: _defaultAmounts[i])),
  ];
  String? _error;

  @override
  void dispose() {
    for (final (TextEditingController label, TextEditingController amount) in _rows) {
      label.dispose();
      amount.dispose();
    }
    super.dispose();
  }

  num get _total => _rows.fold<num>(0, (sum, row) => sum + (num.tryParse(row.$2.text.trim()) ?? 0));

  void _submit() {
    final List<PaymentLineItem> items = [];
    for (final (TextEditingController label, TextEditingController amount) in _rows) {
      final String text = label.text.trim();
      final num? value = num.tryParse(amount.text.trim());
      if (text.isEmpty && amount.text.trim().isEmpty) continue;
      if (text.isEmpty || value == null || value <= 0) {
        setState(() => _error = context.l10n.allocationEveryLineNeedsLabelAmount);
        return;
      }
      items.add(PaymentLineItem(label: text, amount: value));
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
        for (final (TextEditingController label, TextEditingController amount) in _rows) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  label: context.l10n.allocationItem,
                  controller: label,
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 2,
                child: AppTextField(
                  label: context.l10n.allocationAmount,
                  controller: amount,
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
        const Gap.md(),
        KeyValueRow(label: context.l10n.commonTotal, value: Fmt.money(_total), valueStyle: AppText.titleMedium),
        if (_error != null) ...[
          const Gap.sm(),
          Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger)),
        ],
        const Gap.lg(),
        PrimaryButton(label: context.l10n.allocationSendPaymentRequest, icon: Icons.send_rounded, onPressed: _submit),
        const Gap.md(),
      ],
    );
  }
}

class _PdiSheet extends StatefulWidget {
  const _PdiSheet({required this.defaults});

  final List<String> defaults;

  static Future<({String partner, List<PdiChecklistItem> items})?> show(BuildContext context) =>
      AppSheet.show<({String partner, List<PdiChecklistItem> items})>(
        context,
        title: context.l10n.commonPreDeliveryInspection,
        subtitle: context.l10n.allocationChecklistRiderWillAcceptItem,
        child: _PdiSheet(
          defaults: [
            context.l10n.commonBrakes,
            context.l10n.allocationTyresPressure,
            context.l10n.allocationLightsIndicators,
            context.l10n.allocationHornMirrors,
            context.l10n.allocationBatteryChargeCharger,
            context.l10n.allocationBodyPaintwork,
            context.l10n.allocationHelmetHandedOver,
          ],
        ),
      );

  @override
  State<_PdiSheet> createState() => _PdiSheetState();
}

class _PdiSheetState extends State<_PdiSheet> {
  final TextEditingController _partner = TextEditingController();
  final TextEditingController _custom = TextEditingController();
  late final Map<String, bool> _items = {for (final String label in widget.defaults) label: true};
  String? _error;

  @override
  void dispose() {
    _partner.dispose();
    _custom.dispose();
    super.dispose();
  }

  static String _code(String label) =>
      label.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '');

  void _addItem() {
    final String value = _custom.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _items[value] = true;
      _custom.clear();
    });
  }

  void _submit() {
    final String partner = _partner.text.trim();
    if (partner.isEmpty) {
      setState(() => _error = context.l10n.allocationNameWorkPartnerWorkshopInspected);
      return;
    }
    final List<PdiChecklistItem> items = [
      for (final MapEntry<String, bool> entry in _items.entries)
        PdiChecklistItem(code: _code(entry.key), label: entry.key, mandatory: entry.value),
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
        for (final String label in _items.keys.toList()) ...[
          AppCheckTile(
            value: _items[label]!,
            onChanged: (mandatory) => setState(() => _items[label] = mandatory),
            title: label,
            subtitle: _items[label]! ? context.l10n.commonMandatory : context.l10n.commonOptional,
          ),
          const Gap.sm(),
        ],
        Row(
          children: [
            Expanded(
              child: AppTextField(label: context.l10n.allocationAddItem, controller: _custom),
            ),
            const SizedBox(width: Insets.md),
            CircleIconButton(icon: Icons.add_rounded, onTap: _addItem),
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
