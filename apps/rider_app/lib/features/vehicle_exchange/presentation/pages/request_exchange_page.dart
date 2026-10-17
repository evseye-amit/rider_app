import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/check_in/submission_hubs.dart';
import '../../domain/entities/exchange_request.dart';
import '../../domain/entities/rental_agreement.dart';
import '../../domain/usecases/request_exchange.dart';
import '../../exchange_dependencies.dart';
import '../providers/exchange_provider.dart';
import '../widgets/exchange_widgets.dart';

class RequestExchangePage extends ConsumerStatefulWidget {
  const RequestExchangePage({super.key});

  @override
  ConsumerState<RequestExchangePage> createState() => _RequestExchangePageState();
}

class _RequestExchangePageState extends ConsumerState<RequestExchangePage> {
  static const int _maxDaysAhead = 60;

  final TextEditingController _note = TextEditingController();
  ExchangeReason? _reason;
  DateTime? _date;
  SubmissionHub? _hub;
  bool _sending = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  DateTime get _today {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await AppDateWheel.show(
      context,
      first: _today,
      last: _today.add(const Duration(days: _maxDaysAhead)),
      initial: _date ?? _today,
      title: context.l10n.returnsPickDate,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickHub(SubmissionHub? current) async {
    final SubmissionHub? picked = await SubmissionHubPicker.show(context, selectedId: current?.id);
    if (picked != null) setState(() => _hub = picked);
  }

  Future<void> _send(RentalAgreement agreement, SubmissionHub? hub) async {
    final ExchangeReason? reason = _reason;
    final DateTime? date = _date;
    if (reason == null || date == null || _sending) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _sending = true);
    final Result<ExchangeRequest> result = await ref.read(requestExchangeProvider)(
      RequestExchangeParams(
        agreementId: agreement.id,
        reasonCode: reason.code,
        plannedDate: date,
        hubId: hub?.id,
        reason: _note.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _sending = false);

    switch (result) {
      case Ok<ExchangeRequest>(:final value):
        ref.invalidate(exchangesProvider);
        AppSnack.success(context, context.l10n.exchangeRequestSent);
        context.pushReplacement('${Routes.vehicleExchangeDetail}?id=${value.id}');
      case Err<ExchangeRequest>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RentalAgreement?> agreement = ref.watch(activeAgreementProvider);
    final RentalAgreement? active = agreement.value;
    final SubmissionHub? hub = _hub ?? ref.watch(submissionChoicesProvider(null)).value?.defaultHub;
    final DateTime? date = _date;

    return AppScaffold(
      title: context.l10n.exchangeRequestAction,
      subtitle: context.l10n.exchangeRequestSubtitle,
      footer: active == null
          ? null
          : PrimaryButton(
              label: context.l10n.exchangeSendRequest,
              icon: Icons.send_rounded,
              loading: _sending,
              onPressed: _reason == null || date == null || _sending ? null : () => _send(active, hub),
            ),
      body: switch (agreement) {
        AsyncValue(hasValue: false, hasError: true) => EmptyState(
          title: context.l10n.exchangeRentalCouldNotLoad,
          message: agreement.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(activeAgreementProvider),
        ),
        AsyncValue(hasValue: false) => const PageBody(
          children: [
            ShimmerBox(height: 96, borderRadius: Corners.brLg),
            Gap.lg(),
            ShimmerBox(height: 260, borderRadius: Corners.brLg),
          ],
        ),
        _ when active == null => EmptyState(
          title: context.l10n.exchangeNoRentalTitle,
          message: context.l10n.exchangeNoRentalBody,
          icon: Icons.electric_scooter_rounded,
        ),
        _ => PageBody(
          children: [
            _CurrentScooterCard(agreement: active),
            const Gap.xl(),
            SectionHeader(title: context.l10n.exchangeChooseReason),
            const Gap.lg(),
            for (final ExchangeReason reason in ExchangeReason.values) ...[
              AppRadioTile(
                selected: _reason == reason,
                onTap: () => setState(() => _reason = reason),
                title: exchangeReasonLabel(context.l10n, reason.code),
                subtitle: exchangeReasonHint(context.l10n, reason),
                leading: Icon(exchangeReasonIcon(reason), color: AppColors.primary, size: 22),
              ),
              const Gap.sm(),
            ],
            const Gap.xl(),
            SectionHeader(title: context.l10n.exchangeWhenWhere, subtitle: context.l10n.exchangeWhenWhereHint),
            const Gap.lg(),
            AppPickerField(
              label: context.l10n.exchangeReturnDate,
              required: true,
              value: date == null ? null : Fmt.date(date),
              hint: context.l10n.returnsPickDate,
              prefixIcon: Icons.calendar_today_rounded,
              onTap: _pickDate,
            ),
            const Gap.lg(),
            AppPickerField(
              label: context.l10n.returnsHub,
              value: hub?.name,
              hint: context.l10n.returnsPickHub,
              prefixIcon: Icons.store_rounded,
              helper: hub == null || hub.address.isEmpty ? null : hub.address,
              onTap: () => _pickHub(hub),
            ),
            const Gap.xl(),
            AppTextField(
              controller: _note,
              label: context.l10n.exchangeNoteLabel,
              hint: context.l10n.exchangeNoteHint,
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      },
    );
  }
}

class _CurrentScooterCard extends StatelessWidget {
  const _CurrentScooterCard({required this.agreement});

  final RentalAgreement agreement;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: context.l10n.exchangeCurrentScooter,
      leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
      child: Column(
        children: [
          if (agreement.scooterName case final String scooter)
            KeyValueRow(label: context.l10n.commonVehicle, value: scooter, icon: Icons.two_wheeler_rounded),
          KeyValueRow(
            label: context.l10n.homeRent,
            value: rentWithPeriod(context.l10n, agreement.rent, agreement.period),
            icon: Icons.receipt_long_rounded,
          ),
          KeyValueRow(
            label: context.l10n.onboardingStepAgreement,
            value: agreement.number,
            icon: Icons.description_rounded,
          ),
        ],
      ),
    );
  }
}
