import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../../hub/domain/entities/hub_profile.dart';
import '../../domain/entities/return_case.dart';
import '../../domain/usecases/return_desk_usecases.dart';
import '../../return_desk_dependencies.dart';
import '../providers/return_desk_providers.dart';
import '../widgets/charges_editor.dart';
import '../widgets/receive_card.dart';
import '../widgets/return_desk_widgets.dart';

class ReturnCasePage extends ConsumerStatefulWidget {
  const ReturnCasePage({required this.returnId, super.key});

  final String returnId;

  @override
  ConsumerState<ReturnCasePage> createState() => _ReturnCasePageState();
}

class _ReturnCasePageState extends ConsumerState<ReturnCasePage> {
  bool _busy = false;

  Future<void> _refresh() =>
      ref.refresh(returnCaseProvider(widget.returnId).future).then<void>((_) {}, onError: (_) {});

  Future<bool> _run(Future<Result<void>> Function() action, String success) async {
    setState(() => _busy = true);
    final Result<void> result = await action();
    if (!mounted) return false;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, success);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
    return result.isOk;
  }

  Future<void> _receive(ReceiveInput input) async {
    final bool received = await _run(
      () => ref.read(receiveReturnProvider)(
        ReceiveReturnParams(
          id: widget.returnId,
          hubId: input.hubId,
          receivedAt: input.receivedAt,
          backdateReason: input.backdateReason,
        ),
      ),
      context.l10n.returnDeskReceived,
    );
    if (!received || !mounted) return;
    final ReturnCase? item = ref.read(returnCaseProvider(widget.returnId)).value;
    if (item != null && item.needsInspection) await _inspect(item);
  }

  Future<void> _inspect(ReturnCase item) async {
    final String? inspectionId = item.inspectionId;
    if (inspectionId == null) {
      AppSnack.error(context, context.l10n.returnDeskNoInspection);
      return;
    }
    await context.push<bool>(
      Uri(
        path: Routes.returnInspection,
        queryParameters: {'id': inspectionId, 'vehicle': ?item.vehicleNumber},
      ).toString(),
    );
    if (mounted) await _refresh();
  }

  Future<void> _saveCharges(List<PenaltyLine> lines, {required bool send}) async {
    setState(() => _busy = true);
    final Result<void> saved = await ref.read(saveReturnChargesProvider)(
      SaveChargesParams(id: widget.returnId, lines: lines),
    );
    Result<void> result = saved;
    if (saved.isOk && send) result = await ref.read(submitReturnChargesProvider)(widget.returnId);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(
          context,
          !send
              ? context.l10n.returnDeskDraftSaved
              : lines.isEmpty
              ? context.l10n.returnDeskClosedNoCharges
              : context.l10n.returnDeskSentToRider,
        );
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  Future<void> _approve(PenaltyState penalty) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.returnDeskApproveTitle,
      message: penalty.riderApproved || penalty.adminOverridden
          ? context.l10n.returnDeskApproveBodyPost(Fmt.money(penalty.total, paise: true))
          : context.l10n.returnDeskApproveBodyWait,
      confirmLabel: context.l10n.returnDeskApprove,
      icon: Icons.verified_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !mounted) return;
    await _run(() => ref.read(approveReturnChargesProvider)(widget.returnId), context.l10n.returnDeskApproved);
  }

  Future<void> _override() async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await AppSheet.show<String>(
      context,
      title: context.l10n.returnDeskApproveForRider,
      subtitle: context.l10n.returnDeskOverrideSubtitle,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AppTextField(
          label: context.l10n.returnDeskOverrideReason,
          maxLines: 3,
          maxLength: 500,
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      footer: Builder(
        builder: (sheet) => PrimaryButton(
          label: context.l10n.returnDeskApproveForRider,
          icon: Icons.admin_panel_settings_rounded,
          onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
        ),
      ),
    );
    controller.dispose();
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.returnDeskOverrideReasonNeeded);
      return;
    }
    await _run(
      () => ref.read(overrideRiderApprovalProvider)(OverrideApprovalParams(id: widget.returnId, reason: reason)),
      context.l10n.returnDeskOverridden,
    );
  }

  Future<void> _call(String mobile) async {
    final bool opened = await launchUrl(Uri(scheme: 'tel', path: mobile));
    if (!opened && mounted) AppSnack.error(context, context.l10n.commonSomethingWentWrongPleaseTry);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ReturnCase> detail = ref.watch(returnCaseProvider(widget.returnId));
    final ReturnCase? item = detail.value;

    if (item == null) {
      return AppScaffold(
        title: context.l10n.returnDeskCaseTitle,
        body: detail.hasError
            ? EmptyState(
                title: context.l10n.returnDeskCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(returnCaseProvider(widget.returnId)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 110, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 230, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 200, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    final FleetSession session = ref.watch(fleetSessionProvider);
    final Map<String, String> hubNames = {for (final HubProfile hub in session.hubs) hub.id: hub.name};
    final PenaltyState? penalty = item.penalty;

    return AppScaffold(
      title: context.l10n.returnDeskCaseTitle,
      subtitle: item.riderName,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _StageCard(item: item),
            const Gap.lg(),
            _CaseDetails(item: item, hubNames: hubNames, onCall: _call),
            const Gap.lg(),
            if (item.awaitingScooter)
              ReceiveCard(
                key: ValueKey('receive-${item.id}'),
                hubs: session.hubs,
                plannedHubId: item.plannedHubId,
                busy: _busy,
                onReceive: _receive,
              )
            else if (item.needsInspection)
              ModuleCard(
                title: context.l10n.returnDeskInspectTitle,
                leading: const IconTile(icon: Icons.fact_check_rounded, solid: true, size: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.returnDeskInspectHint,
                      style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                    ),
                    const Gap.lg(),
                    PrimaryButton(
                      label: context.l10n.returnDeskStartInspection,
                      icon: Icons.photo_camera_rounded,
                      onPressed: _busy ? null : () => _inspect(item),
                    ),
                  ],
                ),
              )
            else if (item.chargesEditable) ...[
              ChargesEditor(
                key: ValueKey('charges-${item.id}-${penalty?.stage}-${penalty?.lines.length}-${penalty?.submittedAt}'),
                item: item,
                busy: _busy,
                onSave: _saveCharges,
              ),
              if (penalty?.stage == PenaltyStage.disputed && session.canOverridePenalties) ...[
                const Gap.sm(),
                GhostButton(
                  label: context.l10n.returnDeskApproveForRider,
                  icon: Icons.admin_panel_settings_rounded,
                  onPressed: _busy ? null : _override,
                ),
              ],
            ] else if (penalty != null)
              _ChargesStatus(
                item: item,
                penalty: penalty,
                busy: _busy,
                canApprove: session.canApprovePenalties,
                canOverride: session.canOverridePenalties,
                onApprove: () => _approve(penalty),
                onOverride: _override,
              ),
          ],
        ),
      ),
    );
  }
}

