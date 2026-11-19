import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/auto_pay_setup.dart';
import '../../domain/entities/payments_overview.dart';
import '../../domain/usecases/auto_pay_usecases.dart';
import '../../payments_dependencies.dart';
import '../providers/payments_provider.dart';
import 'payments_widgets.dart';

class AutoPayCard extends ConsumerStatefulWidget {
  const AutoPayCard({required this.payments, super.key});

  final PaymentsOverview payments;

  @override
  ConsumerState<AutoPayCard> createState() => _AutoPayCardState();
}

class _AutoPayCardState extends ConsumerState<AutoPayCard> with WidgetsBindingObserver {
  bool _busy = false;
  String? _returningFrom;
  bool _leftApp = false;
  final Map<String, String> _keys = {};

  String _key(String action) => _keys[action] ??= newIdempotencyKey();

  void _release(String action, Result<AutoPayMandate> result) {
    if (result case Err<AutoPayMandate>(:final failure)
        when failure is NetworkFailure || (failure is ServerFailure && (failure.status ?? 500) >= 500)) {
      return;
    }
    _keys.remove(action);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final String? mandateId = _returningFrom;
    if (mandateId == null) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) _leftApp = true;
    if (state == AppLifecycleState.resumed && _leftApp) {
      _returningFrom = null;
      _leftApp = false;
      unawaited(_verify(mandateId));
    }
  }

  void _refresh() => ref
    ..invalidate(autoPaySetupProvider)
    ..invalidate(paymentsOverviewProvider)
    ..invalidate(upcomingDebitsProvider)
    ..invalidate(autoPayDebitsProvider);

  Future<void> _setUp(AutoPaySetup setup) async {
    final String? email = await _AutoPaySetupSheet.show(context, maxAmount: setup.maxAmount);
    if (email == null || !mounted) return;
    setState(() => _busy = true);
    final Result<AutoPayMandate> result = await ref.read(setUpAutoPayProvider)(
      SetUpAutoPayParams(email: email, idempotencyKey: _key('setup')),
    );
    _release('setup', result);
    if (!mounted) return;
    setState(() => _busy = false);
    _refresh();
    switch (result) {
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.active)):
        AppSnack.success(context, context.l10n.paymentsAutoPayTurnedOn);
      case Ok<AutoPayMandate>(:final value):
        await _openApproval(value);
      case Err<AutoPayMandate>(failure: ServerFailure(status: 503)):
        AppSnack.error(context, context.l10n.paymentsAutoPayUnavailable);
      case Err<AutoPayMandate>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _openApproval(AutoPayMandate mandate) async {
    final Uri? uri = Uri.tryParse(mandate.approvalUrl ?? '');
    _returningFrom = mandate.id;
    _leftApp = false;
    final bool opened =
        uri != null &&
        uri.hasScheme &&
        await launchUrl(uri, mode: LaunchMode.externalApplication).catchError((Object _) => false);
    if (opened || !mounted) return;
    _returningFrom = null;
    AppSnack.error(context, context.l10n.paymentsAutoPayOpenFailed);
  }

  Future<void> _verify(String mandateId) async {
    setState(() => _busy = true);
    final Result<AutoPayMandate> result = await ref.read(verifyAutoPayProvider)(mandateId);
    if (!mounted) return;
    setState(() => _busy = false);
    _refresh();
    final AppL10n l10n = context.l10n;
    switch (result) {
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.closed)):
        AppSnack.error(context, l10n.paymentsAutoPaySetupFailed);
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.awaitingApproval)):
        AppSnack.info(context, l10n.paymentsAutoPayStillWaiting);
      case Ok<AutoPayMandate>():
        AppSnack.success(context, l10n.paymentsAutoPayTurnedOn);
      case Err<AutoPayMandate>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _change(
    Future<Result<AutoPayMandate>> Function() action, {
    required String Function(AutoPayMandate mandate) success,
    String? keyName,
  }) async {
    setState(() => _busy = true);
    final Result<AutoPayMandate> result = await action();
    if (keyName != null) _release(keyName, result);
    if (!mounted) return;
    setState(() => _busy = false);
    _refresh();
    switch (result) {
      case Ok<AutoPayMandate>(:final value):
        AppSnack.success(context, success(value));
      case Err<AutoPayMandate>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _cancel(AutoPayMandate mandate) async {
    final AppL10n l10n = context.l10n;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: l10n.paymentsAutoPayCancelTitle,
      message: l10n.paymentsAutoPayCancelMessage,
      confirmLabel: l10n.paymentsAutoPayCancel,
      cancelLabel: l10n.paymentsAutoPayKeep,
      icon: Icons.event_busy_rounded,
      tone: AppColors.danger,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    final String keyName = 'cancel:${mandate.id}';
    await _change(
      () => ref.read(cancelAutoPayProvider)(AutoPayActionParams(mandateId: mandate.id, idempotencyKey: _key(keyName))),
      success: (updated) =>
          updated.cancellationPending ? l10n.paymentsAutoPayCancelPending : l10n.paymentsAutoPayCancelled,
      keyName: keyName,
    );
  }

  Future<void> _pause(AutoPayMandate mandate, {required bool pause}) {
    final String keyName = '${pause ? 'pause' : 'resume'}:${mandate.id}';
    return _change(
      () => ref.read(pauseAutoPayProvider)(
        PauseAutoPayParams(mandateId: mandate.id, pause: pause, idempotencyKey: _key(keyName)),
      ),
      success: (_) => context.l10n.paymentsAutoPayUpdated,
      keyName: keyName,
    );
  }

  Future<void> _toggle(AutoPayMandate mandate) => _change(
    () => ref.read(setAutoDebitProvider)(!mandate.autoDebitOn),
    success: (_) => context.l10n.paymentsAutoPayUpdated,
  );

  List<Widget> _actions(AppL10n l10n, AutoPayMandate mandate) {
    VoidCallback? guard(VoidCallback action) => _busy ? null : action;
    final List<Widget> items = switch (mandate.state) {
      AutoPayMandateState.awaitingApproval => [
        if (mandate.approvalUrl != null)
          PrimaryButton(
            label: l10n.paymentsAutoPayFinishSetup,
            icon: Icons.open_in_new_rounded,
            loading: _busy,
            onPressed: guard(() => _openApproval(mandate)),
          ),
        GhostButton(
          label: l10n.paymentsAutoPayCheckStatus,
          icon: Icons.refresh_rounded,
          onPressed: guard(() => _verify(mandate.id)),
        ),
      ],
      AutoPayMandateState.active || AutoPayMandateState.paused when mandate.cancellationPending => [
        _AutoPayNote(text: l10n.paymentsAutoPayCancelPending, icon: Icons.hourglass_top_rounded),
      ],
      AutoPayMandateState.active => [
        if (!mandate.autoDebitOn) _AutoPayNote(text: l10n.paymentsAutoPayOffNote, icon: Icons.info_outline_rounded),
        if (mandate.canTurnOff)
          SecondaryButton(
            label: mandate.autoDebitOn ? l10n.paymentsAutoPayTurnOff : l10n.paymentsAutoPayTurnOn,
            icon: mandate.autoDebitOn ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
            onPressed: guard(() => _toggle(mandate)),
          ),
        if (mandate.canPause)
          GhostButton(
            label: l10n.paymentsAutoPayPause,
            icon: Icons.pause_rounded,
            onPressed: guard(() => _pause(mandate, pause: true)),
          ),
        if (mandate.canCancel)
          GhostButton(
            label: l10n.paymentsAutoPayCancel,
            icon: Icons.close_rounded,
            color: AppColors.danger,
            onPressed: guard(() => _cancel(mandate)),
          ),
        if (mandate.managedInUpiApp)
          _AutoPayNote(text: l10n.paymentsAutoPayManageInUpiApp, icon: Icons.smartphone_rounded),
      ],
      AutoPayMandateState.paused => [
        if (mandate.canResume)
          SecondaryButton(
            label: l10n.paymentsAutoPayResume,
            icon: Icons.play_arrow_rounded,
            onPressed: guard(() => _pause(mandate, pause: false)),
          ),
        if (mandate.canCancel)
          GhostButton(
            label: l10n.paymentsAutoPayCancel,
            icon: Icons.close_rounded,
            color: AppColors.danger,
            onPressed: guard(() => _cancel(mandate)),
          ),
      ],
      AutoPayMandateState.closed => const [],
    };
    return [
      for (final (int i, Widget item) in items.indexed) ...[if (i > 0) const Gap.sm(), item],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final PaymentsOverview payments = widget.payments;
    final AutoPaySetup? setup = ref.watch(autoPaySetupProvider).value;
    final AutoPayMandate? mandate = setup?.mandate;
    final List<Widget> actions = mandate == null || mandate.state == AutoPayMandateState.closed
        ? const []
        : _actions(l10n, mandate);
    final String? method = payments.paymentMethod;
    final num? limit = payments.mandateMaxAmount;
    final DateTime? next = payments.nextAutoPayDate;
    final DateTime? expires = payments.mandateExpiresAt;
    final bool hasDetails = method != null || limit != null || next != null || expires != null;
    final bool hasMandate = mandate != null;
    final List<AutoPayDebit> upcoming = hasMandate ? ref.watch(upcomingDebitsProvider).value ?? const [] : const [];
    final List<AutoPayDebit> recent = hasMandate
        ? [...?ref.watch(autoPayDebitsProvider).value?.where((debit) => debit.state != AutoPayDebitState.pending)]
        : const [];

    return ModuleCard(
      title: l10n.paymentsAutoPay,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(
              label: autoPayLabel(l10n, payments.autoPay),
              tone: autoPayTone(payments.autoPay),
              dense: true,
            ),
          ),
          if (hasDetails) const Gap.sm(),
          if (method != null) KeyValueRow(label: l10n.paymentsMethod, value: method, dense: true),
          if (limit != null) KeyValueRow(label: l10n.paymentsMandateLimit, value: Fmt.money(limit), dense: true),
          if (next != null) KeyValueRow(label: l10n.paymentsNextDebit, value: Fmt.dateTime(next), dense: true),
          if (expires != null) KeyValueRow(label: l10n.paymentsMandateExpires, value: Fmt.date(expires), dense: true),
          if (upcoming.isNotEmpty) ...[
            const Gap.md(),
            GroupLabel(l10n.paymentsUpcomingDebits),
            for (final AutoPayDebit debit in upcoming.take(3)) _DebitRow(debit: debit),
          ],
          if (recent.isNotEmpty) ...[
            const Gap.md(),
            GroupLabel(l10n.paymentsRecentDebits),
            for (final AutoPayDebit debit in recent.take(5)) _DebitRow(debit: debit),
          ],
          if (actions.isNotEmpty) ...[
            const Gap.md(),
            ...actions,
          ] else if (setup case final AutoPaySetup available when available.canSetUp) ...[
            const Gap.md(),
            PrimaryButton(
              label: l10n.paymentsAutoPaySetUp,
              icon: Icons.autorenew_rounded,
              loading: _busy,
              onPressed: _busy ? null : () => _setUp(available),
            ),
          ] else if (payments.autoPayNeedsAttention) ...[
            const Gap.sm(),
            _AutoPayNote(text: l10n.paymentsAutoPayAttention, icon: Icons.info_outline_rounded),
          ],
        ],
      ),
    );
  }
}

