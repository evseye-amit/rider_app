import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/usecases/accept_pdi.dart';
import '../cubit/deployment_cubit.dart';
import '../cubit/pdi_cubit.dart';

class PdiPage extends StatelessWidget {
  const PdiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentCubit(sl<SessionController>())..load(silent: sl<SessionController>().deployment != null),
      child: const _PdiLoader(),
    );
  }
}

class _PdiLoader extends StatelessWidget {
  const _PdiLoader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeploymentCubit, DeploymentState>(
      buildWhen: (a, b) => a.deployment?.allocation?.id != b.deployment?.allocation?.id || a.status != b.status,
      builder: (context, state) {
        final RiderDeployment? d = state.deployment;
        final String? allocationId = d?.allocation?.id;
        final List<PdiChecklistItem> items = d?.workflow?.pdiChecklist ?? const [];

        if (state.status == DeploymentLoad.failure || (allocationId == null && !state.isLoading)) {
          return AppScaffold(
            title: 'Pre-delivery inspection',
            showBack: false,
            body: EmptyState(
              title: 'Could not load the checklist',
              message: state.message ?? 'Your fleet manager has not submitted the inspection yet.',
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: context.read<DeploymentCubit>().load,
            ),
          );
        }
        if (allocationId == null || items.isEmpty) {
          return AppScaffold(
            title: 'Pre-delivery inspection',
            showBack: false,
            body: PageBody(
              children: List.generate(
                4,
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: Insets.md),
                  child: ShimmerBox(height: 74, borderRadius: Corners.brMd),
                ),
              ),
            ),
          );
        }

        return BlocProvider(
          key: ValueKey(allocationId),
          create: (_) => PdiCubit(items: items, acceptPdi: AcceptPdi(sl()), allocationId: allocationId),
          child: _PdiView(deployment: d!),
        );
      },
    );
  }
}

class _PdiView extends StatelessWidget {
  const _PdiView({required this.deployment});

  final RiderDeployment deployment;

  Future<void> _fail(BuildContext context, PdiCubit cubit, PdiChecklistItem item) async {
    final TextEditingController controller = TextEditingController();
    final String? note = await AppSheet.show<String>(
      context,
      title: 'What is wrong?',
      subtitle: item.label,
      child: AppTextField(
        label: 'Note for the workshop team',
        hint: 'e.g. Front tyre worn below limit',
        maxLines: 3,
        controller: controller,
        autofocus: true,
      ),
      footer: PrimaryButton(
        label: 'Flag as a problem',
        icon: Icons.flag_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
    if (note == null) return;
    cubit.setVerdict(item.code, CheckState.fail);

    cubit.setNote(item.code, note.isEmpty ? 'Flagged by rider' : note);
  }

  Future<void> _submit(BuildContext context, PdiCubit cubit, PdiState state) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: state.anyFailed ? 'Submit with problems flagged?' : 'Accept this scooter?',
      message: state.anyFailed
          ? 'Items marked as a problem go to your fleet manager with your notes. The handover continues on the rest.'
          : 'You confirm every item has been checked with your team lead and the scooter is fit to ride.',
      confirmLabel: state.anyFailed ? 'Submit inspection' : 'Accept scooter',
      icon: Icons.fact_check_rounded,
    );
    if (!confirmed || !context.mounted) return;
    final bool ok = await cubit.submit();
    if (!context.mounted) return;
    if (ok) {
      AppSnack.success(context, 'Inspection accepted');

      await context.read<DeploymentCubit>().load(silent: true);
    } else {
      AppSnack.error(context, cubit.state.message ?? 'Could not submit the inspection');
    }
  }

  @override
  Widget build(BuildContext context) {
    final DeploymentFleet? fleet = deployment.allocation?.fleet;
    final String? partner = deployment.workflow?.workPartnerName;

    return BlocBuilder<PdiCubit, PdiState>(
      builder: (context, state) {
        final PdiCubit cubit = context.read<PdiCubit>();
        return AppScaffold(
          title: 'Pre-delivery inspection',
          subtitle: fleet == null ? null : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
          showBack: false,
          footer: PrimaryButton(
            label: state.allChecked ? (state.anyFailed ? 'Submit inspection' : 'Accept scooter') : 'Submit inspection',
            icon: Icons.fact_check_rounded,
            loading: state.isSubmitting,
            onPressed: state.allChecked && !state.isSubmitting ? () => _submit(context, cubit, state) : null,
          ),
          body: PageBody(
            children: [
              _Band(state: state, partner: partner),
              const Gap.lg(),
              ModuleCard(
                title: 'Check each item',
                leading: const IconTile(icon: Icons.checklist_rounded, solid: true, size: 28),
                child: Column(
                  children: [
                    for (final item in state.items) ...[
                      ChecklistTile(
                        title: item.label,
                        subtitle: item.mandatory ? 'Mandatory' : 'Optional',
                        state: state.verdictOf(item.code),
                        note: state.notes[item.code],
                        onPass: () => cubit.setVerdict(item.code, CheckState.pass),
                        onFail: () => _fail(context, cubit, item),
                      ),
                      if (item != state.items.last) const Gap.md(),
                    ],
                  ],
                ),
              ),
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.state, required this.partner});

  final PdiState state;
  final String? partner;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Go through each item with your team lead. Flag anything that is not right — it goes to the workshop with your note.',
            style: AppText.bodySmall.copyWith(height: 1.5),
          ),
          if (partner != null && partner!.isNotEmpty) ...[
            const Gap.sm(),
            Text('Inspected by $partner', style: AppText.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
          const Gap.lg(),
          LabeledProgress(
            value: state.total == 0 ? 0 : state.checked / state.total,
            label: '${state.checked} of ${state.total} checked',
            trailingLabel: state.anyFailed ? '${state.verdicts.values.where((v) => v == CheckState.fail).length} flagged' : null,
            color: state.anyFailed ? AppColors.warning : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
