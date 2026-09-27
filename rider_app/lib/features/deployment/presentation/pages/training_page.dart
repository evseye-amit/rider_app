import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/deployment_provider.dart';
import '../providers/training_provider.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  bool _finishing = false;

  Future<void> _open(String allocationId, TrainingItem item) async {
    await AppSheet.show<void>(
      context,
      title: item.title,
      subtitle: item.isMandatory ? context.l10n.commonMandatory : context.l10n.commonOptional,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.downloadUrl != null)
            ClipRRect(
              borderRadius: Corners.brLg,
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.network(
                  item.downloadUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: AppColors.surfaceMuted,
                    child: Center(child: Icon(Icons.school_rounded, size: 40, color: AppColors.textMuted)),
                  ),
                ),
              ),
            ),
          const Gap.lg(),
          Text(
            item.description ?? context.l10n.deploymentReadThroughModuleWithTeam,
            style: AppText.bodyMedium.copyWith(height: 1.55),
          ),
          const Gap.lg(),
        ],
      ),
      footer: PrimaryButton(
        label: context.l10n.deploymentDone,
        icon: Icons.check_rounded,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
    if (!mounted || item.viewed) return;

    final Result<DeploymentWorkflow> marked = await ref
        .read(trainingProvider(allocationId).notifier)
        .markViewed(item.code);
    if (!mounted) return;
    if (marked case Err<DeploymentWorkflow>(:final failure)) AppSnack.error(context, failure.message);
  }

  Future<void> _finish(String allocationId) async {
    setState(() => _finishing = true);
    final Result<DeploymentWorkflow> result = await ref.read(trainingProvider(allocationId).notifier).complete();
    if (!mounted) return;
    setState(() => _finishing = false);

    switch (result) {
      case Ok<DeploymentWorkflow>():
        AppSnack.success(context, context.l10n.deploymentTrainingComplete);
        await ref.read(deploymentProvider.notifier).refresh(silent: true);
      case Err<DeploymentWorkflow>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);
    final String? allocationId = deployment.value?.allocation?.id;

    if (deployment.hasError || (allocationId == null && !deployment.isLoading)) {
      return AppScaffold(
        title: context.l10n.deploymentSafetyTraining,
        showBack: false,
        body: EmptyState(
          title: context.l10n.deploymentCouldNotLoadTraining,
          message: deployment.failureMessage,
          icon: Icons.cloud_off_rounded,
          tone: AppColors.danger,
          actionLabel: context.l10n.commonTryAgain,
          onAction: () => ref.read(deploymentProvider.notifier).refresh(),
        ),
      );
    }

    final AsyncValue<List<TrainingItem>>? training = allocationId == null
        ? null
        : ref.watch(trainingProvider(allocationId));
    final List<TrainingItem>? items = training?.value;
    final int viewed = items?.where((item) => item.viewed).length ?? 0;
    final bool ready = items != null && items.where((item) => item.isMandatory).every((item) => item.viewed);

    return AppScaffold(
      title: context.l10n.deploymentSafetyTraining,
      subtitle: items == null ? null : '$viewed of ${items.length} completed',
      showBack: false,
      footer: PrimaryButton(
        label: context.l10n.deploymentFinishTraining,
        icon: Icons.school_rounded,
        loading: _finishing,
        onPressed: ready && !_finishing && allocationId != null ? () => _finish(allocationId) : null,
      ),
      body: PageBody(
        children: [
          if (training != null && training.hasError)
            EmptyState(
              title: context.l10n.deploymentTrainingUnavailable,
              message: training.failureMessage,
              icon: Icons.school_outlined,
              tone: AppColors.warning,
              actionLabel: context.l10n.commonRetry,
              onAction: () => ref.invalidate(trainingProvider(allocationId!)),
            )
          else if (items == null)
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: Insets.md),
                child: ShimmerBox(height: 96, borderRadius: Corners.brLg),
              ),
            )
          else ...[
            ModuleCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.deploymentOpenEachModuleReadThrough,
                    style: AppText.bodySmall.copyWith(height: 1.5),
                  ),
                  const Gap.lg(),
                  LabeledProgress(
                    value: items.isEmpty ? 0 : viewed / items.length,
                    label: '$viewed of ${items.length} viewed',
                  ),
                ],
              ),
            ),
            const Gap.lg(),
            for (final TrainingItem item in items) ...[
              AppNavTile(
                title: item.title,
                subtitle:
                    item.description ??
                    (item.isMandatory ? context.l10n.deploymentMandatoryModule : context.l10n.deploymentOptionalModule),
                icon: item.viewed ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded,
                iconColor: item.viewed ? AppColors.success : AppColors.primary,
                badge: item.isMandatory && !item.viewed ? context.l10n.deploymentRequired : null,
                onTap: allocationId == null ? null : () => _open(allocationId, item),
              ),
              const Gap.sm(),
            ],
          ],
          const Gap.xl(),
        ],
      ),
    );
  }
}
