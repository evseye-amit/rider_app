import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'pressable.dart';

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.counts = const {},
    this.height = 42,
    super.key,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  final Map<int, int> counts;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tabWidth = (constraints.maxWidth - 10) / items.length;
        return Container(
          height: height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: Corners.pill,
            border: Border.all(color: AppColors.stroke),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Motion.normal,
                curve: Motion.smooth,
                left: tabWidth * selectedIndex,
                width: tabWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: Corners.pill,
                    boxShadow: Shadows.card,
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (i) {
                  final bool active = i == selectedIndex;
                  final int? count = counts[i];
                  return SizedBox(
                    width: tabWidth,
                    child: Pressable(
                      onTap: () => onChanged(i),
                      scale: 0.96,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                items[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.titleSmall.copyWith(
                                  fontSize: 13,
                                  color: active ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                              ),
                            ),
                            if (count != null && count > 0) ...[
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: active ? AppColors.primaryWash : AppColors.surfaceSunken,
                                  borderRadius: Corners.pill,
                                ),
                                child: Text(
                                  '$count',
                                  style: AppText.bodySmall.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: active ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: Insets.gutter),
    super.key,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: Insets.sm),
        itemBuilder: (context, i) {
          final bool active = i == selectedIndex;
          return Pressable(
            onTap: () => onChanged(i),
            scale: 0.95,
            child: AnimatedContainer(
              duration: Motion.fast,
              padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.primaryWash : AppColors.surface,
                borderRadius: Corners.pill,
                border: Border.all(color: active ? AppColors.primary : AppColors.stroke),
              ),
              child: Text(
                items[i],
                style: AppText.titleSmall.copyWith(
                  fontSize: 12.5,
                  color: active ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
