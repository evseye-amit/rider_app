import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/exchange_case.dart';
import '../../domain/usecases/exchange_steps.dart';
import '../../exchange_dependencies.dart';
import '../providers/exchange_case_providers.dart';
import '../widgets/exchange_case_widgets.dart';

class ExchangeCasePage extends ConsumerStatefulWidget {
  const ExchangeCasePage({required this.exchangeId, super.key});

  final String exchangeId;

  @override
  ConsumerState<ExchangeCasePage> createState() => _ExchangeCasePageState();
}

class _ExchangeCasePageState extends ConsumerState<ExchangeCasePage> {
  bool _busy = false;

  String get _id => widget.exchangeId;

  Future<void> _refresh() async {
    ref.invalidate(exchangeCasesProvider);
    ref.invalidate(exchangeQuoteProvider(_id));
    await ref.refreshQuietly(exchangeCaseProvider(_id));
  }

  Future<bool> _run(Future<Result<void>> Function() action, String successMessage) async {
    setState(() => _busy = true);
    final Result<void> result = await action();
    if (!mounted) return false;
    setState(() => _busy = false);
    final bool ok = result.isOk;
    switch (result) {
      case Ok<void>():
        AppSnack.success(context, successMessage);
      case Err<void>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
    return ok;
  }

  Future<void> _reject() async {
    final TextEditingController controller = TextEditingController();
    final String? reason = await AppSheet.show<String>(
      context,
      title: context.l10n.exchangeDeskReject,
      subtitle: context.l10n.exchangeDeskRejectSubtitle,
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
          label: context.l10n.exchangeDeskReject,
          icon: Icons.close_rounded,
          fillColor: AppColors.danger,
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
      () => ref.read(rejectExchangeProvider)(RejectExchangeParams(id: _id, reason: reason)),
      context.l10n.exchangeDeskRejectedDone,
    );
  }

  Future<void> _settleDeposits() async {
    setState(() => _busy = true);
    final Result<DepositOutcome> result = await ref.read(settleExchangeDepositsProvider)(_id);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<DepositOutcome>(:final value) when !value.settled:
        if (value.securityShortfall > 0) {
          AppSnack.warning(
            context,
            context.l10n.exchangeDeskDepositBreakdown(
              Fmt.money(value.due),
              Fmt.money(value.newDeposit),
              Fmt.money(value.securityShortfall),
            ),
          );
        } else {
          AppSnack.info(context, context.l10n.exchangeDeskDepositDue(Fmt.money(value.due)));
        }
      case Ok<DepositOutcome>():
        AppSnack.success(context, context.l10n.exchangeDeskDepositsSettled);
      case Err<DepositOutcome>(:final failure):
        AppSnack.error(context, failure.message);
    }
    await _refresh();
  }

