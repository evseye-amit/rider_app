import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../api/company_api.dart';
import '../l10n/l10n.dart';
import '../utils/result.dart';
import '../widgets/buttons.dart';
import 'company.dart';
import 'first_run_scaffold.dart';

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
        : ref.watch(companyLanguagesProvider(code));
    final BootstrapLanguages? data = bootstrap.value;
    final List<AppLocale> options = data?.locales ?? const <AppLocale>[];
    final AppLocale selected = options.contains(_selected) ? _selected : (options.isEmpty ? _selected : options.first);
    final Map<String, String> nativeNames = data?.nativeNames ?? const <String, String>{};
    final Map<String, String> englishNames = data?.englishNames ?? const <String, String>{};

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
                      onPressed: () => ref.invalidate(companyLanguagesProvider(code!)),
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
