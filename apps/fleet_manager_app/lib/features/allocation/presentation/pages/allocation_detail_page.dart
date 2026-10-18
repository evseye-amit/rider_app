import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../allocation_dependencies.dart';
import '../providers/deployment_detail_provider.dart';
import '../widgets/allocation_widgets.dart';
import '../widgets/rental_plan_widgets.dart';

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
      band: _Band(detail: detail),
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
            ],
          ),
        ),
        const Gap.lg(),
        if (status.beforeInspection) ...[
          RentalPlanCard(
            commercial: detail.commercial,
            isExchange: request.isExchangeReplacement,
            paymentTotal: _planOpen(status) ? null : request.workflow?.paymentTotal,
            onChange: detail.busy ? null : () => _choosePlan(context, ref, allocationId),
          ),
          const Gap.lg(),
        ],
        ModuleCard(
          title: context.l10n.commonHandover,
          leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
          child: DeploymentTimeline(status: status, workflow: request.workflow),
        ),
        const Gap.lg(),
        if (status.beforeInspection) _VehiclePhotosCard(allocationId: allocationId, evidence: detail.evidence),
        if (status == DeploymentStatus.pdiPendingRider || status == DeploymentStatus.trainingPending)
          _RiderTurnCard(status: status),
        if (status.isDeployed)
          ArtBlock(
            art: BrandArt.success,
            artSize: 120,
            title: context.l10n.allocationDeployed,
            message: context.l10n.allocationHandoverCompleteMessage,
          ),
      ],
    );
  }
}

enum _PlanStep { choose, awaitingRider, ready }

bool _planOpen(DeploymentStatus status) =>
    status == DeploymentStatus.riderWaiting || status == DeploymentStatus.fleetRequested;

_PlanStep _planStep(DeploymentDetail detail) {
  final DeploymentAllocation request = detail.request;
  final AllocationCommercial? commercial = detail.commercial;
  if (request.isExchangeReplacement || (commercial?.isAccepted ?? request.rentalAgreementId != null)) {
    return _PlanStep.ready;
  }
  if (commercial?.awaitingRider ?? request.commercialOfferId != null) return _PlanStep.awaitingRider;
  return _PlanStep.choose;
}

Future<void> _choosePlan(BuildContext context, WidgetRef ref, String allocationId) async {
  final RentalPlanOption? plan = await RentalPlanPicker.show(context, allocationId: allocationId);
  if (plan == null || !context.mounted) return;
  final Result<void> result = await ref.read(deploymentDetailProvider(allocationId).notifier).selectPlan(plan);
  if (!context.mounted) return;
  switch (result) {
    case Ok<void>():
      AppSnack.success(context, context.l10n.allocationPlanSentSnack);
    case Err<void>(:final failure):
      AppSnack.error(context, failure.message);
  }
}

String _nextActionLabel(AppL10n l10n, DeploymentDetail detail) => switch (detail.status) {
  DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested => switch (_planStep(detail)) {
    _PlanStep.choose => l10n.allocationChoosePlan,
    _PlanStep.awaitingRider => l10n.allocationPlanWaitingButton,
    _PlanStep.ready => l10n.allocationAskPayment,
  },
  DeploymentStatus.paymentPending => l10n.allocationVerifyPayment,
  DeploymentStatus.paymentPaid => l10n.commonSubmitInspection,
  DeploymentStatus.pdiPendingRider => l10n.allocationWaitingRiderAcceptInspection,
  DeploymentStatus.trainingPending => l10n.allocationWaitingRiderFinishTraining,
  DeploymentStatus.deployed => l10n.allocationDeployed,
  DeploymentStatus.unknown => l10n.commonRefresh,
};

class _Band extends StatelessWidget {
  const _Band({required this.detail});

  final DeploymentDetail detail;

  @override
  Widget build(BuildContext context) {
    final DeploymentAllocation request = detail.request;
    final DeploymentStatus status = request.deploymentStatus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => context.canPop() ? context.pop() : context.go(Routes.allocations),
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
          detail.waitsOnRider
              ? context.l10n.allocationWaitingRiderPageRefreshesIts
              : status.isDeployed
              ? context.l10n.allocationComplete2
              : 'Your move: ${_nextActionLabel(context.l10n, detail).toLowerCase()}.',
          style: AppText.bodySmall.copyWith(color: AppColors.onInkMuted),
        ),
      ],
    );
  }
}

