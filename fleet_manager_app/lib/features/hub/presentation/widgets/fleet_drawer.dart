import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/legal/legal_link.dart';
import '../../../../core/session/session_controller.dart';

class FleetDrawer extends StatelessWidget {
  const FleetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionController session = sl<SessionController>();

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _Header(session: session),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.xxl),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _Item(
                      icon: Icons.dashboard_rounded,
                      label: 'Home',
                      subtitle: 'Your hub at a glance',
                      onTap: () => _goTab(context, Routes.home),
                    ),
                    _Item(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Allocation',
                      onTap: () => _goTab(context, Routes.allocations),
                    ),
                    _Item(
                      icon: Icons.assignment_return_rounded,
                      label: 'De-allocation',
                      onTap: () => _goTab(context, Routes.deallocations),
                    ),
                    _Item(
                      icon: Icons.build_rounded,
                      label: 'Maintenance',
                      onTap: () => _goTab(context, Routes.maintenance),
                    ),

                    const SizedBox(height: Insets.md),
                    _Item(
                      icon: Icons.gavel_rounded,
                      label: 'Terms of service',
                      onTap: () => _openDocument(context),
                    ),
                    _Item(
                      icon: Icons.privacy_tip_rounded,
                      label: 'Privacy policy',
                      onTap: () => _openDocument(context),
                    ),
                    _Item(
                      icon: Icons.info_rounded,
                      label: 'About EVSEYE',
                      onTap: () => _openDocument(context),
                    ),

                    const SizedBox(height: Insets.xl),
                    _Item(
                      icon: Icons.logout_rounded,
                      label: 'Sign out',
                      destructive: true,
                      onTap: () async {
                        final bool ok = await AppDialog.confirm(
                          context,
                          title: 'Sign out?',
                          message: 'You will need your mobile number and an OTP to sign back in.',
                          confirmLabel: 'Sign out',
                          icon: Icons.logout_rounded,
                          destructive: true,
                        );
                        if (!ok || !context.mounted) return;
                        session.signOut();
                        context.go(Routes.login);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.lg),
                child: Column(
                  children: [
                    const EvseyeLogo(markSize: 26, wordSize: 17, inline: true),
                    const SizedBox(height: Insets.sm),
                    Text(
                      'Fleet Manager · v1.0.0',
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

  static void _goTab(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  static void _openDocument(BuildContext context) {
    Navigator.of(context).pop();
    LegalLink.open(context);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.session});

  final SessionController session;

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
                name: session.managerName,
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
                      session.managerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Fleet Manager',
                      style: AppText.bodySmall.copyWith(fontSize: 12),
                    ),
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
                    '${session.hubName} · ${session.hubCode}',
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
  const _Item({
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
