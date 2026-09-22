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
      title: 'Sign out?',
      message: 'Your progress is saved. Sign in again any time to pick up where you left off.',
      confirmLabel: 'Sign out',
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
          title: 'You\'re all set up',
          message: 'Your fleet manager will allocate a scooter to you. We will bring you straight here when they do.',
          art: BrandArt.waiting,
        ),
      DeploymentStatus.riderWaiting => (
          title: '$vehicle is reserved for you',
          message: 'Your fleet manager is preparing the vehicle and its IoT unit. Your payment details appear here as soon as they are ready.',
          art: BrandArt.scooter,
        ),
      DeploymentStatus.fleetRequested => (
          title: '$vehicle is reserved for you',
          message: 'Your fleet manager is putting together your payment details. You will be asked to pay in a moment.',
          art: BrandArt.wallet,
        ),
      DeploymentStatus.paymentPaid => (
          title: 'Payment received',
          message: 'Your fleet manager is writing up the pre-delivery inspection for $vehicle. You will check it over next.',
          art: BrandArt.service,
        ),
      _ => (
          title: 'Almost there',
          message: 'Your fleet manager is on the next step for $vehicle.',
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
            title: 'Preparing your scooter',
            showBack: false,
            actions: [IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () => _signOut(context))],
            body: EmptyState(
              title: 'Could not reach the server',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: cubit.load,
            ),
          );
        }

        if (state.isLoading && state.deployment == null) {
          return AppScaffold(
            title: 'Preparing your scooter',
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
          title: 'Preparing your scooter',
          subtitle: d?.status == DeploymentStatus.unknown || d?.status == null ? 'Waiting for an allocation' : d!.status.label,
          centerTitle: true,
          showBack: false,
          actions: [IconButton(icon: const Icon(Icons.logout_rounded), tooltip: 'Sign out', onPressed: () => _signOut(context))],
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
                    title: 'Your scooter',
                    leading: const IconTile(icon: Icons.electric_scooter_rounded, solid: true, size: 28),
                    child: Column(
                      children: [
                        KeyValueRow(label: 'Vehicle', value: f.vehicleNumber, icon: Icons.confirmation_number_rounded),
                        if (f.modelName != null) KeyValueRow(label: 'Model', value: f.modelName!, icon: Icons.two_wheeler_rounded),
                        if (f.colour != null) KeyValueRow(label: 'Colour', value: f.colour!, icon: Icons.palette_rounded),
                        KeyValueRow(label: 'Handover', value: d!.status.label, icon: Icons.timeline_rounded),
                      ],
                    ),
                  ),
                const Gap.lg(),
                _Steps(status: d?.status ?? DeploymentStatus.unknown),
                const Gap.xl(),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, _) => Opacity(
                    opacity: 0.55 + _pulse.value * 0.45,
                    child: Text(
                      'Checking with your fleet manager every few seconds…',
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

  static const List<(DeploymentStatus, String)> _labels = [
    (DeploymentStatus.riderWaiting, 'Scooter reserved'),
    (DeploymentStatus.paymentPending, 'Payment'),
    (DeploymentStatus.pdiPendingRider, 'Inspection'),
    (DeploymentStatus.trainingPending, 'Training'),
    (DeploymentStatus.devicePairingPending, 'Pair the IoT unit'),
    (DeploymentStatus.deployed, 'Ride'),
  ];

  @override
  Widget build(BuildContext context) {
    final int current = status == DeploymentStatus.unknown ? -1 : status.step;
    return ModuleCard(
      title: 'What happens next',
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