const List<String> _assignPhotos = ['FRONT', 'REAR', 'LEFT', 'RIGHT', 'RIDER_WITH_VEHICLE', 'DECLARATION_FORM'];

List<String> _photoSlots(AllocationEvidence? evidence) => [
  ..._assignPhotos,
  for (final String type in evidence?.requiredPhotoTypes ?? const <String>[])
    if (!_assignPhotos.contains(type)) type,
];

bool _photosReady(AllocationEvidence? evidence) =>
    evidence == null || (evidence.isComplete && _assignPhotos.every(evidence.completedPhotoTypes.contains));

String _photoLabel(AppL10n l10n, String type) => switch (type) {
  'FRONT' => l10n.allocationPhotoFront,
  'REAR' => l10n.allocationPhotoBack,
  'LEFT' => l10n.allocationPhotoLeft,
  'RIGHT' => l10n.allocationPhotoRight,
  'RIDER_WITH_VEHICLE' => l10n.allocationPhotoRider,
  'DECLARATION_FORM' => l10n.allocationPhotoDeclaration,
  _ => PhotoRequirement(photoType: type, isRequired: true).title,
};

IconData _photoIcon(String type) => switch (type) {
  'FRONT' => Icons.arrow_circle_up_rounded,
  'REAR' => Icons.arrow_circle_down_rounded,
  'LEFT' => Icons.arrow_circle_left_rounded,
  'RIGHT' => Icons.arrow_circle_right_rounded,
  'RIDER_WITH_VEHICLE' => Icons.account_circle_rounded,
  'DECLARATION_FORM' => Icons.assignment_rounded,
  _ => Icons.photo_camera_rounded,
};

class _VehiclePhotosCard extends ConsumerStatefulWidget {
  const _VehiclePhotosCard({required this.allocationId, required this.evidence});

  final String allocationId;
  final AllocationEvidence? evidence;

  @override
  ConsumerState<_VehiclePhotosCard> createState() => _VehiclePhotosCardState();
}

class _VehiclePhotosCardState extends ConsumerState<_VehiclePhotosCard> {
  final Map<String, File> _local = {};
  final Set<String> _uploading = {};

  Future<void> _take(String photoType) async {
    final File? file = await PhotoSourceSheet.pick(context);
    if (file == null || !mounted) return;
    setState(() => _uploading.add(photoType));
    final Result<void> result = await ref
        .read(deploymentDetailProvider(widget.allocationId).notifier)
        .uploadEvidencePhoto(photoType, file);
    if (!mounted) return;
    setState(() {
      _uploading.remove(photoType);
      if (result.isOk) _local[photoType] = file;
    });
    if (result case Err<void>(:final failure)) AppSnack.error(context, failure.message);
  }

