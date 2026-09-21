import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'brand_photo.dart';
import 'illustrations.dart';
import 'pressable.dart';

class AuthSheetScaffold extends StatelessWidget {
  const AuthSheetScaffold({
    required this.title,
    required this.children,
    this.subtitle,
    this.art,
    this.photo,
    this.artSize = 190,
    this.showBack = false,
    this.onBack,
    this.bandAction,
    this.onBandAction,
    this.bandColor = AppColors.ink,
    this.centerTitle = true,
    this.sheetRadius = 34,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  final BrandArt? art;

  final BrandPhoto? photo;

  final double artSize;

  final bool showBack;
  final VoidCallback? onBack;

  final String? bandAction;
  final VoidCallback? onBandAction;

  final Color bandColor;
  final bool centerTitle;
  final double sheetRadius;

  static const double _overlap = 30;

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.inkDeep,

      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double heroHeight = (topInset + 96 + artSize * 0.92).clamp(
            topInset + 140,
            constraints.maxHeight * 0.46,
          );

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight + sheetRadius,
                child: _Hero(
                  photo: photo,
                  art: art,
                  bandColor: bandColor,
                  topInset: topInset,

                  bottomClearance: _overlap + sheetRadius,
                  showBack: showBack,
                  onBack: onBack,
                  bandAction: bandAction,
                  onBandAction: onBandAction,
                ),
              ),
              Positioned(
                top: heroHeight - _overlap,
                left: 0,
                right: 0,
                bottom: 0,
                child: _Sheet(
                  radius: sheetRadius,
                  title: title,
                  subtitle: subtitle,
                  centerTitle: centerTitle,
                  children: children,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.photo,
    required this.art,
    required this.bandColor,
    required this.topInset,
    required this.bottomClearance,
    required this.showBack,
    required this.onBack,
    required this.bandAction,
    required this.onBandAction,
  });

  final BrandPhoto? photo;
  final BrandArt? art;
  final Color bandColor;
  final double topInset;
  final double bottomClearance;
  final bool showBack;
  final VoidCallback? onBack;
  final String? bandAction;
  final VoidCallback? onBandAction;

  @override
  Widget build(BuildContext context) {
    final BrandArt? hero = photo?.art ?? art;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: bandColor),

        if (hero != null)
          Padding(
            padding: EdgeInsets.fromLTRB(
              Insets.gutter,
              topInset + 56,
              Insets.gutter,
              bottomClearance + Insets.sm,
            ),
            child: Center(
              child: LayoutBuilder(
                builder: (context, c) {
                  final double size =
                      math.min(c.maxWidth * 0.68, c.maxHeight / hero.aspect);
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: size * 1.02,
                        height: size * 1.02,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                      ),
                      BrandIllustration(art: hero, size: size),
                    ],
                  );
                },
              ),
            ),
          ),

        if (showBack || bandAction != null)
          Positioned(
            top: topInset + Insets.sm,
            left: Insets.gutter,
            right: Insets.gutter,
            child: Row(
              children: [
                if (showBack)
                  Pressable(
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    scale: 0.9,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                if (bandAction != null)
                  Flexible(
                    child: Pressable(
                      onTap: onBandAction,
                      scale: 0.95,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Insets.lg,
                          vertical: Insets.sm + 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: Corners.pill,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.26)),
                        ),
                        child: Text(
                          bandAction!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleSmall.copyWith(
                            fontSize: 12.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.radius,
    required this.title,
    required this.subtitle,
    required this.centerTitle,
    required this.children,
  });

  final double radius;
  final String title;
  final String? subtitle;
  final bool centerTitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        boxShadow: Shadows.raised,
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.fromLTRB(
          Insets.gutter + 4,
          Insets.xxl,
          Insets.gutter + 4,
          MediaQuery.viewInsetsOf(context).bottom + Insets.x3l,
        ),
        child: Column(
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: Insets.xl),
                decoration: BoxDecoration(
                  color: AppColors.strokeStrong,
                  borderRadius: Corners.pill,
                ),
              ),
            ),
            Text(
              title,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              style: AppText.displaySmall.copyWith(fontSize: 25, letterSpacing: -0.6),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: Insets.sm + 2),
              Text(
                subtitle!,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                style: AppText.bodyMedium.copyWith(height: 1.55, fontSize: 13.5),
              ),
            ],
            const SizedBox(height: Insets.xxl),
            ...children.map((c) => Align(alignment: Alignment.center, child: c)),
          ],
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({this.label = 'Or', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Insets.md),
          child: Text(
            label,
            style: AppText.bodySmall.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    required this.count,
    required this.index,
    required this.label,
    required this.onNext,
    this.onSkip,
    this.onDark = false,
    super.key,
  });

  final int count;
  final int index;
  final String label;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final Color dotOn = onDark ? Colors.white : AppColors.primary;
    final Color dotOff =
        onDark ? Colors.white.withValues(alpha: 0.34) : AppColors.strokeStrong;

    return Row(
      children: [
        for (var i = 0; i < count; i++) ...[
          AnimatedContainer(
            duration: Motion.normal,
            curve: Motion.enter,
            width: i == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index ? dotOn : dotOff,
              borderRadius: Corners.pill,
            ),
          ),
          const SizedBox(width: Insets.sm - 2),
        ],
        const Spacer(),
        if (onSkip != null) ...[
          Pressable(
            onTap: onSkip,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
              child: Text(
                'Skip',
                style: AppText.titleSmall.copyWith(
                  fontSize: 13,
                  color: onDark ? Colors.white.withValues(alpha: 0.78) : AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: Insets.xs),
        ],
        Pressable(
          onTap: onNext,
          scale: 0.95,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.xxl, vertical: Insets.lg - 1),
            decoration: BoxDecoration(
              color: onDark ? Colors.white : AppColors.primary,
              borderRadius: Corners.pill,
              boxShadow: onDark
                  ? Shadows.lift(const Color(0xFF04101F), opacity: 0.32, blur: 18)
                  : Shadows.lift(AppColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppText.button.copyWith(
                    fontSize: 14.5,
                    color: onDark ? AppColors.textPrimary : Colors.white,
                  ),
                ),
                const SizedBox(width: Insets.sm - 2),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 17,
                  color: onDark ? AppColors.textPrimary : Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
