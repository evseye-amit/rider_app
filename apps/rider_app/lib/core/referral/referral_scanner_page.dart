import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'referral_link.dart';

class ReferralScannerPage extends StatefulWidget {
  const ReferralScannerPage({super.key});

  @override
  State<ReferralScannerPage> createState() => _ReferralScannerPageState();
}

class _ReferralScannerPageState extends State<ReferralScannerPage> {
  static const List<BarcodeFormat> _formats = [BarcodeFormat.qrCode];

  final MobileScannerController _controller = MobileScannerController(
    formats: _formats,
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _done = false;
  bool _picking = false;
  DateTime? _warnedAt;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    final ReferralLink? link = _linkIn(capture);
    if (link != null) {
      _finish(link);
    } else if (capture.barcodes.isNotEmpty) {
      _warn(context.l10n.referScanNotReferral);
    }
  }

  ReferralLink? _linkIn(BarcodeCapture? capture) {
    for (final Barcode barcode in capture?.barcodes ?? const <Barcode>[]) {
      final ReferralLink? link = ReferralLink.parse(barcode.rawValue);
      if (link != null) return link;
    }
    return null;
  }

  void _finish(ReferralLink link) {
    _done = true;
    unawaited(HapticFeedback.mediumImpact());
    context.pop(link);
  }

  void _warn(String message) {
    final DateTime now = DateTime.now();
    final DateTime? last = _warnedAt;
    if (last != null && now.difference(last) < const Duration(seconds: 3)) return;
    _warnedAt = now;
    AppSnack.warning(context, message);
  }

  Future<void> _pickPhoto() async {
    if (_picking || _done) return;
    setState(() => _picking = true);
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (photo == null) {
      setState(() => _picking = false);
      return;
    }
    BarcodeCapture? capture;
    try {
      capture = await _controller.analyzeImage(photo.path, formats: _formats);
    } on MobileScannerException {
      capture = null;
    } on PlatformException {
      capture = null;
    } on UnsupportedError {
      capture = null;
    }
    if (!mounted) return;
    setState(() => _picking = false);
    final ReferralLink? link = _linkIn(capture);
    if (link != null) {
      _finish(link);
      return;
    }
    AppSnack.error(
      context,
      (capture?.barcodes ?? const <Barcode>[]).isEmpty
          ? context.l10n.referScanNoQrInPhoto
          : context.l10n.referScanNotReferral,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) =>
                _ScannerError(error: error, onRetry: () => unawaited(_controller.start())),
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: _controller,
            builder: (context, state, _) => state.error == null ? const _ScanFrame() : const SizedBox.shrink(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.xl),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleIconButton(
                        icon: Icons.close_rounded,
                        background: Colors.black54,
                        foreground: Colors.white,
                        onTap: () => context.pop(),
                      ),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Text(
                          context.l10n.referScanTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleMedium.copyWith(color: Colors.white),
                        ),
                      ),
                      ValueListenableBuilder<MobileScannerState>(
                        valueListenable: _controller,
                        builder: (context, state, _) => switch (state.torchState) {
                          TorchState.unavailable => const SizedBox.shrink(),
                          TorchState.on => CircleIconButton(
                            icon: Icons.flash_on_rounded,
                            background: Colors.white,
                            foreground: Colors.black,
                            onTap: () => unawaited(_controller.toggleTorch()),
                          ),
                          TorchState.off || TorchState.auto => CircleIconButton(
                            icon: Icons.flash_off_rounded,
                            background: Colors.black54,
                            foreground: Colors.white,
                            onTap: () => unawaited(_controller.toggleTorch()),
                          ),
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    context.l10n.referScanHint,
                    textAlign: TextAlign.center,
                    style: AppText.bodyMedium.copyWith(color: Colors.white, height: 1.4),
                  ),
                  const Gap.lg(),
                  PrimaryButton(
                    label: context.l10n.referScanFromPhotos,
                    icon: Icons.photo_library_rounded,
                    loading: _picking,
                    onPressed: _picking ? null : _pickPhoto,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(painter: _ScanFramePainter(), child: SizedBox.expand()),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  const _ScanFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double side = size.shortestSide * 0.68;
    final Rect window = Rect.fromCenter(center: size.center(Offset.zero), width: side, height: side);
    final RRect frame = RRect.fromRectAndRadius(window, const Radius.circular(24));
    final Path shade = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addRRect(frame),
    );
    canvas.drawPath(shade, Paint()..color = Colors.black.withValues(alpha: 0.55));
    canvas.drawRRect(
      frame,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) => false;
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.error, required this.onRetry});

  final MobileScannerException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String message, String? action, VoidCallback? onAction) = switch (error.errorCode) {
      MobileScannerErrorCode.permissionDenied => (
        Icons.no_photography_rounded,
        context.l10n.referScanPermissionDenied,
        context.l10n.mapsOpenSettings,
        () => unawaited(Geolocator.openAppSettings()),
      ),
      MobileScannerErrorCode.unsupported => (Icons.videocam_off_rounded, context.l10n.referScanNoCamera, null, null),
      _ => (Icons.error_outline_rounded, context.l10n.referScanCameraFailed, context.l10n.commonTryAgain, onRetry),
    };
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.x3l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 44, color: Colors.white70),
              const Gap.md(),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.bodyMedium.copyWith(color: Colors.white, height: 1.45),
              ),
              if (action != null && onAction != null) ...[
                const Gap.lg(),
                GhostButton(label: action, color: Colors.white, onPressed: onAction),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
