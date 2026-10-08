import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/location/geo_point.dart';
import '../../../../core/maps/location_gate.dart';
import '../../../../core/maps/map_place.dart';
import '../../../../core/maps/places_map.dart';
import '../../domain/entities/swap_station.dart';
import '../providers/swap_stations_provider.dart';

class BatterySwapPage extends StatelessWidget {
  const BatterySwapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: LocationGate(builder: (context, origin) => _StationsMap(origin: origin)),
    );
  }
}

class _StationsMap extends ConsumerWidget {
  const _StationsMap({required this.origin});

  final GeoPoint origin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SwapStation>> stations = ref.watch(nearbySwapStationsProvider(origin));
    final List<SwapStation> found = stations.value ?? const [];

    return PlacesMap(
      title: context.l10n.swapTitle,
      subtitle: context.l10n.swapSubtitle,
      origin: origin,
      placeIcon: Icons.ev_station_rounded,
      loading: stations.isLoading,
      onRefresh: () => ref.invalidate(nearbySwapStationsProvider(origin)),
      places: [
        for (final SwapStation station in found)
          MapPlace(
            id: station.id,
            title: station.name,
            subtitle: station.address,
            position: station.position,
            distanceMeters: station.distanceMeters,
            badge: switch (station.units) {
              final int units when units > 0 => context.l10n.swapUnits('$units'),
              _ => null,
            },
          ),
      ],
      notice: switch (stations) {
        AsyncError() => MapNotice(
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          title: context.l10n.swapCouldNotLoad,
          message: stations.failureMessage,
          actionLabel: context.l10n.commonRetry,
          onAction: () => ref.invalidate(nearbySwapStationsProvider(origin)),
        ),
        AsyncData() when found.isEmpty => MapNotice(
          icon: Icons.ev_station_rounded,
          title: context.l10n.swapNoneTitle,
          message: context.l10n.swapNoneBody,
        ),
        _ => null,
      },
    );
  }
}
