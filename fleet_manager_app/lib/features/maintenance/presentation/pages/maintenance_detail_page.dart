import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../domain/entities/maintenance_job.dart';
import '../../domain/entities/vendor_option.dart';
import '../../domain/usecases/get_maintenance_job.dart';
import '../../domain/usecases/get_vendor_options.dart';
import '../cubit/maintenance_detail_cubit.dart';
import '../widgets/maintenance_widgets.dart';

class MaintenanceDetailPage extends StatelessWidget {
  const MaintenanceDetailPage({required this.jobId, super.key});

  final String jobId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MaintenanceDetailCubit(GetMaintenanceJob(sl()), jobId)..load(),
      child: const _MaintenanceDetailView(),
    );
  }
}

class _MaintenanceDetailView extends StatefulWidget {
  const _MaintenanceDetailView();

  @override
  State<_MaintenanceDetailView> createState() => _MaintenanceDetailViewState();
}

class _MaintenanceDetailViewState extends State<_MaintenanceDetailView> {
  List<VendorOption> _vendors = const [];

  @override
  void initState() {
    super.initState();
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    final result = await GetVendorOptions(sl())(const NoParams());
    if (!mounted) return;
    result.fold((_) {}, (vendors) => setState(() => _vendors = vendors));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MaintenanceDetailCubit, MaintenanceDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.canvas,
            body: SafeArea(
              child: PageBody(children: const [
                ShimmerBox(height: 100, borderRadius: Corners.brLg),
                Gap.xl(),
                ShimmerBox(height: 160, borderRadius: Corners.brLg),
                Gap.md(),
                ShimmerBox(height: 220, borderRadius: Corners.brLg),
              ]),
            ),
          );
        }
        if (state.status == MaintenanceDetailStatus.failure || state.job == null) {
          return AppScaffold(
            title: 'Job',
            body: EmptyState(
              title: 'Could not load this job',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: () => context.read<MaintenanceDetailCubit>().load(),
            ),
          );
        }
        return _Loaded(job: state.job!, vendors: _vendors);
      },
    );
  }
}

(int, int) _costBreakdown(String type) => switch (type) {
      'Battery' => (4200, 800),
      'Brakes' => (550, 350),
      'Tyres' => (1800, 200),
      'IoT' => (900, 300),
      'Body' => (1200, 600),
      'Pre-delivery' => (200, 150),
      _ => (650, 450),
    };

class _Loaded extends StatelessWidget {
  const _Loaded({required this.job, required this.vendors});

  final MaintenanceJob job;
  final List<VendorOption> vendors;

