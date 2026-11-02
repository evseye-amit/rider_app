import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/company_api.dart';
import '../api/legal_api.dart';
import '../l10n/l10n.dart';
import '../providers/core_providers.dart';
import '../utils/result.dart';
import '../widgets/buttons.dart';
import 'company.dart';
import 'first_run_scaffold.dart';

final _bootstrapLanguagesProvider = FutureProvider.family<BootstrapLanguages, String>((ref, code) async {
  final Result<BootstrapLanguages> result = await ref
      .read(companyApiProvider)
      .languages(code: code, audience: LegalAudience.rider);
  final BootstrapLanguages languages = result.getOrThrow();
  if (!languages.options.any((language) => AppLocale.values.any((locale) => locale.code == language.code))) {
    throw const ValidationFailure('No available language has an app translation.');
  }
  return languages;
});

class LanguageSelectionPage extends ConsumerStatefulWidget {
  const LanguageSelectionPage({required this.onSelected, super.key});

  final VoidCallback onSelected;

  @override
  ConsumerState<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends ConsumerState<LanguageSelectionPage> {
  late AppLocale _selected = ref.read(localeProvider).locale;
  bool _saving = false;

  Future<void> _continue(AppLocale locale) async {
    setState(() => _saving = true);
    try {
      await ref.read(localeProvider.notifier).select(locale);
      if (mounted) widget.onSelected();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? code = ref.watch(companyProvider)?.code;
    final AsyncValue<BootstrapLanguages> bootstrap = code == null
        ? const AsyncLoading<BootstrapLanguages>()
        : ref.watch(_bootstrapLanguagesProvider(code));
    final BootstrapLanguages? data = bootstrap.value;
    final List<AppLocale> options = [
      for (final BootstrapLanguage language in data?.options ?? const <BootstrapLanguage>[])
        for (final AppLocale locale in AppLocale.values)
          if (locale.code == language.code) locale,
    ];
    final AppLocale selected = options.contains(_selected) ? _selected : (options.isEmpty ? _selected : options.first);
    final Map<String, String> nativeNames = {
      for (final BootstrapLanguage language in data?.options ?? const <BootstrapLanguage>[])
        language.code: language.nativeName,
    };
    final Map<String, String> englishNames = {
      for (final BootstrapLanguage language in data?.options ?? const <BootstrapLanguage>[])
        language.code: language.name,
    };

    return Localizations.override(
      context: context,
      locale: selected.locale,
      child: Builder(
        builder: (localizedContext) {
          final AppL10nLabels labels = AppL10nLabels(localizedContext);
          return FirstRunScaffold(
            icon: Icons.translate_rounded,
            title: labels.title,
            subtitle: labels.firstRunSubtitle,
            body: switch (bootstrap) {
              AsyncError(:final error) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(error is Failure ? error.message : localizedContext.l10n.commonSomethingWentWrongPleaseTry),
                    TextButton(
                      onPressed: () => ref.invalidate(_bootstrapLanguagesProvider(code!)),
                      child: Text(localizedContext.l10n.commonTryAgain),
                    ),
                  ],
                ),
              ),
              AsyncData() => SingleChildScrollView(
                child: LanguageOptions(
                  selected: selected,
                  options: options,
                  nativeNames: nativeNames,
                  englishNames: englishNames,
                  onChanged: (locale) => setState(() => _selected = locale),
                ),
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
            footer: PrimaryButton(
              label: localizedContext.l10n.authContinue,
              trailingIcon: Icons.arrow_forward_rounded,
              loading: _saving,
              onPressed: options.isNotEmpty && bootstrap is AsyncData<BootstrapLanguages> && !_saving
                  ? () => _continue(selected)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
