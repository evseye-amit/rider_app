import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/usecases/pair_device.dart';
import '../cubit/deployment_cubit.dart';

class PairingPage extends StatelessWidget {
  const PairingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentCubit(sl<SessionController>())
        ..load(silent: sl<SessionController>().deployment != null)
        ..startPolling(),
      child: const _PairingView(),
    );
  }
}

class _PairingView extends StatefulWidget {
  const _PairingView();

  @override
  State<_PairingView> createState() => _PairingViewState();
}

class _PairingViewState extends State<_PairingView> {
  final TextEditingController _device = TextEditingController();
  bool _pairing = false;
  String? _error;

  @override
  void dispose() {
    _device.dispose();
    super.dispose();
  }

  Future<void> _pair(BuildContext context, String allocationId) async {
    final String number = _device.text.trim().toUpperCase();
    if (number.length < 4) {
      setState(() => _error = 'Enter the device number printed on the IoT unit');
      return;
    }
    setState(() {
      _pairing = true;
      _error = null;
    });
    final Result<DeploymentWorkflow> result =
        await PairDevice(sl())(PairDeviceParams(allocationId: allocationId, deviceNumber: number));
    if (!context.mounted) return;
    setState(() => _pairing = false);
    switch (result) {
      case Ok<DeploymentWorkflow>():
        HapticFeedback.mediumImpact();
        AppSnack.success(context, 'Paired — your scooter is ready');
        await context.read<DeploymentCubit>().load(silent: true);
      case Err<DeploymentWorkflow>(:final failure):
        setState(() => _error = failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeploymentCubit, DeploymentState>(
      builder: (context, state) {
        final RiderDeployment? d = state.deployment;
        final String? allocationId = d?.allocation?.id;
        final DeploymentFleet? fleet = d?.allocation?.fleet;

        if (state.status == DeploymentLoad.failure || (allocationId == null && !state.isLoading)) {
          return AppScaffold(
            title: 'Pair your scooter',
            showBack: false,
            body: EmptyState(
              title: 'Nothing to pair yet',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: context.read<DeploymentCubit>().load,
            ),
          );
        }

        if (_device.text.isEmpty && fleet?.iotDeviceNumber != null) _device.text = fleet!.iotDeviceNumber!;

        return AppScaffold(
          title: 'Pair your scooter',
          subtitle: fleet == null ? null : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
          showBack: false,
          footer: PrimaryButton(
            label: 'Pair device',
            icon: Icons.sensors_rounded,
            loading: _pairing,
            onPressed: _pairing || allocationId == null ? null : () => _pair(context, allocationId),
          ),
          body: PageBody(
            children: [
              const Gap.lg(),
              const ArtBlock(
                art: BrandArt.charging,
                artSize: 150,
                title: 'One last step',
                message: 'Find the device number on the IoT unit under the seat and enter it below. It pairs the scooter to your account.',
              ),
              const Gap.xl(),
              ModuleCard(
                title: 'IoT device',
                leading: const IconTile(icon: Icons.sensors_rounded, solid: true, size: 28),
                child: AppTextField(
                  label: 'Device number',
                  hint: 'e.g. EVS-IOT-0001',
                  helper: 'Printed on the unit. Ask your fleet manager if you cannot find it.',
                  controller: _device,
                  errorText: _error,
                  prefixIcon: Icons.qr_code_2_rounded,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() => _error = null),
                ),
              ),
              const Gap.lg(),
              Text(
                'Cannot pair? Your fleet manager can complete the handover from their app after checking the unit\'s health.',
                textAlign: TextAlign.center,
                style: AppText.bodySmall.copyWith(color: AppColors.textMuted, height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
