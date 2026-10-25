import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/check_in/check_in_card.dart';
import '../../domain/entities/ride_return.dart';
import '../../domain/usecases/ride_return_usecases.dart';
import '../../ride_returns_dependencies.dart';
import '../providers/ride_returns_providers.dart';
import '../widgets/return_widgets.dart';

class ReturnDetailPage extends ConsumerStatefulWidget {
  const ReturnDetailPage({required this.returnId, super.key});

  final String returnId;

  @override
  ConsumerState<ReturnDetailPage> createState() => _ReturnDetailPageState();
}

class _ReturnDetailPageState extends ConsumerState<ReturnDetailPage> {
  bool _busy = false;

  Future<void> _refresh() {
    ref.invalidate(riderCheckInProvider);
    return ref.refresh(rideReturnProvider(widget.returnId).future).then<void>((_) {}, onError: (_) {});
  }

  Future<void> _cancel() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.returnsCancelTitle,
      message: context.l10n.returnsCancelBody,
      confirmLabel: context.l10n.returnsCancel,
      icon: Icons.cancel_rounded,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    final Result<void> result = await ref.read(cancelRideReturnProvider)(widget.returnId);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.returnsCancelled);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  Future<void> _approve(ReturnCharges charges) async {
    setState(() => _busy = true);
    final Result<ApprovalCode> first = await ref.read(requestChargesApprovalCodeProvider)(widget.returnId);
    if (!mounted) return;
    setState(() => _busy = false);
    if (first case Err<ApprovalCode>(:final failure)) {
      AppSnack.error(context, failure.message);
      await _refresh();
      return;
    }
    ApprovalCode code = (first as Ok<ApprovalCode>).value;

    final bool approved = await ApprovalCodeSheet.show(
      context,
      total: charges.total,
      onResend: () async {
        final Result<ApprovalCode> again = await ref.read(requestChargesApprovalCodeProvider)(widget.returnId);
        if (again case Ok<ApprovalCode>(:final value)) code = value;
        return again.failureOrNull?.message;
      },
      onVerify: (entered) async => (await ref.read(approveReturnChargesProvider)(
        ApproveChargesParams(id: widget.returnId, requestId: code.requestId, code: entered),
      )).failureOrNull?.message,
    );
    if (!mounted) return;
    if (approved) AppSnack.success(context, context.l10n.returnsChargesApproved);
    await _refresh();
  }

  Future<void> _dispute() async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await AppSheet.show<String>(
      context,
      title: context.l10n.returnsDisputeCharges,
      subtitle: context.l10n.returnsDisputeSubtitle,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AppTextField(
          label: context.l10n.returnsDisputeReason,
          maxLines: 4,
          maxLength: 500,
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      footer: Builder(
        builder: (sheet) => PrimaryButton(
          label: context.l10n.returnsSendDispute,
          icon: Icons.send_rounded,
          onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
        ),
      ),
    );
    controller.dispose();
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.returnsDisputeReasonRequired);
      return;
    }
    setState(() => _busy = true);
    final Result<void> result = await ref.read(disputeReturnChargesProvider)(
      DisputeChargesParams(id: widget.returnId, reason: reason),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, context.l10n.returnsDisputeSent);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RideReturn> detail = ref.watch(rideReturnProvider(widget.returnId));
    final RideReturn? item = detail.value;

    if (item == null) {
      return AppScaffold(
        title: context.l10n.returnsDetailTitle,
        body: detail.hasError
            ? EmptyState(
                title: context.l10n.returnsCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(rideReturnProvider(widget.returnId)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 120, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 220, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 180, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    final ReturnCharges? charges = item.charges;
    final String? notes = item.notes;
    final DateTime? receivedAt = item.receivedAt;
    final DateTime? cancelledAt = item.cancelledAt;
    final String? checkInId = item.checkInId;

    return HeroScaffold(
      onRefresh: _refresh,
      band: _Band(item: item),
      children: [
        if (checkInId != null) ...[CheckInCard(submissionId: checkInId), const Gap.lg()],
        if (!item.usesCheckIn && item.status == ReturnStatus.returned) ...[
          ChargesCard(
            charges:
                charges ??
                const ReturnCharges(
                  stage: ChargesStage.reviewing,
                  total: 0,
                  items: [],
                  approvedByYou: false,
                  approvedByAdmin: false,
                ),
            busy: _busy,
            onApprove: () => _approve(charges!),
            onDispute: _dispute,
          ),
          const Gap.lg(),
        ],
        if (item.status != ReturnStatus.cancelled) ...[ReturnTimeline(item: item), const Gap.lg()],
        ModuleCard(
          title: context.l10n.returnsDetails,
          leading: const IconTile(icon: Icons.info_outline_rounded, solid: true, size: 28),
          child: Column(
            children: [
              KeyValueRow(
                label: context.l10n.returnsReason,
                value: returnReasonLabel(context.l10n, item.reasonCode),
                icon: Icons.help_outline_rounded,
              ),
              if (notes != null && notes.isNotEmpty)
                KeyValueRow(label: context.l10n.returnsNotes, value: notes, icon: Icons.notes_rounded),
              KeyValueRow(
                label: context.l10n.returnsDate,
                value: Fmt.date(item.plannedDate),
                icon: Icons.event_rounded,
              ),
              KeyValueRow(
                label: context.l10n.commonRaised,
                value: Fmt.dateTime(item.createdAt),
                icon: Icons.schedule_rounded,
              ),
              if (receivedAt != null)
                KeyValueRow(
                  label: context.l10n.returnsHandedOver,
                  value: Fmt.dateTime(receivedAt),
                  icon: Icons.assignment_turned_in_rounded,
                ),
              if (cancelledAt != null)
                KeyValueRow(
                  label: context.l10n.returnsStatusCancelled,
                  value: Fmt.dateTime(cancelledAt),
                  icon: Icons.cancel_outlined,
                ),
            ],
          ),
        ),
        if (item.canCancel) ...[
          const Gap.xl(),
          SecondaryButton(
            label: context.l10n.returnsCancel,
            icon: Icons.close_rounded,
            color: AppColors.danger,
            onPressed: _busy ? null : _cancel,
          ),
        ],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.item});

  final RideReturn item;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final ReturnStatusStyle style = ReturnStatusStyle.of(l10n, item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            const Spacer(),
            StatusChip(label: style.label, tone: style.tone, icon: style.icon, dense: true, solid: true),
          ],
        ),
        const Gap.xl(),
        Row(
          children: [
            const IconTile(icon: Icons.assignment_return_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    returnReasonLabel(l10n, item.reasonCode),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 21, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${l10n.returnsDetailTitle} · ${l10n.returnsPlannedFor(Fmt.date(item.plannedDate))}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodyMedium.copyWith(color: AppColors.onInkSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
