import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/auto_pay.dart';
import '../../domain/usecases/auto_pay_usecases.dart';
import '../../payments_dependencies.dart';
import '../providers/auto_pay_provider.dart';

mixin AutoPayEnrollment<T extends ConsumerStatefulWidget> on ConsumerState<T>, WidgetsBindingObserver {
  final Map<String, String> _keys = {};
  String? _returningFrom;
  bool _leftApp = false;
  int? _consented;
  bool autoPayBusy = false;

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
      unawaited(verifyAutoPay(mandateId));
    }
  }

  static bool _retryable(Result<AutoPayMandate> result) => switch (result) {
    Err<AutoPayMandate>(:final failure) =>
      failure is NetworkFailure || (failure is ServerFailure && (failure.status ?? 500) >= 500),
    Ok<AutoPayMandate>() => false,
  };

  void _busy(bool value) {
    if (mounted) setState(() => autoPayBusy = value);
  }

  void _settle() {
    _busy(false);
    ref.invalidate(autoPayProvider);
  }

  Future<void> setUpAutoPay(AutoPay autoPay, String email) async {
    final AppL10n l10n = context.l10n;
    _consented = autoPay.policyRevision;
    _busy(true);
    final Result<AutoPayMandate> result = await ref.read(setUpAutoPayProvider)(
      SetUpAutoPayParams(email: email, idempotencyKey: _keys['setup'] ??= newIdempotencyKey()),
    );
    if (!_retryable(result)) _keys.remove('setup');
    if (!mounted) return;
    switch (result) {
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.active)):
        await _activate();
      case Ok<AutoPayMandate>(:final value) when value.state == AutoPayMandateState.awaitingApproval:
        _settle();
        await openAutoPayApproval(value);
      case Ok<AutoPayMandate>():
        _settle();
        AppSnack.error(context, l10n.paymentsAutoPaySetupFailed);
      case Err<AutoPayMandate>(failure: ServerFailure(status: 503)):
        _settle();
        AppSnack.error(context, l10n.paymentsAutoPayUnavailable);
      case Err<AutoPayMandate>(:final failure):
        _settle();
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> openAutoPayApproval(AutoPayMandate mandate) async {
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

  Future<void> verifyAutoPay(String mandateId) async {
    final AppL10n l10n = context.l10n;
    _busy(true);
    final Result<AutoPayMandate> result = await ref.read(verifyAutoPayProvider)(mandateId);
    if (!mounted) return;
    switch (result) {
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.active)):
        await _activate();
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.awaitingApproval)):
        _settle();
        AppSnack.info(context, l10n.paymentsAutoPayStillWaiting);
      case Ok<AutoPayMandate>(value: AutoPayMandate(state: AutoPayMandateState.closed)):
        _settle();
        AppSnack.error(context, l10n.paymentsAutoPaySetupFailed);
      case Ok<AutoPayMandate>():
        _settle();
      case Err<AutoPayMandate>(:final failure):
        _settle();
        AppSnack.error(context, failure.message);
    }
  }

  Future<void> _activate() async {
    final AppL10n l10n = context.l10n;
    final AutoPay? fresh = await ref.refresh(autoPayProvider.future).catchError((Object _) => null);
    if (!mounted) return;
    if (fresh != null && fresh.canTurnOn && fresh.policyRevision == _consented) {
      await turnOnAutoPay(fresh);
      return;
    }
    _busy(false);
    if (fresh != null && fresh.isOn) AppSnack.success(context, l10n.walletAutoPayTurnedOn);
  }

  Future<void> turnOnAutoPay(AutoPay autoPay) async {
    final AutoPayMandate? mandate = autoPay.mandate;
    if (mandate == null) return;
    final AppL10n l10n = context.l10n;
    _busy(true);
    final Result<AutoPay> result = await ref
        .read(autoPayProvider.notifier)
        .turnOn(mandateId: mandate.id, revision: autoPay.revision, consentRevision: autoPay.policyRevision);
    if (!mounted) return;
    _busy(false);
    switch (result) {
      case Ok<AutoPay>():
        _consented = null;
        AppSnack.success(context, l10n.walletAutoPayTurnedOn);
      case Err<AutoPay>(:final failure):
        ref.invalidate(autoPayProvider);
        AppSnack.error(context, failure.message);
    }
  }
}
