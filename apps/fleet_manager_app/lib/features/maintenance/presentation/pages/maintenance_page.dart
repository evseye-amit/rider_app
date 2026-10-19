import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/maintenance/maintenance_issue_widgets.dart';
import '../../../../core/session/fleet_session_provider.dart';
import '../../../hub/domain/entities/hub_profile.dart';
import '../../domain/entities/maintenance_vehicle.dart';
import '../providers/maintenance_providers.dart';
import '../widgets/maintenance_widgets.dart';

const List<MaintenanceFleetStatus> _heldStatuses = [
  MaintenanceFleetStatus.maintenance,
  MaintenanceFleetStatus.broken,
  MaintenanceFleetStatus.awaitingParts,
];

class MaintenancePage extends ConsumerStatefulWidget {
  const MaintenancePage({super.key});

  @override
  ConsumerState<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends ConsumerState<MaintenancePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _hubId;
  String _search = '';
  MaintenanceFleetStatus? _status;
  MaintenanceIssueCategory? _category;

  MaintenanceFilter get _filter => (hubId: _hubId, search: _search, status: _status, category: _category);

  @override
  void initState() {
    super.initState();
    final FleetSession session = ref.read(fleetSessionProvider);
    final int? index = session.selectedHubIndex;
    if (index != null && index < session.hubs.length) _hubId = session.hubs[index].id;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final String next = value.trim();
      if (mounted && next != _search) setState(() => _search = next);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    if (_search.isNotEmpty) setState(() => _search = '');
  }

