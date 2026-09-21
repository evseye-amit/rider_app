import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/hub_profile.dart';
import '../../domain/entities/hub_summary.dart';

class HubCard extends StatelessWidget {
  const HubCard({
    required this.profile,
    required this.summary,
    required this.hubs,
    required this.selectedIndex,
    required this.onHubChanged,
    super.key,
  });

  final HubProfile profile;
  final HubSummary summary;

  final List<HubProfile> hubs;

  final int selectedIndex;
  final ValueChanged<int> onHubChanged;

  @override
  Widget build(BuildContext context) {
    final int allocated = summary.fleet.allocated;

    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.brXl,

        boxShadow: Shadows.floating,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.hub_rounded,
                tone: AppColors.primary,
                solid: true,
                size: 40,
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.code,
                      style: AppText.code.copyWith(fontSize: 11.5, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (hubs.length > 1) ...[
            const Gap.lg(),
            _HubPicker(
              hubs: hubs,
              selectedIndex: selectedIndex,
              onChanged: onHubChanged,
            ),
          ],

          const Gap.lg(),
          Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: 1),
          const Gap.lg(),

          _Line(icon: Icons.location_on_rounded, text: profile.address),
          const Gap.md(),
          _Line(
            icon: Icons.electric_scooter_rounded,
            text: '$allocated of ${profile.capacity} slots in use',
          ),
          const Gap.md(),
          _Line(
            icon: Icons.ev_station_rounded,
            text: '${profile.chargingBays} charging bays · '
                '${profile.serviceBays} service bays',
          ),
          if (profile.hasTeamLeads) ...[
            const Gap.md(),
            _Line(
              icon: Icons.groups_rounded,
              text: profile.teamLeads.map((l) => l.name.split(' ').first).join(', '),
            ),
          ],
        ],
      ),
    );
  }
}

class _HubPicker extends StatelessWidget {
  const _HubPicker({
    required this.hubs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<HubProfile> hubs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => _open(context),
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.sm + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryWash,
          borderRadius: Corners.brMd,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
        ),
        child: Row(
          children: [
            const Icon(Icons.swap_horiz_rounded, size: 17, color: AppColors.primary),
            const SizedBox(width: Insets.sm),
            Expanded(
              child: Text(
                'Switch hub · ${hubs.length} assigned',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodySmall.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final int? picked = await AppSheet.show<int>(
      context,
      title: 'Your hubs',
      subtitle: 'Everything in the app follows the hub you pick',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < hubs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: _HubOption(
                name: hubs[i].name,
                code: hubs[i].code,
                city: hubs[i].city,
                selected: i == selectedIndex,
                onTap: () => Navigator.of(context).pop(i),
              ),
            ),
          const Gap.sm(),
        ],
      ),
    );
    if (picked != null) onChanged(picked);
  }
}

class _HubOption extends StatelessWidget {
  const _HubOption({
    required this.name,
    required this.code,
    required this.city,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String code;
  final String city;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.brMd,
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.45)
                : AppColors.stroke,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            IconTile(
              icon: Icons.hub_rounded,
              tone: AppColors.primary,
              solid: selected,
              size: 36,
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.titleSmall.copyWith(fontSize: 13.5),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    city.isEmpty ? code : '$code · $city',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.primary),
        const SizedBox(width: Insets.sm + 2),
        Expanded(
          child: Text(
            text,
            style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
          ),
        ),
      ],
    );
  }
}
