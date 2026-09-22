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
            title: 'Handover',
            body: EmptyState(
              title: 'Could not load this handover',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
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
          title: 'Rider',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KeyValueRow(
                label: 'Mobile',
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
              KeyValueRow(label: 'Rider code', value: (rider?.riderCode ?? '').isEmpty ? '—' : rider!.riderCode!, icon: Icons.badge_rounded),
              KeyValueRow(label: 'City', value: rider?.city ?? '—', icon: Icons.place_rounded),
              if (request.createdAt != null)
                KeyValueRow(label: 'Reserved on', value: Fmt.dateTime(request.createdAt!), icon: Icons.schedule_rounded),
            ],
          ),
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Vehicle',
          leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(label: 'Number', value: fleet?.vehicleNumber ?? '—', icon: Icons.confirmation_number_rounded),
              KeyValueRow(label: 'Model', value: fleet?.modelName ?? '—', icon: Icons.two_wheeler_rounded),
              KeyValueRow(label: 'Fleet code', value: fleet?.fleetCode ?? '—', icon: Icons.qr_code_rounded),
              KeyValueRow(
                label: 'IoT device',
                value: fleet?.iotDeviceNumber ?? 'Not mapped',
                icon: Icons.sensors_rounded,
                valueColor: fleet?.iotDeviceNumber == null ? AppColors.warning : null,
              ),
            ],
          ),
        ),
        const Gap.lg(),

        ModuleCard(
          title: 'Handover',
          leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
          child: DeploymentTimeline(status: status, workflow: request.workflow),
        ),
        const Gap.lg(),

        if (status == DeploymentStatus.paymentPaid) _EvidenceCard(evidence: state.evidence),
        if (status == DeploymentStatus.devicePairingPending) _IotCard(health: state.iotHealth),
        if (status == DeploymentStatus.pdiPendingRider || status == DeploymentStatus.trainingPending) _RiderTurnCard(status: status),
        if (status.isDeployed)
          const ArtBlock(
            art: BrandArt.success,
            artSize: 120,
            title: 'Deployed',
            message: 'The rider paired the scooter and is on the road. This handover is complete.',
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
                    request.rider?.name ?? 'Rider',
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
              ? 'Waiting on the rider — this page refreshes on its own.'
              : status.isDeployed
                  ? 'Complete.'
                  : 'Your move: ${_nextActionLabel(status).toLowerCase()}.',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkMuted),
        ),
      ],
    );
  }
}

String _nextActionLabel(DeploymentStatus status) => switch (status) {
      DeploymentStatus.riderWaiting => 'Ask for payment',
      DeploymentStatus.fleetRequested => 'Ask for payment',
      DeploymentStatus.paymentPending => 'Verify payment',
      DeploymentStatus.paymentPaid => 'Submit inspection',
      DeploymentStatus.pdiPendingRider => 'Waiting for rider to accept inspection',
      DeploymentStatus.trainingPending => 'Waiting for rider to finish training',
      DeploymentStatus.devicePairingPending => 'Waiting for rider to pair — or bypass',
      DeploymentStatus.deployed => 'Deployed',
      DeploymentStatus.unknown => 'Refresh',
    };

