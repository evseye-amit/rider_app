import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/auto_pay_setup.dart';
import '../../domain/entities/payments_overview.dart';
import '../../domain/usecases/auto_pay_usecases.dart';
import '../../payments_dependencies.dart';
import '../providers/payments_provider.dart';
import '../widgets/payments_widgets.dart';

class PaymentsPage extends ConsumerWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PaymentsOverview> overview = ref.watch(paymentsOverviewProvider);

    if (overview.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.paymentsCouldNotLoad,
            message: overview.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(paymentsOverviewProvider),
          ),
        ),
      );
    }

    final PaymentsOverview? payments = overview.value;

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () async {
        ref
          ..invalidate(paymentHistoryProvider)
          ..invalidate(autoPaySetupProvider);
        await ref.refreshQuietly(paymentsOverviewProvider);
      },
      band: PaymentsBand(overview: payments),
      children: payments == null
          ? const [_PaymentsSkeleton()]
          : [
              if (payments.isSettled) const _AllClear() else _Breakdown(payments: payments),
              const Gap.lg(),
              _DamageChargesTile(count: payments.damageCount, amount: payments.damageDue),
              const Gap.lg(),
              _AutoPayCard(payments: payments),
              const Gap.lg(),
              const _History(),
            ],
    );
  }
}

class _AllClear extends StatelessWidget {
  const _AllClear();

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Row(
        children: [
          const IconTile(icon: Icons.check_circle_rounded, tone: AppColors.success, size: 40),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.paymentsAllClear, style: AppText.titleSmall.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  context.l10n.paymentsAllClearMessage,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.payments});

  final PaymentsOverview payments;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    return ModuleCard(
      title: l10n.paymentsBreakdown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyValueRow(label: l10n.paymentRentAndFees, value: Fmt.money(payments.rentDue), dense: true),
          if (payments.damageDue > 0)
            KeyValueRow(
              label: l10n.damageChargesTitle,
              value: Fmt.money(payments.damageDue),
              valueColor: AppColors.danger,
              dense: true,
            ),
          if (payments.isOverdue)
            KeyValueRow(
              label: l10n.paymentsOverdue,
              value: Fmt.money(payments.rentOverdue),
              valueColor: AppColors.danger,
              dense: true,
            ),
          const Gap.sm(),
          Text(
            l10n.paymentsPayAtHub,
            style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _DamageChargesTile extends StatelessWidget {
  const _DamageChargesTile({required this.count, required this.amount});

  final int count;
  final num amount;

  @override
  Widget build(BuildContext context) {
    final bool unpaid = count > 0;
    return Pressable(
      onTap: () => context.push(Routes.damageCharges),
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.card),
        child: Row(
          children: [
            IconTile(icon: Icons.car_crash_rounded, tone: unpaid ? AppColors.danger : AppColors.textMuted, size: 40),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.damageChargesTitle, style: AppText.titleSmall.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    unpaid ? context.l10n.damageChargesToPay(count) : context.l10n.damageChargesNoUnpaid,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5),
                  ),
                ],
              ),
            ),
            if (unpaid) ...[
              Text(Fmt.money(amount), style: AppText.numericSmall.copyWith(fontSize: 14, color: AppColors.danger)),
              const SizedBox(width: Insets.xs),
            ],
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _AutoPayCard extends ConsumerStatefulWidget {
  const _AutoPayCard({required this.payments});

  final PaymentsOverview payments;

  @override
  ConsumerState<_AutoPayCard> createState() => _AutoPayCardState();
}

class _AutoPayCardState extends ConsumerState<_AutoPayCard> with WidgetsBindingObserver {
  bool _busy = false;
  String? _returningFrom;
  bool _leftApp = false;

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
    ..invalidate(paymentsOverviewProvider);

  Future<void> _setUp(AutoPaySetup setup) async {
    final String? email = await _AutoPaySetupSheet.show(context, maxAmount: setup.maxAmount);
    if (email == null || !mounted) return;
    setState(() => _busy = true);
    final Result<AutoPayMandate> result = await ref.read(setUpAutoPayProvider)(
      SetUpAutoPayParams(email: email, idempotencyKey: newIdempotencyKey()),
    );
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
  }) async {
    setState(() => _busy = true);
    final Result<AutoPayMandate> result = await action();
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
    await _change(
      () => ref.read(cancelAutoPayProvider)(
        AutoPayActionParams(mandateId: mandate.id, idempotencyKey: newIdempotencyKey()),
      ),
      success: (updated) =>
          updated.cancellationPending ? l10n.paymentsAutoPayCancelPending : l10n.paymentsAutoPayCancelled,
    );
  }

  Future<void> _pause(AutoPayMandate mandate, {required bool pause}) => _change(
    () => ref.read(pauseAutoPayProvider)(
      PauseAutoPayParams(mandateId: mandate.id, pause: pause, idempotencyKey: newIdempotencyKey()),
    ),
    success: (_) => context.l10n.paymentsAutoPayUpdated,
  );

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

class _History extends ConsumerWidget {
  const _History();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PaymentRecord>> history = ref.watch(paymentHistoryProvider);
    final List<PaymentRecord> records = history.value ?? const [];

    return ModuleCard(
      title: context.l10n.paymentsHistory,
      child: history.isLoading && !history.hasValue
          ? const ShimmerBox(height: 120, borderRadius: Corners.brLg)
          : records.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.paymentsNoPayments, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(
                  context.l10n.paymentsNoPaymentsMessage,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.textMuted),
                ),
              ],
            )
          : Column(
              children: [
                for (final PaymentRecord record in records) ...[
                  PaymentRecordTile(record: record),
                  if (record != records.last) Divider(color: AppColors.stroke.withValues(alpha: 0.5), height: 1),
                ],
              ],
            ),
    );
  }
}

class _PaymentsSkeleton extends StatelessWidget {
  const _PaymentsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 120, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 72, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 140, borderRadius: Corners.brXl),
      ],
    );
  }
}
