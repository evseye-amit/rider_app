import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/session/rider_session_provider.dart';
import '../../../payments/domain/entities/auto_pay.dart';
import '../../../payments/presentation/providers/auto_pay_provider.dart';
import '../../../payments/presentation/widgets/auto_pay_card.dart';
import '../../../payments/presentation/widgets/auto_pay_enrollment.dart';

class AutoPayPage extends ConsumerStatefulWidget {
  const AutoPayPage({super.key});

  @override
  ConsumerState<AutoPayPage> createState() => _AutoPayPageState();
}

class _AutoPayPageState extends ConsumerState<AutoPayPage> with WidgetsBindingObserver, AutoPayEnrollment<AutoPayPage> {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  final TextEditingController _email = TextEditingController();
  String? _emailError;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(autoPayProvider, (_, next) => _settle(next), fireImmediately: true);
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _settle(AsyncValue<AutoPay?> value) {
    if (value case AsyncData<AutoPay?>(value: final AutoPay? autoPay) when autoPay == null || !autoPay.needsSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _finish());
    }
  }

  Future<void> _finish() async {
    final String? allocationId = ref.read(riderSessionProvider).deployment?.allocation?.id;
    if (_finishing || allocationId == null || !mounted) return;
    setState(() => _finishing = true);
    await ref.read(riderSessionProvider.notifier).finishAutoPay(allocationId);
  }

  Future<void> _setUp(AutoPay autoPay) async {
    final String email = _email.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _emailError = context.l10n.paymentsAutoPayEmailInvalid);
      return;
    }
    await setUpAutoPay(autoPay, email);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AsyncValue<AutoPay?> state = ref.watch(autoPayProvider);
    final AutoPay? current = state.value;

    if (state.hasError && current == null) {
      return AppScaffold(
        title: l10n.paymentsAutoPaySetUp,
        showBack: false,
        body: EmptyState(
          title: l10n.paymentsAutoPayUnavailable,
          message: state.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: l10n.commonTryAgain,
          onAction: () => ref.invalidate(autoPayProvider),
        ),
      );
    }

    final AutoPay? shown = current != null && current.needsSetup && !_finishing ? current : null;
    final AutoPayMandate? pending = shown != null && shown.awaitingApproval ? shown.mandate : null;
    final bool turnOn = shown != null && pending == null && shown.canTurnOn;

    return AppScaffold(
      title: l10n.paymentsAutoPaySetUp,
      showBack: false,
      footer: switch (shown) {
        null => null,
        _ when pending != null && pending.approvalUrl != null => PrimaryButton(
          label: l10n.paymentsAutoPayFinishSetup,
          icon: Icons.open_in_new_rounded,
          loading: autoPayBusy,
          onPressed: autoPayBusy ? null : () => openAutoPayApproval(pending),
        ),
        _ when pending != null => PrimaryButton(
          label: l10n.paymentsAutoPayCheckStatus,
          icon: Icons.refresh_rounded,
          loading: autoPayBusy,
          onPressed: autoPayBusy ? null : () => verifyAutoPay(pending.id),
        ),
        final AutoPay autoPay when turnOn => PrimaryButton(
          label: l10n.walletAutoPayTurnOn,
          icon: Icons.autorenew_rounded,
          loading: autoPayBusy,
          onPressed: autoPayBusy ? null : () => turnOnAutoPay(autoPay),
        ),
        final AutoPay autoPay => PrimaryButton(
          label: l10n.paymentsAutoPayContinue,
          icon: Icons.open_in_new_rounded,
          loading: autoPayBusy,
          onPressed: autoPayBusy ? null : () => _setUp(autoPay),
        ),
      },
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(autoPayProvider.future).then<void>((_) {}, onError: (_) {}),
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (shown == null)
              const ShimmerBox(height: 220, borderRadius: Corners.brXl)
            else ...[
              _Terms(autoPay: shown),
              const Gap.lg(),
              if (pending != null)
                AccentCard(
                  accent: AppColors.warning,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.paymentsAutoPayAuthPending,
                        style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                      ),
                      if (pending.approvalUrl != null) ...[
                        const Gap.sm(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GhostButton(
                            label: l10n.paymentsAutoPayCheckStatus,
                            icon: Icons.refresh_rounded,
                            dense: true,
                            onPressed: autoPayBusy ? null : () => verifyAutoPay(pending.id),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              else if (turnOn) ...[
                if (shown.state == AutoPayState.consentRequired)
                  AccentCard(
                    accent: AppColors.warning,
                    child: Text(
                      l10n.walletAutoPayTermsChanged,
                      style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                    ),
                  ),
              ] else ...[
                if (shown.mandate?.state == AutoPayMandateState.closed) ...[
                  AccentCard(
                    accent: AppColors.danger,
                    child: Text(
                      l10n.paymentsAutoPaySetupFailed,
                      style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                    ),
                  ),
                  const Gap.lg(),
                ],
                AppTextField(
                  label: l10n.paymentsAutoPayEmail,
                  hint: 'name@example.com',
                  helper: l10n.paymentsAutoPayEmailHelp,
                  controller: _email,
                  errorText: _emailError,
                  enabled: !autoPayBusy,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  onChanged: (_) => setState(() => _emailError = null),
                  onSubmitted: (_) {
                    if (!autoPayBusy) unawaited(_setUp(shown));
                  },
                ),
              ],
            ],
            const Gap.xl(),
          ],
        ),
      ),
    );
  }
}

class _Terms extends StatelessWidget {
  const _Terms({required this.autoPay});

  final AutoPay autoPay;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    return ModuleCard(
      title: l10n.walletAutoPayTitle,
      leading: const IconTile(icon: Icons.autorenew_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.deploymentAutoPayIntro, style: AppText.titleSmall.copyWith(fontSize: 13.5, height: 1.45)),
          const Gap.md(),
          AutoPayTerms(autoPay: autoPay),
          const Gap.md(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textMuted),
              const SizedBox(width: Insets.sm),
              Expanded(
                child: Text(
                  l10n.deploymentAutoPayUpiApp,
                  style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
