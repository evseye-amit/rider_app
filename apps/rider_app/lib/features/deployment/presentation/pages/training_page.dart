import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/rider_session_provider.dart';
import '../providers/deployment_provider.dart';
import '../widgets/training_modules.dart';

class TrainingPage extends ConsumerStatefulWidget {
  const TrainingPage({super.key});

  @override
  ConsumerState<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends ConsumerState<TrainingPage> {
  final Set<TrainingModule> _viewed = {};
  bool _finishing = false;

  Future<void> _open(TrainingModule module) async {
    final bool? done = await AppSheet.show<bool>(
      context,
      title: module.title(context.l10n),
      subtitle: module.summary(context.l10n),
      maxHeightFactor: 0.92,
      child: _ModuleSheet(module: module),
      footer: PrimaryButton(
        label: context.l10n.deploymentDone,
        icon: Icons.check_rounded,
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    if (done == true && mounted) setState(() => _viewed.add(module));
  }

  Future<void> _finish(String allocationId) async {
    setState(() => _finishing = true);
    AppSnack.success(context, context.l10n.deploymentHygieneComplete);
    await ref.read(riderSessionProvider.notifier).finishHygiene(allocationId);
    if (mounted) setState(() => _finishing = false);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RiderDeployment> deployment = ref.watch(deploymentProvider);
    final String? allocationId = deployment.value?.allocation?.id;

    if (deployment.hasError || (allocationId == null && !deployment.isLoading)) {
      return AppScaffold(
        title: context.l10n.deploymentRiderHygiene,
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

    final int viewed = _viewed.length;
    final int total = TrainingModule.values.length;

    return AppScaffold(
      title: context.l10n.deploymentRiderHygiene,
      subtitle: '$viewed of $total completed',
      showBack: false,
      footer: PrimaryButton(
        label: context.l10n.deploymentFinishHygieneCheck,
        icon: Icons.school_rounded,
        loading: _finishing,
        onPressed: viewed == total && !_finishing && allocationId != null ? () => _finish(allocationId) : null,
      ),
      body: PageBody(
        children: [
          ModuleCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.deploymentOpenEachModuleReadThrough, style: AppText.bodySmall.copyWith(height: 1.5)),
                const Gap.lg(),
                LabeledProgress(value: viewed / total, label: '$viewed of $total viewed'),
              ],
            ),
          ),
          const Gap.lg(),
          for (final TrainingModule module in TrainingModule.values) ...[
            _ModuleTile(
              module: module,
              number: module.index + 1,
              viewed: _viewed.contains(module),
              onTap: () => _open(module),
            ),
            const Gap.md(),
          ],
          const Gap.xl(),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module, required this.number, required this.viewed, required this.onTap});

  final TrainingModule module;
  final int number;
  final bool viewed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: Corners.brLg,
          border: Border.all(color: viewed ? AppColors.success.withValues(alpha: 0.35) : AppColors.stroke),
          boxShadow: Shadows.card,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: Corners.brMd,
              child: Image.asset(
                module.asset,
                width: 72,
                height: 96,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                cacheWidth: 288,
              ),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _NumberBadge(number: number, solid: true),
                      const SizedBox(width: Insets.sm),
                      Expanded(
                        child: Text(
                          module.title(context.l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.titleMedium.copyWith(fontSize: 15.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Insets.xs),
                  Text(
                    module.summary(context.l10n),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.4),
                  ),
                  const SizedBox(height: Insets.sm),
                  StatusChip(
                    label: viewed ? context.l10n.trainingViewed : context.l10n.deploymentRequired,
                    tone: viewed ? StatusTone.success : StatusTone.warning,
                    dense: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Insets.sm),
            Icon(
              viewed ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
              color: viewed ? AppColors.success : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleSheet extends StatelessWidget {
  const _ModuleSheet({required this.module});

  final TrainingModule module;

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> points = module.points(context.l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Pressable(
          onTap: () => PhotoViewer.showImage(context, AssetImage(module.asset)),
          scale: 0.99,
          child: ClipRRect(
            borderRadius: Corners.brLg,
            child: Image.asset(module.asset, fit: BoxFit.fitWidth),
          ),
        ),
        const Gap.xl(),
        Text(context.l10n.trainingKeyPoints, style: AppText.titleMedium.copyWith(fontSize: 15.5)),
        const Gap.md(),
        for (final (int index, (String title, String body)) in points.indexed) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberBadge(number: index + 1),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.titleSmall.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(body, style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          if (index < points.length - 1) const Gap.md(),
        ],
        const Gap.sm(),
      ],
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, this.solid = false});

  final int number;
  final bool solid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: solid ? AppColors.primary : AppColors.primaryWash, shape: BoxShape.circle),
      child: Text(
        '$number',
        style: AppText.label.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: solid ? AppColors.textOnPrimary : AppColors.primary,
        ),
      ),
    );
  }
}