  @override
  Widget build(BuildContext context) {
    final (parts, labour) = _costBreakdown(job.type);
    final int total = parts + labour;

    return HeroScaffold(
      bandColor: AppColors.ink,
      bottomPadding: job.isClosed ? 40 : 110,
      band: _Band(job: job),
      bottomNavigationBar: job.isClosed
          ? null
          : _Footer(
              onUpdateStatus: () => _openStatusSheet(context),
              onClose: () => _confirmClose(context),
            ),
      children: [
          PhotoPanel(
            photo: BrandPhoto.service,
            height: 150,
            title: job.vehicleNumber,
            subtitle: job.model,
            badge: StatusChip(
              label: job.isClosed
                  ? 'Closed ${Fmt.date(job.closedOn ?? job.dueOn)}'
                  : 'Due ${Fmt.date(job.dueOn)}',
              tone: job.isPastDue ? StatusTone.danger : StatusTone.neutral,
              icon: Icons.event_rounded,
              showDot: false,
              dense: true,
              solid: job.isPastDue,
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Issue',
            leading: const IconTile(icon: Icons.report_problem_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job.issue, style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.45)),
                const SizedBox(height: Insets.md),
                Divider(color: AppColors.stroke.withValues(alpha: 0.6), height: 1),
                const SizedBox(height: Insets.md),
                KeyValueRow(label: 'Odometer', value: '${Fmt.number(job.odometerKm)} km', icon: Icons.speed_rounded),
                if (job.rider != null)
                  KeyValueRow(label: 'Rider on file', value: job.rider!, icon: Icons.person_rounded),
                if (job.bay != null)
                  KeyValueRow(label: 'Bay', value: job.bay!, icon: Icons.garage_rounded),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Assigned vendor',
            leading: const IconTile(icon: Icons.handyman_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const IconTile(icon: Icons.build_rounded, tone: AppColors.primary, size: 44),
                    const SizedBox(width: Insets.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.assignedTo ?? 'Unassigned',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.titleSmall.copyWith(fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            job.assignedTo == null ? 'Assign a vendor to start work' : 'Service partner',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodySmall.copyWith(fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.md),
                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: Insets.sm,
                  runSpacing: Insets.sm,
                  children: [
                    if (job.assignedTo != null)
                      CircleIconButton(
                        icon: Icons.call_rounded,

                        background: AppColors.primaryWash,
                        foreground: AppColors.primary,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AppSnack.info(context, 'Calling ${job.assignedTo}…');
                        },
                      ),
                    GhostButton(
                      label: 'Reassign',
                      icon: Icons.swap_horiz_rounded,
                      onPressed: job.isClosed ? null : () => _openReassignSheet(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Job timeline',
            leading: const IconTile(icon: Icons.timeline_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              children: [
                _TimelineRow(
                  icon: Icons.flag_rounded,
                  title: 'Raised',
                  time: Fmt.dateTime(job.openedOn),
                  done: true,
                  isLast: false,
                ),
                _TimelineRow(
                  icon: Icons.assignment_ind_rounded,
                  title: job.assignedTo == null ? 'Awaiting vendor assignment' : 'Assigned to ${job.assignedTo}',
                  time: job.assignedTo == null ? 'Pending' : 'Done',
                  done: job.assignedTo != null,
                  isLast: false,
                ),
                _TimelineRow(
                  icon: Icons.build_circle_rounded,
                  title: 'In progress',
                  time: job.status == 'inProgress' || job.isClosed ? 'Done' : 'Pending',
                  done: job.status == 'inProgress' || job.isClosed,
                  isLast: false,
                ),
                _TimelineRow(
                  icon: Icons.check_circle_rounded,
                  title: 'Closed',
                  time: job.isClosed ? Fmt.dateTime(job.closedOn ?? job.dueOn) : 'Pending',
                  done: job.isClosed,
                  isLast: true,
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Cost breakdown',
            leading: const IconTile(icon: Icons.receipt_long_rounded, tone: AppColors.primary, size: 28),
            child: Column(
              children: [
                KeyValueRow(label: 'Parts', value: Fmt.money(parts)),
                KeyValueRow(label: 'Labour', value: Fmt.money(labour)),
                const Divider(color: AppColors.stroke, height: Insets.xl),
                KeyValueRow(
                  label: 'Total',
                  value: Fmt.money(total),
                  valueStyle: AppText.numeric.copyWith(fontSize: 17, color: AppColors.primary),
                ),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Photo evidence',
            leading: const IconTile(icon: Icons.photo_camera_rounded, tone: AppColors.primary, size: 28),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: Insets.md,
              mainAxisSpacing: Insets.md,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const PhotoSlot(label: 'Issue', captured: true),
                PhotoSlot(label: 'In progress', captured: job.status == 'inProgress' || job.isClosed),
                PhotoSlot(label: 'Completed', captured: job.isClosed),
              ],
            ),
          ),
          const Gap.lg(),

          ModuleCard(
            title: 'Notes',
            actionLabel: 'Add note',
            onAction: job.isClosed ? null : () => _openAddNoteSheet(context),
            child: job.notes.isEmpty
                ? const EmptyState(
                    title: 'No notes yet',
                    message: 'Updates from the workshop will show up here.',
                    icon: Icons.notes_rounded,
                    compact: true,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final n in job.notes) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, size: 6, color: AppColors.primary),
                            const SizedBox(width: Insets.sm),
                            Expanded(
                              child: Text(n, style: AppText.bodyMedium.copyWith(fontSize: 13)),
                            ),
                          ],
                        ),
                        if (n != job.notes.last) const Gap.md(),
                      ],
                    ],
                  ),
          ),
        ],
    );
  }

  Future<void> _confirmClose(BuildContext context) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: 'Close this job?',
      message: '${job.id} will be marked closed. This cannot be undone from here.',
      confirmLabel: 'Close job',
      icon: Icons.check_circle_rounded,
      tone: AppColors.success,
    );
    if (!confirmed || !context.mounted) return;
    context.read<MaintenanceDetailCubit>().closeJob();
    AppSnack.success(context, '${job.id} closed.');
  }

