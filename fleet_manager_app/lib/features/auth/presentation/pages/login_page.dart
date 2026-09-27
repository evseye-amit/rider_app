import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static final RegExp _mobilePattern = RegExp(r'^[6-9]\d{9}$');

  final TextEditingController _mobile = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _mobile.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _askLanguage());
  }

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  bool get _isValid => _mobilePattern.hasMatch(_mobile.text.trim());

  Future<void> _askLanguage() async {
    final LocalePreference preference = ref.read(localeProvider);
    if (preference.hasBeenPrompted || !mounted) return;
    final AppLocale? picked = await LanguagePicker.show(context, selected: preference.locale, firstRun: true);
    final LocaleNotifier locale = ref.read(localeProvider.notifier);
    if (picked == null) {
      await locale.markPrompted();
      return;
    }
    await locale.select(picked);
  }

  Future<void> _continue() async {
    FocusScope.of(context).unfocus();
    if (!_isValid) {
      setState(() => _error = context.l10n.commonEnterValid10DigitMobile);
      return;
    }
    setState(() {
      _error = null;
      _submitting = true;
    });

    final String mobile = _mobile.text.trim();
    final Result<OtpChallenge> result = await ref.read(fleetSessionProvider.notifier).requestOtp(mobile);
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<OtpChallenge>(:final value):
        unawaited(context.push('${Routes.otp}?mobile=$mobile&request=${value.otpRequestId}'));
      case Err<OtpChallenge>(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
      trailing: const LanguageChip(),
      art: BrandArt.manager,
      artSize: 200,
      title: context.l10n.authSignRunHub,
      subtitle: context.l10n.authSignWithMobileNumberRegistered,
      children: [
        AppTextField(
          label: context.l10n.commonMobileNumber,
          hint: '98765 43210',
          prefixText: '+91',
          required: true,
          keyboardType: TextInputType.phone,
          controller: _mobile,
          errorText: _error,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _continue(),
          suffix: _isValid ? const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success) : null,
        ),
        const Gap.xl(),
        PrimaryButton(
          label: context.l10n.authContinue,
          trailingIcon: Icons.arrow_forward_rounded,
          loading: _submitting,
          onPressed: _isValid ? _continue : null,
        ),
        const Gap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: Insets.sm - 2),
            Flexible(
              child: Text(
                context.l10n.authOnlyNumbersRegisteredByAdmin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppText.bodySmall.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        AuthDivider(label: context.l10n.authWhyChooseUs),
        const Gap.xl(),
        const _TrustStrip(),
      ],
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    final List<(IconData, String)> items = [
      (Icons.hub_rounded, context.l10n.authVerifiedHubNetwork),
      (Icons.insights_rounded, context.l10n.authLiveFleetVisibility),
      (Icons.support_agent_rounded, context.l10n.authOpsSupport),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (IconData icon, String label) in items) ...[
          Expanded(
            child: Column(
              children: [
                IconTile(icon: icon, tone: AppColors.primary, size: 46, solid: true),
                const SizedBox(height: Insets.sm),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(
                    fontSize: 11.5,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (label != items.last.$2) const SizedBox(width: Insets.sm),
        ],
      ],
    );
  }
}