  Future<String?> _askText({
    required String title,
    required String subtitle,
    required String label,
    required String action,
    required IconData icon,
    Color? fill,
  }) async {
    final TextEditingController controller = TextEditingController();
    final String? value = await AppSheet.show<String>(
      context,
      title: title,
      subtitle: subtitle,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: AppTextField(
          label: label,
          maxLines: 3,
          maxLength: 500,
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      footer: Builder(
        builder: (sheet) => PrimaryButton(
          label: action,
          icon: icon,
          fillColor: fill,
          onPressed: () => Navigator.of(sheet).pop(controller.text.trim()),
        ),
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _acceptForRider(CaseOffer offer) async {
    final String? consent = await _askText(
      title: context.l10n.exchangeDeskAcceptForRider,
      subtitle: context.l10n.exchangeDeskConsentSubtitle,
      label: context.l10n.exchangeDeskConsentReference,
      action: context.l10n.commonContinue,
      icon: Icons.arrow_forward_rounded,
    );
    if (consent == null || !mounted) return;
    if (consent.isEmpty) {
      AppSnack.error(context, context.l10n.exchangeDeskConsentNeeded);
      return;
    }
    final String? reason = await _askText(
      title: context.l10n.exchangeDeskAcceptForRider,
      subtitle: context.l10n.exchangeDeskAssistedReasonSubtitle,
      label: context.l10n.exchangeDeskAssistedReason,
      action: context.l10n.exchangeDeskAcceptForRider,
      icon: Icons.verified_rounded,
      fill: AppColors.success,
    );
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.exchangeDeskAssistedReasonNeeded);
      return;
    }
    await _run(
      () => ref.read(acceptOfferOnBehalfProvider)(
        AssistedAcceptParams(id: _id, offer: offer, consentReference: consent, reason: reason),
      ),
      context.l10n.exchangeDeskAcceptedForRider,
    );
  }

  Future<void> _declineForRider(CaseOffer offer) async {
    final String? reason = await _askText(
      title: context.l10n.exchangeDeskDeclineForRider,
      subtitle: context.l10n.exchangeDeskDeclineSubtitle,
      label: context.l10n.exchangeRejectReason,
      action: context.l10n.exchangeDeskDeclineForRider,
      icon: Icons.close_rounded,
      fill: AppColors.danger,
    );
    if (reason == null || !mounted) return;
    if (reason.isEmpty) {
      AppSnack.error(context, context.l10n.exchangeRejectReasonRequired);
      return;
    }
    await _run(
      () => ref.read(rejectOfferOnBehalfProvider)(AssistedRejectParams(id: _id, offer: offer, reason: reason)),
      context.l10n.exchangeDeskDeclinedForRider,
    );
  }

  void _showTerms(CaseOffer offer) => AppSheet.show<void>(
    context,
    title: offer.termsTitle.isEmpty ? context.l10n.exchangeReadTerms : offer.termsTitle,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: Text(plainTextFromHtml(offer.termsBody), style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.55)),
    ),
  );

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
    await _run(() => ref.read(cancelExchangeCaseProvider)(_id), context.l10n.exchangeCancelled);
  }

  Future<void> _chooseScooter() async {
    final bool? reserved = await context.push<bool>('${Routes.exchangeReplacement}?id=$_id');
    if (reserved == true && mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ExchangeCase> detail = ref.watch(exchangeCaseProvider(_id));
    final ExchangeCase? exchange = detail.value;

    if (exchange == null) {
      return AppScaffold(
        title: context.l10n.exchangeDetailTitle,
        body: detail.hasError
            ? EmptyState(
                title: context.l10n.exchangeCouldNotLoad,
                message: detail.failureMessage,
                icon: Icons.cloud_off_rounded,
                tone: AppColors.danger,
                actionLabel: context.l10n.commonTryAgain,
                onAction: () => ref.invalidate(exchangeCaseProvider(_id)),
              )
            : const PageBody(
                children: [
                  ShimmerBox(height: 120, borderRadius: Corners.brLg),
                  Gap.md(),
                  ShimmerBox(height: 220, borderRadius: Corners.brLg),
                ],
              ),
      );
    }

    final String? guide = caseStepGuide(context.l10n, exchange.nextStep);

    return AppScaffold(
      title: context.l10n.exchangeDetailTitle,
      subtitle: exchange.riderName,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            AccentCard(
              accent: caseStatusTone(exchange).color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusChip(
                    label: caseStatusLabel(context.l10n, exchange),
                    tone: caseStatusTone(exchange),
                    dense: true,
                    solid: true,
                  ),
                  if (guide != null) ...[const Gap.md(), Text(guide, style: AppText.bodyMedium.copyWith(height: 1.5))],
                ],
              ),
            ),
            const Gap.lg(),
            ..._actions(exchange),
            _CaseSummary(exchange: exchange),
            if (exchange.canCancel) ...[
              const Gap.xl(),
              SecondaryButton(
                label: context.l10n.exchangeCancelRequest,
                icon: Icons.cancel_rounded,
                onPressed: _busy ? null : _cancel,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(ExchangeCase exchange) {
    Widget primary(String label, IconData icon, Future<void> Function() onTap) =>
        PrimaryButton(label: label, icon: icon, loading: _busy, onPressed: _busy ? null : onTap);

    final List<Widget> actions = switch (exchange.nextStep) {
      CaseStep.review => [
        primary(
          context.l10n.exchangeDeskApprove,
          Icons.check_circle_rounded,
          () => _run(() => ref.read(approveExchangeProvider)(_id), context.l10n.exchangeDeskApproved),
        ),
        const Gap.md(),
        SecondaryButton(
          label: context.l10n.exchangeDeskReject,
          icon: Icons.close_rounded,
          onPressed: _busy ? null : _reject,
        ),
      ],
      CaseStep.startReturn => [
        primary(
          context.l10n.exchangeDeskStartReturn,
          Icons.assignment_return_rounded,
          () => _run(() => ref.read(startExchangeReturnProvider)(_id), context.l10n.exchangeDeskReturnStarted),
        ),
      ],
      CaseStep.finishReturn => [
        if (exchange.oldAllocationId case final String allocationId) ...[
          SecondaryButton(
            label: context.l10n.exchangeDeskOpenReturn,
            icon: Icons.open_in_new_rounded,
            onPressed: () => context.push('${Routes.deallocationDetail}?id=$allocationId'),
          ),
          const Gap.md(),
        ],
        primary(
          context.l10n.exchangeDeskConfirmReturn,
          Icons.task_alt_rounded,
          () => _run(() => ref.read(confirmExchangeReturnProvider)(_id), context.l10n.exchangeDeskReturnConfirmed),
        ),
      ],
      CaseStep.chooseScooter => [
        primary(context.l10n.exchangeDeskChooseScooter, Icons.electric_scooter_rounded, _chooseScooter),
      ],
      CaseStep.sendOffer => [
        _QuotePreview(exchangeId: _id, reservedUntil: exchange.reservedUntil),
        const Gap.lg(),
        primary(
          context.l10n.exchangeDeskSendOffer,
          Icons.send_rounded,
          () => _run(() => ref.read(sendExchangeOfferProvider)(_id), context.l10n.exchangeDeskOfferSent),
        ),
        const Gap.sm(),
        GhostButton(
          label: context.l10n.exchangeDeskChangeScooter,
          icon: Icons.swap_horiz_rounded,
          onPressed: _busy ? null : _chooseScooter,
        ),
      ],
      CaseStep.awaitRider => [
        if (exchange.pendingOffer case final CaseOffer offer) ...[
          ModuleCard(
            title: context.l10n.exchangeOfferTitle,
            leading: const IconTile(icon: Icons.local_offer_rounded, solid: true, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CaseQuoteView(quote: offer.quote),
                KeyValueRow(
                  label: context.l10n.exchangeOfferExpires,
                  value: Fmt.dateTime(offer.expiresAt),
                  icon: Icons.schedule_rounded,
                  valueColor: offer.hasExpired ? AppColors.danger : null,
                ),
                if (offer.termsBody.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GhostButton(
                      label: context.l10n.exchangeReadTerms,
                      icon: Icons.description_rounded,
                      dense: true,
                      onPressed: () => _showTerms(offer),
                    ),
                  ),
              ],
            ),
          ),
          if (!offer.hasExpired) ...[
            const Gap.md(),
            Text(context.l10n.exchangeDeskAssistedHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
            const Gap.md(),
            primary(context.l10n.exchangeDeskAcceptForRider, Icons.verified_rounded, () => _acceptForRider(offer)),
            const Gap.sm(),
            SecondaryButton(
              label: context.l10n.exchangeDeskDeclineForRider,
              icon: Icons.close_rounded,
              onPressed: _busy ? null : () => _declineForRider(offer),
            ),
          ],
        ],
        const Gap.sm(),
        GhostButton(
          label: context.l10n.exchangeDeskChangeScooter,
          icon: Icons.swap_horiz_rounded,
          onPressed: _busy ? null : _chooseScooter,
        ),
      ],
      CaseStep.settleDeposits => [
        if (exchange.acceptedOffer case final CaseOffer offer) ...[
          ModuleCard(
            title: context.l10n.exchangeAcceptedOfferTitle,
            leading: const IconTile(icon: Icons.verified_rounded, tone: AppColors.success, solid: true, size: 28),
            child: CaseQuoteView(quote: offer.quote),
          ),
          const Gap.lg(),
        ],
        primary(context.l10n.exchangeDeskSettleDeposits, Icons.savings_rounded, _settleDeposits),
      ],
      CaseStep.startHandover => [
        primary(
          context.l10n.exchangeDeskStartHandover,
          Icons.handshake_rounded,
          () => _run(() => ref.read(startExchangeHandoverProvider)(_id), context.l10n.exchangeDeskHandoverStarted),
        ),
      ],
      CaseStep.finishHandover => [
        if (exchange.newAllocationId case final String allocationId) ...[
          SecondaryButton(
            label: context.l10n.exchangeDeskOpenAllocation,
            icon: Icons.open_in_new_rounded,
            onPressed: () => context.push('${Routes.allocationDetail}?id=$allocationId'),
          ),
          const Gap.md(),
        ],
        primary(
          context.l10n.exchangeDeskComplete,
          Icons.task_alt_rounded,
          () => _run(() => ref.read(completeExchangeProvider)(_id), context.l10n.exchangeDeskExchangeCompleted),
        ),
      ],
      CaseStep.none => [
        if (exchange.status == CaseStatus.completed && exchange.newAllocationId != null)
          SecondaryButton(
            label: context.l10n.exchangeDeskOpenAllocation,
            icon: Icons.open_in_new_rounded,
            onPressed: () => context.push('${Routes.allocationDetail}?id=${exchange.newAllocationId}'),
          ),
      ],
    };
    return actions.isEmpty ? const [] : [...actions, const Gap.xl()];
  }
}

class _QuotePreview extends ConsumerWidget {
  const _QuotePreview({required this.exchangeId, this.reservedUntil});

  final String exchangeId;
  final DateTime? reservedUntil;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CaseQuote> quote = ref.watch(exchangeQuoteProvider(exchangeId));
    final DateTime? until = reservedUntil;
    return ModuleCard(
      title: context.l10n.exchangeDeskOfferPreview,
      leading: const IconTile(icon: Icons.local_offer_rounded, solid: true, size: 28),
      child: switch (quote) {
        AsyncValue(:final CaseQuote value) => Column(
          children: [
            CaseQuoteView(quote: value),
            if (until != null)
              KeyValueRow(
                label: context.l10n.exchangeDeskStatusReserved,
                value: context.l10n.exchangeDeskReservedUntil(Fmt.dateTime(until)),
                icon: Icons.lock_clock_rounded,
              ),
          ],
        ),
        AsyncValue(hasError: true) => EmptyState(
          title: context.l10n.exchangeCouldNotLoad,
          message: quote.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(exchangeQuoteProvider(exchangeId)),
          compact: true,
        ),
        _ => const ShimmerBox(height: 120, borderRadius: Corners.brMd),
      },
    );
  }
}

class _CaseSummary extends StatelessWidget {
  const _CaseSummary({required this.exchange});

  final ExchangeCase exchange;

  @override
  Widget build(BuildContext context) {
    final String? mobile = exchange.riderMobile;
    final String? note = exchange.status == CaseStatus.rejected ? null : exchange.reason;
    final String? hubReason = exchange.status == CaseStatus.rejected ? exchange.reason : null;
    return ModuleCard(
      title: context.l10n.exchangeDetails,
      leading: const IconTile(icon: Icons.info_outline_rounded, solid: true, size: 28),
      child: Column(
        children: [
          KeyValueRow(label: context.l10n.allocationRider, value: exchange.riderName, icon: Icons.person_rounded),
          if (mobile != null) KeyValueRow(label: context.l10n.commonMobile, value: mobile, icon: Icons.phone_rounded),
          if (exchange.oldScooter case final ScooterOption scooter)
            KeyValueRow(
              label: context.l10n.exchangeCurrentScooter,
              value: scooter.label,
              icon: Icons.electric_scooter_rounded,
            ),
          if (exchange.replacementScooter case final ScooterOption scooter)
            KeyValueRow(
              label: context.l10n.exchangeDeskReplacement,
              value: scooter.label,
              icon: Icons.two_wheeler_rounded,
            ),
          KeyValueRow(
            label: context.l10n.exchangeReason,
            value: caseReasonLabel(context.l10n, exchange.reasonCode),
            icon: Icons.help_outline_rounded,
          ),
          if (note != null && note.isNotEmpty)
            KeyValueRow(label: context.l10n.exchangeDeskRiderNote, value: note, icon: Icons.notes_rounded),
          if (hubReason != null && hubReason.isNotEmpty)
            KeyValueRow(label: context.l10n.exchangeHubReason, value: hubReason, icon: Icons.notes_rounded),
          if (exchange.agreementNumber case final String number)
            KeyValueRow(label: context.l10n.onboardingStepAgreement, value: number, icon: Icons.description_rounded),
          KeyValueRow(
            label: context.l10n.exchangeRaised,
            value: Fmt.dateTime(exchange.createdAt),
            icon: Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }
}