class _DebitRow extends StatelessWidget {
  const _DebitRow({required this.debit});

  final AutoPayDebit debit;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? scheduled = debit.scheduledFor;
    final String detail = [?debit.invoiceNumber, if (scheduled != null) Fmt.dateTime(scheduled)].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.money(debit.amount, paise: true), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                    if (detail.isNotEmpty)
                      Text(detail, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
                  ],
                ),
              ),
              StatusChip(
                label: switch (debit.state) {
                  AutoPayDebitState.pending => l10n.walletStatePending,
                  AutoPayDebitState.settled => l10n.walletStateSettled,
                  AutoPayDebitState.failed => l10n.walletStateFailed,
                },
                tone: switch (debit.state) {
                  AutoPayDebitState.pending => StatusTone.warning,
                  AutoPayDebitState.settled => StatusTone.success,
                  AutoPayDebitState.failed => StatusTone.danger,
                },
                dense: true,
              ),
            ],
          ),
          if (debit.amountMayChange)
            Text(l10n.paymentsAmountMayChange, style: AppText.bodySmall.copyWith(fontSize: 11.5, height: 1.4)),
        ],
      ),
    );
  }
}

class _AutoPayNote extends StatelessWidget {
  const _AutoPayNote({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.warning),
        const SizedBox(width: Insets.sm),
        Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
      ],
    );
  }
}

