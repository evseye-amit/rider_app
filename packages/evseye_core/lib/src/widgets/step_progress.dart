import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

class StepProgress extends StatelessWidget {
  const StepProgress({
    required this.steps,
    required this.currentIndex,
    this.onStepTap,
    this.compact = false,
    super.key,
  });

  final List<String> steps;
  final int currentIndex;
  final ValueChanged<int>? onStepTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final int left = i ~/ 2;
              return Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: left < currentIndex ? AppColors.primary : AppColors.stroke,
                    borderRadius: Corners.pill,
                  ),
                ),
              );
            }
            final int index = i ~/ 2;
            return _StepDot(
              index: index,
              label: compact ? null : steps[index],
              state: index < currentIndex
                  ? _DotState.done
                  : index == currentIndex
                      ? _DotState.active
                      : _DotState.todo,
              onTap: onStepTap == null || index > currentIndex ? null : () => onStepTap!(index),
            );
          }),
        ),
        if (compact) ...[
          const SizedBox(height: Insets.sm + 2),
          Text(
            'Step ${currentIndex + 1} of ${steps.length}  ·  ${steps[currentIndex.clamp(0, steps.length - 1)]}',
            style: AppText.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ],
    );
  }
}

enum _DotState { todo, active, done }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.index, required this.state, this.label, this.onTap});

  final int index;
  final _DotState state;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool active = state == _DotState.active;
    final bool done = state == _DotState.done;

    final Widget dot = AnimatedContainer(
      duration: Motion.normal,
      curve: Motion.enter,
      width: active ? 30 : 26,
      height: active ? 30 : 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done || active ? AppColors.primary : AppColors.surface,
        border: Border.all(
          color: done || active ? AppColors.primary : AppColors.strokeStrong,
          width: 1.3,
        ),
      ),
      alignment: Alignment.center,
      child: done
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : Text(
              '${index + 1}',
              style: AppText.titleSmall.copyWith(
                fontSize: active ? 13 : 12,
                color: active ? Colors.white : AppColors.textMuted,
              ),
            ),
    );

    if (label == null) {
      return GestureDetector(onTap: onTap, child: dot);
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            dot,
            const SizedBox(height: Insets.sm - 2),
            Text(
              label!,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodySmall.copyWith(
                fontSize: 10.5,
                height: 1.25,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabeledProgress extends StatelessWidget {
  const LabeledProgress({
    required this.value,
    this.label,
    this.trailingLabel,
    this.color = AppColors.primary,
    this.height = 7,
    super.key,
  });

  final double value;
  final String? label;
  final String? trailingLabel;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || trailingLabel != null) ...[
          Row(
            children: [
              if (label != null)
                Flexible(
                  child: Text(
                    label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12),
                  ),
                ),
              const SizedBox(width: Insets.sm),
              const Spacer(),
              if (trailingLabel != null)
                Text(
                  trailingLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.titleSmall.copyWith(fontSize: 12.5, color: color),
                ),
            ],
          ),
          const SizedBox(height: Insets.sm),
        ],
        ClipRRect(
          borderRadius: Corners.pill,
          child: Stack(
            children: [
              Container(height: height, color: AppColors.surfaceSunken),
              AnimatedFractionallySizedBox(
                duration: Motion.slow,
                curve: Motion.enter,
                widthFactor: value.clamp(0.0, 1.0),
                child: Container(
                  height: height,
                  decoration: BoxDecoration(color: color, borderRadius: Corners.pill),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
