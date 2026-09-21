import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

class AppNavTile extends StatelessWidget {
  const AppNavTile({
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
    this.trailing,
    this.showChevron = true,
    this.badge,
    this.destructive = false,
    this.padding = const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md + 2),
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;
  final String? badge;
  final bool destructive;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Color tint = destructive ? AppColors.danger : (iconColor ?? AppColors.primary);

    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.washFor(tint),
                  borderRadius: Corners.brSm,
                ),
                child: Icon(icon, size: 19, color: tint),
              ),
              const SizedBox(width: Insets.md + 2),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.titleSmall.copyWith(
                      fontSize: 14.5,
                      color: destructive ? AppColors.danger : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: Corners.pill,
                ),
                child: Text(
                  badge!,
                  style: AppText.bodySmall.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: Insets.sm),
            ],
            if (trailing != null)
              trailing!
            else if (showChevron)
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

enum CheckState { pending, pass, fail }

class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    required this.title,
    required this.state,
    this.subtitle,
    this.onPass,
    this.onFail,
    this.note,
    super.key,
  });

  final String title;
  final String? subtitle;
  final CheckState state;
  final VoidCallback? onPass;
  final VoidCallback? onFail;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final Color tone = switch (state) {
      CheckState.pending => AppColors.strokeStrong,
      CheckState.pass => AppColors.success,
      CheckState.fail => AppColors.danger,
    };

    return AnimatedContainer(
      duration: Motion.fast,
      padding: const EdgeInsets.all(Insets.md + 2),
      decoration: BoxDecoration(
        color: state == CheckState.pending ? AppColors.surface : AppColors.washFor(tone),
        borderRadius: Corners.brMd,
        border: Border.all(
          color: state == CheckState.pending ? AppColors.stroke : tone.withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.titleSmall.copyWith(fontSize: 14)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: Insets.md),
              _CheckAction(
                icon: Icons.close_rounded,
                active: state == CheckState.fail,
                color: AppColors.danger,
                onTap: onFail,
              ),
              const SizedBox(width: Insets.sm),
              _CheckAction(
                icon: Icons.check_rounded,
                active: state == CheckState.pass,
                color: AppColors.success,
                onTap: onPass,
              ),
            ],
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: Insets.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Insets.sm + 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: Corners.brXs,
              ),
              child: Text(note!, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
            ),
          ],
        ],
      ),
    );
  }
}

class _CheckAction extends StatelessWidget {
  const _CheckAction({
    required this.icon,
    required this.active,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final bool active;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.88,
      child: AnimatedContainer(
        duration: Motion.fast,
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: active ? color : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: active ? color : AppColors.strokeStrong, width: 1.3),
        ),
        child: Icon(icon, size: 18, color: active ? Colors.white : AppColors.textMuted),
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.name,
    this.imageUrl,
    this.size = 44,
    this.showRing = false,
    this.ringColor = AppColors.success,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final bool showRing;
  final Color ringColor;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: showRing ? const EdgeInsets.all(2.5) : EdgeInsets.zero,
      decoration: showRing
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ringColor, width: 2),
            )
          : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          image: imageUrl != null
              ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
              : null,
        ),
        alignment: Alignment.center,
        child: imageUrl != null
            ? null
            : Text(
                _initials,
                style: AppText.titleSmall.copyWith(
                  fontSize: size * 0.34,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
