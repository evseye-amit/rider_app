import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/entities/auto_pay.dart';
import '../providers/auto_pay_provider.dart';
import 'auto_pay_enrollment.dart';

String _termsText(AppL10n l10n, AutoPay autoPay) => l10n.walletAutoPayConsent(
  Fmt.money(autoPay.rechargeAmount),
  Fmt.money(autoPay.threshold),
  Fmt.number(autoPay.leadHours),
  Fmt.number(autoPay.cooldownHours),
);

String _stateLabel(AppL10n l10n, AutoPayState state) => switch (state) {
  AutoPayState.active => l10n.paymentsAutoPayActive,
  AutoPayState.waitingForAllocation => l10n.paymentsAutoPayWaitingVehicle,
  AutoPayState.off => l10n.walletAutoPayOff,
  AutoPayState.setupRequired => l10n.paymentsAutoPayNotEnabled,
  AutoPayState.authorizationPending => l10n.paymentsAutoPayAuthPending,
  AutoPayState.activationPending => l10n.paymentsAutoPayActivating,
  AutoPayState.mandateActionRequired => l10n.paymentsAutoPaySetupRequired,
  AutoPayState.actionRequired => l10n.paymentsAutoPayFailed,
  AutoPayState.pausedByClient => l10n.paymentsAutoPayPaused,
  AutoPayState.migrationBlocked || AutoPayState.unknown => l10n.walletAutoPayStatusReview,
};

StatusTone _stateTone(AutoPayState state) => switch (state) {
  AutoPayState.active => StatusTone.success,
  AutoPayState.waitingForAllocation || AutoPayState.activationPending => StatusTone.info,
  AutoPayState.off || AutoPayState.setupRequired || AutoPayState.pausedByClient => StatusTone.neutral,
  AutoPayState.actionRequired => StatusTone.danger,
  AutoPayState.authorizationPending ||
  AutoPayState.mandateActionRequired ||
  AutoPayState.migrationBlocked ||
  AutoPayState.unknown => StatusTone.warning,
};

String? _stateNote(AppL10n l10n, AutoPay autoPay) => switch (autoPay.state) {
  _ when autoPay.mandate?.cancellationPending ?? false => l10n.paymentsAutoPayCancelPending,
  AutoPayState.pausedByClient => l10n.walletAutoPayPolicyOff,
  AutoPayState.activationPending => l10n.paymentsAutoPayActivatingNote,
  AutoPayState.actionRequired => l10n.paymentsAutoPayAttention,
  AutoPayState.off when autoPay.mandate?.state == AutoPayMandateState.active => l10n.paymentsAutoPayAttention,
  AutoPayState.migrationBlocked => l10n.paymentsAutoPayMigrationBlocked,
  AutoPayState.mandateActionRequired when !autoPay.canSetUp => l10n.paymentsAutoPayAttention,
  _ => null,
};

String _rechargeLabel(AppL10n l10n, AutoRechargeState state) => switch (state) {
  AutoRechargeState.creating => l10n.walletAutoPayStatusPreparing,
  AutoRechargeState.pending => l10n.walletAutoPayStatusPending,
  AutoRechargeState.unknown => l10n.walletAutoPayStatusConfirming,
  AutoRechargeState.review => l10n.walletAutoPayStatusReview,
  AutoRechargeState.success => l10n.walletAutoPayStatusAdded,
  AutoRechargeState.failed => l10n.walletStateFailed,
  AutoRechargeState.cancelled => l10n.walletAutoPayStatusStopped,
};

StatusTone _rechargeTone(AutoRechargeState state) => switch (state) {
  AutoRechargeState.success => StatusTone.success,
  AutoRechargeState.failed => StatusTone.danger,
  AutoRechargeState.cancelled => StatusTone.neutral,
  _ => StatusTone.warning,
};

class AutoPayCard extends ConsumerStatefulWidget {
  const AutoPayCard({this.spacing = 0, super.key});

  final double spacing;

  @override
  ConsumerState<AutoPayCard> createState() => _AutoPayCardState();
}

class _AutoPayCardState extends ConsumerState<AutoPayCard> with WidgetsBindingObserver, AutoPayEnrollment<AutoPayCard> {
  Future<void> _setUp(AutoPay autoPay) async {
    final String? email = await _AutoPaySetupSheet.show(context, autoPay: autoPay);
    if (email == null || !mounted) return;
    await setUpAutoPay(email);
  }

