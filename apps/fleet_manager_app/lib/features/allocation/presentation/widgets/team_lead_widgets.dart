import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../allocation_dependencies.dart';

final teamLeadsProvider = FutureProvider.autoDispose.family<List<TeamLeadOption>, String>(
  (ref, search) async => (await ref.watch(getTeamLeadsProvider)(search)).getOrThrow(),
);

String teamLeadDetails(AppL10n l10n, TeamLeadOption lead) => [
  if ((lead.employeeCode ?? '').isNotEmpty) lead.employeeCode!,
  if ((lead.designation ?? '').isNotEmpty) lead.designation!,
  if (lead.assignedRiderCount case final int count) l10n.allocationTeamLeadRiderCount(count),
].join(' · ');

class TeamLeadPicker extends ConsumerStatefulWidget {
  const TeamLeadPicker({this.selectedId, super.key});

  final String? selectedId;

  static Future<TeamLeadOption?> show(BuildContext context, {String? selectedId}) => AppSheet.show<TeamLeadOption>(
    context,
    title: context.l10n.allocationChooseTeamLead,
    subtitle: context.l10n.allocationTeamLeadPickerSubtitle,
    maxHeightFactor: 0.85,
    child: TeamLeadPicker(selectedId: selectedId),
  );

  @override
  ConsumerState<TeamLeadPicker> createState() => _TeamLeadPickerState();
}

class _TeamLeadPickerState extends ConsumerState<TeamLeadPicker> {
  Timer? _debounce;
  String _search = '';

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _search = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<TeamLeadOption>> leads = ref.watch(teamLeadsProvider(_search));
    final List<TeamLeadOption>? items = leads.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchField(hint: context.l10n.allocationSearchTeamLead, onChanged: _onSearch),
        const Gap.lg(),
        if (items == null && leads.hasError)
          EmptyState(
            title: context.l10n.allocationCouldNotLoadTeamLeads,
            message: leads.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: () => ref.invalidate(teamLeadsProvider(_search)),
            compact: true,
          )
        else if (items == null)
          for (int i = 0; i < 3; i++) ...[const ShimmerBox(height: 64, borderRadius: Corners.brLg), const Gap.sm()]
        else if (items.isEmpty)
          EmptyState(
            title: context.l10n.allocationNoTeamLeads,
            message: context.l10n.allocationNoTeamLeadsMessage,
            icon: Icons.supervisor_account_rounded,
            compact: true,
          )
        else
          for (final TeamLeadOption lead in items) ...[
            AppRadioTile(
              selected: lead.id == widget.selectedId,
              onTap: () => Navigator.of(context).pop(lead),
              title: lead.name,
              subtitle: teamLeadDetails(context.l10n, lead),
              leading: AppAvatar(name: lead.name, size: 38),
            ),
            const Gap.sm(),
          ],
        const Gap.sm(),
      ],
    );
  }
}

class TeamLeadField extends StatelessWidget {
  const TeamLeadField({required this.teamLead, required this.onTap, super.key});

  final TeamLeadOption? teamLead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TeamLeadOption? lead = teamLead;
    return ModuleCard(
      title: context.l10n.allocationTeamLead,
      leading: const IconTile(icon: Icons.supervisor_account_rounded, solid: true, size: 28),
      child: Pressable(
        onTap: onTap,
        scale: 0.99,
        child: Container(
          padding: const EdgeInsets.all(Insets.md),
          decoration: BoxDecoration(
            color: lead == null ? AppColors.surface : AppColors.washFor(AppColors.primary),
            borderRadius: Corners.brLg,
            border: Border.all(
              color: lead == null ? AppColors.stroke : AppColors.primary,
              width: lead == null ? 1 : 1.6,
            ),
          ),
          child: Row(
            children: [
              if (lead == null)
                const IconTile(icon: Icons.person_search_rounded, size: 38)
              else
                AppAvatar(name: lead.name, size: 38),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead?.name ?? context.l10n.allocationChooseTeamLead,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.titleSmall.copyWith(fontSize: 14.5),
                    ),
                    if (lead != null && teamLeadDetails(context.l10n, lead).isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        teamLeadDetails(context.l10n, lead),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class TeamLeadCard extends StatelessWidget {
  const TeamLeadCard({required this.teamLead, required this.loaded, this.onChange, super.key});

  final TeamLeadOption? teamLead;
  final bool loaded;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final TeamLeadOption? lead = teamLead;
    return ModuleCard(
      title: context.l10n.allocationTeamLead,
      leading: const IconTile(icon: Icons.supervisor_account_rounded, solid: true, size: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!loaded)
            const ShimmerBox(height: 52, borderRadius: Corners.brMd)
          else if (lead == null)
            AccentCard(
              accent: AppColors.warning,
              child: Text(
                context.l10n.allocationTeamLeadMissing,
                style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5),
              ),
            )
          else
            Row(
              children: [
                AppAvatar(name: lead.name, size: 42),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.name, style: AppText.titleSmall.copyWith(fontSize: 14.5)),
                      if (teamLeadDetails(context.l10n, lead).isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(teamLeadDetails(context.l10n, lead), style: AppText.bodySmall.copyWith(fontSize: 12)),
                      ],
                      if ((lead.mobile ?? '').isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(Fmt.phone(lead.mobile!), style: AppText.bodySmall.copyWith(fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          if (loaded && onChange != null) ...[
            const Gap.sm(),
            GhostButton(
              label: lead == null ? context.l10n.allocationAssignTeamLead : context.l10n.allocationChangeTeamLead,
              icon: lead == null ? Icons.person_add_alt_1_rounded : Icons.swap_horiz_rounded,
              dense: true,
              onPressed: onChange,
            ),
          ],
        ],
      ),
    );
  }
}
