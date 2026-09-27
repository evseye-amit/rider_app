import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/pressable.dart';
import 'language_picker.dart';
import 'locale_controller.dart';

/// Compact language switcher for the sign-in screens, so the language can be
/// changed again after the first-run prompt.
class LanguageChip extends StatelessWidget {
  const LanguageChip({
    required this.controller,
    this.onChanged,
    this.onInk = true,
    super.key,
  });

  final LocaleController controller;
  final ValueChanged<AppLocale>? onChanged;

  /// True when the chip sits on the dark brand band.
  final bool onInk;

  Future<void> _open(BuildContext context) async {
    final AppLocale? picked = await LanguagePicker.show(
      context,
      selected: controller.current,
    );
    if (picked == null) return;
    await controller.select(picked);
    onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final Color ink = onInk ? Colors.white : AppColors.textPrimary;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Pressable(
        onTap: () => _open(context),
        scale: 0.95,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
          decoration: BoxDecoration(
            color: onInk ? Colors.white.withValues(alpha: 0.18) : AppColors.surfaceMuted,
            borderRadius: Corners.pill,
            border: Border.all(
              color: onInk ? Colors.white.withValues(alpha: 0.24) : AppColors.stroke,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language_rounded, size: 16, color: ink),
              const SizedBox(width: Insets.xs + 2),
              Text(
                controller.current.nativeName,
                style: AppText.titleSmall.copyWith(fontSize: 13, color: ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
