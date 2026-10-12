import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../location/geo_point.dart';
import 'directions.dart';
import 'map_place.dart';

class PlacesMap extends StatefulWidget {
  const PlacesMap({
    required this.title,
    required this.subtitle,
    required this.origin,
    required this.places,
    required this.placeIcon,
    this.loading = false,
    this.notice,
    this.onRefresh,
    super.key,
  });

  final String title;
  final String subtitle;
  final GeoPoint origin;
  final List<MapPlace> places;
  final IconData placeIcon;
  final bool loading;
  final Widget? notice;
  final VoidCallback? onRefresh;

  @override
  State<PlacesMap> createState() => _PlacesMapState();
}

class _PlacesMapState extends State<PlacesMap> {
  static const double _cardHeight = 150;
  static const double _headerSpace = 84;
  static const double _placeHue = 316;
  static const double _focusZoom = 14.5;

  final PageController _cards = PageController(viewportFraction: 0.88);
  GoogleMapController? _map;
  int _selected = 0;
  bool _syncingCards = false;

  @override
  void didUpdateWidget(PlacesMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (listEquals(_ids(oldWidget.places), _ids(widget.places))) return;
    _selected = 0;
    if (_cards.hasClients && widget.places.isNotEmpty) _cards.jumpToPage(0);
    _fitPlaces();
  }

  @override
  void dispose() {
    _cards.dispose();
    super.dispose();
  }

  static List<String> _ids(List<MapPlace> places) => [for (final MapPlace place in places) place.id];

  static LatLng _latLng(GeoPoint point) => LatLng(point.latitude, point.longitude);

  Set<Marker> _markers() => {
    for (int i = 0; i < widget.places.length; i++)
      Marker(
        markerId: MarkerId(widget.places[i].id),
        position: _latLng(widget.places[i].position),
        icon: BitmapDescriptor.defaultMarkerWithHue(i == _selected ? BitmapDescriptor.hueAzure : _placeHue),
        infoWindow: InfoWindow(title: widget.places[i].title),
        onTap: () => _onMarkerTap(i),
      ),
  };

  void _focus(int index) {
    setState(() => _selected = index);
    _map?.animateCamera(CameraUpdate.newLatLngZoom(_latLng(widget.places[index].position), _focusZoom));
  }

  void _onMarkerTap(int index) {
    _focus(index);
    unawaited(_showCard(index));
  }

  void _onCardChanged(int index) {
    if (!_syncingCards) _focus(index);
  }

  Future<void> _showCard(int index) async {
    if (!_cards.hasClients) return;
    _syncingCards = true;
    await _cards.animateToPage(index, duration: Motion.normal, curve: Motion.enter);
    _syncingCards = false;
  }

  void _recenter() => _map?.animateCamera(CameraUpdate.newLatLngZoom(_latLng(widget.origin), _focusZoom));

  void _fitPlaces() {
    final GoogleMapController? map = _map;
    if (map == null) return;
    final List<GeoPoint> points = [widget.origin, for (final MapPlace place in widget.places.take(5)) place.position];
    if (points.length == 1) {
      map.animateCamera(CameraUpdate.newLatLngZoom(_latLng(widget.origin), 13));
      return;
    }
    double south = points.first.latitude;
    double north = south;
    double west = points.first.longitude;
    double east = west;
    for (final GeoPoint point in points) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }
    map.animateCamera(
      CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(south, west), northeast: LatLng(north, east)), 48),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _map = controller;
    Future<void>.delayed(Motion.normal, () {
      if (mounted) _fitPlaces();
    });
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safe = MediaQuery.paddingOf(context);
    final double cardsBottom = safe.bottom + Insets.md;

    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: _latLng(widget.origin), zoom: 13),
            markers: _markers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            padding: EdgeInsets.only(top: safe.top + _headerSpace, bottom: cardsBottom + _cardHeight + Insets.md),
            onMapCreated: _onMapCreated,
          ),
        ),
        Positioned(
          top: safe.top + Insets.md,
          left: Insets.gutter,
          right: Insets.gutter,
          child: _MapHeader(
            icon: widget.placeIcon,
            title: widget.title,
            subtitle: widget.subtitle,
            loading: widget.loading,
            onRefresh: widget.onRefresh,
          ),
        ),
        Positioned(
          right: Insets.gutter,
          bottom: cardsBottom + _cardHeight + Insets.lg,
          child: _MapButton(icon: Icons.my_location_rounded, onTap: _recenter),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: cardsBottom,
          height: _cardHeight,
          child: widget.places.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
                  child: Align(alignment: Alignment.bottomCenter, child: widget.notice),
                )
              : PageView.builder(
                  controller: _cards,
                  itemCount: widget.places.length,
                  onPageChanged: _onCardChanged,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Insets.xs + 2),
                    child: _PlaceCard(
                      place: widget.places[index],
                      icon: widget.placeIcon,
                      selected: index == _selected,
                      onTap: () => _onMarkerTap(index),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class MapNotice extends StatelessWidget {
  const MapNotice({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.tone = AppColors.primary,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
      child: Row(
        children: [
          IconTile(icon: icon, tone: tone, size: 44),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.titleMedium),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(message!, maxLines: 3, overflow: TextOverflow.ellipsis, style: AppText.bodySmall),
                ],
              ],
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(width: Insets.sm),
            GhostButton(label: actionLabel!, onPressed: onAction, dense: true),
          ],
        ],
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.loading,
    required this.onRefresh,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool loading;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.sm, Insets.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: Corners.brXl, boxShadow: Shadows.floating),
      child: Row(
        children: [
          IconTile(icon: icon, size: 40, solid: true),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(Insets.md),
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.primary),
              ),
            )
          else if (onRefresh != null)
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.92,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, boxShadow: Shadows.floating),
        child: Icon(icon, size: 22, color: AppColors.primary),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.icon, required this.selected, required this.onTap});

  final MapPlace place;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  Future<void> _navigate(BuildContext context) async {
    final bool opened = await Directions.open(place.position);
    if (!opened && context.mounted) AppSnack.error(context, context.l10n.mapsCouldNotOpenMaps);
  }

  @override
  Widget build(BuildContext context) {
    final double? meters = place.distanceMeters;
    final int? minutes = place.etaMinutes;
    final String? badge = place.badge;
    final List<String> meta = [
      if (meters != null) context.l10n.mapsAway(Fmt.distanceKm(meters / 1000)),
      if (minutes != null) context.l10n.mapsMinutes('$minutes'),
      ?badge,
    ];

    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brXl,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke, width: selected ? 1.6 : 1),
          boxShadow: Shadows.floating,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTile(icon: icon, size: 38, solid: true),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppText.titleMedium),
                      if (place.subtitle case final String subtitle when subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.35),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    meta.join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: Insets.sm),
                PrimaryButton(
                  label: context.l10n.mapsNavigate,
                  icon: Icons.directions_rounded,
                  size: AppButtonSize.small,
                  expand: false,
                  onPressed: () => _navigate(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
