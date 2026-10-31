import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({required this.mobile, required this.otpRequestId, super.key});

  final String mobile;
  final String otpRequestId;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  late final OtpResendController _resendController;
  bool _verifying = false;
  bool _hasError = false;
  String? _error;

  late String _requestId = widget.otpRequestId;

  @override
  void initState() {
    super.initState();
    _resendController = OtpResendController()..addListener(_onResendChanged)..start();
  }

  @override
  void dispose() {
    _resendController.dispose();
    super.dispose();
  }
  void _onResendChanged() { if (mounted) setState(() {}); }

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

    final Result<AuthUser> result = await ref
        .read(fleetSessionProvider.notifier)
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
        if (failure.serverCode == 'OTP_EXPIRED') {
          AppSnack.error(context, context.l10n.authCodeDidNotVerifyPlease);
        } else if (failure.serverCode == 'OTP_RATE_LIMITED') {
          AppSnack.error(context, context.l10n.commonTooManyAttemptsWaitMoment);
        }
    }
  }

  Future<void> _resend() async {
    final Result<OtpChallenge>? result = await _resendController.run(() => ref.read(fleetSessionProvider.notifier).requestOtp(widget.mobile));
    if (result == null) return;
    if (!mounted) return;
    switch (result) {
      case Ok<OtpChallenge>(:final value):
        _requestId = value.otpRequestId;
        _resendController.start();
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
      title: context.l10n.authVerifyNumber,
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
                  _error ?? context.l10n.authCodeDidNotVerifyPlease,
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
              Text(context.l10n.authVerifying, style: AppText.bodySmall),
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
              label: context.l10n.authEditNumber,
              icon: Icons.edit_rounded,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            GhostButton(
              label: _resendController.remaining > 0 ? 'Resend in ${_resendController.remaining}s' : 'Resend OTP',
              icon: Icons.refresh_rounded,
              onPressed: _resendController.canResend ? _resend : null,
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
                context.l10n.authSessionEncryptedEndEnd,
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
