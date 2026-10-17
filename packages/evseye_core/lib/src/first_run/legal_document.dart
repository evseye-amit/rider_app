import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../api/legal_api.dart';
import '../l10n/l10n.dart';
import '../providers/core_providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/empty_state.dart';

class LegalRequest extends Equatable {
  const LegalRequest({required this.audience, required this.kind, required this.locale});

  final LegalAudience audience;
  final LegalKind kind;
  final String locale;

  @override
  List<Object?> get props => [audience.appCode, audience.role, kind, locale];
}

final legalDocumentProvider = FutureProvider.autoDispose.family<LegalDocumentDto, LegalRequest>(
  (ref, request) async =>
      (await ref
              .watch(legalApiProvider)
              .current(audience: request.audience, kind: request.kind, locale: request.locale))
          .getOrThrow(),
);

class LegalHtmlView extends ConsumerStatefulWidget {
  const LegalHtmlView({required this.request, this.onReady, super.key});

  final LegalRequest request;

  final ValueChanged<LegalDocumentDto>? onReady;

  @override
  ConsumerState<LegalHtmlView> createState() => _LegalHtmlViewState();
}

class _LegalHtmlViewState extends ConsumerState<LegalHtmlView> {
  late final WebViewController _web = WebViewController()
    ..setBackgroundColor(AppColors.surface)
    ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) => _rendered()));

  LegalDocumentDto? _document;
  bool _rendering = true;

  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<LegalDocumentDto>>(legalDocumentProvider(widget.request), (_, next) {
      if (next case AsyncData<LegalDocumentDto>(:final value)) _show(value);
    }, fireImmediately: true);
  }

  void _show(LegalDocumentDto document) {
    if (_document?.id == document.id && _document?.contentHash == document.contentHash) return;
    _document = document;
    if (mounted) setState(() => _rendering = true);
    _web.loadHtmlString(document.content);
  }

  void _rendered() {
    final LegalDocumentDto? document = _document;
    if (!mounted || document == null) return;
    setState(() => _rendering = false);
    widget.onReady?.call(document);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<LegalDocumentDto> document = ref.watch(legalDocumentProvider(widget.request));
    if (document.hasError && !document.isLoading) {
      return ColoredBox(
        color: AppColors.surface,
        child: EmptyState(
          title: context.l10n.legalDocumentCouldNotLoad,
          icon: Icons.cloud_off_rounded,
          actionLabel: context.l10n.commonRetry,
          onAction: () => ref.invalidate(legalDocumentProvider(widget.request)),
          compact: true,
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        WebViewWidget(controller: _web),
        if (document.isLoading || _rendering)
          const ColoredBox(
            color: AppColors.surface,
            child: Center(
              child: SizedBox.square(
                dimension: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

class LegalDocumentPage extends ConsumerWidget {
  const LegalDocumentPage({required this.audience, required this.kind, super.key});

  final LegalAudience audience;
  final LegalKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String locale = ref.watch(localeProvider.select((p) => p.locale.code));
    final LegalRequest request = LegalRequest(audience: audience, kind: kind, locale: locale);
    final String? title = ref.watch(legalDocumentProvider(request)).value?.title;
    return AppScaffold(
      title: title ?? (kind == LegalKind.terms ? context.l10n.commonTermsService : context.l10n.commonPrivacyPolicy),
      body: LegalHtmlView(request: request),
    );
  }
}

class LegalAgreementText extends StatefulWidget {
  const LegalAgreementText({required this.onOpen, super.key});

  final ValueChanged<LegalKind> onOpen;

  @override
  State<LegalAgreementText> createState() => _LegalAgreementTextState();
}

class _LegalAgreementTextState extends State<LegalAgreementText> {
  late final TapGestureRecognizer _terms = TapGestureRecognizer()..onTap = () => widget.onOpen(LegalKind.terms);
  late final TapGestureRecognizer _privacy = TapGestureRecognizer()..onTap = () => widget.onOpen(LegalKind.privacy);

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle base = AppText.bodySmall.copyWith(fontSize: 12, height: 1.5);
    final TextStyle link = base.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700);
    final String terms = context.l10n.authLegalTerms;
    final String privacy = context.l10n.authLegalPrivacy;
    final Map<String, TapGestureRecognizer> links = {terms: _terms, privacy: _privacy};
    final String text = context.l10n.authLegalAgreement(terms, privacy);

    final List<InlineSpan> spans = [];
    int start = 0;
    for (final RegExpMatch match in RegExp(links.keys.map(RegExp.escape).join('|')).allMatches(text)) {
      spans
        ..add(TextSpan(text: text.substring(start, match.start)))
        ..add(TextSpan(text: match[0], style: link, recognizer: links[match[0]]));
      start = match.end;
    }
    spans.add(TextSpan(text: text.substring(start)));

    return Text.rich(
      TextSpan(style: base, children: spans),
      textAlign: TextAlign.center,
    );
  }
}