  Future<void> _view(String photoType) async {
    final File? local = _local[photoType];
    if (local != null) return PhotoViewer.showImage(context, FileImage(local));
    final RemotePhoto? photo = widget.evidence?.photoFor(photoType);
    if (photo == null) return;
    final Result<String> url = await ref.read(getPhotoUrlProvider)(photo.id);
    if (!mounted) return;
    switch (url) {
      case Ok<String>(:final value) when value.isNotEmpty:
        await PhotoViewer.show(context, value);
      case _:
        AppSnack.error(context, context.l10n.allocationPhotoCannotOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AllocationEvidence? evidence = widget.evidence;
    final Set<String> uploaded = {...?evidence?.completedPhotoTypes, ..._local.keys};
    final List<String> slots = _photoSlots(evidence);
    final bool done = slots.every(uploaded.contains);

    return ModuleCard(
      title: context.l10n.allocationVehiclePhotos,
      leading: IconTile(
        icon: Icons.photo_camera_rounded,
        tone: done ? AppColors.success : AppColors.warning,
        solid: true,
        size: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.allocationVehiclePhotosHint,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          const Gap.md(),
          if (evidence == null)
            const ShimmerBox(height: 220, borderRadius: Corners.brLg)
          else
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              mainAxisSpacing: Insets.md,
              crossAxisSpacing: Insets.md,
              childAspectRatio: 1.2,
              children: [
                for (final String type in slots)
                  _SidePhotoTile(
                    label: _photoLabel(context.l10n, type),
                    icon: _photoIcon(type),
                    file: _local[type],
                    uploaded: uploaded.contains(type),
                    uploading: _uploading.contains(type),
                    onTake: () => _take(type),
                    onView: () => _view(type),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SidePhotoTile extends StatelessWidget {
  const _SidePhotoTile({
    required this.label,
    required this.icon,
    required this.file,
    required this.uploaded,
    required this.uploading,
    required this.onTake,
    required this.onView,
  });

  final String label;
  final IconData icon;
  final File? file;
  final bool uploaded;
  final bool uploading;
  final VoidCallback onTake;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final File? local = file;
    final bool captured = local != null || uploaded;
    final Widget face = local != null
        ? _PreviewFace(file: local, label: label)
        : uploaded
        ? _UploadedFace(label: label)
        : PhotoSlot(label: label, icon: icon, onTap: uploading ? null : onTake);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (captured)
          Pressable(
            onTap: uploading ? null : onView,
            scale: 0.97,
            child: ClipRRect(borderRadius: Corners.brMd, child: face),
          )
        else
          face,
        if (captured && !uploading)
          Positioned(
            top: 6,
            right: 6,
            child: Pressable(
              onTap: onTake,
              child: StatusChip(
                label: context.l10n.commonRetake,
                tone: StatusTone.neutral,
                dense: true,
                showDot: false,
              ),
            ),
          ),
        if (uploading)
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.black38, borderRadius: Corners.brMd),
            child: const Center(
              child: SizedBox.square(
                dimension: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

class _PreviewFace extends StatelessWidget {
  const _PreviewFace({required this.file, required this.label});

  final File file;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(file, fit: BoxFit.cover, cacheWidth: 600),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.black54,
            padding: const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                const SizedBox(width: Insets.xs),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadedFace extends StatelessWidget {
  const _UploadedFace({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.successWash,
        borderRadius: Corners.brMd,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35), width: 1.3),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 26, color: AppColors.success),
            const SizedBox(height: Insets.sm),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              context.l10n.allocationPhotoUploaded,
              style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
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
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationAskPayment,
      message: detail.request.isExchangeReplacement
          ? context.l10n.allocationAskPaymentExchange
          : context.l10n.allocationAskPaymentConfirm,
      confirmLabel: context.l10n.allocationSendPaymentRequest,
      icon: Icons.receipt_long_rounded,
    );
    if (!confirmed || !context.mounted) return;

    final DeploymentDetailNotifier notifier = _notifier(ref);
    if (detail.status == DeploymentStatus.riderWaiting) {
      final Result<void> requested = await notifier.requestFleet();
      if (!context.mounted) return;
      if (requested case Err<void>(:final failure)) {
        AppSnack.error(context, failure.message);
        return;
      }
    }
    final Result<void> asked = await notifier.askPayment();
    if (context.mounted) _announce(context, asked, context.l10n.allocationPaymentRequestedRiderSeesNow);
  }

  Future<void> _verifyPayment(BuildContext context, WidgetRef ref) async {
    final num? total = detail.request.workflow?.paymentTotal;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.allocationPaymentReceived,
      message: total == null
          ? context.l10n.allocationConfirmHaveReceivedAmountRider
          : context.l10n.allocationConfirmReceivedAmount(Fmt.money(total)),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeploymentStatus status = detail.status;
    final bool evidenceReady = _photosReady(detail.evidence);

    final _PlanStep step = _planStep(detail);
    final (String label, IconData icon, VoidCallback? onPressed) = switch (status) {
      DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested when step == _PlanStep.ready => (
        context.l10n.allocationAskPayment,
        Icons.receipt_long_rounded,
        () => _askPayment(context, ref),
      ),
      DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested when step == _PlanStep.awaitingRider => (
        context.l10n.allocationPlanWaitingButton,
        Icons.hourglass_top_rounded,
        null,
      ),
      DeploymentStatus.riderWaiting || DeploymentStatus.fleetRequested => (
        context.l10n.allocationChoosePlan,
        Icons.price_change_rounded,
        () => _choosePlan(context, ref, allocationId),
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
      child: PrimaryButton(label: label, icon: icon, loading: detail.busy, onPressed: detail.busy ? null : onPressed),
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
