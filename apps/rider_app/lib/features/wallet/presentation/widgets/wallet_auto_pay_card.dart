import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/router/app_routes.dart';
import '../../../payments/domain/entities/auto_pay_setup.dart';
import '../../../payments/presentation/providers/payments_provider.dart';
import '../../domain/entities/wallet_auto_pay.dart';
import '../providers/wallet_auto_pay_provider.dart';

String autoRechargeLabel(AppL10n l10n, AutoRechargeState state) => switch (state) {
  AutoRechargeState.creating => l10n.walletAutoPayStatusPreparing,
  AutoRechargeState.pending => l10n.walletAutoPayStatusPending,
  AutoRechargeState.unknown => l10n.walletAutoPayStatusConfirming,
  AutoRechargeState.review => l10n.walletAutoPayStatusReview,
  AutoRechargeState.success => l10n.walletAutoPayStatusAdded,
  AutoRechargeState.failed => l10n.walletStateFailed,
  AutoRechargeState.cancelled => l10n.walletAutoPayStatusStopped,
};

StatusTone autoRechargeTone(AutoRechargeState state) => switch (state) {
  AutoRechargeState.success => StatusTone.success,
  AutoRechargeState.failed => StatusTone.danger,
  AutoRechargeState.cancelled => StatusTone.neutral,
  _ => StatusTone.warning,
};

class WalletAutoPayCard extends ConsumerStatefulWidget {
  const WalletAutoPayCard({super.key});

  @override
  ConsumerState<WalletAutoPayCard> createState() => _WalletAutoPayCardState();
}

class _WalletAutoPayCardState extends ConsumerState<WalletAutoPayCard> {
  bool _busy = false;

  Future<void> _turnOn(WalletAutoPay autoPay) async {
    final String? mandateId = await WalletAutoPaySheet.show(context, autoPay: autoPay);
    if (mandateId == null || !mounted) return;
    await _apply(
      () => ref.read(walletAutoPayProvider.notifier).enable(mandateId: mandateId, revision: autoPay.revision),
      success: context.l10n.walletAutoPayTurnedOn,
    );
  }

  Future<void> _turnOff() async {
    final AppL10n l10n = context.l10n;
    final bool confirmed = await AppDialog.confirm(
      context,
      title: l10n.walletAutoPayTurnOffTitle,
      message: l10n.walletAutoPayTurnOffMessage,
      confirmLabel: l10n.walletAutoPayTurnOff,
      icon: Icons.autorenew_rounded,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await _apply(() => ref.read(walletAutoPayProvider.notifier).disable(), success: l10n.walletAutoPayTurnedOff);
  }

  Future<void> _apply(Future<Result<WalletAutoPay>> Function() action, {required String success}) async {
    setState(() => _busy = true);
    final Result<WalletAutoPay> result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok<WalletAutoPay>():
        AppSnack.success(context, success);
      case Err<WalletAutoPay>(:final failure):
        AppSnack.error(context, failure.message);
        ref
          ..invalidate(walletAutoPayProvider)
          ..invalidate(autoPaySetupProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final WalletAutoPay? autoPay = ref.watch(walletAutoPayProvider).value;
    if (autoPay == null || !autoPay.isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: ModuleCard(
        title: l10n.walletAutoPayTitle,
        leading: const IconTile(icon: Icons.autorenew_rounded, solid: true, size: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.walletAutoPaySummary(Fmt.money(autoPay.rechargeAmount), Fmt.money(autoPay.threshold)),
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                  ),
                ),
                const SizedBox(width: Insets.sm),
                StatusChip(
                  label: autoPay.isOn ? l10n.walletAutoPayOn : l10n.walletAutoPayOff,
                  tone: autoPay.isOn ? StatusTone.success : StatusTone.neutral,
                  dense: true,
                ),
              ],
            ),
            if (!autoPay.policyEnabled)
              _Note(text: l10n.walletAutoPayPolicyOff, tone: AppColors.info)
            else if (autoPay.enabled && autoPay.consentRequired)
              _Note(text: l10n.walletAutoPayTermsChanged, tone: AppColors.warning),
            if (autoPay.actionRequired) _Note(text: l10n.walletAutoPayActionRequired, tone: AppColors.danger),
            if (autoPay.requests.isNotEmpty) ...[
              const Gap.md(),
              GroupLabel(l10n.walletAutoPayRecent),
              for (final AutoRecharge request in autoPay.requests.take(3)) _RechargeRow(request: request),
            ],
            if (autoPay.policyEnabled && !autoPay.isOn) ...[
              const Gap.md(),
              PrimaryButton(
                label: autoPay.enabled ? l10n.walletAutoPayReviewTerms : l10n.walletAutoPayTurnOn,
                icon: Icons.autorenew_rounded,
                loading: _busy,
                onPressed: _busy ? null : () => _turnOn(autoPay),
              ),
            ],
            if (autoPay.enabled) ...[
              const Gap.sm(),
              SecondaryButton(
                label: l10n.walletAutoPayTurnOff,
                icon: Icons.pause_circle_outline_rounded,
                onPressed: _busy ? null : _turnOff,
              ),
            ],
          ],
        ),
      ),
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
          StatusChip(label: autoRechargeLabel(l10n, request.state), tone: autoRechargeTone(request.state), dense: true),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.text, required this.tone});

  final String text;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: tone),
          const SizedBox(width: Insets.sm),
          Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
        ],
      ),
    );
  }
}

