import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/legal_api.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/buttons.dart';
import '../widgets/inputs.dart';
import 'consent.dart';
import 'first_run_scaffold.dart';
import 'legal_document.dart';

class ConsentPage extends ConsumerStatefulWidget {
  const ConsentPage({required this.audience, required this.title, required this.onAccepted, super.key});

  final LegalAudience audience;

  final String title;

  final VoidCallback onAccepted;

  @override
  ConsumerState<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends ConsumerState<ConsentPage> {
  LegalDocumentDto? _document;
  bool _agreed = false;
  bool _accepting = false;

  Future<void> _accept() async {
    final LegalDocumentDto? document = _document;
    if (document == null) return;
    setState(() => _accepting = true);
    await ref.read(consentProvider.notifier).accept(documentId: document.id, contentHash: document.contentHash);
    if (mounted) widget.onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    final String locale = ref.watch(localeProvider.select((p) => p.locale.code));
    final bool ready = _document != null;

    return FirstRunScaffold(
      icon: Icons.verified_user_rounded,
      title: widget.title,
      subtitle: context.l10n.consentSubtitle,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brXl,
          border: Border.all(color: AppColors.stroke),
        ),
        child: ClipRRect(
          borderRadius: Corners.brXl,
          child: LegalHtmlView(
            request: LegalRequest(audience: widget.audience, kind: LegalKind.consent, locale: locale),
            onReady: (document) => setState(() => _document = document),
          ),
        ),
      ),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IgnorePointer(
            ignoring: !ready,
            child: AnimatedOpacity(
              duration: Motion.normal,
              opacity: ready ? 1 : 0.5,
              child: AppCheckTile(
                value: _agreed,
                onChanged: (value) => setState(() => _agreed = value),
                title: context.l10n.consentAgree,
              ),
            ),
          ),
          const SizedBox(height: Insets.lg),
          PrimaryButton(
            label: context.l10n.authContinue,
            trailingIcon: Icons.arrow_forward_rounded,
            loading: _accepting,
            onPressed: ready && _agreed ? _accept : null,
          ),
        ],
      ),
    );
  }
}
