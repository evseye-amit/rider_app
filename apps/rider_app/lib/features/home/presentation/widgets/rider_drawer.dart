import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/legal/legal_link.dart';
import '../../../../core/referral/my_referral.dart';
import '../../../../core/referral/referral_qr_card.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../../../profile/domain/entities/rider_profile.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class RiderDrawer extends ConsumerWidget {
  const RiderDrawer({super.key});

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
    await ref.read(riderSessionProvider.notifier).signOut();
    if (context.mounted) context.go(Routes.login);
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.push(route);
  }

  void _openDocument(BuildContext context, LegalKind kind) {
    Navigator.of(context).pop();
    LegalLink.open(context, kind);
  }

  void _showAbout(BuildContext context) {
    Navigator.of(context).pop();
    AppSheet.show<void>(
      context,
      title: context.l10n.commonAboutApp,
      child: Column(
        children: [
          KeyValueRow(label: context.l10n.legalAppName, value: FlavorConfig.riderAppName, icon: Icons.apps_rounded),
          KeyValueRow(
            label: context.l10n.commonVersion,
            value: FlavorConfig.riderVersion,
            icon: Icons.info_outline_rounded,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RiderProfile? profile = ref.watch(riderProfileProvider).value;
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Colors.transparent,
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _DrawerHeader(
                name: profile?.name ?? context.l10n.allocationRider,
                riderCode: profile?.riderCode,
                mobile: profile?.mobile,
                photoUrl: profile?.photoUrl,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.md, Insets.xxl),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const _ReferralQr(),
                    _DrawerItem(
                      icon: Icons.person_rounded,
                      label: context.l10n.commonProfile,
                      subtitle: context.l10n.profilePersonalDetails,
                      onTap: () => _go(context, Routes.profile),
                    ),
                    _DrawerItem(
                      icon: Icons.support_agent_rounded,
                      label: context.l10n.homeHelpSupport,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push(Routes.support);
                      },
                    ),
                    _DrawerItem(
                      icon: Icons.account_balance_rounded,
                      label: context.l10n.paymentsTitle,
                      subtitle: context.l10n.paymentsSubtitle,
                      onTap: () => _go(context, Routes.payments),
                    ),
                    _DrawerItem(
                      icon: Icons.swap_horiz_rounded,
                      label: context.l10n.exchangeTitle,
                      subtitle: context.l10n.exchangeSubtitle,
                      onTap: () => _go(context, Routes.vehicleExchanges),
                    ),
                    _DrawerItem(
                      icon: Icons.assignment_return_rounded,
                      label: context.l10n.returnsTitle,
                      subtitle: context.l10n.returnsSubtitle,
                      onTap: () => _go(context, Routes.rideReturns),
                    ),
                    const SizedBox(height: Insets.md),
                    _DrawerItem(
                      icon: Icons.language_rounded,
                      label: context.l10n.commonLanguage,
                      subtitle: locale.nativeName,
                      onTap: () => _pickLanguage(context, ref),
                    ),
                    const SizedBox(height: Insets.md),
                    _DrawerItem(
                      icon: Icons.gavel_rounded,
                      label: context.l10n.commonTermsService,
                      onTap: () => _openDocument(context, LegalKind.terms),
                    ),
                    _DrawerItem(
                      icon: Icons.privacy_tip_rounded,
                      label: context.l10n.commonPrivacyPolicy,
                      onTap: () => _openDocument(context, LegalKind.privacy),
                    ),
                    _DrawerItem(
                      icon: Icons.info_rounded,
                      label: context.l10n.commonAboutApp,
                      onTap: () => _showAbout(context),
                    ),
                    const SizedBox(height: Insets.xl),
                    _DrawerItem(
                      icon: Icons.logout_rounded,
                      label: context.l10n.commonSignOut,
                      destructive: true,
                      onTap: () => _signOut(context, ref),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Insets.lg),
                child: Text(
                  '${context.l10n.commonVersion} ${FlavorConfig.riderVersion}',
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

class _ReferralQr extends ConsumerWidget {
  const _ReferralQr();

  void _expand(BuildContext context, MyReferral referral) => AppSheet.show<void>(
    context,
    title: context.l10n.referYourQr,
    subtitle: context.l10n.referYourQrSubtitle,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Insets.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: ReferralQrCard(code: referral.code, data: referral.qrData, title: referral.title),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyReferral? referral = ref.watch(myReferralProvider).value;
    if (referral == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: Pressable(
        onTap: () => _expand(context, referral),
        scale: 0.98,
        child: Container(
          padding: const EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: Corners.brLg,
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Insets.xs + 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: Corners.brSm),
                child: ReferralQrCode(data: referral.qrData, size: 88),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.referDrawerTitle, style: AppText.titleSmall),
                    const SizedBox(height: 2),
                    Text(referral.code, style: AppText.code.copyWith(fontSize: 12.5, letterSpacing: 1)),
                    const SizedBox(height: Insets.xs),
                    Text(
                      context.l10n.referDrawerHint,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 11.5, height: 1.35),
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
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.name, required this.riderCode, required this.mobile, required this.photoUrl});

  final String name;
  final String? riderCode;
  final String? mobile;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final String? mobile = this.mobile;
    final String? riderCode = this.riderCode;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.xl, Insets.xl, Insets.lg, Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: name, imageUrl: photoUrl, size: 54, showRing: true, ringColor: AppColors.primaryBright),
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
                    if (riderCode != null) ...[
                      const SizedBox(height: 3),
                      Text(riderCode, style: AppText.code.copyWith(fontSize: 11.5, letterSpacing: 1)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (mobile != null) ...[
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
                  const Icon(Icons.call_rounded, size: 14, color: AppColors.primaryBright),
                  const SizedBox(width: Insets.sm - 2),
                  Flexible(
                    child: Text(
                      Fmt.phone(mobile),
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
          ],
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
