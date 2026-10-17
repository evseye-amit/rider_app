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
    required this.onSelected,
    super.key,
  });

  final HubProfile profile;
  final HubSummary summary;

  final List<HubProfile> hubs;

  final int? selectedIndex;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final bool all = selectedIndex == null && hubs.length > 1;
    final List<TeamLead> leads = all
        ? {for (final HubProfile hub in hubs) ...hub.teamLeads}.toList()
        : profile.teamLeads;
    final int chargingBays = all ? hubs.fold(0, (sum, hub) => sum + hub.chargingBays) : profile.chargingBays;
    final int serviceBays = all ? hubs.fold(0, (sum, hub) => sum + hub.serviceBays) : profile.serviceBays;

    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconTile(icon: Icons.hub_rounded, tone: AppColors.primary, solid: true, size: 40),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      all ? context.l10n.hubAllHubs : profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleMedium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      all ? hubs.map((hub) => hub.code).join(' · ') : profile.code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.code.copyWith(fontSize: 11.5, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (hubs.length > 1) ...[
            const Gap.lg(),
            _HubDropdown(hubs: hubs, selectedIndex: all ? null : selectedIndex, onSelected: onSelected),
          ],

          const Gap.lg(),
          Divider(color: AppColors.stroke.withValues(alpha: 0.7), height: 1),
          const Gap.lg(),

          if (all)
            _Line(icon: Icons.hub_rounded, text: hubs.map((hub) => hub.name).join(', '))
          else
            _Line(icon: Icons.location_on_rounded, text: profile.address),
          const Gap.md(),
          _Line(
            icon: Icons.electric_scooter_rounded,
            text: '${summary.parkingOccupied} of ${summary.parkingCapacity} slots in use',
          ),
          const Gap.md(),
          _Line(
            icon: Icons.ev_station_rounded,
            text:
                '$chargingBays charging bays · '
                '$serviceBays service bays',
          ),
          if (leads.isNotEmpty) ...[
            const Gap.md(),
            _Line(icon: Icons.groups_rounded, text: leads.map((l) => l.name.split(' ').first).join(', ')),
          ],
        ],
      ),
    );
  }
}

class _HubChoice {
  const _HubChoice(this.index);

  final int? index;
}

class _HubDropdown extends StatelessWidget {
  const _HubDropdown({required this.hubs, required this.selectedIndex, required this.onSelected});

  final List<HubProfile> hubs;
  final int? selectedIndex;
  final ValueChanged<int?> onSelected;

  Future<void> _open(BuildContext context) async {
    final int? current = selectedIndex;
    final _HubChoice? picked = await AppSheet.show<_HubChoice>(
      context,
      title: context.l10n.hubChooseHub,
      subtitle: context.l10n.hubChooseHubSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: _HubOption(
              name: context.l10n.hubAllHubs,
              code: context.l10n.hubCount(hubs.length),
              city: '',
              selected: current == null,
              onTap: () => Navigator.of(context).pop(const _HubChoice(null)),
            ),
          ),
          for (int i = 0; i < hubs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: _HubOption(
                name: hubs[i].name,
                code: hubs[i].code,
                city: hubs[i].city,
                selected: current == i,
                onTap: () => Navigator.of(context).pop(_HubChoice(i)),
              ),
            ),
          const Gap.sm(),
        ],
      ),
    );
    if (picked != null && picked.index != current) onSelected(picked.index);
  }

  @override
  Widget build(BuildContext context) {
    final int? index = selectedIndex;
    return AppPickerField(
      label: context.l10n.hubShowDataFor,
      value: index == null ? context.l10n.hubAllHubs : hubs[index].name,
      prefixIcon: Icons.hub_rounded,
      onTap: () => _open(context),
    );
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
            color: selected ? AppColors.primary.withValues(alpha: 0.45) : AppColors.stroke,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            IconTile(icon: Icons.hub_rounded, tone: AppColors.primary, solid: selected, size: 36),
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
            if (selected) const Icon(Icons.check_circle_rounded, size: 20, color: AppColors.primary),
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
        Expanded(child: Text(text, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
      ],
    );
  }
}
