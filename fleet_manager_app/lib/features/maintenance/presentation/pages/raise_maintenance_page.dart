import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/raise_job_input.dart';
import '../../domain/entities/vehicle_option.dart';
import '../../domain/entities/vendor_option.dart';
import '../../domain/usecases/get_vehicle_options.dart';
import '../../domain/usecases/get_vendor_options.dart';
import '../../domain/usecases/raise_maintenance_job.dart';
import '../cubit/raise_maintenance_cubit.dart';

List<String> _jobTypes = [
  LocaleController.strings.maintenanceScheduledService,
  LocaleController.strings.maintenanceBattery,
  LocaleController.strings.commonBrakes,
  LocaleController.strings.maintenanceTyres,
  'IoT',
  LocaleController.strings.maintenanceBody,
  LocaleController.strings.commonOther,
];

class RaiseMaintenancePage extends StatelessWidget {
  const RaiseMaintenancePage({this.vehicleNumber, super.key});

  final String? vehicleNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RaiseMaintenanceCubit(
        GetVehicleOptions(sl()),
        GetVendorOptions(sl()),
        RaiseMaintenanceJob(sl()),
      )..load(),
      child: _RaiseMaintenanceView(prefillVehicleNumber: vehicleNumber),
    );
  }
}

class _RaiseMaintenanceView extends StatefulWidget {
  const _RaiseMaintenanceView({this.prefillVehicleNumber});

  final String? prefillVehicleNumber;

  @override
  State<_RaiseMaintenanceView> createState() => _RaiseMaintenanceViewState();
}

class _RaiseMaintenanceViewState extends State<_RaiseMaintenanceView> {
  VehicleOption? _vehicle;
  String? _jobType;
  String _priority = 'normal';
  String? _vendor;
  bool _prefilled = false;
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _odometerController = TextEditingController();

  String? _vehicleError;
  String? _jobTypeError;
  String? _issueError;

  final Set<String> _photos = {};
  static const List<String> _photoSlots = ['issue', 'context', 'closeup'];

  @override
  void dispose() {
    _issueController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _prefill(List<VehicleOption> vehicles) {
    if (_prefilled || widget.prefillVehicleNumber == null) return;
    final VehicleOption? match =
        vehicles.where((v) => v.number == widget.prefillVehicleNumber).firstOrNull;
    if (match != null) {
      _vehicle = match;
    }
    _prefilled = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RaiseMaintenanceCubit, RaiseMaintenanceState>(
      builder: (context, state) {
        if (state.isLoading) {
          return AppScaffold(
            title: context.l10n.maintenanceRaiseJob,
            body: PageBody(children: const [
              ShimmerBox(height: 108, borderRadius: Corners.brLg),
              Gap.xl(),
              ShimmerBox(height: 54, borderRadius: Corners.brMd),
              Gap.lg(),
              ShimmerBox(height: 54, borderRadius: Corners.brMd),
              Gap.lg(),
              ShimmerBox(height: 120, borderRadius: Corners.brMd),
            ]),
          );
        }
        if (state.status == RaiseMaintenanceStatus.failure) {
          return AppScaffold(
            title: context.l10n.maintenanceRaiseJob,
            body: EmptyState(
              title: context.l10n.maintenanceCouldNotLoadForm,
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => context.read<RaiseMaintenanceCubit>().load(),
            ),
          );
        }

        _prefill(state.vehicles);

        return AppScaffold(
          title: context.l10n.maintenanceRaiseJob,
          subtitle: context.l10n.maintenanceSendVehicleWorkshop,
          footer: PrimaryButton(
            label: context.l10n.maintenanceRaiseJob2,
            icon: Icons.build_rounded,
            loading: state.submitting,
            onPressed: state.submitting ? null : () => _submit(context, state),
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
                  onTap: () => _pickVehicle(context, state.vehicles),
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
                      onTap: () => _pickJobType(context),
                    ),
                    const Gap.lg(),
                    _PrioritySelector(
                      value: _priority,
                      onChanged: (p) => setState(() => _priority = p),
                    ),
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
                  onTap: () => _pickVendor(context, state.vendors),
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
                    for (final slot in _photoSlots)
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
      },
    );
  }

  Future<void> _pickVehicle(BuildContext context, List<VehicleOption> vehicles) async {
    final VehicleOption? picked = await AppSheet.show<VehicleOption>(
      context,
      title: context.l10n.maintenanceSelectVehicle,
      child: Column(
        children: [
          for (final v in vehicles)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _vehicle?.number == v.number,
                title: v.number,
                subtitle: v.model,
                onTap: () => Navigator.of(context).pop(v),
              ),
            ),
        ],
      ),
    );
    if (picked != null) setState(() { _vehicle = picked; _vehicleError = null; });
  }

  Future<void> _pickJobType(BuildContext context) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.maintenanceJobType,
      child: Column(
        children: [
          for (final t in _jobTypes)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _jobType == t,
                title: t,
                onTap: () => Navigator.of(context).pop(t),
              ),
            ),
        ],
      ),
    );
    if (picked != null) setState(() { _jobType = picked; _jobTypeError = null; });
  }

  Future<void> _pickVendor(BuildContext context, List<VendorOption> vendors) async {
    final String? picked = await AppSheet.show<String>(
      context,
      title: context.l10n.maintenanceAssignVendor,
      subtitle: context.l10n.maintenanceCanAlsoAssignLater,
      child: Column(
        children: [
          for (final v in vendors)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: _vendor == v.name,
                title: v.name,
                subtitle: '${v.type} · ★ ${v.rating.toStringAsFixed(1)}',
                onTap: () => Navigator.of(context).pop(v.name),
              ),
            ),
        ],
      ),
    );
    if (picked != null) setState(() => _vendor = picked);
  }

  Future<void> _submit(BuildContext context, RaiseMaintenanceState state) async {
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

    final result = await context.read<RaiseMaintenanceCubit>().submit(input);
    if (!context.mounted) return;
    result.fold(
      (failure) => AppSnack.error(context, failure.message),
      (jobId) {
        AppSnack.success(context, '$jobId raised for ${input.vehicleNumber}.');
        Navigator.of(context).pop(jobId);
      },
    );
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
            for (final p in const ['low', 'normal', 'high']) ...[
              Expanded(child: _PriorityPill(priority: p, selected: value == p, onTap: () => onChanged(p))),
              if (p != 'high') const SizedBox(width: Insets.sm),
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
