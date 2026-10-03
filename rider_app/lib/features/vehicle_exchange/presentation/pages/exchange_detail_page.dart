import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> _run(Future<Result<ExchangeRequest>> Function() action, String successMessage) async {
    setState(() => _busy = true);
    final Result<ExchangeRequest> result = await action();
    if (!mounted) return;
    setState(() => _busy = false);

    switch (result) {
      case Ok<ExchangeRequest>():
        ref.invalidate(exchangeProvider(widget.exchangeId));
        ref.invalidate(exchangesProvider);
        AppSnack.success(context, successMessage);
      case Err<ExchangeRequest>(:final failure):
        AppSnack.error(context, failure.message);
    }
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
      child: AppTextField(
        label: context.l10n.exchangeRejectReason,
        maxLines: 3,
        controller: controller,
        autofocus: true,
      ),
      footer: PrimaryButton(
        label: context.l10n.exchangeRejectOffer,
        icon: Icons.close_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
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

    if (exchange.isLoading && !exchange.hasValue) {
      return AppScaffold(
        title: context.l10n.exchangeDetailTitle,
        body: const PageBody(
          children: [
            ShimmerBox(height: 140, borderRadius: Corners.brLg),
            Gap.md(),
            ShimmerBox(height: 200, borderRadius: Corners.brLg),
          ],
        ),
      );
    }

    final ExchangeRequest? request = exchange.value;
    if (exchange.hasError || request == null) {
      return AppScaffold(
        title: context.l10n.exchangeDetailTitle,
        body: EmptyState(
          title: context.l10n.exchangeCouldNotLoad,
          message: exchange.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(exchangeProvider(widget.exchangeId)),
        ),
      );
    }

    final ExchangeOffer? offer = request.pendingOffer;

    return AppScaffold(
      title: context.l10n.exchangeDetailTitle,
      subtitle: exchangeReasonLabel(context.l10n, request.reasonCode),
      body: PageBody(
        children: [
          ModuleCard(
            title: context.l10n.commonStatus,
            leading: const IconTile(icon: Icons.timeline_rounded, solid: true, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(
                  label: exchangeStageLabel(context.l10n, request.stage),
                  tone: exchangeStageTone(request.stage),
                  dense: true,
                  solid: true,
                ),
                const Gap.md(),
                KeyValueRow(
                  label: context.l10n.exchangeRaised,
                  value: Fmt.dateTime(request.createdAt),
                  icon: Icons.schedule_rounded,
                ),
                KeyValueRow(
                  label: context.l10n.exchangeReason,
                  value: exchangeReasonLabel(context.l10n, request.reasonCode),
                  icon: Icons.info_outline_rounded,
                ),
                if (request.reason != null && request.reason!.isNotEmpty)
                  KeyValueRow(label: context.l10n.exchangeNotes, value: request.reason!),
                if (request.effectiveAt != null)
                  KeyValueRow(
                    label: context.l10n.exchangeEffective,
                    value: Fmt.date(request.effectiveAt!),
                    icon: Icons.event_rounded,
                  ),
                if (request.completedAt != null)
                  KeyValueRow(
                    label: context.l10n.exchangeCompleted,
                    value: Fmt.dateTime(request.completedAt!),
                    icon: Icons.check_circle_rounded,
                  ),
              ],
            ),
          ),
          const Gap.lg(),
          if (offer != null)
            ExchangeOfferCard(offer: offer, busy: _busy, onAccept: () => _accept(offer), onReject: () => _reject(offer))
          else if (request.stage.isOpen)
            AccentCard(
              accent: AppColors.primary,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.hourglass_top_rounded, size: 19, color: AppColors.primary),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Text(
                      context.l10n.exchangeWaitingOnHub,
                      style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          if (request.canCancel) ...[
            const Gap.xl(),
            SecondaryButton(
              label: context.l10n.exchangeCancelRequest,
              icon: Icons.cancel_rounded,
              onPressed: _busy ? null : _cancel,
            ),
          ],
          const Gap.xl(),
        ],
      ),
    );
  }
}