  @override
  Widget build(BuildContext context) {
    final FleetSession session = ref.watch(fleetSessionProvider);
    final List<HubProfile> hubs = session.hubs;
    final int hubIndex = hubs.indexWhere((hub) => hub.id == _hubId);
    final AsyncValue<MaintenanceVehicleList> vehicles = ref.watch(maintenanceListProvider(_filter));
    final String scope = hubIndex >= 0
        ? hubs[hubIndex].name
        : (hubs.length > 1 ? context.l10n.hubAllHubs : session.hubName);

    return HeroScaffold(
      bottomPadding: 120,
      onRefresh: () => ref.read(maintenanceListProvider(_filter).notifier).reload(),
      band: _Band(count: vehicles.value?.underMaintenance, scope: scope),
      children: [
        _Filters(
          controller: _searchController,
          onSearch: _onSearch,
          onClear: _clearSearch,
          hubs: hubs,
          selected: hubIndex + 1,
          onHub: (index) => setState(() => _hubId = index == 0 ? null : hubs[index - 1].id),
          status: _status,
          onStatus: (index) => setState(() => _status = index == 0 ? null : _heldStatuses[index - 1]),
          category: _category,
          onCategory: (index) =>
              setState(() => _category = index == 0 ? null : MaintenanceIssueCategory.values[index - 1]),
        ),
        const Gap.lg(),
        _Results(
          vehicles: vehicles,
          searching: _search.isNotEmpty || _status != null || _category != null,
          onRetry: () => ref.invalidate(maintenanceListProvider(_filter)),
          onLoadMore: () => ref.read(maintenanceListProvider(_filter).notifier).loadMore(),
          onOpen: (vehicle) => context.push('${Routes.maintenanceDetail}?id=${vehicle.id}'),
        ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.count, required this.scope});

  final int? count;
  final String scope;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.build_rounded, tone: AppColors.primaryBright, solid: true, size: 46),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.maintenanceTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scope,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, color: AppColors.onInkSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap.xl(),
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: Corners.brMd,
            border: Border.all(color: AppColors.inkStroke),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.maintenanceUnderMaintenance,
                    style: AppText.label.copyWith(color: AppColors.onInkSecondary),
                  ),
                  const Gap.xs(),
                  Text(
                    count == null ? '—' : '$count',
                    style: AppText.numericLarge.copyWith(fontSize: 36, color: AppColors.onInk),
                  ),
                ],
              ),
              const SizedBox(width: Insets.lg),
              const InkDivider(),
              const SizedBox(width: Insets.lg),
              Expanded(
                child: Text(
                  context.l10n.maintenanceBandHint,
                  style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45, color: AppColors.onInkSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.hubs,
    required this.selected,
    required this.onHub,
    required this.status,
    required this.onStatus,
    required this.category,
    required this.onCategory,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final List<HubProfile> hubs;
  final int selected;
  final ValueChanged<int> onHub;
  final MaintenanceFleetStatus? status;
  final ValueChanged<int> onStatus;
  final MaintenanceIssueCategory? category;
  final ValueChanged<int> onCategory;

  @override
  Widget build(BuildContext context) {
    final AppL10n l10n = context.l10n;
    final MaintenanceFleetStatus? status = this.status;
    final MaintenanceIssueCategory? category = this.category;
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            hint: context.l10n.maintenanceSearchHint,
            controller: controller,
            onChanged: onSearch,
            trailing: ListenableBuilder(
              listenable: controller,
              builder: (context, _) => controller.text.isEmpty
                  ? const SizedBox.shrink()
                  : Pressable(
                      onTap: onClear,
                      child: const Icon(Icons.close_rounded, size: 18, color: AppColors.textMuted),
                    ),
            ),
          ),
          if (hubs.length > 1) ...[
            const Gap.md(),
            FilterChipBar(
              items: [context.l10n.hubAllHubs, for (final HubProfile hub in hubs) hub.name],
              selectedIndex: selected,
              onChanged: onHub,
              padding: EdgeInsets.zero,
            ),
          ],
          const Gap.md(),
          FilterChipBar(
            items: [
              l10n.maintenanceAllStatuses,
              for (final MaintenanceFleetStatus option in _heldStatuses) fleetConditionLabel(l10n, option),
            ],
            selectedIndex: status == null ? 0 : _heldStatuses.indexOf(status) + 1,
            onChanged: onStatus,
            padding: EdgeInsets.zero,
          ),
          const Gap.sm(),
          FilterChipBar(
            items: [
              l10n.maintenanceAllCategories,
              for (final MaintenanceIssueCategory option in MaintenanceIssueCategory.values)
                issueCategoryLabel(l10n, option),
            ],
            selectedIndex: category == null ? 0 : category.index + 1,
            onChanged: onCategory,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.vehicles,
    required this.searching,
    required this.onRetry,
    required this.onLoadMore,
    required this.onOpen,
  });

  final AsyncValue<MaintenanceVehicleList> vehicles;
  final bool searching;
  final VoidCallback onRetry;
  final Future<bool> Function() onLoadMore;
  final ValueChanged<MaintenanceVehicle> onOpen;

  @override
  Widget build(BuildContext context) {
    final MaintenanceVehicleList? list = vehicles.value;
    if (list == null) {
      if (vehicles.hasError) {
        return ModuleCard(
          child: EmptyState(
            title: context.l10n.maintenanceCouldNotLoad,
            message: vehicles.failureMessage,
            icon: Icons.cloud_off_rounded,
            tone: AppColors.danger,
            actionLabel: context.l10n.commonTryAgain,
            onAction: onRetry,
            compact: true,
          ),
        );
      }
      return const _ListSkeleton();
    }

    if (list.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.lg),
        child: ArtBlock(
          art: BrandArt.empty,
          artSize: 112,
          title: searching ? context.l10n.maintenanceNoMatchTitle : context.l10n.maintenanceEmptyTitle,
          message: searching ? context.l10n.maintenanceNoMatchBody : context.l10n.maintenanceEmptyBody,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Insets.xs, bottom: Insets.md),
          child: Text(
            context.l10n.maintenanceShowing(list.items.length, list.total),
            style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        for (final MaintenanceVehicle vehicle in list.items) ...[
          MaintenanceVehicleCard(vehicle: vehicle, onTap: () => onOpen(vehicle)),
          const Gap.md(),
        ],
        if (list.hasMore) LoadMoreTile(onLoad: onLoadMore),
      ],
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 14, width: 120),
        Gap.md(),
        ShimmerBox(height: 168, borderRadius: Corners.brLg),
        Gap.md(),
        ShimmerBox(height: 168, borderRadius: Corners.brLg),
        Gap.md(),
        ShimmerBox(height: 168, borderRadius: Corners.brLg),
      ],
    );
  }
}
