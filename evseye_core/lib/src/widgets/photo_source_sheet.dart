import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'pressable.dart';

enum PhotoSource { camera, gallery }

abstract final class PhotoSourceSheet {
  static Future<File?> pick(
    BuildContext context, {
    String title = 'Add a photo',
    String subtitle = 'Take one now, or choose from your gallery',
  }) async {
    final PhotoSource? source = await showModalBottomSheet<PhotoSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _Sheet(title: title, subtitle: subtitle),
    );
    if (source == null || !context.mounted) return null;
    return capture(source);
  }

  static Future<File?> capture(PhotoSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? shot = await picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,

      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );
    return shot == null ? null : File(shot.path);
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(Insets.md),
        padding: const EdgeInsets.all(Insets.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brXxl,
          boxShadow: Shadows.raised,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppText.titleLarge.copyWith(fontSize: 18)),
            const SizedBox(height: Insets.xs),
            Text(
              subtitle,
              style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
            ),
            const SizedBox(height: Insets.xl),
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_camera_rounded,
                    label: 'Camera',
                    onTap: () => Navigator.of(context).pop(PhotoSource.camera),
                  ),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Insets.md),
            GhostButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.97,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Insets.xl),
        decoration: BoxDecoration(
          color: AppColors.primaryWash,
          borderRadius: Corners.brLg,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            const SizedBox(height: Insets.sm),
            Text(
              label,
              style: AppText.titleSmall.copyWith(
                fontSize: 13.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
