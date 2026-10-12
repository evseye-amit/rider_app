import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/geo_point.dart';
import '../location/location_service.dart';

class LocationGate extends ConsumerStatefulWidget {
  const LocationGate({required this.builder, super.key});

  final Widget Function(BuildContext context, GeoPoint origin) builder;

  @override
  ConsumerState<LocationGate> createState() => _LocationGateState();
}

class _LocationGateState extends ConsumerState<LocationGate> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _retryIfBlocked);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _retryIfBlocked() {
    if (ref.read(currentLocationProvider).hasError) ref.invalidate(currentLocationProvider);
  }

  @override
  Widget build(BuildContext context) {
    return switch (ref.watch(currentLocationProvider)) {
      AsyncData(:final value) => widget.builder(context, value),
      AsyncError(:final error) => _LocationProblem(
        issue: error is LocationException ? error.issue : LocationIssue.unavailable,
        onRetry: () => ref.invalidate(currentLocationProvider),
      ),
      _ => const _Locating(),
    };
  }
}

class _LocationProblem extends ConsumerWidget {
  const _LocationProblem({required this.issue, required this.onRetry});

  final LocationIssue issue;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppL10n l10n = context.l10n;
    final (String title, String message, String action) = switch (issue) {
      LocationIssue.serviceDisabled => (l10n.mapsLocationOffTitle, l10n.mapsLocationOffBody, l10n.mapsOpenSettings),
      LocationIssue.deniedForever => (l10n.mapsLocationDeniedTitle, l10n.mapsLocationDeniedBody, l10n.mapsOpenSettings),
      LocationIssue.denied => (l10n.mapsLocationDeniedTitle, l10n.mapsLocationDeniedBody, l10n.mapsAllowLocation),
      LocationIssue.unavailable => (l10n.mapsLocationUnavailable, l10n.mapsLocationDeniedBody, l10n.commonTryAgain),
    };
    final bool needsSettings = issue == LocationIssue.serviceDisabled || issue == LocationIssue.deniedForever;

    return SafeArea(
      child: EmptyState(
        title: title,
        message: message,
        icon: Icons.location_off_rounded,
        actionLabel: action,
        onAction: needsSettings ? () => ref.read(locationServiceProvider).openSettings(issue) : onRetry,
      ),
    );
  }
}

class _Locating extends StatelessWidget {
  const _Locating();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox.square(
            dimension: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
          ),
          const Gap.lg(),
          Text(context.l10n.mapsLocating, style: AppText.bodyMedium),
        ],
      ),
    );
  }
}
