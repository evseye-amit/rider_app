import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/check_in/check_in_card.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../domain/entities/exchange_request.dart';
import '../../domain/usecases/respond_to_offer.dart';
import '../../exchange_dependencies.dart';
import '../providers/exchange_provider.dart';
import '../widgets/exchange_widgets.dart';

class ExchangeDetailPage extends ConsumerStatefulWidget {
  const ExchangeDetailPage({required this.exchangeId, super.key});

  final String exchangeId;

  @override
  ConsumerState<ExchangeDetailPage> createState() => _ExchangeDetailPageState();
}

class _ExchangeDetailPageState extends ConsumerState<ExchangeDetailPage> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(riderSessionProvider.notifier).refreshState();
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(exchangesProvider);
    ref.invalidate(riderCheckInProvider);
    await (
      ref.refreshQuietly(exchangeProvider(widget.exchangeId)),
      ref.read(riderSessionProvider.notifier).refreshState(),
    ).wait;
  }

  Future<void> _openHandover() async {
    setState(() => _busy = true);
    await ref.read(riderSessionProvider.notifier).refreshState();
    if (!mounted) return;
    setState(() => _busy = false);
    if (ref.read(riderSessionProvider).stage == RiderStage.active) {
      AppSnack.info(context, context.l10n.exchangeHandoverNotReady);
    }
  }

  Future<void> _run(Future<Result<void>> Function() action, String successMessage) async {
    setState(() => _busy = true);
    final Result<void> result = await action();
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case Ok<void>():
        AppSnack.success(context, successMessage);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  Future<void> _accept(ExchangeOffer offer) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.exchangeAcceptOffer,
      message: context.l10n.exchangeAcceptConfirm,
      confirmLabel: context.l10n.exchangeAcceptOffer,
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !mounted) return;
    await _run(
      () => ref.read(acceptExchangeOfferProvider)(
        AcceptOfferParams(id: widget.exchangeId, offerId: offer.id, offerHash: offer.hash),
      ),
      context.l10n.exchangeAccepted,
    );
  }

  Future<void> _reject(ExchangeOffer offer) async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await AppSheet.show<String>(
      context,
      title: context.l10n.exchangeRejectOffer,
      subtitle: context.l10n.exchangeRejectSubtitle,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AppTextField(
          label: context.l10n.exchangeRejectReason,
          maxLines: 3,
          maxLength: 500,
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      footer: Builder(
        builder: (sheet) => PrimaryButton(
          label: context.l10n.exchangeRejectOffer,
          icon: Icons.close_rounded,
          onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
        ),
      ),
    );
    controller.dispose();
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.exchangeRejectReasonRequired);
      return;
    }
    await _run(
      () => ref.read(rejectExchangeOfferProvider)(
        RejectOfferParams(id: widget.exchangeId, offerId: offer.id, reason: reason),
      ),
      context.l10n.exchangeRejected,
    );
  }

  Future<void> _cancel() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.exchangeCancelRequest,
      message: context.l10n.exchangeCancelConfirm,
      confirmLabel: context.l10n.exchangeCancelRequest,
      icon: Icons.cancel_rounded,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await _run(() => ref.read(cancelExchangeProvider)(widget.exchangeId), context.l10n.exchangeCancelled);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ExchangeRequest> exchange = ref.watch(exchangeProvider(widget.exchangeId));
    final ExchangeRequest? request = exchange.value;

    if (request == null) {
      return AppScaffold(
        title: context.l10n.exchangeDetailTitle,
        body: exchange.hasError
            ? EmptyState(
                title: context.l10n.exchangeCouldNotLoad,
                message: exchange.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(exchangeProvider(widget.exchangeId)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 120, borderRadius: Corners.brLg),
                  Gap.md(),
                  ShimmerBox(height: 260, borderRadius: Corners.brLg),
                ],
              ),
      );
    }

    final ExchangeOffer? pending = request.pendingOffer;
    final ExchangeOffer? accepted = request.acceptedOffer;
    final bool rejected = request.status == ExchangeStatus.rejected;
    final String? note = rejected ? null : request.reason;
    final String? hubReason = rejected ? request.reason : null;
    final DateTime? completedAt = request.completedAt;
    final DateTime? plannedDate = request.plannedDate;
    final String? checkInId = request.checkInId;

    final List<Widget> sections = [
      if (request.status == ExchangeStatus.handoverPending)
        ModuleCard(
          title: context.l10n.exchangeHandoverTitle,
          leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.l10n.exchangeHandoverBody, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.5)),
              const Gap.lg(),
              PrimaryButton(
                label: context.l10n.exchangeHandoverCheck,
                icon: Icons.fact_check_rounded,
                loading: _busy,
                onPressed: _busy ? null : _openHandover,
              ),
            ],
          ),
        ),
      if (pending != null)
        ExchangeOfferCard(
          key: ValueKey(pending.id),
          offer: pending,
          busy: _busy,
          onAccept: () => _accept(pending),
          onReject: () => _reject(pending),
        )
      else if (accepted != null)
        AcceptedPlanCard(request: request, offer: accepted),
      if (checkInId != null) CheckInCard(submissionId: checkInId),
      ExchangeTimeline(request: request),
      ModuleCard(
        title: context.l10n.exchangeDetails,
        leading: const IconTile(icon: Icons.info_outline_rounded, solid: true, size: 28),
        child: Column(
          children: [
            KeyValueRow(
              label: context.l10n.exchangeReason,
              value: exchangeReasonLabel(context.l10n, request.reasonCode),
              icon: Icons.help_outline_rounded,
            ),
            if (note != null && note.isNotEmpty)
              KeyValueRow(label: context.l10n.exchangeNotes, value: note, icon: Icons.notes_rounded),
            if (hubReason != null && hubReason.isNotEmpty)
              KeyValueRow(label: context.l10n.exchangeHubReason, value: hubReason, icon: Icons.info_outline_rounded),
            if (plannedDate != null)
              KeyValueRow(
                label: context.l10n.exchangeReturnDate,
                value: Fmt.date(plannedDate),
                icon: Icons.event_rounded,
              ),
            KeyValueRow(
              label: context.l10n.exchangeRaised,
              value: Fmt.dateTime(request.createdAt),
              icon: Icons.schedule_rounded,
            ),
            if (completedAt != null)
              KeyValueRow(
                label: context.l10n.exchangeCompleted,
                value: Fmt.dateTime(completedAt),
                icon: Icons.check_circle_rounded,
              ),
          ],
        ),
      ),
      if (accepted != null) AgreementHistoryCard(agreementId: request.agreementId),
    ];

    return HeroScaffold(
      onRefresh: _refresh,
      band: _Band(request: request),
      children: [
        for (final (int i, Widget section) in sections.indexed) ...[if (i > 0) const Gap.lg(), section],
        if (request.canCancel) ...[
          const Gap.xl(),
          SecondaryButton(
            label: context.l10n.exchangeCancelRequest,
            icon: Icons.cancel_rounded,
            onPressed: _busy ? null : _cancel,
          ),
        ],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.request});

  final ExchangeRequest request;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? plannedDate = request.plannedDate;
    final bool showPlanned = plannedDate != null && !request.oldScooterReturned && request.status.isOpen;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            const Spacer(),
            StatusChip(
              label: exchangeStatusLabel(l10n, request),
              tone: exchangeStatusTone(request.status),
              icon: switch (request.status) {
                ExchangeStatus.completed => Icons.check_circle_rounded,
                ExchangeStatus.rejected => Icons.cancel_rounded,
                ExchangeStatus.cancelled || ExchangeStatus.expired => Icons.block_rounded,
                ExchangeStatus.offerPresented => Icons.local_offer_rounded,
                _ => Icons.hourglass_top_rounded,
              },
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Row(
          children: [
            const IconTile(icon: Icons.swap_horiz_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exchangeReasonLabel(l10n, request.reasonCode),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 21, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    showPlanned
                        ? '${l10n.exchangeDetailTitle} · ${l10n.returnsPlannedFor(Fmt.date(plannedDate))}'
                        : l10n.exchangeDetailTitle,
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
