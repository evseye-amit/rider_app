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

class _AllocationDonePageState extends State<AllocationDonePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.slow,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Vehicle reserved',
      showBack: false,

      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PrimaryButton(
            label: 'Continue the handover',
            icon: Icons.arrow_forward_rounded,
            onPressed: widget.allocationId == null
                ? () => context.go(Routes.allocations)
                : () => context.go('${Routes.allocationDetail}?id=${widget.allocationId}'),
          ),
          const Gap.md(),
          SecondaryButton(
            label: 'Back to the desk',
            icon: Icons.swap_horiz_rounded,
            onPressed: () => context.go(Routes.allocations),
          ),
        ],
      ),
      body: PageBody(
        children: [
          const Gap.lg(),
          Center(
            child: ScaleTransition(
              scale: CurvedAnimation(parent: _controller, curve: Motion.spring),
              child: ArtBlock(
                art: BrandArt.success,
                title: 'Vehicle reserved',
                message: '${widget.vehicleNumber} is reserved for ${widget.riderName}. The handover starts now.',
              ),
            ),
          ),
          const Gap.xxl(),
          ModuleCard(
            title: 'What was allocated',
            child: Row(
              children: [
                const IconTile(icon: Icons.person_rounded, tone: AppColors.primary, size: 38),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.riderName, style: AppText.titleSmall.copyWith(fontSize: 14)),
                      const SizedBox(height: 2),
                      Text(
                        'Vehicle ${widget.vehicleNumber}',
                        style: AppText.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const StatusChip(label: 'Reserved', tone: StatusTone.brand, dense: true),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: 'What happens next',
            child: Column(
              children: const [
                _NextStep(
                  icon: Icons.electric_scooter_rounded,
                  title: 'Request the vehicle',
                  message: 'Confirms the vehicle\'s photos are on file and its IoT unit is online.',
                ),
                Gap.md(),
                _NextStep(
                  icon: Icons.receipt_long_rounded,
                  title: 'Payment',
                  message: 'You raise the deposit and fees; the rider pays and submits the reference; you verify it.',
                ),
                Gap.md(),
                _NextStep(
                  icon: Icons.fact_check_rounded,
                  title: 'Inspection, training, pairing',
                  message: 'You write the PDI checklist; the rider accepts it, completes training and pairs the IoT unit.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStep extends StatelessWidget {
  const _NextStep({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AccentCard(
      accent: AppColors.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: AppColors.primary),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                const SizedBox(height: 3),
                Text(message, style: AppText.bodySmall.copyWith(fontSize: 12, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
