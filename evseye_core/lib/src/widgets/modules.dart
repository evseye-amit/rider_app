import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'brand_photo.dart';
import 'pressable.dart';

class ModuleCard extends StatelessWidget {
  const ModuleCard({
    required this.child,
    this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.all(Insets.lg),
    this.leading,
    super.key,
  });

  final Widget child;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: Insets.sm + 2)],
                Expanded(
                  child: Text(
                    title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleMedium.copyWith(fontSize: 15.5),
                  ),
                ),
                if (actionLabel != null)
                  Pressable(
                    onTap: onAction,
                    child: Row(
                      children: [
                        Text(
                          actionLabel!,
                          style: AppText.titleSmall.copyWith(
                            fontSize: 12.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 17,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Insets.lg),
          ],
          child,
        ],
      ),
    );
  }
}

class ServiceItem {
  const ServiceItem({
    required this.label,
    required this.icon,
    required this.tone,
    this.onTap,
    this.badge,
  });

  final String label;
  final IconData icon;
  final Color tone;
  final VoidCallback? onTap;

  final String? badge;
}

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({
    required this.items,
    this.columns = 4,
    this.iconSize = 46,
    super.key,
  });

  final List<ServiceItem> items;
  final int columns;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int rows = (items.length / columns).ceil();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var r = 0; r < rows; r++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var c = 0; c < columns; c++)
                    Expanded(
                      child: r * columns + c < items.length
                          ? _ServiceCell(
                              item: items[r * columns + c],
                              iconSize: iconSize,
                            )
                          : const SizedBox.shrink(),
                    ),
                ],
              ),
              if (r != rows - 1) const SizedBox(height: Insets.lg + 2),
            ],
          ],
        );
      },
    );
  }
}

class _ServiceCell extends StatelessWidget {
  const _ServiceCell({required this.item, required this.iconSize});

  final ServiceItem item;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: item.onTap,
      scale: 0.92,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  color: item.tone,
                  borderRadius: BorderRadius.circular(iconSize * 0.32),

                  boxShadow: [
                    BoxShadow(
                      color: item.tone.withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(item.icon, size: iconSize * 0.50, color: Colors.white),
              ),
              if (item.badge != null)
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: Corners.pill,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                    child: Text(
                      item.badge!,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Insets.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              item.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySmall.copyWith(
                fontSize: 11,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StripAction {
  const StripAction({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
}

class BalanceStrip extends StatelessWidget {
  const BalanceStrip({
    required this.label,
    required this.amount,
    required this.actions,
    this.caption,
    this.onTapBalance,
    this.tone = AppColors.primary,
    super.key,
  });

  final String label;
  final String amount;
  final String? caption;
  final List<StripAction> actions;
  final VoidCallback? onTapBalance;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        boxShadow: Shadows.floating,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Pressable(
                onTap: onTapBalance,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.lg, Insets.md, Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: AppColors.washFor(tone),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_rounded,
                              size: 13,
                              color: tone,
                            ),
                          ),
                          const SizedBox(width: Insets.sm - 2),
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodySmall.copyWith(fontSize: 11.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Insets.sm - 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(amount, style: AppText.numeric.copyWith(fontSize: 22)),
                      ),
                      if (caption != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          caption!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(
                            fontSize: 10.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            for (final action in actions) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                child: SizedBox(
                  width: 1,
                  child: ColoredBox(color: AppColors.stroke, child: const SizedBox.expand()),
                ),
              ),
              Expanded(
                flex: 3,
                child: Pressable(
                  onTap: action.onTap,
                  scale: 0.94,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.lg,
                      horizontal: Insets.xs,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.washFor(tone),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(action.icon, size: 17, color: tone),
                        ),
                        const SizedBox(height: Insets.sm - 1),
                        Text(
                          action.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PromoItem {
  const PromoItem({
    required this.title,
    required this.subtitle,
    this.photo,
    this.tone = AppColors.primary,
    this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final BrandPhoto? photo;
  final Color tone;
  final IconData? icon;
  final VoidCallback? onTap;
}

class PromoCarousel extends StatelessWidget {
  const PromoCarousel({
    required this.items,
    this.height = 132,
    this.cardWidth = 268,
    this.padding = const EdgeInsets.symmetric(horizontal: Insets.gutter),
    super.key,
  });

  final List<PromoItem> items;
  final double height;
  final double cardWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: Insets.md),
        itemBuilder: (context, i) {
          final PromoItem item = items[i];
          return SizedBox(
            width: cardWidth,
            child: item.photo != null
                ? PhotoPanel(
                    photo: item.photo!,
                    height: height,
                    title: item.title,
                    subtitle: item.subtitle,
                    onTap: item.onTap,
                  )
                : Pressable(
                    onTap: item.onTap,
                    scale: 0.98,
                    child: Container(
                      padding: const EdgeInsets.all(Insets.lg),
                      decoration: BoxDecoration(
                        color: AppColors.washFor(item.tone),
                        borderRadius: Corners.brXl,
                        border: Border.all(color: item.tone.withValues(alpha: 0.16)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.icon != null) ...[
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: item.tone,
                                borderRadius: Corners.brSm,
                              ),
                              child: Icon(item.icon, size: 18, color: Colors.white),
                            ),
                            const Spacer(),
                          ],
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.titleMedium.copyWith(fontSize: 14.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.35),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
