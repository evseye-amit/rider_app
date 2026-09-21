import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../../../../core/legal/legal_link.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  static final RegExp _mobileRe = RegExp(r'^[6-9]\d{9}$');

  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _valid => _mobileRe.hasMatch(_controller.text.trim());

  Future<void> _continue() async {
    final String mobile = _controller.text.trim();
    if (!_valid) {
      setState(() => _error = 'Enter a valid 10-digit mobile number');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });

    final Result<OtpChallenge> result =
        await sl<SessionController>().startSignIn(mobile);
    if (!mounted) return;

    switch (result) {
      case Ok<OtpChallenge>(:final value):
        await context.push('${Routes.otp}?mobile=$mobile&request=${value.otpRequestId}');
        if (mounted) setState(() => _loading = false);
      case Err<OtpChallenge>(:final failure):
        setState(() {
          _loading = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
      photo: BrandPhoto.rider,
      artSize: 210,
      title: 'Welcome back',
      subtitle: 'Sign in with the mobile number registered with your fleet operator.',
      children: [
        AppTextField(
          label: 'Mobile number',
          hint: '98765 43210',
          prefixText: '+91',
          controller: _controller,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          errorText: _error,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onSubmitted: (_) => _continue(),
          suffix: _valid
              ? const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success)
              : null,
        ),
        const Gap.xl(),
        PrimaryButton(
          label: 'Continue',
          trailingIcon: Icons.arrow_forward_rounded,
          loading: _loading,
          onPressed: _valid ? _continue : null,
        ),
        const Gap.lg(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: Insets.sm - 2),
            Flexible(
              child: Text(
                'We will text you a 6-digit code',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        const Gap.xxl(),
        const AuthDivider(label: 'Why EVSEYE'),
        const Gap.xl(),
        const _TrustStrip(),
        const Gap.xxl(),
        _LegalLine(),
      ],
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.verified_user_rounded, 'Verified\noperators'),
      (Icons.bolt_rounded, 'Same-day\npayouts'),
      (Icons.support_agent_rounded, '24x7\nroadside help'),
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

class _LegalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle base = AppText.bodySmall.copyWith(fontSize: 12, height: 1.5);
    final TextStyle link = base.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w700,
    );

    return Text.rich(
      TextSpan(
        style: base,
        children: [
          const TextSpan(text: 'By continuing you agree to our '),
          TextSpan(
            text: 'Terms of service',
            style: link,
            recognizer: TapGestureRecognizer()..onTap = () => LegalLink.open(context),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy policy',
            style: link,
            recognizer: TapGestureRecognizer()..onTap = () => LegalLink.open(context),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
