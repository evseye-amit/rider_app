import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _mobile = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _mobile.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _askLanguage());
  }

  Future<void> _askLanguage() async {
    final LocaleController locale = sl<LocaleController>();
    if (locale.hasBeenPrompted || !mounted) return;
    final AppLocale? picked = await LanguagePicker.show(
      context,
      selected: locale.current,
      firstRun: true,
    );
    if (picked == null) {
      await locale.markPrompted();
      return;
    }
    await locale.select(picked);
  }

  @override
  void dispose() {
    _mobile.dispose();
    super.dispose();
  }

  bool get _isValid => RegExp(r'^[6-9]\d{9}$').hasMatch(_mobile.text.trim());

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
    final Result<OtpChallenge> result =
        await sl<SessionController>().requestOtp(mobile);
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<OtpChallenge>(:final value):
        context.push('${Routes.otp}?mobile=$mobile&request=${value.otpRequestId}');
      case Err<OtpChallenge>(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _continue(),
          suffix: _isValid
              ? const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success)
              : null,
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
    final items = [
      (Icons.hub_rounded, context.l10n.authVerifiedHubNetwork),
      (Icons.insights_rounded, context.l10n.authLiveFleetVisibility),
      (Icons.support_agent_rounded, context.l10n.authOpsSupport),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (icon, label) in items) ...[
          Expanded(
            child: Column(
              children: [
                IconTile(
                  icon: icon,
                  tone: AppColors.primary,
                  size: 46,
                  solid: true,
                ),
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
