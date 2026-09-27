import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/pressable.dart';
import 'app_locale.dart';
import 'language_picker.dart';
import 'locale_provider.dart';

class LanguageChip extends ConsumerWidget {
  const LanguageChip({this.onInk = true, super.key});

  final bool onInk;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final AppLocale? picked = await LanguagePicker.show(context, selected: ref.read(localeProvider).locale);
    if (picked == null) return;
    await ref.read(localeProvider.notifier).select(picked);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));
    final Color ink = onInk ? Colors.white : AppColors.textPrimary;

    return Pressable(
      onTap: () => _open(context, ref),
      scale: 0.95,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: onInk ? Colors.white.withValues(alpha: 0.18) : AppColors.surfaceMuted,
          borderRadius: Corners.pill,
          border: Border.all(color: onInk ? Colors.white.withValues(alpha: 0.24) : AppColors.stroke),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language_rounded, size: 16, color: ink),
            const SizedBox(width: Insets.xs + 2),
            Text(locale.nativeName, style: AppText.titleSmall.copyWith(fontSize: 13, color: ink)),
          ],
        ),
      ),
    );
  }
}
