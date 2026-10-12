import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../../../core/maps/location_gate.dart';
import '../../../../core/maps/map_place.dart';
import '../../../../core/maps/places_map.dart';
import '../../domain/entities/nearby_hub.dart';
import '../providers/nearby_hubs_provider.dart';

class NearbyHubsPage extends StatelessWidget {
  const NearbyHubsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: LocationGate(builder: (context, origin) => _HubsMap(origin: origin)),
    );
  }
}

class _HubsMap extends ConsumerWidget {
  const _HubsMap({required this.origin});

  final GeoPoint origin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<NearbyHub>> hubs = ref.watch(nearbyHubsProvider(origin));
    final List<NearbyHub> found = hubs.value ?? const [];

    return PlacesMap(
      title: context.l10n.navNearbyHubs,
      subtitle: context.l10n.hubsSubtitle,
      origin: origin,
      placeIcon: Icons.hub_rounded,
      loading: hubs.isLoading,
      onRefresh: () => ref.invalidate(nearbyHubsProvider(origin)),
      places: [
        for (final NearbyHub hub in found)
          MapPlace(
            id: hub.id,
            title: hub.name,
            subtitle: hub.address,
            position: hub.position,
            distanceMeters: hub.distanceMeters,
            etaMinutes: hub.etaMinutes,
          ),
      ],
      notice: switch (hubs) {
        AsyncError() => MapNotice(
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          title: context.l10n.hubsCouldNotLoad,
          message: hubs.failureMessage,
          actionLabel: context.l10n.commonRetry,
          onAction: () => ref.invalidate(nearbyHubsProvider(origin)),
        ),
        AsyncData() when found.isEmpty => MapNotice(
          icon: Icons.hub_rounded,
          title: context.l10n.hubsNoneTitle,
          message: context.l10n.hubsNoneBody,
        ),
        _ => null,
      },
    );
  }
}
