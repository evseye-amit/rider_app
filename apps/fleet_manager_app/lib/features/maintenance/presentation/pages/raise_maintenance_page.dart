import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/raise_job_input.dart';
import '../../domain/entities/vehicle_option.dart';
import '../../domain/entities/vendor_option.dart';
import '../../maintenance_dependencies.dart';
import '../providers/maintenance_options_providers.dart';

class RaiseMaintenancePage extends ConsumerStatefulWidget {
  const RaiseMaintenancePage({this.vehicleNumber, super.key});

  final String? vehicleNumber;

  @override
  ConsumerState<RaiseMaintenancePage> createState() => _RaiseMaintenancePageState();
}

class _RaiseMaintenancePageState extends ConsumerState<RaiseMaintenancePage> {
  static const List<String> _photoSlots = ['issue', 'context', 'closeup'];

  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _odometerController = TextEditingController();
  final Set<String> _photos = {};

  VehicleOption? _vehicle;
  String? _jobType;
  String _priority = 'normal';
  String? _vendor;
  bool _prefilled = false;
  bool _submitting = false;

  String? _vehicleError;
  String? _jobTypeError;
  String? _issueError;

  @override
  void dispose() {
    _issueController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  List<String> _jobTypes(AppL10n l10n) => [
    l10n.maintenanceScheduledService,
    l10n.maintenanceBattery,
    l10n.commonBrakes,
    l10n.maintenanceTyres,
    'IoT',
    l10n.maintenanceBody,
    l10n.commonOther,
  ];

  void _prefill(List<VehicleOption> vehicles) {
    if (_prefilled || widget.vehicleNumber == null) return;
    _vehicle = vehicles.where((vehicle) => vehicle.number == widget.vehicleNumber).firstOrNull ?? _vehicle;
    _prefilled = true;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<VehicleOption>> vehicles = ref.watch(vehicleOptionsProvider);
    final AsyncValue<List<VendorOption>> vendors = ref.watch(vendorOptionsProvider);

    if ((vehicles.isLoading && !vehicles.hasValue) || (vendors.isLoading && !vendors.hasValue)) {
      return AppScaffold(
        title: context.l10n.maintenanceRaiseJob,
        body: const PageBody(
          children: [
            ShimmerBox(height: 108, borderRadius: Corners.brLg),
            Gap.xl(),
            ShimmerBox(height: 54, borderRadius: Corners.brMd),
            Gap.lg(),
            ShimmerBox(height: 54, borderRadius: Corners.brMd),
            Gap.lg(),
            ShimmerBox(height: 120, borderRadius: Corners.brMd),
          ],
        ),
      );
    }

    final String? loadError = vehicles.failureMessage ?? vendors.failureMessage;
    final List<VehicleOption>? vehicleOptions = vehicles.value;
    final List<VendorOption>? vendorOptions = vendors.value;
    if (loadError != null || vehicleOptions == null || vendorOptions == null) {
      return AppScaffold(
        title: context.l10n.maintenanceRaiseJob,
        body: EmptyState(
          title: context.l10n.maintenanceCouldNotLoadForm,
          message: loadError,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () {
            ref.invalidate(vehicleOptionsProvider);
            ref.invalidate(vendorOptionsProvider);
          },
        ),
      );
    }

    _prefill(vehicleOptions);

    return AppScaffold(
      title: context.l10n.maintenanceRaiseJob,
      subtitle: context.l10n.maintenanceSendVehicleWorkshop,
      footer: PrimaryButton(
        label: context.l10n.maintenanceRaiseJob2,
        icon: Icons.build_rounded,
        loading: _submitting,
        onPressed: _submitting ? null : _submit,
      ),
      body: PageBody(
        children: [
          PhotoPanel(
            photo: BrandPhoto.service,
            height: 132,
            title: context.l10n.maintenanceSendWorkshop,
            subtitle: context.l10n.maintenanceTechnicianPicksUpAsSoon,
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.commonVehicle,
            leading: const IconTile(icon: Icons.electric_scooter_rounded, tone: AppColors.primary, size: 28),
            child: AppPickerField(
              label: context.l10n.commonVehicle,
              required: true,
              hint: context.l10n.maintenanceSelectVehicle,
              value: _vehicle == null ? null : '${_vehicle!.number} · ${_vehicle!.model}',
              errorText: _vehicleError,
              prefixIcon: Icons.electric_scooter_rounded,
              onTap: () => _pickVehicle(vehicleOptions),
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.maintenanceJobDetails,
            leading: const IconTile(icon: Icons.assignment_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPickerField(
                  label: context.l10n.maintenanceJobType,
                  required: true,
                  hint: context.l10n.maintenanceWhatKindJob,
                  value: _jobType,
                  errorText: _jobTypeError,
                  prefixIcon: Icons.category_rounded,
                  onTap: _pickJobType,
                ),
                const Gap.lg(),
                _PrioritySelector(value: _priority, onChanged: (priority) => setState(() => _priority = priority)),
                const Gap.lg(),
                AppTextField(
                  label: context.l10n.maintenanceIssueDescription,
                  hint: context.l10n.maintenanceWhatWrongWithVehicle,
                  required: true,
                  maxLines: 4,
                  controller: _issueController,
                  errorText: _issueError,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const Gap.lg(),
                AppTextField(
                  label: context.l10n.maintenanceOdometerReading,
                  hint: context.l10n.maintenanceHintOdometer,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.speed_rounded,
                  controller: _odometerController,
                  helper: context.l10n.maintenanceKilometresAsShownCluster,
                ),
              ],
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.maintenanceVendor,
            leading: const IconTile(icon: Icons.build_rounded, tone: AppColors.primary, size: 28),
            child: AppPickerField(
              label: context.l10n.maintenanceAssign,
              hint: context.l10n.maintenanceChooseLater,
              value: _vendor,
              prefixIcon: Icons.storefront_rounded,
              onTap: () => _pickVendor(vendorOptions),
            ),
          ),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.maintenancePhotoEvidence,
            leading: const IconTile(icon: Icons.photo_camera_rounded, tone: AppColors.primary, size: 28),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: Insets.md,
              mainAxisSpacing: Insets.md,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final String slot in _photoSlots)
                  PhotoSlot(
                    label: switch (slot) {
                      'issue' => context.l10n.maintenanceIssueCloseUp,
                      'context' => context.l10n.maintenanceWideShot,
                      _ => context.l10n.commonOdometer,
                    },
                    captured: _photos.contains(slot),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _photos.add(slot));
                    },
                    onRetake: () => setState(() => _photos.remove(slot)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickVehicle(List<VehicleOption> vehicles) async {
    final VehicleOption? picked = await AppSheet.show<VehicleOption>(
      context,
      title: context.l10n.maintenanceSelectVehicle,
      child: Column(
        children: [
          for (final VehicleOption vehicle in vehicles)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _vehicle?.number == vehicle.number,
                title: vehicle.number,
                subtitle: vehicle.model,
                onTap: () => Navigator.of(context).pop(vehicle),
              ),
            ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() {
      _vehicle = picked;
      _vehicleError = null;
    });
  }

  Future<void> _pickJobType() async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.maintenanceJobType,
      child: Column(
        children: [
          for (final String type in _jobTypes(context.l10n))
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _jobType == type,
                title: type,
                onTap: () => Navigator.of(context).pop(type),
              ),
            ),
        ],
      ),
    );
    if (picked == null) return;
    setState(() {
      _jobType = picked;
      _jobTypeError = null;
    });
  }

  Future<void> _pickVendor(List<VendorOption> vendors) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.maintenanceAssignVendor,
      subtitle: context.l10n.maintenanceCanAlsoAssignLater,
      child: Column(
        children: [
          for (final VendorOption vendor in vendors)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _vendor == vendor.name,
                title: vendor.name,
                subtitle: '${vendor.type} · ★ ${vendor.rating.toStringAsFixed(1)}',
                onTap: () => Navigator.of(context).pop(vendor.name),
              ),
            ),
        ],
      ),
    );
    if (picked != null) setState(() => _vendor = picked);
  }

  Future<void> _submit() async {
    setState(() {
      _vehicleError = _vehicle == null ? context.l10n.maintenanceSelectVehicleJob : null;
      _jobTypeError = _jobType == null ? context.l10n.maintenanceSelectJobType : null;
      _issueError = _issueController.text.trim().isEmpty ? context.l10n.maintenanceDescribeIssue : null;
    });
    if (_vehicleError != null || _jobTypeError != null || _issueError != null) return;

    final RaiseJobInput input = RaiseJobInput(
      vehicleNumber: _vehicle!.number,
      model: _vehicle!.model,
      jobType: _jobType!,
      priority: _priority,
      issue: _issueController.text.trim(),
      odometerKm: int.tryParse(_odometerController.text.trim()) ?? 0,
      vendor: _vendor,
      photoCount: _photos.length,
    );

    setState(() => _submitting = true);
    final Result<String> result = await ref.read(raiseMaintenanceJobProvider)(input);
    if (!mounted) return;
    setState(() => _submitting = false);

    switch (result) {
      case Ok<String>(:final value):
        AppSnack.success(context, '$value raised for ${input.vehicleNumber}.');
        Navigator.of(context).pop(value);
      case Err<String>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.maintenancePriority, style: AppText.label),
        const SizedBox(height: Insets.sm),
        Row(
          children: [
            for (final String priority in const ['low', 'normal', 'high']) ...[
              Expanded(
                child: _PriorityPill(priority: priority, selected: value == priority, onTap: () => onChanged(priority)),
              ),
              if (priority != 'high') const SizedBox(width: Insets.sm),
            ],
          ],
        ),
      ],
    );
  }
}

class _PriorityPill extends StatelessWidget {
  const _PriorityPill({required this.priority, required this.selected, required this.onTap});

  final String priority;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color tone = switch (priority) {
      'high' => AppColors.coral,
      'low' => AppColors.textSecondary,
      _ => AppColors.primary,
    };
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: AnimatedContainer(
        duration: Motion.fast,
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? tone : AppColors.surface,
          borderRadius: Corners.brMd,
          border: Border.all(color: selected ? tone : AppColors.stroke, width: selected ? 1.5 : 1),
          boxShadow: selected ? Shadows.lift(tone, opacity: 0.22, blur: 12) : null,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check_rounded, size: 15, color: Colors.white),
                const SizedBox(width: 5),
              ],
              Text(
                priority[0].toUpperCase() + priority.substring(1),
                style: AppText.titleSmall.copyWith(
                  fontSize: 13,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
