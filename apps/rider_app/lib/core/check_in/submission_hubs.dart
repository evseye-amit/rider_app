import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/geo_point.dart';
import '../location/location_service.dart';

class SubmissionHub extends Equatable {
  const SubmissionHub({required this.id, required this.name, required this.address, this.distanceMeters});

  final String id;
  final String name;
  final String address;
  final double? distanceMeters;

  @override
  List<Object?> get props => [id, name, address, distanceMeters];
}

class SubmissionChoices extends Equatable {
  const SubmissionChoices({required this.hasVehicle, required this.hubs, this.defaultHubId});

  final bool hasVehicle;
  final List<SubmissionHub> hubs;
  final String? defaultHubId;

  SubmissionHub? get defaultHub => hubs.where((hub) => hub.id == defaultHubId).firstOrNull;

  @override
  List<Object?> get props => [hasVehicle, hubs, defaultHubId];
}

final submissionChoicesProvider = FutureProvider.autoDispose.family<SubmissionChoices, GeoPoint?>((ref, origin) async {
  final SubmissionOptions options =
      (await ref.watch(vehicleSubmissionApiProvider).options(latitude: origin?.latitude, longitude: origin?.longitude))
          .getOrThrow();
  final List<SubmissionHub> hubs = [
    for (final SubmissionHubOption hub in options.hubs)
      SubmissionHub(
        id: hub.id,
        name: hub.name,
        address: [?hub.city, ?hub.code].join(' · '),
        distanceMeters: switch ((origin, hub.latitude, hub.longitude)) {
          (final GeoPoint from, final double latitude, final double longitude) => from.distanceTo(
            GeoPoint(latitude: latitude, longitude: longitude),
          ),
          _ => null,
        },
      ),
  ];
  if (origin != null) {
    hubs.sort((a, b) => (a.distanceMeters ?? double.infinity).compareTo(b.distanceMeters ?? double.infinity));
  }
  return SubmissionChoices(hasVehicle: options.hasActiveVehicle, hubs: hubs, defaultHubId: options.defaultHub?.id);
});

class SubmissionHubPicker extends ConsumerWidget {
  const SubmissionHubPicker({required this.selectedId, super.key});

  final String? selectedId;

  static Future<SubmissionHub?> show(BuildContext context, {String? selectedId}) => AppSheet.show<SubmissionHub>(
    context,
    title: context.l10n.returnsPickHub,
    subtitle: context.l10n.returnsPickHubSubtitle,
    child: SubmissionHubPicker(selectedId: selectedId),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GeoPoint> location = ref.watch(currentLocationProvider);
    return switch (location) {
      AsyncData(:final value) => _HubList(origin: value, selectedId: selectedId),
      AsyncError(:final error) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LocationHint(
            issue: error is LocationException ? error.issue : LocationIssue.unavailable,
            onRetry: () => ref.invalidate(currentLocationProvider),
            onSettings: (issue) => ref.read(locationServiceProvider).openSettings(issue),
          ),
          const Gap.md(),
          _HubList(origin: null, selectedId: selectedId),
        ],
      ),
      _ => const _SheetLoading(),
    };
  }
}

class SubmissionHubTile extends StatelessWidget {
  const SubmissionHubTile({required this.hub, required this.selected, required this.onTap, super.key});

  final SubmissionHub hub;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final double? distance = hub.distanceMeters;
    final String subtitle = [
      if (distance != null) Fmt.distanceKm(distance / 1000),
      if (hub.address.isNotEmpty) hub.address,
    ].join(' · ');
    return AppRadioTile(
      selected: selected,
      onTap: onTap,
      title: hub.name,
      subtitle: subtitle.isEmpty ? null : subtitle,
      leading: IconTile(
        icon: Icons.store_rounded,
        tone: selected ? AppColors.primary : AppColors.textSecondary,
        size: 36,
      ),
    );
  }
}

class _HubList extends ConsumerWidget {
  const _HubList({required this.origin, required this.selectedId});

  final GeoPoint? origin;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SubmissionChoices> choices = ref.watch(submissionChoicesProvider(origin));
    final List<SubmissionHub>? hubs = choices.value?.hubs;
    if (hubs == null) {
      return choices.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.returnsCouldNotLoadHubs,
              message: choices.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(submissionChoicesProvider(origin)),
            )
          : const _SheetLoading();
    }
    if (hubs.isEmpty) {
      return EmptyState(
        compact: true,
        title: context.l10n.returnsNoHubsNearby,
        icon: Icons.store_mall_directory_outlined,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final SubmissionHub hub in hubs) ...[
          SubmissionHubTile(hub: hub, selected: hub.id == selectedId, onTap: () => Navigator.of(context).pop(hub)),
          const Gap.sm(),
        ],
      ],
    );
  }
}

class _LocationHint extends StatelessWidget {
  const _LocationHint({required this.issue, required this.onRetry, required this.onSettings});

  final LocationIssue issue;
  final VoidCallback onRetry;
  final ValueChanged<LocationIssue> onSettings;

  @override
  Widget build(BuildContext context) {
    final bool needsSettings = issue == LocationIssue.serviceDisabled || issue == LocationIssue.deniedForever;
    return Container(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.sm, Insets.xs, Insets.sm),
      decoration: BoxDecoration(color: AppColors.washFor(AppColors.amber), borderRadius: Corners.brLg),
      child: Row(
        children: [
          const Icon(Icons.location_off_rounded, size: 18, color: AppColors.amber),
          const SizedBox(width: Insets.sm),
          Expanded(
            child: Text(
              context.l10n.returnsLocationForHubs,
              style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.4),
            ),
          ),
          GhostButton(
            label: needsSettings ? context.l10n.mapsOpenSettings : context.l10n.mapsAllowLocation,
            dense: true,
            onPressed: needsSettings ? () => onSettings(issue) : onRetry,
          ),
        ],
      ),
    );
  }
}

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.x3l),
      child: Center(
        child: SizedBox.square(
          dimension: 26,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
        ),
      ),
    );
  }
}
