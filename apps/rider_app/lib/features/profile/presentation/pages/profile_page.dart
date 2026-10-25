import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/rider_profile.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RiderProfile> profile = ref.watch(riderProfileProvider);

    if (profile.hasError) {
      return Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: EmptyState(
            title: context.l10n.profileCouldNotLoad,
            message: profile.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(riderProfileProvider),
          ),
        ),
      );
    }

    final RiderProfile? rider = profile.value;
    final List<Widget> sections = rider == null
        ? const [_ProfileSkeleton()]
        : [
            if (rider.hasPersonalDetails) _PersonalDetails(profile: rider),
            if (rider.hasAddress) _Address(profile: rider),
            if (rider.hasEmergencyContact)
              _EmergencyContact(name: rider.emergencyContactName, mobile: rider.emergencyContactMobile),
          ];

    return HeroScaffold(
      bottomPadding: Insets.x4l,
      onRefresh: () => ref.refreshQuietly(riderProfileProvider),
      band: _Band(profile: rider),
      children: [
        for (final (int i, Widget section) in sections.indexed) ...[if (i > 0) const Gap.lg(), section],
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.profile});

  final RiderProfile? profile;

  @override
  Widget build(BuildContext context) {
    final RiderProfile? profile = this.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) =>
                  InkCircleButton(icon: Icons.arrow_back_rounded, onTap: () => Navigator.of(context).maybePop()),
            ),
            const Spacer(),
            Text(context.l10n.commonProfile, style: AppText.titleLarge.copyWith(fontSize: 17, color: AppColors.onInk)),
            const Spacer(),
            const SizedBox(width: 40),
          ],
        ),
        if (profile != null) ...[
          const Gap.xl(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(color: Colors.white24, width: 1.4)),
                ),
                child: AppAvatar(name: profile.name ?? '?', imageUrl: profile.photoUrl, size: 72),
              ),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.name ?? context.l10n.allocationRider,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.displaySmall.copyWith(fontSize: 21, color: AppColors.onInk),
                    ),
                    if (profile.riderCode case final String code) ...[
                      const SizedBox(height: 4),
                      Text(
                        code,
                        style: AppText.code.copyWith(
                          fontSize: 11.5,
                          letterSpacing: 1.2,
                          color: AppColors.onInkSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PersonalDetails extends StatelessWidget {
  const _PersonalDetails({required this.profile});

  final RiderProfile profile;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final String? name = profile.name;
    final String? mobile = profile.mobile;
    final DateTime? born = profile.dateOfBirth;
    return _SectionCard(
      icon: Icons.badge_rounded,
      title: l10n.profilePersonalDetails,
      children: [
        if (name != null) KeyValueRow(label: l10n.commonFullName, value: name),
        if (mobile != null) KeyValueRow(label: l10n.commonMobile, value: Fmt.phone(mobile)),
        if (born != null) KeyValueRow(label: l10n.profileDateOfBirth, value: Fmt.date(born)),
      ],
    );
  }
}

class _Address extends StatelessWidget {
  const _Address({required this.profile});

  final RiderProfile profile;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final List<Widget> blocks = [
      if (!profile.currentAddress.isEmpty)
        _AddressBlock(label: l10n.profileCurrentAddress, text: profile.currentAddress.lines.join('\n')),
      if (profile.showsPermanentAddress)
        _AddressBlock(
          label: l10n.profilePermanentAddress,
          text: profile.sameAsCurrentAddress
              ? l10n.profileSameAsCurrentAddress
              : profile.permanentAddress.lines.join('\n'),
        ),
    ];
    return _SectionCard(
      icon: Icons.location_on_rounded,
      title: l10n.profileAddress,
      children: [
        for (final (int i, Widget block) in blocks.indexed) ...[
          if (i > 0) Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
          block,
        ],
      ],
    );
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodySmall.copyWith(fontSize: 12.5)),
          const SizedBox(height: 4),
          Text(
            text,
            style: AppText.bodyMedium.copyWith(
              fontSize: 13.5,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyContact extends StatelessWidget {
  const _EmergencyContact({required this.name, required this.mobile});

  final String? name;
  final String? mobile;

  @override
  Widget build(BuildContext context) {
    final String? name = this.name;
    final String? mobile = this.mobile;
    final String? phone = mobile == null ? null : Fmt.phone(mobile);
    return _SectionCard(
      icon: Icons.contact_phone_rounded,
      title: context.l10n.profileEmergencyContact,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.sm),
          child: Row(
            children: [
              AppAvatar(name: name ?? '?', size: 44),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? phone ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleSmall.copyWith(fontSize: 14),
                    ),
                    if (name != null && phone != null) ...[
                      const SizedBox(height: 2),
                      Text(phone, style: AppText.bodySmall.copyWith(fontSize: 12.5)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.icon, required this.title, required this.children});

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      title: title,
      leading: IconTile(icon: icon, tone: AppColors.primary, size: 34, solid: true),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 210, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 120, borderRadius: Corners.brXl),
        Gap.lg(),
        ShimmerBox(height: 110, borderRadius: Corners.brXl),
      ],
    );
  }
}
