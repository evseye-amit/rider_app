import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';

class AttendanceToggle extends StatelessWidget {
  const AttendanceToggle({
    required this.present,
    required this.onChanged,
    this.width = 104,
    this.height = 36,
    this.presentLabel = 'Present',
    this.absentLabel = 'Absent',
    this.enabled = true,
    super.key,
  });

  final bool present;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  final String presentLabel;
  final String absentLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color tone = present ? AppColors.success : AppColors.danger;
    final double thumb = height - 6;

    return Semantics(
      toggled: present,
      label: 'Attendance',
      child: GestureDetector(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onChanged(!present);
              }
            : null,
        child: AnimatedContainer(
          duration: Motion.normal,
          curve: Motion.smooth,
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.washFor(tone),
            borderRadius: Corners.pill,
            border: Border.all(color: tone.withValues(alpha: 0.35), width: 1.1),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Motion.normal,
                curve: Motion.smooth,
                top: 0,
                bottom: 0,
                left: present ? 0 : thumb + 4,
                right: present ? thumb + 4 : 0,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      present ? presentLabel : absentLabel,
                      maxLines: 1,
                      style: AppText.bodySmall.copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: tone,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: Motion.normal,
                curve: Motion.smooth,
                alignment: present ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: thumb,
                  height: thumb,
                  decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
                  child: Icon(
                    present ? Icons.how_to_reg_rounded : Icons.person_off_rounded,
                    size: thumb * 0.55,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