  Future<void> _openStatusSheet(BuildContext context) async {
    final MaintenanceDetailCubit cubit = context.read<MaintenanceDetailCubit>();
    final String? picked = await AppSheet.show<String>(
      context,
      title: 'Update status',
      subtitle: job.id,
      child: Column(
        children: [
          for (final s in const ['open', 'inProgress', 'overdue'])
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: job.status == s,
                title: jobStatusLabel(s),
                onTap: () => Navigator.of(context).pop(s),
              ),
            ),
        ],
      ),
    );
    if (picked != null && context.mounted) {
      cubit.updateStatus(picked);
      AppSnack.success(context, 'Status updated to ${jobStatusLabel(picked)}.');
    }
  }

  Future<void> _openReassignSheet(BuildContext context) async {
    final MaintenanceDetailCubit cubit = context.read<MaintenanceDetailCubit>();
    if (vendors.isEmpty) {
      AppSnack.warning(context, 'No vendors available to reassign right now.');
      return;
    }
    final String? picked = await AppSheet.show<String>(
      context,
      title: 'Reassign vendor',
      subtitle: job.id,
      child: Column(
        children: [
          for (final v in vendors)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm + 2),
              child: AppRadioTile(
                selected: job.assignedTo == v.name,
                title: v.name,
                subtitle: '${v.type} · ★ ${v.rating.toStringAsFixed(1)}',
                onTap: () => Navigator.of(context).pop(v.name),
              ),
            ),
        ],
      ),
    );
    if (picked != null && context.mounted) {
      cubit.reassignVendor(picked);
      AppSnack.success(context, 'Reassigned to $picked.');
    }
  }

  Future<void> _openAddNoteSheet(BuildContext context) async {
    final MaintenanceDetailCubit cubit = context.read<MaintenanceDetailCubit>();
    final TextEditingController controller = TextEditingController();
    final String? note = await AppSheet.show<String>(
      context,
      title: 'Add a note',
      subtitle: job.id,
      child: AppTextField(
        label: 'Note',
        hint: 'What happened, or what is needed next',
        maxLines: 4,
        controller: controller,
        autofocus: true,
      ),
      footer: PrimaryButton(
        label: 'Save note',
        onPressed: () => Navigator.of(context).pop(controller.text),
      ),
    );
    if (note != null && note.trim().isNotEmpty && context.mounted) {
      cubit.addNote(note);
      AppSnack.success(context, 'Note added.');
    }
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.title,
    required this.time,
    required this.done,
    required this.isLast,
  });

  final IconData icon;
  final String title;
  final String time;
  final bool done;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Color tone = done ? AppColors.success : AppColors.textMuted;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: done ? AppColors.washFor(tone) : AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                  border: Border.all(color: done ? tone.withValues(alpha: 0.3) : AppColors.stroke),
                ),
                child: Icon(icon, size: 15, color: tone),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.4,
                    color: AppColors.stroke,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : Insets.lg, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.titleSmall.copyWith(fontSize: 13.5)),
                  const SizedBox(height: 2),
                  Text(time, style: AppText.bodySmall.copyWith(fontSize: 11.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.job});

  final MaintenanceJob job;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => InkCircleButton(
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Spacer(),
            StatusChip(
              label: jobStatusLabel(job.status),
              tone: jobStatusTone(job.status),
              dense: true,
              solid: true,
            ),
          ],
        ),
        const Gap.xl(),
        Text(
          '${job.id} · ${job.type}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.bodySmall.copyWith(fontSize: 12, color: AppColors.onInkSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          job.vehicleNumber,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.displaySmall.copyWith(fontSize: 24, color: AppColors.onInk),
        ),
        const Gap.lg(),
        StatusChip(
          label: jobPriorityLabel(job.priority),
          tone: jobPriorityTone(job.priority),
          dense: true,
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.onUpdateStatus, required this.onClose});

  final VoidCallback onUpdateStatus;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Insets.gutter,
        Insets.md,
        Insets.gutter,
        MediaQuery.paddingOf(context).bottom + Insets.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.stroke)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SecondaryButton(
              label: 'Update status',
              size: AppButtonSize.medium,
              onPressed: onUpdateStatus,
            ),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: PrimaryButton(
              label: 'Close job',
              icon: Icons.check_circle_rounded,
              size: AppButtonSize.medium,
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}