class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({required this.evidence});

  final AllocationEvidence? evidence;

  @override
  Widget build(BuildContext context) {
    final AllocationEvidence? e = evidence;
    return ModuleCard(
      title: 'Inspection evidence',
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
                      ? 'This client requires no inspection photos. You can write up the checklist now.'
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
      title: 'IoT unit',
      leading: IconTile(
        icon: Icons.sensors_rounded,
        tone: h == null ? AppColors.textMuted : (h.isHealthy ? AppColors.success : AppColors.warning),
        solid: true,
        size: 28,
      ),
      actionLabel: 'Refresh',
      onAction: () => context.read<DeploymentDetailCubit>().refreshIotHealth(),
      child: h == null
          ? const ShimmerBox(height: 60)
          : Column(
              children: [
                KeyValueRow(label: 'Device', value: h.deviceNumber, icon: Icons.qr_code_2_rounded),
                KeyValueRow(
                  label: 'Heartbeat',
                  value: h.heartbeatAt == null ? 'Never' : '${Fmt.relative(h.heartbeatAt!)}${h.heartbeatFresh ? '' : ' · stale'}',
                  icon: Icons.favorite_rounded,
                  valueColor: h.heartbeatFresh ? AppColors.success : AppColors.warning,
                ),
                KeyValueRow(label: 'SIM', value: '${h.simStatus}${h.simLastFour == null ? '' : ' · ••${h.simLastFour}'}', icon: Icons.sim_card_rounded),
                KeyValueRow(
                  label: 'Condition',
                  value: h.isHealthy ? 'Healthy' : 'Attention required',
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
                  ? 'The rider is going through your checklist in their app. Items they reject come back with a note.'
                  : 'The rider is completing the safety training in their app. Pairing opens once every mandatory module is done.',
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
    if (ok && context.mounted) AppSnack.success(context, 'Payment requested — the rider sees it now');
  }

  Future<void> _verifyPayment(BuildContext context) async {
    final DeploymentPayment? payment = null;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Payment received?',
      message: payment == null
          ? 'Confirm you have received the amount the rider submitted a reference for. This cannot be undone.'
          : 'Confirm ${Fmt.money(payment.amount)} was received.',
      confirmLabel: 'Mark as paid',
      icon: Icons.payments_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;
    final bool ok = await context.read<DeploymentDetailCubit>().verifyPayment();
    if (ok && context.mounted) AppSnack.success(context, 'Payment verified');
  }

  Future<void> _submitPdi(BuildContext context) async {
    final ({String partner, List<PdiChecklistItem> items})? result = await _PdiSheet.show(context);
    if (result == null || !context.mounted) return;
    final bool ok =
        await context.read<DeploymentDetailCubit>().submitPdi(workPartnerName: result.partner, checklist: result.items);
    if (ok && context.mounted) AppSnack.success(context, 'Inspection sent to the rider');
  }

  Future<void> _bypass(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final String? remarks = await AppSheet.show<String>(
      context,
      title: 'Bypass pairing?',
      subtitle: 'Completes the handover without the rider pairing the device',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use this when the IoT unit cannot be paired at the hub. The unit\'s current health is recorded with your reason.',
            style: AppText.bodySmall.copyWith(height: 1.5),
          ),
          const Gap.lg(),
          AppTextField(label: 'Reason', hint: 'e.g. Unit not powering on; workshop ticket raised', maxLines: 3, controller: controller, autofocus: true),
        ],
      ),
      footer: PrimaryButton(
        label: 'Bypass and deploy',
        icon: Icons.warning_amber_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
    if (remarks == null || remarks.isEmpty || !context.mounted) {
      if (remarks != null && remarks.isEmpty && context.mounted) AppSnack.error(context, 'A reason is required to bypass');
      return;
    }
    final bool ok = await context.read<DeploymentDetailCubit>().bypassPairing(remarks);
    if (ok && context.mounted) AppSnack.success(context, 'Handover completed without pairing');
  }

  @override
  Widget build(BuildContext context) {
    final DeploymentStatus status = state.deployment;
    final bool evidenceReady = state.evidence == null || state.evidence!.isComplete;

    final (String label, IconData icon, VoidCallback? onPressed) = switch (status) {
      DeploymentStatus.riderWaiting => ('Ask for payment', Icons.receipt_long_rounded, () => _askPayment(context)),
      DeploymentStatus.fleetRequested => ('Ask for payment', Icons.receipt_long_rounded, () => _askPayment(context)),
      DeploymentStatus.paymentPending => ('Verify payment', Icons.payments_rounded, () => _verifyPayment(context)),
      DeploymentStatus.paymentPaid => (
          evidenceReady ? 'Submit inspection' : 'Upload evidence to continue',
          Icons.fact_check_rounded,
          evidenceReady ? () => _submitPdi(context) : null,
        ),
      DeploymentStatus.pdiPendingRider => ('Waiting for rider: inspection', Icons.hourglass_top_rounded, null),
      DeploymentStatus.trainingPending => ('Waiting for rider: training', Icons.hourglass_top_rounded, null),
      DeploymentStatus.devicePairingPending => ('Bypass pairing', Icons.sensors_off_rounded, () => _bypass(context)),
      DeploymentStatus.deployed => ('Deployed', Icons.verified_rounded, null),
      DeploymentStatus.unknown => ('Refresh', Icons.refresh_rounded, () => context.read<DeploymentDetailCubit>().load()),
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
        title: 'Ask for payment',
        subtitle: 'What the rider pays before the handover',
        child: const _PaymentSheet(),
      );

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  final List<(TextEditingController, TextEditingController)> _rows = [
    (TextEditingController(text: 'Rental fee (week)'), TextEditingController(text: '700')),
    (TextEditingController(text: 'Security deposit'), TextEditingController(text: '3000')),
    (TextEditingController(text: 'Onboarding fee'), TextEditingController(text: '500')),
  ];
  String? _error;

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
        setState(() => _error = 'Every line needs a label and an amount above zero');
        return;
      }
      items.add(PaymentLineItem(label: l, amount: a));
    }
    if (items.isEmpty) {
      setState(() => _error = 'Add at least one line');
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
              Expanded(flex: 3, child: AppTextField(label: 'Item', controller: _rows[i].$1, onChanged: (_) => setState(() => _error = null))),
              const SizedBox(width: Insets.md),
              Expanded(
                flex: 2,
                child: AppTextField(
                  label: 'Amount',
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
          label: 'Add a line',
          icon: Icons.add_rounded,
          onPressed: () => setState(() => _rows.add((TextEditingController(), TextEditingController()))),
        ),
        const Gap.md(),
        KeyValueRow(label: 'Total', value: Fmt.money(_total), valueStyle: AppText.titleMedium),
        if (_error != null) ...[
          const Gap.sm(),
          Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger)),
        ],
        const Gap.lg(),
        PrimaryButton(label: 'Send payment request', icon: Icons.send_rounded, onPressed: _submit),
        const Gap.md(),
      ],
    );
  }
}

