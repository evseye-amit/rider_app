import 'dart:ui' show ImageFilter;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.canvas,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeroBand(
            padding: EdgeInsets.fromLTRB(Insets.gutter, Insets.md, Insets.gutter, Insets.xxl),
            child: _TeamBand(),
          ),
          Expanded(child: _HubTeamPreview()),
        ],
      ),
    );
  }
}

class _TeamBand extends StatelessWidget {
  const _TeamBand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconTile(icon: Icons.groups_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Text(
            context.l10n.ridersTeam,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
          ),
        ),
      ],
    );
  }
}

class _HubTeamPreview extends StatelessWidget {
  const _HubTeamPreview();

  @override
  Widget build(BuildContext context) {
    final List<(String, String, IconData)> members = [
      ('Ravi Kumar', context.l10n.teamTechnician, Icons.engineering_rounded),
      ('Sandeep Naik', context.l10n.teamBatteryExpert, Icons.battery_charging_full_rounded),
      ('Faisal Shaikh', context.l10n.teamMotorControllerRepair, Icons.electrical_services_rounded),
      ('Priya Menon', context.l10n.teamAdvisor, Icons.support_agent_rounded),
    ];
    final double bottom = MediaQuery.paddingOf(context).bottom;

    return Stack(
      fit: StackFit.expand,
      children: [
        ExcludeSemantics(
          child: ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 3.2, sigmaY: 3.2, tileMode: TileMode.decal),
              child: Opacity(
                opacity: 0.5,
                child: ListView.builder(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.lg, Insets.gutter, 0),
                  itemCount: 16,
                  itemBuilder: (context, i) {
                    final (String name, String role, IconData icon) = members[i % members.length];
                    return Column(
                      children: [
                        _TeamMemberRow(name: name, role: role, icon: icon),
                        const Gap.md(),
                        Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
                        const Gap.md(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(Insets.gutter, Insets.lg, Insets.gutter, bottom + Insets.lg),
          child: Center(
            child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: const _NotIncludedCard()),
          ),
        ),
      ],
    );
  }
}

class _NotIncludedCard extends StatelessWidget {
  const _NotIncludedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Insets.lg, Insets.lg, Insets.lg, Insets.lg + 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: Shadows.floating,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconTile(icon: Icons.lock_rounded, solid: true, size: 52),
          const Gap.md(),
          Text(
            context.l10n.teamNotIncluded,
            textAlign: TextAlign.center,
            style: AppText.titleLarge.copyWith(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const Gap.xs(),
          Text(
            context.l10n.teamNotIncludedMessage,
            textAlign: TextAlign.center,
            style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.45, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberRow extends StatelessWidget {
  const _TeamMemberRow({required this.name, required this.role, required this.icon});

  final String name;
  final String role;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(name: name, size: 46),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleSmall.copyWith(fontSize: 14.5),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(icon, size: 14, color: AppColors.primary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: Insets.sm),
        const IconTile(icon: Icons.call_rounded, size: 36),
      ],
    );
  }
}
