import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';

enum _Stage { entering, verifying, verified }

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

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    if (code.length != 6 || _stage != _Stage.entering) return;
    setState(() {
      _stage = _Stage.verifying;
      _hasError = false;
    });

    final Result<AuthUser> result = await sl<SessionController>()
        .verifyOtp(otpRequestId: _requestId, code: code);
    if (!mounted) return;

    switch (result) {
      case Ok<AuthUser>():
        setState(() => _stage = _Stage.verified);

        await Future.delayed(const Duration(milliseconds: 450));
        if (!mounted) return;

        context.go(sl<SessionController>().homeRoute);
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
    final Result<OtpChallenge> result =
        await sl<SessionController>().requestOtp(widget.mobile);
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
    final String m = widget.mobile;
    if (m.length < 6) return m;
    return '${m.substring(0, 2)}${'•' * (m.length - 4)}${m.substring(m.length - 2)}';
  }

  @override
  Widget build(BuildContext context) {
    return AuthSheetScaffold(
      showBack: true,
      onBack: () => context.pop(),
      photo: BrandPhoto.rider,
      artSize: 170,
      title: 'Verify your number',
      subtitle: 'A 6-digit code was sent to +91 $_masked',
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
                child: Text(
                  _error!,
                  style: AppText.bodySmall.copyWith(
                    color: AppColors.danger,
                    fontSize: 12.5,
                  ),
                ),
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
                        'Resend code in 0:${_remaining.toString().padLeft(2, '0')}',
                        style: AppText.bodySmall,
                      )
                    : GhostButton(
                        label: 'Resend code',
                        icon: Icons.refresh_rounded,
                        onPressed: _resend,
                      ),
              ),
            _Stage.verifying => const _StatusRow(
                key: ValueKey('verifying'),
                icon: null,
                label: 'Verifying your number…',
                tone: AppColors.cyan,
                spinning: true,
              ),
            _Stage.verified => const _StatusRow(
                key: ValueKey('verified'),
                icon: Icons.check_circle_rounded,
                label: 'Number verified',
                tone: AppColors.success,
                spinning: false,
              ),
          },
        ),
        const Gap.xxl(),
        const AuthDivider(label: 'Wrong number?'),
        const Gap.lg(),
        GhostButton(
          label: 'Change number',
          icon: Icons.edit_rounded,
          onPressed: _stage == _Stage.entering ? () => context.pop() : null,
        ),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.tone,
    required this.spinning,
    super.key,
  });

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
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: tone),
          )
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