class _StageCard extends StatelessWidget {
  const _StageCard({required this.item});

  final ReturnCase item;

  @override
  Widget build(BuildContext context) {
    final ReturnStageStyle style = ReturnStageStyle.of(context.l10n, item);
    final PenaltyStage? stage = item.penalty?.stage;
    final String guide = switch (item.state) {
      ReturnState.cancelled => context.l10n.returnDeskGuideCancelled,
      ReturnState.requested => context.l10n.returnDeskGuideReceive(Fmt.date(item.plannedDate)),
      ReturnState.returned when !item.inspectionDone => context.l10n.returnDeskGuideInspect,
      ReturnState.returned => switch (stage) {
        null || PenaltyStage.draft => context.l10n.returnDeskGuideCharges,
        PenaltyStage.awaitingRider => context.l10n.returnDeskGuideWithRider,
        PenaltyStage.awaitingManager => context.l10n.returnDeskGuideApprove,
        PenaltyStage.disputed => context.l10n.returnDeskGuideDisputed,
        PenaltyStage.posted => context.l10n.returnDeskGuideClosed,
      },
    };
    return AccentCard(
      accent: style.tone.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(label: style.label, tone: style.tone, dense: true, solid: true),
          const Gap.md(),
          Text(guide, style: AppText.bodyMedium.copyWith(height: 1.5)),
        ],
      ),
    );
  }
}

class _CaseDetails extends StatelessWidget {
  const _CaseDetails({required this.item, required this.hubNames, required this.onCall});

  final ReturnCase item;
  final Map<String, String> hubNames;
  final ValueChanged<String> onCall;

  @override
  Widget build(BuildContext context) {
    final String? mobile = item.riderMobile;
    final String? notes = item.notes;
    final DateTime? receivedAt = item.receivedAt;
    final String? plannedHub = hubNames[item.plannedHubId];
    final String? receivedHub = hubNames[item.receivedHubId];
    final String? vehicle = item.vehicleNumber == null ? null : [item.vehicleNumber!, ?item.vehicleModel].join(' · ');
    final bool? safe = item.safeForReuse;
    return ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppAvatar(name: item.riderName, size: 44),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.riderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium.copyWith(fontSize: 15.5),
                    ),
                    if (mobile != null) ...[
                      const SizedBox(height: 2),
                      Text(Fmt.phone(mobile), style: AppText.bodySmall.copyWith(fontSize: 12.5)),
                    ],
                  ],
                ),
              ),
              if (mobile != null)
                CircleIconButton(
                  icon: Icons.call_rounded,
                  background: AppColors.primaryWash,
                  foreground: AppColors.primary,
                  onTap: () => onCall(mobile),
                ),
            ],
          ),
          const Gap.md(),
          if (vehicle != null)
            KeyValueRow(
              label: context.l10n.commonVehicle,
              value: vehicle,
              icon: Icons.electric_moped_rounded,
              dense: true,
            ),
          KeyValueRow(
            label: context.l10n.returnsReason,
            value: returnReasonLabel(context.l10n, item.reasonCode),
            icon: Icons.help_outline_rounded,
            dense: true,
          ),
          if (notes != null && notes.isNotEmpty)
            KeyValueRow(label: context.l10n.returnDeskRiderNote, value: notes, icon: Icons.notes_rounded, dense: true),
          KeyValueRow(
            label: context.l10n.returnsDate,
            value: Fmt.date(item.plannedDate),
            icon: Icons.event_rounded,
            dense: true,
          ),
          if (plannedHub != null)
            KeyValueRow(label: context.l10n.returnsHub, value: plannedHub, icon: Icons.store_rounded, dense: true),
          if (receivedAt != null)
            KeyValueRow(
              label: context.l10n.returnDeskReceivedAt,
              value: [Fmt.dateTime(receivedAt), ?receivedHub].join(' · '),
              icon: Icons.assignment_turned_in_rounded,
              dense: true,
            ),
          if (safe != null)
            KeyValueRow(
              label: context.l10n.returnDeskInspectionResult,
              value: safe ? context.l10n.returnDeskSafeYes : context.l10n.returnDeskSafeNo,
              valueColor: safe ? AppColors.success : AppColors.danger,
              icon: Icons.health_and_safety_rounded,
              dense: true,
            ),
        ],
      ),
    );
  }
}

