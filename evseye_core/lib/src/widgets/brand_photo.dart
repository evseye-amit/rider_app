import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'illustrations.dart';

enum BrandPhoto {
  fleet(BrandArt.scooter),

  rider(BrandArt.rider),

  charging(BrandArt.charging),

  service(BrandArt.service),

  money(BrandArt.wallet);

  const BrandPhoto(this.art);

  final BrandArt art;

  Color get tone => AppColors.primary;
}

class PhotoPanel extends StatelessWidget {
  const PhotoPanel({
    required this.photo,
    this.height = 150,
    this.borderRadius = Corners.brXl,
    this.title,
    this.subtitle,
    this.badge,
    this.overlay = true,
    this.alignment,
    this.onTap,
    this.child,
    super.key,
  });

  final BrandPhoto photo;
  final double height;
  final BorderRadius borderRadius;
  final String? title;
  final String? subtitle;
  final Widget? badge;

  final bool overlay;

  final Alignment? alignment;

  final VoidCallback? onTap;

  final Widget? child;

  bool get _hasText => child != null || title != null || subtitle != null;

  @override
  Widget build(BuildContext context) {
    final Widget panel = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.washFor(photo.tone),
        borderRadius: borderRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double artBoxHeight = height - Insets.xxl;
          double artWidth = artBoxHeight / photo.art.aspect;
          final double maxWidth =
              constraints.maxWidth * (_hasText ? 0.46 : 0.62);
          artWidth = math.min(artWidth, maxWidth);

          return Stack(
            children: [
              Positioned(
                right: _hasText ? Insets.md : null,
                left: _hasText ? null : 0,
                top: 0,
                bottom: 0,
                child: _hasText
                    ? Center(child: BrandIllustration(art: photo.art, size: artWidth))
                    : SizedBox(
                        width: constraints.maxWidth,
                        child: Center(
                          child: BrandIllustration(art: photo.art, size: artWidth),
                        ),
                      ),
              ),
              if (child != null)
                Padding(padding: const EdgeInsets.all(Insets.lg), child: child!)
              else if (title != null || subtitle != null)
                Positioned(
                  left: Insets.lg,
                  top: Insets.lg,
                  bottom: Insets.lg,
                  width: constraints.maxWidth * 0.52 - Insets.lg,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleLarge.copyWith(fontSize: 16.5),
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            subtitle!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySmall.copyWith(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (badge != null)
                Positioned(top: Insets.md, right: Insets.md, child: badge!),
            ],
          );
        },
      ),
    );

    if (onTap == null) return panel;
    return GestureDetector(onTap: onTap, child: panel);
  }
}

class PhotoThumb extends StatelessWidget {
  const PhotoThumb({
    required this.photo,
    this.size = 56,
    this.radius = 14,
    this.badge,
    super.key,
  });

  final BrandPhoto photo;
  final double size;
  final double radius;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.washFor(photo.tone),
              borderRadius: BorderRadius.circular(radius),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,

            child: BrandIllustration(art: photo.art, size: size * 0.78),
          ),
          if (badge != null) Positioned(right: -2, bottom: -2, child: badge!),
        ],
      ),
    );
  }
}
