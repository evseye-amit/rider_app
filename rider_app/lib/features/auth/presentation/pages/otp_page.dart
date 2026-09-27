import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/session/rider_session_provider.dart';

enum _Stage { entering, verifying, verified }

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({required this.mobile, required this.otpRequestId, super.key});

  final String mobile;
  final String otpRequestId;

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  static const int _resendSeconds = 30;

  Timer? _ticker;
  int _remaining = _resendSeconds;
  _Stage _stage = _Stage.entering;
  bool _hasError = false;
  String? _error;

  late String _requestId = widget.otpRequestId;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remaining = _resendSeconds;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
        return;
      }
      setState(() => _remaining -= 1);
    });
  }

  Future<void> _verify(String code) async {
    if (code.length != 6 || _stage != _Stage.entering) return;
    setState(() {
      _stage = _Stage.verifying;
      _hasError = false;
    });

    final Result<AuthUser> result = await ref
        .read(riderSessionProvider.notifier)
        .verifyOtp(otpRequestId: _requestId, code: code);
    if (!mounted) return;

    switch (result) {
      case Ok<AuthUser>():
        setState(() => _stage = _Stage.verified);
        await Future<void>.delayed(const Duration(milliseconds: 450));
        if (!mounted) return;
        context.go(ref.read(riderSessionProvider).homeRoute);
      case Err<AuthUser>(:final failure):
        setState(() {
          _stage = _Stage.entering;
          _hasError = true;
          _error = failure.message;
        });
    }
  }

  Future<void> _resend() async {
    if (_remaining > 0) return;
    final Result<OtpChallenge> result = await ref.read(riderSessionProvider.notifier).requestOtp(widget.mobile);
    if (!mounted) return;
    switch (result) {
      case Ok<OtpChallenge>(:final value):
        _requestId = value.otpRequestId;
        _startTimer();
        setState(() => _error = null);
        AppSnack.info(context, 'A new code was sent to +91 ${widget.mobile}');
      case Err<OtpChallenge>(:final failure):
        setState(() => _error = failure.message);
        AppSnack.error(context, failure.message);
    }
  }

  String get _masked {
    final String mobile = widget.mobile;
    if (mobile.length < 6) return mobile;
    return '${mobile.substring(0, 2)}${'•' * (mobile.length - 4)}${mobile.substring(mobile.length - 2)}';
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
      showBack: true,
      onBack: () => context.pop(),
      photo: BrandPhoto.rider,
      artSize: 170,
      title: context.l10n.authVerifyNumber,
      subtitle: context.l10n.authOtpSentTo(_masked),
      children: [
        IgnorePointer(
          ignoring: _stage != _Stage.entering,
          child: AnimatedOpacity(
            duration: Motion.normal,
            opacity: _stage == _Stage.entering ? 1 : 0.35,
            child: OtpInput(length: 6, hasError: _hasError, onCompleted: _verify),
          ),
        ),
        if (_error != null) ...[
          const Gap.md(),
          Row(
            children: [
              const Icon(Icons.error_rounded, size: 15, color: AppColors.danger),
              const SizedBox(width: Insets.xs + 2),
              Expanded(
                child: Text(_error!, style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12.5)),
              ),
            ],
          ),
        ],
        const Gap.xl(),
        AnimatedSwitcher(
          duration: Motion.normal,
          child: switch (_stage) {
            _Stage.entering => Center(
              key: const ValueKey('idle'),
              child: _remaining > 0
                  ? Text(
                      context.l10n.authResendCodeIn('0:${_remaining.toString().padLeft(2, '0')}'),
                      style: AppText.bodySmall,
                    )
                  : GhostButton(label: context.l10n.authResendCode, icon: Icons.refresh_rounded, onPressed: _resend),
            ),
            _Stage.verifying => _StatusRow(
              key: const ValueKey('verifying'),
              icon: null,
              label: context.l10n.authVerifyingNumber,
              tone: AppColors.cyan,
              spinning: true,
            ),
            _Stage.verified => _StatusRow(
              key: const ValueKey('verified'),
              icon: Icons.check_circle_rounded,
              label: context.l10n.authNumberVerified,
              tone: AppColors.success,
              spinning: false,
            ),
          },
        ),
        const Gap.xxl(),
        AuthDivider(label: context.l10n.authWrongNumber),
        const Gap.lg(),
        GhostButton(
          label: context.l10n.authChangeNumber,
          icon: Icons.edit_rounded,
          onPressed: _stage == _Stage.entering ? () => context.pop() : null,
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.icon, required this.label, required this.tone, required this.spinning, super.key});

  final IconData? icon;
  final String label;
  final Color tone;
  final bool spinning;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (spinning)
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: tone))
        else if (icon != null)
          Icon(icon, size: 18, color: tone),
        const SizedBox(width: Insets.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.titleSmall.copyWith(fontSize: 13, color: tone),
          ),
        ),
      ],
    );
  }
}