class WalletAutoPaySheet extends ConsumerStatefulWidget {
  const WalletAutoPaySheet({required this.autoPay, super.key});

  final WalletAutoPay autoPay;

  static Future<String?> show(BuildContext context, {required WalletAutoPay autoPay}) => AppSheet.show<String>(
    context,
    title: context.l10n.walletAutoPayConsentTitle,
    child: WalletAutoPaySheet(autoPay: autoPay),
  );

  @override
  ConsumerState<WalletAutoPaySheet> createState() => _WalletAutoPaySheetState();
}

class _WalletAutoPaySheetState extends ConsumerState<WalletAutoPaySheet> {
  bool _agreed = false;

  void _openMandateSetup() {
    final GoRouter router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final WalletAutoPay autoPay = widget.autoPay;
    final AsyncValue<AutoPaySetup?> setup = ref.watch(autoPaySetupProvider);
    final AutoPayMandate? mandate = setup.value?.mandate;
    final String? mandateId = switch (mandate) {
      final AutoPayMandate value
          when value.state == AutoPayMandateState.active &&
              !value.cancellationPending &&
              (value.maxAmount <= 0 || value.maxAmount >= autoPay.rechargeAmount) =>
        value.id,
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.walletAutoPayConsent(
            Fmt.money(autoPay.rechargeAmount),
            Fmt.money(autoPay.threshold),
            Fmt.number(autoPay.leadHours),
            Fmt.number(autoPay.cooldownHours),
          ),
          style: AppText.bodyMedium.copyWith(height: 1.55),
        ),
        const Gap.md(),
        Text(l10n.walletAutoPayCashOnly, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
        if (mandate != null && mandate.maxAmount > 0) ...[
          const Gap.md(),
          KeyValueRow(label: l10n.paymentsMandateLimit, value: Fmt.money(mandate.maxAmount), dense: true),
        ],
        const Gap.lg(),
        if (setup.isLoading && !setup.hasValue)
          const Center(child: CircularProgressIndicator())
        else if (mandateId == null) ...[
          _Note(text: l10n.walletAutoPayNeedsMandate(Fmt.money(autoPay.rechargeAmount)), tone: AppColors.warning),
          const Gap.lg(),
          PrimaryButton(
            label: l10n.walletAutoPaySetUpMandate,
            icon: Icons.open_in_new_rounded,
            onPressed: _openMandateSetup,
          ),
        ] else ...[
          AppCheckTile(
            value: _agreed,
            onChanged: (value) => setState(() => _agreed = value),
            title: l10n.walletAutoPayAgree,
          ),
          const Gap.lg(),
          PrimaryButton(
            label: l10n.walletAutoPayTurnOn,
            icon: Icons.autorenew_rounded,
            onPressed: _agreed ? () => Navigator.of(context).pop(mandateId) : null,
          ),
        ],
        const Gap.md(),
      ],
    );
  }
}
