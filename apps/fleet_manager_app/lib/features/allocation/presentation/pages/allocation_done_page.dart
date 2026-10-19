import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

class AllocationDonePage extends StatefulWidget {
  const AllocationDonePage({required this.riderName, required this.vehicleNumber, this.allocationId, super.key});

  final String riderName;
  final String vehicleNumber;

  final String? allocationId;

  @override
  State<AllocationDonePage> createState() => _AllocationDonePageState();
}

class _AllocationDonePageState extends State<AllocationDonePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: Motion.slow)..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBack: false,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: context.l10n.allocationContinueHandover,
            icon: Icons.arrow_forward_rounded,
            onPressed: widget.allocationId == null
                ? () => context.go(Routes.allocations)
                : () => context.go('${Routes.allocationDetail}?id=${widget.allocationId}'),
          ),
          const Gap.sm(),
          GhostButton(label: context.l10n.allocationBackDesk, onPressed: () => context.go(Routes.allocations)),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _controller, curve: Motion.spring),
            child: ArtBlock(
              art: BrandArt.success,
              artSize: 112,
              title: context.l10n.allocationVehicleReserved,
              message: '${widget.vehicleNumber} · ${widget.riderName}',
            ),
          ),
        ),
      ),
    );
  }
}
