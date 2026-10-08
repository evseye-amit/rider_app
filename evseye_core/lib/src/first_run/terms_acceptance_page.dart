import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../widgets/buttons.dart';
import '../widgets/empty_state.dart';
import '../widgets/inputs.dart';
import 'first_run_scaffold.dart';
import 'legal_document.dart';
import 'terms_consent.dart';

class TermsAcceptancePage extends ConsumerStatefulWidget {
  const TermsAcceptancePage({required this.document, required this.onAccepted, super.key});

  final LegalDocument document;

  final VoidCallback onAccepted;

  @override
  ConsumerState<TermsAcceptancePage> createState() => _TermsAcceptancePageState();
}

enum _DocumentStatus { loading, ready, failed }

class _TermsAcceptancePageState extends ConsumerState<TermsAcceptancePage> {
  late final WebViewController _web;

  _DocumentStatus _status = _DocumentStatus.loading;
  bool _agreed = false;
  bool _accepting = false;

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setBackgroundColor(AppColors.surface)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: _onPageFinished, onWebResourceError: _onError));
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      await switch (widget.document) {
        BundledLegalDocument(:final String asset) => _web.loadFlutterAsset(asset),
        HostedLegalDocument(:final Uri url) => _web.loadRequest(url),
      };
    } on Exception {
      _setStatus(_DocumentStatus.failed);
    }
  }

  void _retry() {
    _setStatus(_DocumentStatus.loading);
    unawaited(_load());
  }

  void _onPageFinished(String _) {
    if (_status == _DocumentStatus.loading) _setStatus(_DocumentStatus.ready);
  }

  void _onError(WebResourceError error) {
    if (error.isForMainFrame ?? true) _setStatus(_DocumentStatus.failed);
  }

  void _setStatus(_DocumentStatus status) {
    if (mounted) setState(() => _status = status);
  }

  Future<void> _accept() async {
    setState(() => _accepting = true);
    await ref.read(termsConsentProvider.notifier).accept();
    if (mounted) widget.onAccepted();
  }

  @override
  Widget build(BuildContext context) {
    final bool ready = _status == _DocumentStatus.ready;

    return FirstRunScaffold(
      icon: Icons.description_rounded,
      title: context.l10n.legalTermsTitle,
      subtitle: context.l10n.legalTermsSubtitle,
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brXl,
          border: Border.all(color: AppColors.stroke),
        ),
        child: ClipRRect(
          borderRadius: Corners.brXl,
          child: Stack(
            fit: StackFit.expand,
            children: [
              WebViewWidget(controller: _web),
              if (_status == _DocumentStatus.loading)
                const ColoredBox(
                  color: AppColors.surface,
                  child: Center(
                    child: SizedBox.square(
                      dimension: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
                    ),
                  ),
                ),
              if (_status == _DocumentStatus.failed)
                ColoredBox(
                  color: AppColors.surface,
                  child: EmptyState(
                    title: context.l10n.legalTermsCouldNotLoad,
                    icon: Icons.cloud_off_rounded,
                    actionLabel: context.l10n.commonRetry,
                    onAction: _retry,
                    compact: true,
                  ),
                ),
            ],
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
                title: context.l10n.legalTermsAgree,
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
