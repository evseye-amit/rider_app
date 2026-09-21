import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({required this.mobile, required this.otpRequestId, super.key});

  final String mobile;
  final String otpRequestId;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  static const int _resendSeconds = 30;

  Timer? _ticker;
  int _secondsLeft = _resendSeconds;
  bool _verifying = false;
  bool _hasError = false;
  String? _error;

  late String _requestId = widget.otpRequestId;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    _secondsLeft = _resendSeconds;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        timer.cancel();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    if (_verifying) return;
    if (code.length != 6) {
      setState(() => _hasError = true);
      return;
    }
    setState(() {
      _verifying = true;
      _hasError = false;
      _error = null;
    });

    final Result<AuthUser> result = await sl<SessionController>()
        .verifyOtp(otpRequestId: _requestId, code: code);
    if (!mounted) return;

    switch (result) {
      case Ok<AuthUser>():
        context.go(Routes.home);
      case Err<AuthUser>(:final failure):
        setState(() {
          _verifying = false;
          _hasError = true;
          _error = failure.message;
        });
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0) return;
    final Result<OtpChallenge> result =
        await sl<SessionController>().requestOtp(widget.mobile);
    if (!mounted) return;
    switch (result) {
      case Ok<OtpChallenge>(:final value):
        _requestId = value.otpRequestId;
        _startTicker();
        setState(() => _error = null);
        AppSnack.info(context, 'A new code has been sent to +91 ${widget.mobile}');
      case Err<OtpChallenge>(:final failure):
        setState(() => _error = failure.message);
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
      art: BrandArt.manager,
      artSize: 170,
      showBack: true,
      title: 'Verify your number',
      subtitle: 'Enter the 6-digit code sent to +91 ${widget.mobile}',
      children: [
        OtpInput(hasError: _hasError, onCompleted: _verify),
        if (_hasError) ...[
          const Gap.md(),
          Row(
            children: [
              const Icon(Icons.error_rounded, size: 15, color: AppColors.danger),
              const SizedBox(width: Insets.xs + 2),
              Expanded(
                child: Text(
                  _error ?? 'That code did not verify. Please try again.',
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
        if (_verifying) ...[
          const Gap.xl(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
              ),
              const SizedBox(width: Insets.sm),
              Text('Verifying…', style: AppText.bodySmall),
            ],
          ),
        ],
        const Gap.xl(),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: Insets.sm,
          children: [
            GhostButton(
              label: 'Edit number',
              icon: Icons.edit_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            GhostButton(
              label: _secondsLeft > 0 ? 'Resend in ${_secondsLeft}s' : 'Resend OTP',
              icon: Icons.refresh_rounded,
              onPressed: _secondsLeft > 0 ? null : _resend,
            ),
          ],
        ),
        const Gap.xxl(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.textMuted),
            const SizedBox(width: Insets.sm - 2),
            Flexible(
              child: Text(
                'Your session is encrypted end-to-end',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppText.bodySmall.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
