import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';
import '../cubit/deployment_cubit.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentCubit(sl<SessionController>())
        ..load(silent: sl<SessionController>().deployment != null)
        ..startPolling(),
      child: const _WaitingView(),
    );
  }
}

class _WaitingView extends StatefulWidget {
  const _WaitingView();

  @override
  State<_WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<_WaitingView> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.commonSignOut2,
      message: context.l10n.deploymentProgressSavedSignAgainAny,
      confirmLabel: context.l10n.commonSignOut,
      icon: Icons.logout_rounded,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    await sl<SessionController>().signOut();
    if (context.mounted) context.go(Routes.login);
  }

  ({String title, String message, BrandArt art}) _copy(RiderDeployment? d) {
    final DeploymentAllocation? a = d?.allocation;
    final String vehicle = a?.fleet?.vehicleNumber ?? 'your scooter';
    return switch (d?.status) {
      null || DeploymentStatus.unknown => (
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
    return BlocBuilder<DeploymentCubit, DeploymentState>(
      builder: (context, state) {
        final DeploymentCubit cubit = context.read<DeploymentCubit>();

        if (state.status == DeploymentLoad.failure) {
          return AppScaffold(
            title: context.l10n.deploymentPreparingScooter,
            showBack: false,
            actions: [IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () => _signOut(context))],
            body: EmptyState(
              title: context.l10n.deploymentCouldNotReachServer,
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: cubit.load,
            ),
          );
        }

        if (state.isLoading && state.deployment == null) {
          return AppScaffold(
            title: context.l10n.deploymentPreparingScooter,
            showBack: false,
            body: const PageBody(children: [
              ShimmerBox(height: 200, borderRadius: Corners.brXl),
              Gap.xl(),
              ShimmerBox(height: 150, borderRadius: Corners.brLg),
            ]),
          );
        }

        final RiderDeployment? d = state.deployment;
        final DeploymentAllocation? a = d?.allocation;
        final DeploymentFleet? f = a?.fleet;
        final copy = _copy(d);

        return AppScaffold(
          title: context.l10n.deploymentPreparingScooter,
          subtitle: d?.status == DeploymentStatus.unknown || d?.status == null ? context.l10n.deploymentWaitingAllocation : d!.status.label,
          centerTitle: true,
          showBack: false,
          actions: [IconButton(icon: const Icon(Icons.logout_rounded), tooltip: context.l10n.commonSignOut, onPressed: () => _signOut(context))],
          body: RefreshIndicator(
            onRefresh: cubit.load,
            child: PageBody(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const Gap.lg(),
                ScaleTransition(
                  scale: _pulse.drive(Tween(begin: 0.97, end: 1.0)),
                  child: ArtBlock(art: copy.art, artSize: 176, title: copy.title, message: copy.message),
                ),
                const Gap.xl(),
                if (f != null)
                  ModuleCard(
                    title: context.l10n.commonScooter,
                    leading: IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
                    child: Column(
                      children: [
                        KeyValueRow(label: context.l10n.commonVehicle, value: f.vehicleNumber, icon: Icons.confirmation_number_rounded),
                        if (f.modelName != null) KeyValueRow(label: context.l10n.commonModel, value: f.modelName!, icon: Icons.two_wheeler_rounded),
                        if (f.colour != null) KeyValueRow(label: context.l10n.commonColour, value: f.colour!, icon: Icons.palette_rounded),
                        KeyValueRow(label: context.l10n.commonHandover, value: d!.status.label, icon: Icons.timeline_rounded),
                      ],
                    ),
                  ),
                Gap.lg(),
                _Steps(status: d?.status ?? DeploymentStatus.unknown),
                Gap.xl(),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) => Opacity(
                    opacity: 0.55 + _pulse.value * 0.45,
                    child: Text(context.l10n.deploymentCheckingWithFleetManagerEvery,
                      textAlign: TextAlign.center,
                      style: AppText.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.status});

  final DeploymentStatus status;

  static List<(DeploymentStatus, String)> get _labels => [
    (DeploymentStatus.riderWaiting, LocaleController.strings.deploymentScooterReserved),
    (DeploymentStatus.paymentPending, LocaleController.strings.commonPayment),
    (DeploymentStatus.pdiPendingRider, LocaleController.strings.deploymentInspection),
    (DeploymentStatus.trainingPending, LocaleController.strings.onboardingStepTraining),
    (DeploymentStatus.devicePairingPending, LocaleController.strings.deploymentPairIotUnit),
    (DeploymentStatus.deployed, LocaleController.strings.deploymentRide),
  ];

  @override
  Widget build(BuildContext context) {
    final int current = status == DeploymentStatus.unknown ? -1 : status.step;
    return ModuleCard(
      title: context.l10n.commonWhatHappensNext,
      leading: const IconTile(icon: Icons.route_rounded, solid: true, size: 28),
      child: Column(
        children: [
          for (final (i, (s, label)) in _labels.indexed)
            TimelineRow(
              title: label,
              done: s.step < current || (s == DeploymentStatus.deployed && status.isDeployed),
              current: s.step == current && !status.isDeployed,
              isLast: i == _labels.length - 1,
            ),
        ],
      ),
    );
  }
}