class _PdiSheet extends StatefulWidget {
  const _PdiSheet();

  static Future<({String partner, List<PdiChecklistItem> items})?> show(BuildContext context) =>
      AppSheet.show<({String partner, List<PdiChecklistItem> items})>(
        context,
        title: 'Pre-delivery inspection',
        subtitle: 'The checklist the rider will accept item by item',
        child: const _PdiSheet(),
      );

  @override
  State<_PdiSheet> createState() => _PdiSheetState();
}

class _PdiSheetState extends State<_PdiSheet> {
  static const List<String> _defaults = [
    'Brakes',
    'Tyres and pressure',
    'Lights and indicators',
    'Horn and mirrors',
    'Battery charge and charger',
    'Body and paintwork',
    'Helmet handed over',
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
      setState(() => _error = 'Name the work partner or workshop that inspected the vehicle');
      return;
    }
    final List<PdiChecklistItem> items = [
      for (final e in _items.entries) PdiChecklistItem(code: _code(e.key), label: e.key, mandatory: e.value),
    ];
    if (items.isEmpty) {
      setState(() => _error = 'Add at least one item');
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
          label: 'Work partner',
          hint: 'e.g. Sharma Auto Works',
          helper: 'The workshop or technician who inspected the vehicle',
          controller: _partner,
          onChanged: (_) => setState(() => _error = null),
        ),
        const Gap.lg(),
        const GroupLabel('Checklist · tap to toggle mandatory'),
        const Gap.md(),
        for (final label in _items.keys.toList()) ...[
          AppCheckTile(
            value: _items[label]!,
            onChanged: (v) => setState(() => _items[label] = v),
            title: label,
            subtitle: _items[label]! ? 'Mandatory' : 'Optional',
          ),
          const Gap.sm(),
        ],
        Row(
          children: [
            Expanded(child: AppTextField(label: 'Add an item', controller: _custom)),
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
        PrimaryButton(label: 'Send to rider', icon: Icons.send_rounded, onPressed: _submit),
        const Gap.md(),
      ],
    );
  }
}
