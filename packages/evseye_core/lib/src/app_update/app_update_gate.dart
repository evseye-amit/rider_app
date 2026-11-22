import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/app_update_api.dart';
import '../first_run/company.dart';
import '../l10n/l10n.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/buttons.dart';
import '../widgets/glass_card.dart';
import '../widgets/illustrations.dart';
import 'app_update_provider.dart';

class AppUpdateGate extends ConsumerStatefulWidget {
  const AppUpdateGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppUpdateGate> createState() => _AppUpdateGateState();
}

class _AppUpdateGateState extends ConsumerState<AppUpdateGate> with WidgetsBindingObserver {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lifecycle = AppLifecycleListener(onResume: () => ref.read(appUpdateProvider.notifier).onResume());
    ref.listenManual(companyProvider.select((company) => company?.code), (previous, next) {
      if (previous != next) ref.read(appUpdateProvider.notifier).contextChanged(clientChanged: true);
    });
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _handleBack() {
    final AppUpdateState update = ref.read(appUpdateProvider);
    if (update.blocked) return true;
    if (update.optional == null) return false;
    ref.read(appUpdateProvider.notifier).dismissOptional();
    return true;
  }

  @override
  Future<bool> didPopRoute() async => _handleBack();

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    final AppUpdateState update = ref.read(appUpdateProvider);
    return update.blocked || update.optional != null;
  }

  @override
  void handleCommitBackGesture() => _handleBack();

  @override
  Widget build(BuildContext context) {
    final (AppUpdateDecision? required, AppUpdateDecision? optional) = ref.watch(
      appUpdateProvider.select((state) => (state.required, state.optional)),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(
          offstage: required != null,
          child: TickerMode(enabled: required == null, child: widget.child),
        ),
        if (required != null)
          _ForceUpdatePage(decision: required)
        else if (optional != null)
          _OptionalUpdatePrompt(decision: optional),
      ],
    );
  }
}

Future<bool> _openStore(String? url) async {
  final Uri? uri = url == null ? null : Uri.tryParse(url);
  if (uri == null || uri.scheme != 'https') return false;
  if (uri.host != (Platform.isIOS ? 'apps.apple.com' : 'play.google.com')) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Object {
    return false;
  }
}

class _OptionalUpdatePrompt extends ConsumerStatefulWidget {
  const _OptionalUpdatePrompt({required this.decision});

  final AppUpdateDecision decision;

  @override
  ConsumerState<_OptionalUpdatePrompt> createState() => _OptionalUpdatePromptState();
}

class _OptionalUpdatePromptState extends ConsumerState<_OptionalUpdatePrompt> {
  bool _storeFailed = false;

  Future<void> _update() async {
    setState(() => _storeFailed = false);
    final bool opened = await _openStore(widget.decision.storeUrl);
    if (!opened && mounted) setState(() => _storeFailed = true);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AppUpdateDecision decision = widget.decision;
    final String? notes = decision.releaseNotes?.trim();

    return Stack(
      fit: StackFit.expand,
      children: [
        ModalBarrier(
          color: const Color(0x8A000000),
          onDismiss: () => ref.read(appUpdateProvider.notifier).dismissOptional(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.xl, Insets.gutter, Insets.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const IconTile(icon: Icons.system_update_rounded, solid: true, size: 44),
                        const SizedBox(width: Insets.md),
                        Expanded(
                          child: Text(
                            decision.title?.trim().isNotEmpty == true
                                ? decision.title!.trim()
                                : l10n.appUpdateAvailableTitle,
                            style: AppText.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const Gap.md(),
                    Text(
                      decision.message?.trim().isNotEmpty == true
                          ? decision.message!.trim()
                          : l10n.appUpdateAvailableMessage,
                      style: AppText.bodyMedium.copyWith(height: 1.45),
                    ),
                    if (notes != null && notes.isNotEmpty) ...[
                      const Gap.md(),
                      AccentCard(
                        accent: AppColors.info,
                        child: Text(notes, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
                      ),
                    ],
                    if (_storeFailed) ...[
                      const Gap.md(),
                      Text(l10n.appUpdateStoreError, style: AppText.bodySmall.copyWith(color: AppColors.danger)),
                    ],
                    const Gap.lg(),
                    PrimaryButton(label: l10n.appUpdateNow, icon: Icons.system_update_rounded, onPressed: _update),
                    const Gap.sm(),
                    Center(
                      child: GhostButton(
                        label: l10n.appUpdateLater,
                        onPressed: () => ref.read(appUpdateProvider.notifier).dismissOptional(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ForceUpdatePage extends ConsumerStatefulWidget {
  const _ForceUpdatePage({required this.decision});

  final AppUpdateDecision decision;

  @override
  ConsumerState<_ForceUpdatePage> createState() => _ForceUpdatePageState();
}

class _ForceUpdatePageState extends ConsumerState<_ForceUpdatePage> {
  bool _storeFailed = false;

  Future<void> _update() async {
    setState(() => _storeFailed = false);
    final bool opened = await _openStore(widget.decision.storeUrl);
    if (!opened && mounted) setState(() => _storeFailed = true);
  }

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final AppUpdateDecision decision = widget.decision;
    final bool checking = ref.watch(appUpdateProvider.select((state) => state.checking));
    final String? notes = decision.releaseNotes?.trim();

    return AppScaffold(
      showBack: false,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(label: l10n.appUpdateNow, icon: Icons.system_update_rounded, onPressed: _update),
          const Gap.sm(),
          GhostButton(
            label: l10n.commonTryAgain,
            icon: Icons.refresh_rounded,
            onPressed: checking ? null : () => ref.read(appUpdateProvider.notifier).check(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.gutter, vertical: Insets.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: IconTile(icon: Icons.system_update_rounded, solid: true, size: 72)),
              const Gap.xl(),
              Text(
                decision.title?.trim().isNotEmpty == true ? decision.title!.trim() : l10n.appUpdateTitle,
                textAlign: TextAlign.center,
                style: AppText.titleLarge,
              ),
              const Gap.md(),
              Text(
                decision.message?.trim().isNotEmpty == true ? decision.message!.trim() : l10n.appUpdateMessage,
                textAlign: TextAlign.center,
                style: AppText.bodyMedium.copyWith(height: 1.45),
              ),
              if (notes != null && notes.isNotEmpty) ...[
                const Gap.xl(),
                AccentCard(
                  accent: AppColors.info,
                  child: Text(notes, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45)),
                ),
              ],
              if (_storeFailed) ...[
                const Gap.lg(),
                Text(
                  l10n.appUpdateStoreError,
                  textAlign: TextAlign.center,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
