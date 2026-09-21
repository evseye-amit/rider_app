import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'app_scaffold.dart';
import 'buttons.dart';

class AppDateWheel {
  const AppDateWheel._();

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime first,
    required DateTime last,
    DateTime? initial,
    String title = 'Select a date',
    String confirmLabel = 'Done',
  }) {
    DateTime start = initial ?? DateTime(last.year, last.month, last.day);
    if (start.isBefore(first)) start = first;
    if (start.isAfter(last)) start = last;
    DateTime selected = DateTime(start.year, start.month, start.day);

    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.md, Insets.lg, Insets.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.stroke,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Gap.lg(),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppText.titleMedium.copyWith(color: AppColors.textPrimary),
                ),
                const Gap.md(),
                SizedBox(
                  height: 216,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      brightness: Brightness.light,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: AppText.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selected,
                      minimumDate: DateTime(first.year, first.month, first.day),
                      maximumDate: DateTime(last.year, last.month, last.day),
                      onDateTimeChanged: (value) => selected = value,
                    ),
                  ),
                ),
                const Gap.lg(),
                PrimaryButton(
                  label: confirmLabel,
                  icon: Icons.check_rounded,
                  onPressed: () => Navigator.of(sheetContext).pop(
                    DateTime(selected.year, selected.month, selected.day),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
