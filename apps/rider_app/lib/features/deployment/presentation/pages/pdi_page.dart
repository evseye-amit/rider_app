import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deployment_provider.dart';
import '../providers/pdi_checklist_provider.dart';

class PdiPage extends ConsumerWidget {
  const PdiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);
    final RiderDeployment? current = deployment.value;
    final String? allocationId = current?.allocation?.id;
    final List<PdiChecklistItem> items = current?.workflow?.pdiChecklist ?? const [];

    if (deployment.hasError || (allocationId == null && !deployment.isLoading)) {
      return AppScaffold(
        title: context.l10n.commonPreDeliveryInspection,
        showBack: false,
        body: EmptyState(
          title: context.l10n.deploymentCouldNotLoadChecklist,
          message: deployment.failureMessage ?? context.l10n.deploymentFleetManagerHasNotSubmitted,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.read(deploymentProvider.notifier).refresh(),
        ),
      );
    }

    if (allocationId == null || items.isEmpty) {
      return AppScaffold(
        title: context.l10n.commonPreDeliveryInspection,
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

    return _PdiView(deployment: current!, allocationId: allocationId);
  }
}

class _PdiView extends ConsumerWidget {
  const _PdiView({required this.deployment, required this.allocationId});

  final RiderDeployment deployment;
  final String allocationId;

  Future<void> _fail(BuildContext context, PdiChecklistNotifier checklist, PdiChecklistItem item) async {
    final TextEditingController controller = TextEditingController();
    final String fallbackNote = context.l10n.deploymentFlaggedByRider;
    final String? note = await AppSheet.show<String>(
      context,
      title: context.l10n.deploymentWhatWrong,
      subtitle: item.label,
      child: AppTextField(
        label: context.l10n.deploymentNoteWorkshopTeam,
        hint: context.l10n.pdiHintTyreWorn,
        maxLines: 3,
        controller: controller,
        autofocus: true,
      ),
      footer: PrimaryButton(
        label: context.l10n.deploymentFlagAsProblem,
        icon: Icons.flag_rounded,
        onPressed: () => Navigator.of(context).pop(controller.text.trim()),
      ),
    );
    if (note == null) return;
    checklist
      ..setVerdict(item.code, CheckState.fail)
      ..setNote(item.code, note.isEmpty ? fallbackNote : note);
  }

  Future<void> _submit(BuildContext context, WidgetRef ref, PdiChecklistState state) async {
    final bool confirmed = await AppDialog.confirm(
      context,
      title: state.anyFailed ? context.l10n.deploymentSubmitWithProblemsFlagged : context.l10n.deploymentAcceptScooter2,
      message: state.anyFailed
          ? context.l10n.deploymentItemsMarkedAsProblemGo
          : context.l10n.deploymentConfirmEveryItemHasBeen,
      confirmLabel: state.anyFailed ? context.l10n.commonSubmitInspection : context.l10n.deploymentAcceptScooter,
      icon: Icons.fact_check_rounded,
    );
    if (!confirmed || !context.mounted) return;

    final Result<DeploymentWorkflow> result = await ref.read(pdiChecklistProvider(allocationId).notifier).submit();
    if (!context.mounted) return;
    switch (result) {
      case Ok<DeploymentWorkflow>():
        AppSnack.success(context, context.l10n.deploymentInspectionAccepted);
        await ref.read(deploymentProvider.notifier).refresh(silent: true);
      case Err<DeploymentWorkflow>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeploymentFleet? fleet = deployment.allocation?.fleet;
    final String? partner = deployment.workflow?.workPartnerName;
    final PdiChecklistState state = ref.watch(pdiChecklistProvider(allocationId));
    final PdiChecklistNotifier checklist = ref.watch(pdiChecklistProvider(allocationId).notifier);

    return AppScaffold(
      title: context.l10n.commonPreDeliveryInspection,
      subtitle: fleet == null
          ? null
          : '${fleet.vehicleNumber}${fleet.modelName == null ? '' : ' · ${fleet.modelName}'}',
      showBack: false,
      footer: PrimaryButton(
        label: state.allChecked && !state.anyFailed
            ? context.l10n.deploymentAcceptScooter
            : context.l10n.commonSubmitInspection,
        icon: Icons.fact_check_rounded,
        loading: state.isSubmitting,
        onPressed: state.allChecked && !state.isSubmitting ? () => _submit(context, ref, state) : null,
      ),
      body: PageBody(
        children: [
          _Band(state: state, partner: partner),
          const Gap.lg(),
          ModuleCard(
            title: context.l10n.deploymentCheckEachItem,
            leading: const IconTile(icon: Icons.checklist_rounded, solid: true, size: 28),
            child: Column(
              children: [
                for (final PdiChecklistItem item in state.items) ...[
                  ChecklistTile(
                    title: item.label,
                    subtitle: item.mandatory ? context.l10n.commonMandatory : context.l10n.commonOptional,
                    state: state.verdictOf(item.code),
                    note: state.notes[item.code],
                    onPass: () => checklist.setVerdict(item.code, CheckState.pass),
                    onFail: () => _fail(context, checklist, item),
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
  }
}

class _Band extends StatelessWidget {
  const _Band({required this.state, required this.partner});

  final PdiChecklistState state;
  final String? partner;

  @override
  Widget build(BuildContext context) {
    return ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.deploymentGoThroughEachItemWith, style: AppText.bodySmall.copyWith(height: 1.5)),
          if (partner != null && partner!.isNotEmpty) ...[
            const Gap.sm(),
            Text(context.l10n.pdiInspectedBy(partner!), style: AppText.bodySmall.copyWith(color: AppColors.textMuted)),
          ],
          const Gap.lg(),
          LabeledProgress(
            value: state.total == 0 ? 0 : state.checked / state.total,
            label: '${state.checked} of ${state.total} checked',
            trailingLabel: state.anyFailed ? '${state.flagged} flagged' : null,
            color: state.anyFailed ? AppColors.warning : AppColors.primary,
          ),
        ],
      ),
    );
  }
}
