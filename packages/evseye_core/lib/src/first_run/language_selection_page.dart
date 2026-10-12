import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import '../widgets/buttons.dart';
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

  Future<void> _continue() async {
    setState(() => _saving = true);
    await ref.read(localeProvider.notifier).select(_selected);
    if (mounted) widget.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    final AppL10nLabels labels = AppL10nLabels(context);

    return FirstRunScaffold(
      icon: Icons.translate_rounded,
      title: labels.title,
      subtitle: labels.firstRunSubtitle,
      body: SingleChildScrollView(
        child: LanguageOptions(selected: _selected, onChanged: (locale) => setState(() => _selected = locale)),
      ),
      footer: PrimaryButton(
        label: context.l10n.authContinue,
        trailingIcon: Icons.arrow_forward_rounded,
        loading: _saving,
        onPressed: _continue,
      ),
    );
  }
}
