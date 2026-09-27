import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';
import '../widgets/pressable.dart';
import 'app_locale.dart';

class LanguagePicker {
  const LanguagePicker._();

  static Future<AppLocale?> show(BuildContext context, {bool firstRun = false}) {
    return AppSheet.show<AppLocale>(
      context,
      title: tr('Choose your language'),
      subtitle: firstRun
          ? tr('You can change it later from the menu.')
          : tr('The app will change right away.'),
      isDismissible: !firstRun,
      child: _LanguageList(firstRun: firstRun),
    );
  }
}

class _LanguageList extends StatefulWidget {
  const _LanguageList({required this.firstRun});

  final bool firstRun;

  @override
  State<_LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<_LanguageList> {
  AppLocale _selected = AppLocaleController.instance.locale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final AppLocale option in AppLocale.values)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: _LanguageTile(
              option: option,
              selected: option == _selected,
              onTap: () => setState(() => _selected = option),
            ),
          ),
        const SizedBox(height: Insets.md),
        PrimaryButton(
          label: tr('Save'),
          onPressed: () => Navigator.of(context).pop(_selected),
        ),
        const SizedBox(height: Insets.sm),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.option, required this.selected, required this.onTap});

  final AppLocale option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stroke,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.nativeName,
                    style: AppText.titleMedium.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.englishName,
                    style: AppText.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.strokeStrong,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