  List<Widget> _actions(AppL10n l10n, AutoPay autoPay) {
    final AutoPayMandate? mandate = autoPay.mandate;
    VoidCallback? guard(VoidCallback action) => autoPayBusy ? null : action;
    final List<Widget> items = [
      if (autoPay.awaitingApproval && mandate != null) ...[
        if (mandate.approvalUrl != null)
          PrimaryButton(
            label: l10n.paymentsAutoPayFinishSetup,
            icon: Icons.open_in_new_rounded,
            loading: autoPayBusy,
            onPressed: guard(() => openAutoPayApproval(mandate)),
          ),
        GhostButton(
          label: l10n.paymentsAutoPayCheckStatus,
          icon: Icons.refresh_rounded,
          onPressed: guard(() => verifyAutoPay(mandate.id)),
        ),
      ] else if (autoPay.activating && mandate != null)
        GhostButton(
          label: l10n.paymentsAutoPayCheckStatus,
          icon: Icons.refresh_rounded,
          onPressed: guard(() => verifyAutoPay(mandate.id)),
        )
      else if (autoPay.canSetUp)
        PrimaryButton(
          label: l10n.paymentsAutoPaySetUp,
          icon: Icons.autorenew_rounded,
          loading: autoPayBusy,
          onPressed: guard(() => _setUp(autoPay)),
        ),
    ];
    return [
      for (final (int i, Widget item) in items.indexed) ...[if (i == 0) const Gap.md() else const Gap.sm(), item],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AutoPay? autoPay = ref.watch(autoPayProvider).value;
    if (autoPay == null || !autoPay.isVisible) return const SizedBox.shrink();
    final AutoPayMandate? mandate = switch (autoPay.mandate) {
      final AutoPayMandate value when value.state != AutoPayMandateState.closed => value,
      _ => null,
    };
    final DateTime? expires = mandate?.expiresAt;
    final String? note = _stateNote(l10n, autoPay);

    final Widget card = ModuleCard(
      title: l10n.walletAutoPayTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: StatusChip(label: _stateLabel(l10n, autoPay.state), tone: _stateTone(autoPay.state), dense: true),
          ),
          const Gap.sm(),
          Text(
            l10n.walletAutoPaySummary(Fmt.money(autoPay.rechargeAmount), Fmt.money(autoPay.threshold)),
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
          if (mandate != null) const Gap.sm(),
          if (mandate != null && mandate.maxAmount > 0)
            KeyValueRow(label: l10n.paymentsMandateLimit, value: Fmt.money(mandate.maxAmount), dense: true),
          if (expires != null) KeyValueRow(label: l10n.paymentsMandateExpires, value: Fmt.date(expires), dense: true),
          if (note != null) ...[const Gap.md(), _AutoPayNote(text: note)],
          if (autoPay.requests.isNotEmpty) ...[
            const Gap.md(),
            GroupLabel(l10n.walletAutoPayRecent),
            for (final AutoRecharge request in autoPay.requests.take(3)) _RechargeRow(request: request),
          ],
          ..._actions(l10n, autoPay),
        ],
      ),
    );
    return widget.spacing == 0
        ? card
        : Padding(
            padding: EdgeInsets.only(top: widget.spacing),
            child: card,
          );
  }
}

class AutoPayTerms extends StatelessWidget {
  const AutoPayTerms({required this.autoPay, super.key});

  final AutoPay autoPay;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final num? limit = autoPay.setupLimit;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_termsText(l10n, autoPay), style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5)),
        const Gap.sm(),
        Text(
          l10n.walletAutoPayCashOnly,
          style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
        ),
        const Gap.xs(),
        Text(
          l10n.walletAutoPayVariableTerms,
          style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
        ),
        if (limit != null && limit > 0) ...[
          const Gap.md(),
          KeyValueRow(label: l10n.paymentsMandateLimit, value: Fmt.money(limit), dense: true),
        ],
      ],
    );
  }
}

class _RechargeRow extends StatelessWidget {
  const _RechargeRow({required this.request});

  final AutoRecharge request;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final DateTime? scheduled = request.scheduledAt;
    final DateTime? stamp = request.completedAt ?? request.createdAt;
    final String? when = request.state.isAwaitingBank && scheduled != null
        ? l10n.walletAutoPayEarliestDebit(Fmt.dateTime(scheduled))
        : stamp == null
        ? null
        : Fmt.dateTime(stamp);
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Fmt.money(request.amount), style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                if (when != null)
                  Text(when, style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.textMuted)),
              ],
            ),
          ),
          StatusChip(label: _rechargeLabel(l10n, request.state), tone: _rechargeTone(request.state), dense: true),
        ],
      ),
    );
  }
}

class _AutoPayNote extends StatelessWidget {
  const _AutoPayNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: Insets.sm),
        Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
      ],
    );
  }
}

class _AutoPaySetupSheet extends StatefulWidget {
  const _AutoPaySetupSheet({required this.autoPay});

  final AutoPay autoPay;

  static Future<String?> show(BuildContext context, {required AutoPay autoPay}) => AppSheet.show<String>(
    context,
    title: context.l10n.paymentsAutoPaySetUp,
    child: _AutoPaySetupSheet(autoPay: autoPay),
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
          AutoPayTerms(autoPay: widget.autoPay),
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
