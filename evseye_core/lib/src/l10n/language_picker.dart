import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';
import '../widgets/pressable.dart';
import 'locale_controller.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({required this.selected, super.key});

  final AppLocale selected;

  static Future<AppLocale?> show(
    BuildContext context, {
    required AppLocale selected,
    bool firstRun = false,
  }) {
    final AppL10nLabels labels = AppL10nLabels(context);
    return AppSheet.show<AppLocale>(
      context,
      title: labels.title,
      subtitle: firstRun ? labels.firstRunSubtitle : labels.subtitle,
      isDismissible: !firstRun,
      child: LanguagePicker(selected: selected),
    );
  }

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  late AppLocale _selected = widget.selected;

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
          label: AppL10nLabels(context).save,
          onPressed: () => Navigator.of(context).pop(_selected),
        ),
        const SizedBox(height: Insets.sm),
      ],
    );
  }
}

class AppL10nLabels {
  AppL10nLabels(this.context);

  final BuildContext context;

  String get title => context.l10n.commonChooseLanguage;
  String get subtitle => context.l10n.commonAppWillChangeRightAway;
  String get firstRunSubtitle => context.l10n.commonCanChangeLaterFromMenu;
  String get save => context.l10n.commonSave;
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
                  Text(option.nativeName,
                      style: AppText.titleMedium.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(option.englishName,
                      style: AppText.bodySmall.copyWith(color: AppColors.textSecondary)),
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
