import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';
import 'status_chip.dart';

enum UploadState { empty, uploading, uploaded, rejected }

class UploadTile extends StatelessWidget {
  const UploadTile({
    required this.label,
    this.hint,
    this.state = UploadState.empty,
    this.fileName,
    this.progress = 0,
    this.onTap,
    this.onRemove,
    this.required = false,
    this.rejectReason,
    super.key,
  });

  final String label;
  final String? hint;
  final UploadState state;
  final String? fileName;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool required;
  final String? rejectReason;

  @override
  Widget build(BuildContext context) {
    final (Color tone, IconData icon) = switch (state) {
      UploadState.empty => (AppColors.textMuted, Icons.cloud_upload_outlined),
      UploadState.uploading => (AppColors.warning, Icons.sync_rounded),
      UploadState.uploaded => (AppColors.success, Icons.task_alt_rounded),
      UploadState.rejected => (AppColors.danger, Icons.error_outline_rounded),
    };

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.md + 2),
        decoration: BoxDecoration(
          color: state == UploadState.empty ? AppColors.surface : AppColors.washFor(tone),
          borderRadius: Corners.brMd,
          border: Border.all(
            color: state == UploadState.empty ? AppColors.stroke : tone.withValues(alpha: 0.30),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: state == UploadState.empty
                        ? AppColors.surfaceMuted
                        : AppColors.surface,
                    borderRadius: Corners.brSm,
                  ),
                  child: Icon(icon, size: 20, color: tone),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.titleSmall.copyWith(fontSize: 14),
                            ),
                          ),
                          if (required)
                            Text(' *', style: AppText.titleSmall.copyWith(color: AppColors.danger)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        switch (state) {
                          UploadState.uploaded => fileName ?? 'Uploaded',
                          UploadState.uploading => 'Uploading… ${(progress * 100).round()}%',
                          UploadState.rejected => rejectReason ?? 'Rejected — upload again',
                          UploadState.empty => hint ?? 'JPG, PNG or PDF · up to 5 MB',
                        },
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(
                          fontSize: 11.5,
                          color: state == UploadState.rejected ? AppColors.danger : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Insets.sm),
                if (state == UploadState.uploaded)
                  Pressable(
                    onTap: onRemove,
                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryWash,
                      borderRadius: Corners.pill,
                    ),
                    child: Text(
                      state == UploadState.rejected ? 'Retry' : 'Upload',
                      style: AppText.bodySmall.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            if (state == UploadState.uploading) ...[
              const SizedBox(height: Insets.md),
              ClipRRect(
                borderRadius: Corners.pill,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppColors.surfaceSunken,
                  valueColor: const AlwaysStoppedAnimation(AppColors.warning),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PhotoSlot extends StatelessWidget {
  const PhotoSlot({
    required this.label,
    this.captured = false,
    this.onTap,
    this.onRetake,
    this.icon = Icons.photo_camera_rounded,
    this.required = true,
    super.key,
  });

  final String label;
  final bool captured;
  final VoidCallback? onTap;
  final VoidCallback? onRetake;
  final IconData icon;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: captured ? onRetake : onTap,
      scale: 0.96,
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: captured ? null : _DashedBorderPainter(),
          child: Container(
            decoration: BoxDecoration(
              color: captured ? AppColors.successWash : AppColors.surfaceMuted,
              borderRadius: Corners.brMd,
              border: captured
                  ? Border.all(color: AppColors.success.withValues(alpha: 0.35), width: 1.3)
                  : null,
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        captured ? Icons.check_circle_rounded : icon,
                        size: 26,
                        color: captured ? AppColors.success : AppColors.textMuted,
                      ),
                      const SizedBox(height: Insets.sm),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(
                            fontSize: 11,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: captured ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (captured)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: StatusChip(label: 'Retake', tone: StatusTone.neutral, dense: true, showDot: false),
                  )
                else if (required)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.danger,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.strokeStrong
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final RRect rrect = RRect.fromRectAndRadius(Offset.zero & size, Corners.md);
    final Path path = Path()..addRRect(rrect);

    const double dash = 6;
    const double gap = 5;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, (distance + dash).clamp(0, metric.length)),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
