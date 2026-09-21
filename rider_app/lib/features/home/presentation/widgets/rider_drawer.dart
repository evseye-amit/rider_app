import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/legal/legal_link.dart';
import '../../../../core/session/session_controller.dart';

class RiderDrawer extends StatelessWidget {
  const RiderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();
    final Map<String, Object?> rider = session.profile;
    final String name = rider['name']?.toString() ?? 'Rider';
    final String riderCode = rider['riderCode']?.toString() ?? '—';
    final String hub = rider['hub']?.toString() ?? '—';

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _DrawerHeader(name: name, riderCode: riderCode, hub: hub),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.xxl),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _DrawerItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      subtitle: 'Personal details and KYC',
                      onTap: () => _go(context, Routes.profile),
                    ),
                    _DrawerItem(
                      icon: Icons.support_agent_rounded,
                      label: 'Help & support',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(Routes.support);
                      },
                    ),

                    const SizedBox(height: Insets.md),
                    _DrawerItem(
                      icon: Icons.gavel_rounded,
                      label: 'Terms of service',
                      onTap: () => _openDocument(context),
                    ),
                    _DrawerItem(
                      icon: Icons.privacy_tip_rounded,
                      label: 'Privacy policy',
                      onTap: () => _openDocument(context),
                    ),
                    _DrawerItem(
                      icon: Icons.info_rounded,
                      label: 'About EVSEYE',
                      onTap: () => _openDocument(context),
                    ),

                    const SizedBox(height: Insets.xl),
                    _DrawerItem(
                      icon: Icons.logout_rounded,
                      label: 'Sign out',
                      destructive: true,
                      onTap: () async {
                        final bool confirmed = await AppDialog.confirm(
                          context,
                          title: 'Sign out?',
                          message:
                              'You will need your mobile number and an OTP to sign back in.',
                          confirmLabel: 'Sign out',
                          icon: Icons.logout_rounded,
                          destructive: true,
                        );
                        if (!confirmed || !context.mounted) return;
                        await sl<SessionController>().signOut();
                        if (context.mounted) context.go(Routes.login);
                      },
                    ),
                  ],
                ),
              ),

              Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
              Padding(
                padding: const EdgeInsets.only(top: Insets.lg, bottom: Insets.lg),
                child: Column(
                  children: [
                    const EvseyeLogo(markSize: 26, wordSize: 17, inline: true),
                    const SizedBox(height: Insets.sm),
                    Text(
                      'Version 1.0.0',
                      style: AppText.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.push(route);
  }

  static void _openDocument(BuildContext context) {
    Navigator.of(context).pop();
    LegalLink.open(context);
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.name, required this.riderCode, required this.hub});

  final String name;
  final String riderCode;
  final String hub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xl, Insets.lg, Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: name,
                size: 54,
                showRing: true,
                ringColor: AppColors.primaryBright,
              ),
              const SizedBox(width: Insets.md + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Text(riderCode, style: AppText.code.copyWith(fontSize: 11.5, letterSpacing: 1)),
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
                    hub,
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool destructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppNavTile(
      icon: icon,
      title: label,
      subtitle: subtitle,
      destructive: destructive,
      showChevron: false,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm + 2),
    );
  }
}
