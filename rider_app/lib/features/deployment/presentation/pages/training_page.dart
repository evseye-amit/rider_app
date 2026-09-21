import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/session/session_controller.dart';
import '../../domain/usecases/complete_training.dart';
import '../../domain/usecases/get_training.dart';
import '../../domain/usecases/mark_training_viewed.dart';
import '../cubit/deployment_cubit.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeploymentCubit(sl<SessionController>())..load(silent: sl<SessionController>().deployment != null),
      child: const _TrainingView(),
    );
  }
}

class _TrainingView extends StatefulWidget {
  const _TrainingView();

  @override
  State<_TrainingView> createState() => _TrainingViewState();
}

class _TrainingViewState extends State<_TrainingView> {
  List<TrainingItem>? _items;
  String? _error;
  String? _loadedFor;
  bool _finishing = false;

  Future<void> _load(String allocationId, {bool force = false}) async {
    if (!force && _loadedFor == allocationId) return;
    _loadedFor = allocationId;
    final Result<List<TrainingItem>> result = await GetTraining(sl())(allocationId);
    if (!mounted) return;
    setState(() {
      switch (result) {
        case Ok<List<TrainingItem>>(:final value):
          _items = [...value]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
          _error = null;
        case Err<List<TrainingItem>>(:final failure):
          _error = failure.message;
      }
    });
  }

  Future<void> _open(BuildContext context, String allocationId, TrainingItem item) async {
    await AppSheet.show<void>(
      context,
      title: item.title,
      subtitle: item.isMandatory ? 'Mandatory' : 'Optional',
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
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: AppColors.surfaceMuted,
                    child: Center(child: Icon(Icons.school_rounded, size: 40, color: AppColors.textMuted)),
                  ),
                ),
              ),
            ),
          const Gap.lg(),
          Text(item.description ?? 'Read through this module with your team lead before you ride.', style: AppText.bodyMedium.copyWith(height: 1.55)),
          const Gap.lg(),
        ],
      ),
      footer: PrimaryButton(label: 'Done', icon: Icons.check_rounded, onPressed: () => Navigator.of(context).pop()),
    );
    if (!mounted || item.viewed) return;
    final Result<DeploymentWorkflow> marked =
        await MarkTrainingViewed(sl())(TrainingViewedParams(allocationId: allocationId, contentCode: item.code));
    if (!mounted) return;
    if (marked.isOk) {
      await _load(allocationId, force: true);
    } else {
      AppSnack.error(this.context, marked.failureOrNull!.message);
    }
  }

  Future<void> _finish(BuildContext context, String allocationId) async {
    setState(() => _finishing = true);
    final Result<DeploymentWorkflow> result = await CompleteTraining(sl())(allocationId);
    if (!context.mounted) return;
    setState(() => _finishing = false);
    switch (result) {
      case Ok<DeploymentWorkflow>():
        AppSnack.success(context, 'Training complete');
        await context.read<DeploymentCubit>().load(silent: true);
      case Err<DeploymentWorkflow>(:final failure):
        AppSnack.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeploymentCubit, DeploymentState>(
      builder: (context, state) {
        final String? allocationId = state.deployment?.allocation?.id;
        if (allocationId != null) _load(allocationId);

        if (state.status == DeploymentLoad.failure || (allocationId == null && !state.isLoading)) {
          return AppScaffold(
            title: 'Safety training',
            showBack: false,
            body: EmptyState(
              title: 'Could not load training',
              message: state.message,
              icon: Icons.cloud_off_rounded,
              tone: AppColors.danger,
              actionLabel: 'Try again',
              onAction: context.read<DeploymentCubit>().load,
            ),
          );
        }

        final List<TrainingItem>? items = _items;
        final bool ready = items != null && items.where((i) => i.isMandatory).every((i) => i.viewed);
        final int viewed = items?.where((i) => i.viewed).length ?? 0;

        return AppScaffold(
          title: 'Safety training',
          subtitle: items == null ? null : '$viewed of ${items.length} completed',
          showBack: false,
          footer: PrimaryButton(
            label: 'Finish training',
            icon: Icons.school_rounded,
            loading: _finishing,
            onPressed: ready && !_finishing && allocationId != null ? () => _finish(context, allocationId) : null,
          ),
          body: PageBody(
            children: [
              if (_error != null)
                EmptyState(
                  title: 'Training unavailable',
                  message: _error,
                  icon: Icons.school_outlined,
                  tone: AppColors.warning,
                  actionLabel: 'Retry',
                  onAction: allocationId == null ? null : () => _load(allocationId, force: true),
                )
              else if (items == null)
                ...List.generate(3, (_) => const Padding(padding: EdgeInsets.only(bottom: Insets.md), child: ShimmerBox(height: 96, borderRadius: Corners.brLg)))
              else ...[
                ModuleCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open each module and read it through. Mandatory ones must be completed before you can finish.',
                          style: AppText.bodySmall.copyWith(height: 1.5)),
                      const Gap.lg(),
                      LabeledProgress(
                        value: items.isEmpty ? 0 : viewed / items.length,
                        label: '$viewed of ${items.length} viewed',
                      ),
                    ],
                  ),
                ),
                const Gap.lg(),
                for (final item in items) ...[
                  AppNavTile(
                    title: item.title,
                    subtitle: item.description ?? (item.isMandatory ? 'Mandatory module' : 'Optional module'),
                    icon: item.viewed ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded,
                    iconColor: item.viewed ? AppColors.success : AppColors.primary,
                    badge: item.isMandatory && !item.viewed ? 'Required' : null,
                    onTap: allocationId == null ? null : () => _open(context, allocationId, item),
                  ),
                  const Gap.sm(),
                ],
              ],
              const Gap.xl(),
            ],
          ),
        );
      },
    );
  }
}
