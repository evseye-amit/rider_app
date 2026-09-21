import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

enum BrandArt {
  scooter('scooter'),
  rider('delivery_scooter'),
  hub('hub'),
  charging('charging'),
  wallet('wallet'),
  shield('shield'),
  success('success'),
  waiting('waiting'),
  service('service'),
  empty('empty'),

  manager('manager'),

  introEarnings('intro_earnings'),
  introRide('scooter'),
  introSupport('intro_support');

  const BrandArt(this.file);

  final String file;

  double get aspect => 1.0;

  String get asset => 'assets/art/$file.png';
}

class BrandIllustration extends StatelessWidget {
  const BrandIllustration({
    required this.art,
    this.size = 220,
    this.onInk = false,
    super.key,
  });

  final BrandArt art;
  final double size;

  final bool onInk;

  @override
  Widget build(BuildContext context) {
    final double height = size * art.aspect;
    final Widget picture = Image.asset(
      art.asset,
      package: 'evseye_core',
      width: size,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,

      errorBuilder: (_, __, ___) => SizedBox(width: size, height: height),
    );

    return SizedBox(
      width: size,
      height: height,
      child: onInk
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: Corners.brXl,
              ),
              child: Padding(padding: const EdgeInsets.all(Insets.sm), child: picture),
            )
          : picture,
    );
  }
}

class IconTile extends StatelessWidget {
  const IconTile({
    required this.icon,
    this.tone = AppColors.primary,
    this.size = 40,
    this.solid = false,
    this.radius,
    super.key,
  });

  final IconData icon;
  final Color tone;
  final double size;

  final bool solid;

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: solid ? tone : AppColors.washFor(tone),
        borderRadius: BorderRadius.circular(radius ?? size * 0.32),
        boxShadow: solid
            ? [
                BoxShadow(
                  color: tone.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Icon(icon, size: size * 0.48, color: solid ? Colors.white : tone),
    );
  }
}

class ArtBlock extends StatelessWidget {
  const ArtBlock({
    required this.art,
    required this.title,
    this.message,
    this.artSize = 190,
    this.onInk = false,
    super.key,
  });

  final BrandArt art;
  final String title;
  final String? message;
  final double artSize;
  final bool onInk;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandIllustration(art: art, size: artSize, onInk: onInk),
          const SizedBox(height: Insets.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.displaySmall.copyWith(
              fontSize: 22,
              color: onInk ? AppColors.onInk : AppColors.textPrimary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: Insets.sm),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppText.bodyMedium.copyWith(
                height: 1.55,
                color: onInk ? AppColors.onInkSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
