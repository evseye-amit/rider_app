import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/location/geo_point.dart';
import '../../../../core/location/location_service.dart';
import '../../domain/entities/ride_return.dart';
import '../../domain/usecases/ride_return_usecases.dart';
import '../../ride_returns_dependencies.dart';
import '../providers/ride_returns_providers.dart';
import '../widgets/return_widgets.dart';

class RequestReturnPage extends ConsumerStatefulWidget {
  const RequestReturnPage({super.key});

  @override
  ConsumerState<RequestReturnPage> createState() => _RequestReturnPageState();
}

class _RequestReturnPageState extends ConsumerState<RequestReturnPage> {
  static const int _maxDaysAhead = 60;

  final String _idempotencyKey = newIdempotencyKey();
  final TextEditingController _notes = TextEditingController();

  ReturnablePlan? _plan;
  ReturnReason? _reason;
  ReturnHub? _hub;
  DateTime? _date;
  bool _submitting = false;
  bool _showErrors = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  DateTime get _today {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickPlan(List<ReturnablePlan> plans) async {
    final ReturnablePlan? picked = await AppSheet.show<ReturnablePlan>(
      context,
      title: context.l10n.returnsPickRental,
      child: Column(
        children: [
          for (final ReturnablePlan plan in plans) ...[
            AppRadioTile(
              selected: plan.agreementId == _plan?.agreementId,
              onTap: () => Navigator.of(context).pop(plan),
              title: plan.number,
              subtitle: plan.scooterName,
              leading: const IconTile(icon: Icons.electric_moped_rounded, size: 36),
            ),
            const Gap.sm(),
          ],
        ],
      ),
    );
    if (picked != null) setState(() => _plan = picked);
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await AppDateWheel.show(
      context,
      first: _today,
      last: _today.add(const Duration(days: _maxDaysAhead)),
      initial: _date ?? _today,
      title: context.l10n.returnsPickDate,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickHub() async {
    final ReturnHub? picked = await AppSheet.show<ReturnHub>(
      context,
      title: context.l10n.returnsPickHub,
      subtitle: context.l10n.returnsPickHubSubtitle,
      child: _HubPicker(selectedId: _hub?.id),
    );
    if (picked != null) setState(() => _hub = picked);
  }

  Future<void> _submit(ReturnablePlan? plan) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final ReturnReason? reason = _reason;
    final ReturnHub? hub = _hub;
    final DateTime? date = _date;
    if (plan == null || reason == null || hub == null || date == null) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _submitting = true);
    final Result<RideReturn> result = await ref.read(requestRideReturnProvider)(
      ReturnRequestParams(
        agreementId: plan.agreementId,
        reasonCode: reason.wire,
        hubId: hub.id,
        date: DateTime(date.year, date.month, date.day, 12),
        idempotencyKey: _idempotencyKey,
        notes: _notes.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    switch (result) {
      case Ok<RideReturn>(:final value):
        AppSnack.success(context, context.l10n.returnsRequested);
        context.pop(value.id);
      case Err<RideReturn>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ReturnablePlan>> plans = ref.watch(returnablePlansProvider);
    final List<ReturnablePlan>? list = plans.value;
    final ReturnablePlan? plan = _plan ?? (list != null && list.length == 1 ? list.single : null);

    return AppScaffold(
      title: context.l10n.returnsRequestReturn,
      subtitle: context.l10n.returnsRequestSubtitle,
      footer: list == null || list.isEmpty
          ? null
          : PrimaryButton(
              label: context.l10n.returnsRequestReturn,
              icon: Icons.send_rounded,
              loading: _submitting,
              onPressed: _submitting ? null : () => _submit(plan),
            ),
      body: switch (list) {
        null when plans.hasError => EmptyState(
          title: context.l10n.returnsCouldNotLoad,
          message: plans.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.invalidate(returnablePlansProvider),
        ),
        null => const PageBody(
          children: [
            ShimmerBox(height: 110, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 150, borderRadius: Corners.brXl),
            Gap.lg(),
            ShimmerBox(height: 170, borderRadius: Corners.brXl),
          ],
        ),
        [] => EmptyState(
          title: context.l10n.returnsNothingToReturn,
          message: context.l10n.returnsNothingToReturnBody,
          icon: Icons.electric_moped_rounded,
        ),
        final List<ReturnablePlan> items => _form(items, plan),
      },
    );
  }

  Widget _form(List<ReturnablePlan> plans, ReturnablePlan? plan) {
    final DateTime? date = _date;
    final ReturnHub? hub = _hub;
    return PageBody(
      children: [
        ModuleCard(
          title: context.l10n.returnsRental,
          leading: const IconTile(icon: Icons.electric_moped_rounded, solid: true, size: 28),
          child: plans.length == 1
              ? Column(
                  children: [
                    KeyValueRow(
                      label: context.l10n.returnsAgreement,
                      value: plans.single.number,
                      icon: Icons.tag_rounded,
                    ),
                    if (plans.single.scooterName != null)
                      KeyValueRow(
                        label: context.l10n.commonVehicle,
                        value: plans.single.scooterName!,
                        icon: Icons.electric_moped_rounded,
                      ),
                  ],
                )
              : AppPickerField(
                  label: context.l10n.returnsAgreement,
                  required: true,
                  value: plan == null ? null : [plan.number, ?plan.scooterName].join(' · '),
                  hint: context.l10n.returnsPickRental,
                  prefixIcon: Icons.tag_rounded,
                  errorText: _showErrors && plan == null ? context.l10n.returnsPickRental : null,
                  onTap: () => _pickPlan(plans),
                ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnsWhy,
          leading: const IconTile(icon: Icons.help_outline_rounded, solid: true, size: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final ReturnReason reason in ReturnReason.values)
                    _ReasonChip(
                      label: returnReasonLabel(context.l10n, reason.wire),
                      selected: _reason == reason,
                      onTap: () => setState(() => _reason = reason),
                    ),
                ],
              ),
              if (_showErrors && _reason == null) ...[
                const Gap.sm(),
                Text(
                  context.l10n.returnsPickReason,
                  style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnsWhenWhere,
          leading: const IconTile(icon: Icons.event_rounded, solid: true, size: 28),
          child: Column(
            children: [
              AppPickerField(
                label: context.l10n.returnsDate,
                required: true,
                value: date == null ? null : Fmt.date(date),
                hint: context.l10n.returnsPickDate,
                prefixIcon: Icons.calendar_today_rounded,
                errorText: _showErrors && date == null ? context.l10n.returnsPickDate : null,
                onTap: _pickDate,
              ),
              const Gap.lg(),
              AppPickerField(
                label: context.l10n.returnsHub,
                required: true,
                value: hub?.name,
                hint: context.l10n.returnsPickHub,
                prefixIcon: Icons.store_rounded,
                helper: hub?.address,
                errorText: _showErrors && hub == null ? context.l10n.returnsPickHub : null,
                onTap: _pickHub,
              ),
            ],
          ),
        ),
        const Gap.lg(),
        ModuleCard(
          title: context.l10n.returnsNotes,
          leading: const IconTile(icon: Icons.notes_rounded, solid: true, size: 28),
          child: AppTextField(
            controller: _notes,
            hint: context.l10n.returnsNotesHint,
            maxLines: 3,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        const Gap.lg(),
        AccentCard(
          accent: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.commonWhatHappensNext, style: AppText.titleSmall),
              const Gap.sm(),
              for (final String line in [
                context.l10n.returnsNextHandOver,
                context.l10n.returnsNextInspection,
                context.l10n.returnsNextCharges,
              ])
                Padding(
                  padding: const EdgeInsets.only(top: Insets.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(Icons.check_circle_outline_rounded, size: 15, color: AppColors.primary),
                      ),
                      const SizedBox(width: Insets.sm),
                      Expanded(child: Text(line, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryWash : AppColors.surface,
          borderRadius: Corners.pill,
          border: Border.all(color: selected ? AppColors.primary : AppColors.stroke),
        ),
        child: Text(
          label,
          style: AppText.titleSmall.copyWith(
            fontSize: 12.5,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _HubPicker extends ConsumerWidget {
  const _HubPicker({required this.selectedId});

  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GeoPoint> location = ref.watch(currentLocationProvider);
    return switch (location) {
      AsyncData(:final value) => _HubList(origin: value, selectedId: selectedId),
      AsyncError(:final error) => _LocationNeeded(
        issue: error is LocationException ? error.issue : LocationIssue.unavailable,
        onRetry: () => ref.invalidate(currentLocationProvider),
        onSettings: (issue) => ref.read(locationServiceProvider).openSettings(issue),
      ),
      _ => const _SheetLoading(),
    };
  }
}

class _HubList extends ConsumerWidget {
  const _HubList({required this.origin, required this.selectedId});

  final GeoPoint origin;
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ReturnHub>> hubs = ref.watch(returnHubsProvider(origin));
    final List<ReturnHub>? list = hubs.value;
    if (list == null) {
      return hubs.hasError
          ? EmptyState(
              compact: true,
              title: context.l10n.returnsCouldNotLoadHubs,
              message: hubs.failureMessage,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: context.l10n.commonTryAgain,
              onAction: () => ref.invalidate(returnHubsProvider(origin)),
            )
          : const _SheetLoading();
    }
    if (list.isEmpty) {
      return EmptyState(
        compact: true,
        title: context.l10n.returnsNoHubsNearby,
        icon: Icons.store_mall_directory_outlined,
      );
    }
    return Column(
      children: [
        for (final ReturnHub hub in list) ...[
          ReturnHubTile(hub: hub, selected: hub.id == selectedId, onTap: () => Navigator.of(context).pop(hub)),
          const Gap.sm(),
        ],
      ],
    );
  }
}

class _LocationNeeded extends StatelessWidget {
  const _LocationNeeded({required this.issue, required this.onRetry, required this.onSettings});

  final LocationIssue issue;
  final VoidCallback onRetry;
  final ValueChanged<LocationIssue> onSettings;

  @override
  Widget build(BuildContext context) {
    final bool needsSettings = issue == LocationIssue.serviceDisabled || issue == LocationIssue.deniedForever;
    return EmptyState(
      compact: true,
      title: issue == LocationIssue.serviceDisabled
          ? context.l10n.mapsLocationOffTitle
          : context.l10n.mapsLocationDeniedTitle,
      message: context.l10n.returnsLocationForHubs,
      icon: Icons.location_off_rounded,
      tone: AppColors.amber,
      actionLabel: needsSettings ? context.l10n.mapsOpenSettings : context.l10n.mapsAllowLocation,
      onAction: needsSettings ? () => onSettings(issue) : onRetry,
    );
  }
}

class _SheetLoading extends StatelessWidget {
  const _SheetLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Insets.x3l),
      child: Center(
        child: SizedBox.square(
          dimension: 26,
          child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.primary),
        ),
      ),
    );
  }
}
