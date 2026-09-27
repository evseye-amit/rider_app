import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/rider_session_provider.dart';
import '../providers/deployment_provider.dart';

class WaitingPage extends ConsumerStatefulWidget {
  const WaitingPage({super.key});

  @override
  ConsumerState<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends ConsumerState<WaitingPage> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.commonSignOut2,
      message: context.l10n.deploymentProgressSavedSignAgainAny,
      confirmLabel: context.l10n.commonSignOut,
      icon: Icons.logout_rounded,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    await ref.read(riderSessionProvider.notifier).signOut();
    if (mounted) context.go(Routes.login);
  }

  ({String title, String message, BrandArt art}) _copy(RiderDeployment deployment) {
    final String vehicle = deployment.allocation?.fleet?.vehicleNumber ?? 'your scooter';
    return switch (deployment.status) {
      DeploymentStatus.unknown => (
        title: context.l10n.deploymentAllSetUp,
        message: context.l10n.deploymentFleetManagerWillAllocateScooter,
        art: BrandArt.waiting,
      ),
      DeploymentStatus.riderWaiting => (
        title: '$vehicle is reserved for you',
        message: context.l10n.deploymentFleetManagerPreparingVehicleIts,
        art: BrandArt.scooter,
      ),
      DeploymentStatus.fleetRequested => (
        title: '$vehicle is reserved for you',
        message: context.l10n.deploymentFleetManagerPuttingTogetherPayment,
        art: BrandArt.wallet,
      ),
      DeploymentStatus.paymentPaid => (
        title: context.l10n.deploymentPaymentReceived,
        message: context.l10n.deploymentWritingPdi(vehicle),
        art: BrandArt.service,
      ),
      _ => (
        title: context.l10n.deploymentAlmostThere,
        message: context.l10n.deploymentManagerNextStep(vehicle),
        art: BrandArt.waiting,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(deploymentPollingProvider);
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);

    if (deployment.hasError) {
      return AppScaffold(
        title: context.l10n.deploymentPreparingScooter,
        showBack: false,
        actions: [IconButton(icon: const Icon(Icons.logout_rounded), onPressed: _signOut)],
        body: EmptyState(
          title: context.l10n.deploymentCouldNotReachServer,
          message: deployment.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.read(deploymentProvider.notifier).refresh(),
        ),
      );
    }

    final RiderDeployment? current = deployment.value;
    if (current == null) {
      return AppScaffold(
        title: context.l10n.deploymentPreparingScooter,
        showBack: false,
        body: const PageBody(
          children: [
            ShimmerBox(height: 200, borderRadius: Corners.brXl),
            Gap.xl(),
            ShimmerBox(height: 150, borderRadius: Corners.brLg),
          ],
        ),
      );
    }

    final DeploymentFleet? fleet = current.allocation?.fleet;
    final ({String title, String message, BrandArt art}) copy = _copy(current);

    return AppScaffold(
      title: context.l10n.deploymentPreparingScooter,
      subtitle: current.status == DeploymentStatus.unknown
          ? context.l10n.deploymentWaitingAllocation
          : current.status.label,
      centerTitle: true,
      showBack: false,
      actions: [
        IconButton(icon: const Icon(Icons.logout_rounded), tooltip: context.l10n.commonSignOut, onPressed: _signOut),
      ],
      body: RefreshIndicator(
        onRefresh: () => ref.read(deploymentProvider.notifier).refresh(),
        child: PageBody(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const Gap.lg(),
            ScaleTransition(
              scale: _pulse.drive(Tween(begin: 0.97, end: 1.0)),
              child: ArtBlock(art: copy.art, artSize: 176, title: copy.title, message: copy.message),
            ),
            const Gap.xl(),
            if (fleet != null)
              ModuleCard(
                title: context.l10n.commonScooter,
                leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
                child: Column(
                  children: [
                    KeyValueRow(
                      label: context.l10n.commonVehicle,
                      value: fleet.vehicleNumber,
                      icon: Icons.confirmation_number_rounded,
                    ),
                    if (fleet.modelName != null)
                      KeyValueRow(
                        label: context.l10n.commonModel,
                        value: fleet.modelName!,
                        icon: Icons.two_wheeler_rounded,
                      ),
                    if (fleet.colour != null)
                      KeyValueRow(label: context.l10n.commonColour, value: fleet.colour!, icon: Icons.palette_rounded),
                    KeyValueRow(
                      label: context.l10n.commonHandover,
                      value: current.status.label,
                      icon: Icons.timeline_rounded,
                    ),
                  ],
                ),
              ),
            const Gap.lg(),
            _Steps(status: current.status),
            const Gap.xl(),
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Opacity(
                opacity: 0.55 + _pulse.value * 0.45,
                child: Text(
                  context.l10n.deploymentCheckingWithFleetManagerEvery,
                  textAlign: TextAlign.center,
                  style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.status});

  final DeploymentStatus status;

  List<(DeploymentStatus, String)> _labels(AppL10n l10n) => [
    (DeploymentStatus.riderWaiting, l10n.deploymentScooterReserved),
    (DeploymentStatus.paymentPending, l10n.commonPayment),
    (DeploymentStatus.pdiPendingRider, l10n.deploymentInspection),
    (DeploymentStatus.trainingPending, l10n.onboardingStepTraining),
    (DeploymentStatus.devicePairingPending, l10n.deploymentPairIotUnit),
    (DeploymentStatus.deployed, l10n.deploymentRide),
  ];

  @override
  Widget build(BuildContext context) {
    final List<(DeploymentStatus, String)> labels = _labels(context.l10n);
    final int current = status == DeploymentStatus.unknown ? -1 : status.step;

    return ModuleCard(
      title: context.l10n.commonWhatHappensNext,
      leading: const IconTile(icon: Icons.route_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (final (int i, (DeploymentStatus step, String label)) in labels.indexed)
            TimelineRow(
              title: label,
              done: step.step < current || (step == DeploymentStatus.deployed && status.isDeployed),
              current: step.step == current && !status.isDeployed,
              isLast: i == labels.length - 1,
            ),
        ],
      ),
    );
  }
}