class _AutoPaySetupSheet extends StatefulWidget {
  const _AutoPaySetupSheet({required this.maxAmount});

  final num maxAmount;

  static Future<String?> show(BuildContext context, {required num maxAmount}) => AppSheet.show<String>(
    context,
    title: context.l10n.paymentsAutoPaySetUp,
    child: _AutoPaySetupSheet(maxAmount: maxAmount),
  );

  @override
  State<_AutoPaySetupSheet> createState() => _AutoPaySetupSheetState();
}

class _AutoPaySetupSheetState extends State<_AutoPaySetupSheet> {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  final TextEditingController _email = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _continue() {
    final String email = _email.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _error = context.l10n.paymentsAutoPayEmailInvalid);
      return;
    }
    Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.paymentsAutoPaySetupMessage(Fmt.money(widget.maxAmount)),
            style: AppText.bodyMedium.copyWith(height: 1.55),
          ),
          const Gap.lg(),
          AppTextField(
            label: l10n.paymentsAutoPayEmail,
            hint: 'name@example.com',
            helper: l10n.paymentsAutoPayEmailHelp,
            controller: _email,
            errorText: _error,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
            onChanged: (_) => setState(() => _error = null),
            onSubmitted: (_) => _continue(),
          ),
          const Gap.lg(),
          PrimaryButton(label: l10n.paymentsAutoPayContinue, icon: Icons.open_in_new_rounded, onPressed: _continue),
          const Gap.md(),
        ],
      ),
    );
  }
}
