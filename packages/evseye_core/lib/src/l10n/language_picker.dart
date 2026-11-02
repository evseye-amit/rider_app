import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/buttons.dart';
import '../widgets/feedback.dart';
import '../widgets/pressable.dart';
import 'l10n.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({required this.selected, super.key});

  final AppLocale selected;

  static Future<AppLocale?> show(BuildContext context, {required AppLocale selected}) {
    return showModalBottomSheet<AppLocale>(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LanguagePicker(selected: selected),
    );
  }

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  late AppLocale _selected = widget.selected;

  @override
  Widget build(BuildContext context) {
    final AppL10n labels = lookupAppL10n(_selected.locale);
    return AppSheet(
      title: labels.commonChooseLanguage,
      subtitle: labels.commonAppWillChangeRightAway,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LanguageOptions(selected: _selected, onChanged: (option) => setState(() => _selected = option)),
          const SizedBox(height: Insets.md),
          PrimaryButton(label: labels.commonSave, onPressed: () => Navigator.of(context).pop(_selected)),
          const SizedBox(height: Insets.sm),
        ],
      ),
    );
  }
}

class LanguageOptions extends StatelessWidget {
  const LanguageOptions({
    required this.selected,
    required this.onChanged,
    this.options = AppLocale.values,
    this.nativeNames = const {},
    this.englishNames = const {},
    super.key,
  });

  final AppLocale selected;
  final ValueChanged<AppLocale> onChanged;
  final List<AppLocale> options;
  final Map<String, String> nativeNames;
  final Map<String, String> englishNames;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final AppLocale option in options)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: _LanguageTile(
              option: option,
              selected: option == selected,
              nativeName: nativeNames[option.code] ?? option.nativeName,
              englishName: englishNames[option.code] ?? option.englishName,
              onTap: () => onChanged(option),
            ),
          ),
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
  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.nativeName,
    required this.englishName,
    required this.onTap,
  });

  final AppLocale option;
  final bool selected;
  final String nativeName;
  final String englishName;
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
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nativeName, style: AppText.titleMedium.copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(englishName, style: AppText.bodySmall.copyWith(color: AppColors.textSecondary)),
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