class _ChargesStatus extends ConsumerWidget {
  const _ChargesStatus({
    required this.item,
    required this.penalty,
    required this.busy,
    required this.canApprove,
    required this.canOverride,
    required this.onApprove,
    required this.onOverride,
  });

  final ReturnCase item;
  final PenaltyState penalty;
  final bool busy;
  final bool canApprove;
  final bool canOverride;
  final VoidCallback onApprove;
  final VoidCallback onOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, PenaltyPrice> prices = {
      for (final PenaltyPrice price in ref.watch(penaltyPricesProvider).value ?? const <PenaltyPrice>[])
        price.id: price,
    };
    final DateTime? postedAt = penalty.postedAt;
    final String? overrideReason = penalty.overrideReason;
    final String status = switch (penalty.stage) {
      PenaltyStage.awaitingRider => context.l10n.returnDeskWaitingRider(item.riderName),
      PenaltyStage.awaitingManager when penalty.adminOverridden && !penalty.riderApproved =>
        context.l10n.returnDeskAdminApproved,
      PenaltyStage.awaitingManager => context.l10n.returnDeskRiderApproved,
      PenaltyStage.posted when penalty.total > 0 => context.l10n.returnDeskPosted(
        postedAt == null ? '—' : Fmt.date(postedAt),
      ),
      PenaltyStage.posted => context.l10n.returnsNoteNoCharges,
      PenaltyStage.draft || PenaltyStage.disputed => context.l10n.returnDeskGuideCharges,
    };
    final bool approvable =
        canApprove &&
        !penalty.managerApproved &&
        (penalty.stage == PenaltyStage.awaitingRider || penalty.stage == PenaltyStage.awaitingManager);
    return ModuleCard(
      title: context.l10n.returnsCharges,
      leading: const IconTile(icon: Icons.receipt_long_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final PenaltyLine line in penalty.lines) ...[
            PenaltyLineRow(line: line.priced(prices[line.priceId])),
            if (line != penalty.lines.last) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          ],
          if (penalty.lines.isNotEmpty) ...[const Gap.sm(), ChargesTotal(total: penalty.total)],
          const Gap.md(),
          Text(status, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5)),
          if (overrideReason != null && penalty.adminOverridden) ...[
            const Gap.sm(),
            KeyValueRow(
              label: context.l10n.returnDeskOverrideReason,
              value: overrideReason,
              icon: Icons.admin_panel_settings_rounded,
              dense: true,
            ),
          ],
          if (penalty.managerApproved && penalty.stage != PenaltyStage.posted) ...[
            const Gap.sm(),
            StatusChip(
              label: context.l10n.returnDeskManagerApproved,
              tone: StatusTone.success,
              icon: Icons.verified_rounded,
              dense: true,
            ),
          ],
          if (approvable) ...[
            const Gap.lg(),
            penalty.stage == PenaltyStage.awaitingManager
                ? PrimaryButton(
                    label: context.l10n.returnDeskApproveAndPost,
                    icon: Icons.verified_rounded,
                    loading: busy,
                    onPressed: busy ? null : onApprove,
                  )
                : SecondaryButton(
                    label: context.l10n.returnDeskApproveAsManager,
                    icon: Icons.verified_rounded,
                    onPressed: busy ? null : onApprove,
                  ),
          ] else if (penalty.stage == PenaltyStage.awaitingManager && !canApprove) ...[
            const Gap.sm(),
            Text(
              context.l10n.returnDeskWaitingManager,
              style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
          if (canOverride && penalty.stage == PenaltyStage.awaitingRider) ...[
            const Gap.sm(),
            GhostButton(
              label: context.l10n.returnDeskApproveForRider,
              icon: Icons.admin_panel_settings_rounded,
              onPressed: busy ? null : onOverride,
            ),
          ],
        ],
      ),
    );
  }
}
