import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/legal/legal_link.dart';
import '../../../../core/session/fleet_session_provider.dart';

class FleetDrawer extends ConsumerWidget {
  const FleetDrawer({super.key});

  Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
    final AppLocale? picked = await LanguagePicker.show(context, selected: ref.read(localeProvider).locale);
    if (picked != null) await ref.read(localeProvider.notifier).select(picked);
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.commonSignOut2,
      message: context.l10n.commonWillNeedMobileNumberOtp,
      confirmLabel: context.l10n.commonSignOut,
      icon: Icons.logout_rounded,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(fleetSessionProvider.notifier).signOut();
    if (context.mounted) context.go(Routes.login);
  }

  void _goTab(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  void _openDocument(BuildContext context) {
    Navigator.of(context).pop();
    LegalLink.open(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _Header(managerName: session.managerName, hubName: session.hubName, hubCode: session.hubCode),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.xxl),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _Item(
                      icon: Icons.dashboard_rounded,
                      label: context.l10n.hubHome,
                      subtitle: context.l10n.hubHubGlance,
                      onTap: () => _goTab(context, Routes.home),
                    ),
                    _Item(
                      icon: Icons.swap_horiz_rounded,
                      label: context.l10n.commonAllocation,
                      onTap: () => _goTab(context, Routes.allocations),
                    ),
                    _Item(
                      icon: Icons.assignment_return_rounded,
                      label: context.l10n.commonDeAllocation,
                      onTap: () => _goTab(context, Routes.deallocations),
                    ),
                    _Item(
                      icon: Icons.build_rounded,
                      label: context.l10n.hubMaintenance,
                      onTap: () => _goTab(context, Routes.maintenance),
                    ),
                    const SizedBox(height: Insets.md),
                    _Item(
                      icon: Icons.language_rounded,
                      label: context.l10n.commonLanguage,
                      subtitle: locale.nativeName,
                      onTap: () => _pickLanguage(context, ref),
                    ),
                    const SizedBox(height: Insets.md),
                    _Item(
                      icon: Icons.gavel_rounded,
                      label: context.l10n.commonTermsService,
                      onTap: () => _openDocument(context),
                    ),
                    _Item(
                      icon: Icons.privacy_tip_rounded,
                      label: context.l10n.commonPrivacyPolicy,
                      onTap: () => _openDocument(context),
                    ),
                    _Item(
                      icon: Icons.info_rounded,
                      label: context.l10n.commonAboutApp,
                      onTap: () => _openDocument(context),
                    ),
                    const SizedBox(height: Insets.xl),
                    _Item(
                      icon: Icons.logout_rounded,
                      label: context.l10n.commonSignOut,
                      destructive: true,
                      onTap: () => _signOut(context, ref),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.lg),
                child: Text(
                  '${context.l10n.commonVersion} 1.0.0',
                  style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.managerName, required this.hubName, required this.hubCode});

  final String managerName;
  final String hubName;
  final String hubCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xl, Insets.lg, Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: managerName, size: 54, showRing: true, ringColor: AppColors.primaryBright),
              const SizedBox(width: Insets.md + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      managerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Text(context.l10n.hubFleetManager, style: AppText.bodySmall.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: Corners.pill,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hub_rounded, size: 14, color: AppColors.primaryBright),
                const SizedBox(width: Insets.sm - 2),
                Flexible(
                  child: Text(
                    '$hubName · $hubCode',
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBright,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.label, required this.onTap, this.subtitle, this.destructive = false});

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool destructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppNavTile(
    icon: icon,
    title: label,
    subtitle: subtitle,
    destructive: destructive,
    showChevron: false,
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
  );
}
