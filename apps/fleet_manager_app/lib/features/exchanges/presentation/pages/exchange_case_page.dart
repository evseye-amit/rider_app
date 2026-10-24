import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../../hub/domain/entities/hub_profile.dart';
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
    final String? reason = await _askText(
      title: context.l10n.exchangeDeskReject,
      subtitle: context.l10n.exchangeDeskRejectSubtitle,
      label: context.l10n.exchangeRejectReason,
      action: context.l10n.exchangeDeskReject,
      icon: Icons.close_rounded,
      fill: AppColors.danger,
    );
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

  Future<void> _checkIn(ExchangeCase exchange) async {
    final String? submissionId = exchange.checkInId ?? await _CheckInSheet.show(context, exchange);
    if (submissionId == null || !mounted) return;
    await context.push('${Routes.submission}?id=$submissionId');
    if (mounted) await _refresh();
  }

  Future<void> _openAllocation(String allocationId) async {
    await context.push('${Routes.allocationDetail}?id=$allocationId');
    if (mounted) await _refresh();
  }

  Future<void> _chooseScooter() async {
    final bool? reserved = await context.push<bool>('${Routes.exchangeReplacement}?id=$_id');
    if (reserved == true && mounted) await _refresh();
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
                  ShimmerBox(height: 120, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 90, borderRadius: Corners.brXl),
                  Gap.lg(),
                  ShimmerBox(height: 220, borderRadius: Corners.brXl),
                ],
              ),
      );
    }

    final CaseStage? stage = exchange.stage;
    final String? guide = switch (exchange.status) {
      CaseStatus.completed => null,
      CaseStatus.rejected || CaseStatus.cancelled || CaseStatus.expired => context.l10n.exchangeDeskClosedBody,
      _ when exchange.holdLapsed => context.l10n.exchangeErrorHoldExpired,
      _ => caseStepGuide(context.l10n, exchange.nextStep),
    };
    final Widget? primary = _primary(exchange);

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: _refresh,
      band: _Band(exchange: exchange),
      bottomNavigationBar: primary == null ? null : ExchangeFooter(child: primary),
      children: [
        if (stage != null) ...[
          ExchangeFloatingCard(
            title: context.l10n.exchangeProgress,
            child: StepProgress(
              steps: [for (final CaseStage item in CaseStage.values) caseStageLabel(context.l10n, item)],
              currentIndex: stage.index,
              compact: true,
            ),
          ),
          const Gap.lg(),
        ],
        if (guide != null) ...[
          AccentCard(
            accent: caseStatusTone(exchange).color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(
                  label: context.l10n.submissionNextLabel,
                  tone: caseStatusTone(exchange),
                  dense: true,
                  solid: true,
                ),
                const Gap.md(),
                Text(guide, style: AppText.bodyMedium.copyWith(height: 1.5)),
              ],
            ),
          ),
          const Gap.lg(),
        ],
        ..._stepContent(exchange),
        _CaseSummary(exchange: exchange),
        if (exchange.canCancel && exchange.status != CaseStatus.requested) ...[
          const Gap.lg(),
          SecondaryButton(
            label: context.l10n.exchangeCancelRequest,
            icon: Icons.cancel_rounded,
            color: AppColors.danger,
            onPressed: _busy ? null : _cancel,
          ),
        ],
      ],
    );
  }

  Widget? _primary(ExchangeCase exchange) {
    PrimaryButton button(String label, IconData icon, VoidCallback onTap) =>
        PrimaryButton(label: label, icon: icon, loading: _busy, onPressed: _busy ? null : onTap);

    return switch (exchange.nextStep) {
      CaseStep.review => button(
        context.l10n.exchangeDeskApprove,
        Icons.check_circle_rounded,
        () => _run(() => ref.read(approveExchangeProvider)(_id), context.l10n.exchangeDeskApproved),
      ),
      CaseStep.checkIn => button(
        exchange.checkInId == null ? context.l10n.exchangeDeskCheckIn : context.l10n.exchangeDeskOpenCheckIn,
        Icons.assignment_return_rounded,
        () => _checkIn(exchange),
      ),
      CaseStep.finishCheckIn => button(
        context.l10n.exchangeDeskOpenCheckIn,
        Icons.open_in_new_rounded,
        () => _checkIn(exchange),
      ),
      CaseStep.confirmReturn => button(
        context.l10n.exchangeDeskConfirmReturn,
        Icons.task_alt_rounded,
        () => _run(() => ref.read(confirmExchangeReturnProvider)(_id), context.l10n.exchangeDeskReturnConfirmed),
      ),
      CaseStep.chooseScooter => button(
        context.l10n.exchangeDeskChooseScooter,
        Icons.electric_scooter_rounded,
        _chooseScooter,
      ),
      CaseStep.sendOffer when exchange.holdLapsed => button(
        context.l10n.exchangeDeskChangeScooter,
        Icons.swap_horiz_rounded,
        _chooseScooter,
      ),
      CaseStep.sendOffer => button(
        context.l10n.exchangeDeskSendOffer,
        Icons.send_rounded,
        () => _run(() => ref.read(sendExchangeOfferProvider)(_id), context.l10n.exchangeDeskOfferSent),
      ),
      CaseStep.awaitRider => switch (exchange.pendingOffer) {
        final CaseOffer offer when !offer.hasExpired => button(
          context.l10n.exchangeDeskAcceptForRider,
          Icons.verified_rounded,
          () => _acceptForRider(offer),
        ),
        _ => button(context.l10n.exchangeDeskChangeScooter, Icons.swap_horiz_rounded, _chooseScooter),
      },
      CaseStep.settleDeposits => button(
        context.l10n.exchangeDeskSettleDeposits,
        Icons.savings_rounded,
        _settleDeposits,
      ),
      CaseStep.startHandover => button(
        context.l10n.exchangeDeskStartHandover,
        Icons.handshake_rounded,
        () => _run(() => ref.read(startExchangeHandoverProvider)(_id), context.l10n.exchangeDeskHandoverStarted),
      ),
      CaseStep.finishHandover => button(
        context.l10n.exchangeDeskComplete,
        Icons.task_alt_rounded,
        () => _run(() => ref.read(completeExchangeProvider)(_id), context.l10n.exchangeDeskExchangeCompleted),
      ),
      CaseStep.none => null,
    };
  }

  List<Widget> _stepContent(ExchangeCase exchange) {
    final List<Widget> content = switch (exchange.nextStep) {
      CaseStep.review || CaseStep.checkIn when exchange.status == CaseStatus.requested => [
        SecondaryButton(
          label: context.l10n.exchangeDeskReject,
          icon: Icons.close_rounded,
          color: AppColors.danger,
          onPressed: _busy ? null : _reject,
        ),
      ],
      CaseStep.sendOffer when !exchange.holdLapsed => [
        _QuotePreview(exchangeId: _id, reservedUntil: exchange.reservedUntil),
        const Gap.md(),
        GhostButton(
          label: context.l10n.exchangeDeskChangeScooter,
          icon: Icons.swap_horiz_rounded,
          onPressed: _busy ? null : _chooseScooter,
        ),
      ],
      CaseStep.awaitRider => [
        if (exchange.pendingOffer case final CaseOffer offer) ...[
          _OfferCard(offer: offer, onTerms: () => _showTerms(offer)),
          if (!offer.hasExpired) ...[
            const Gap.md(),
            Text(context.l10n.exchangeDeskAssistedHint, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
            const Gap.md(),
            SecondaryButton(
              label: context.l10n.exchangeDeskDeclineForRider,
              icon: Icons.close_rounded,
              color: AppColors.danger,
              onPressed: _busy ? null : () => _declineForRider(offer),
            ),
            const Gap.sm(),
            GhostButton(
              label: context.l10n.exchangeDeskChangeScooter,
              icon: Icons.swap_horiz_rounded,
              onPressed: _busy ? null : _chooseScooter,
            ),
          ],
        ],
      ],
      CaseStep.settleDeposits || CaseStep.startHandover => [
        if (exchange.acceptedOffer case final CaseOffer offer)
          ModuleCard(
            title: context.l10n.exchangeDeskAcceptedPlan,
            leading: const IconTile(icon: Icons.verified_rounded, tone: AppColors.success, solid: true, size: 28),
            child: CaseQuoteView(quote: offer.quote),
          ),
      ],
      CaseStep.finishHandover => [
        if (exchange.newAllocationId case final String allocationId)
          SecondaryButton(
            label: context.l10n.exchangeDeskOpenAllocation,
            icon: Icons.open_in_new_rounded,
            onPressed: _busy ? null : () => _openAllocation(allocationId),
          ),
      ],
      CaseStep.none when exchange.status == CaseStatus.completed => [
        ArtBlock(
          art: BrandArt.success,
          artSize: 120,
          title: context.l10n.exchangeDeskExchangeCompleted,
          message: context.l10n.exchangeDeskCompletedBody,
        ),
        if (exchange.newAllocationId case final String allocationId) ...[
          const Gap.lg(),
          SecondaryButton(
            label: context.l10n.exchangeDeskOpenAllocation,
            icon: Icons.open_in_new_rounded,
            onPressed: () => _openAllocation(allocationId),
          ),
        ],
      ],
      _ => const [],
    };
    return content.isEmpty ? const [] : [...content, const Gap.lg()];
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.exchange});

  final ExchangeCase exchange;

  @override
  Widget build(BuildContext context) {
    final String? scooter = exchange.oldScooter?.label;
    final bool completed = exchange.status == CaseStatus.completed;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkCircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => context.canPop() ? context.pop() : context.go(Routes.exchanges),
            ),
            const Spacer(),
            StatusChip(
              label: caseStatusLabel(context.l10n, exchange),
              tone: caseStatusTone(exchange),
              icon: completed
                  ? Icons.verified_rounded
                  : exchange.needsStaff
                  ? Icons.touch_app_rounded
                  : Icons.hourglass_top_rounded,
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Row(
          children: [
            AppAvatar(name: exchange.riderName, size: 60, showRing: completed),
            const SizedBox(width: Insets.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exchange.riderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 22, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    [caseReasonLabel(context.l10n, exchange.reasonCode), ?scooter].join(' · '),
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

class _CheckInSheet extends ConsumerStatefulWidget {
  const _CheckInSheet({required this.exchange});

  final ExchangeCase exchange;

  static Future<String?> show(BuildContext context, ExchangeCase exchange) => AppSheet.show<String>(
    context,
    title: context.l10n.exchangeDeskCheckIn,
    subtitle: exchange.riderName,
    child: _CheckInSheet(exchange: exchange),
  );

  @override
  ConsumerState<_CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends ConsumerState<_CheckInSheet> {
  String? _hubId;
  bool _starting = false;

  Future<void> _start(String? hubId) async {
    setState(() => _starting = true);
    final Result<String> result = await ref.read(startExchangeCheckInProvider)(
      StartCheckInParams(id: widget.exchange.id, hubId: hubId),
    );
    if (!mounted) return;
    setState(() => _starting = false);
    switch (result) {
      case Ok<String>(:final value):
        AppSnack.success(context, context.l10n.exchangeDeskCheckInStarted);
        Navigator.of(context).pop(value);
      case Err<String>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ExchangeCase exchange = widget.exchange;
    final List<HubProfile> hubs = ref.watch(fleetSessionProvider.select((session) => session.hubs));
    final String? planned = hubs.any((hub) => hub.id == exchange.plannedHubId) ? exchange.plannedHubId : null;
    final String? selected = _hubId ?? planned ?? hubs.firstOrNull?.id;
    final DateTime? date = exchange.plannedDate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (exchange.oldScooter case final ScooterOption scooter)
          KeyValueRow(
            label: context.l10n.exchangeCurrentScooter,
            value: scooter.label,
            icon: Icons.electric_scooter_rounded,
          ),
        KeyValueRow(
          label: context.l10n.exchangeReason,
          value: caseReasonLabel(context.l10n, exchange.reasonCode),
          icon: Icons.help_outline_rounded,
        ),
        if (date != null)
          KeyValueRow(label: context.l10n.submissionsDropOffDate, value: Fmt.date(date), icon: Icons.event_rounded),
        const Gap.md(),
        Text(context.l10n.submissionStartBodyExchange, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
        if (hubs.length > 1) ...[
          const Gap.lg(),
          GroupLabel(context.l10n.submissionReceivingHub),
          const Gap.sm(),
          for (final HubProfile hub in hubs) ...[
            AppRadioTile(
              selected: hub.id == selected,
              onTap: () => setState(() => _hubId = hub.id),
              title: hub.name,
              subtitle: hub.code,
            ),
            const Gap.sm(),
          ],
        ],
        const Gap.lg(),
        PrimaryButton(
          label: context.l10n.exchangeDeskCheckIn,
          icon: Icons.play_arrow_rounded,
          loading: _starting,
          onPressed: _starting ? null : () => _start(selected),
        ),
        const Gap.md(),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer, required this.onTerms});

  final CaseOffer offer;
  final VoidCallback onTerms;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.exchangeDeskStatusOfferSent,
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
                onPressed: onTerms,
              ),
            ),
        ],
      ),
    );
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
    final DateTime? planned = exchange.oldScooterReturned ? null : exchange.plannedDate;
    return ModuleCard(
      title: context.l10n.exchangeDetails,
      leading: const IconTile(icon: Icons.info_outline_rounded, solid: true, size: 28),
      child: Column(
        children: [
          KeyValueRow(label: context.l10n.allocationRider, value: exchange.riderName, icon: Icons.person_rounded),
          if (mobile != null)
            KeyValueRow(label: context.l10n.commonMobile, value: Fmt.phone(mobile), icon: Icons.call_rounded),
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
          if (planned != null)
            KeyValueRow(
              label: context.l10n.submissionsDropOffDate,
              value: Fmt.date(planned),
              icon: Icons.event_rounded,
            ),
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
