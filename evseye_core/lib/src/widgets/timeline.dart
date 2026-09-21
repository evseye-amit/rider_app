import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'status_chip.dart';

class TimelineRow extends StatelessWidget {
  const TimelineRow({
    required this.title,
    required this.done,
    required this.current,
    required this.isLast,
    this.time,
    this.currentLabel = 'Now',
    super.key,
  });

  final String title;
  final bool done;
  final bool current;
  final bool isLast;
  final String? time;

  final String currentLabel;

  @override
  Widget build(BuildContext context) {
    final Color tone = done ? AppColors.success : (current ? AppColors.primary : AppColors.textMuted);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: done
                      ? AppColors.washFor(AppColors.success)
                      : (current ? AppColors.primaryWash : AppColors.surfaceMuted),
                  shape: BoxShape.circle,
                  border: Border.all(color: tone.withValues(alpha: done || current ? 0.4 : 0.2)),
                ),
                child: Icon(
                  done
                      ? Icons.check_rounded
                      : (current ? Icons.radio_button_checked_rounded : Icons.circle_outlined),
                  size: 14,
                  color: tone,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.4,
                    color: AppColors.stroke,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Insets.md, top: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppText.titleSmall.copyWith(
                        fontSize: 13,
                        color: current || done ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                  ),
                  if (time != null) Text(time!, style: AppText.bodySmall.copyWith(fontSize: 11)),
                  if (current)
                    StatusChip(label: currentLabel, tone: StatusTone.brand, dense: true, showDot: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
