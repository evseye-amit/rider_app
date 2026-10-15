import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'capture_tiles.dart';

class LocalPhotoGrid extends StatelessWidget {
  const LocalPhotoGrid({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    this.max = 3,
    this.addLabel,
    this.columns = 3,
    super.key,
  });

  final List<File> photos;
  final VoidCallback? onAdd;
  final ValueChanged<int>? onRemove;
  final int max;
  final String? addLabel;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final bool canAdd = photos.length < max;
    final int count = photos.length + (canAdd ? 1 : 0);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: Insets.md,
        crossAxisSpacing: Insets.md,
      ),
      itemBuilder: (context, index) {
        if (index == photos.length) {
          return PhotoSlot(
            label: addLabel ?? context.l10n.commonAddPhoto,
            icon: Icons.add_a_photo_rounded,
            required: false,
            onTap: onAdd,
          );
        }
        return _LocalPhotoTile(file: photos[index], onRemove: onRemove == null ? null : () => onRemove!(index));
      },
    );
  }
}

class _LocalPhotoTile extends StatelessWidget {
  const _LocalPhotoTile({required this.file, required this.onRemove});

  final File file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: Corners.brMd,
          child: Image.file(
            file,
            fit: BoxFit.cover,
            cacheWidth: 400,
            errorBuilder: (_, _, _) => const ColoredBox(
              color: AppColors.surfaceMuted,
              child: Icon(Icons.image_not_supported_rounded, color: AppColors.textMuted),
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
