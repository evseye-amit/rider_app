import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.showRule = true,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;
  final bool showRule;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.titleLarge.copyWith(fontSize: 18)),

                if (subtitle != null) ...[
                  const SizedBox(height: Insets.sm),
                  Text(subtitle!, style: AppText.bodySmall),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null)
            Pressable(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionLabel!,
                    style: AppText.titleSmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {this.icon, super.key});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: Insets.sm - 2),
        ],
        Text(text.toUpperCase(), style: AppText.overline),
        const SizedBox(width: Insets.md),
        const Expanded(child: Divider(height: 1)),
      ],
    );
  }
}
