import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../deployment_dependencies.dart';
import '../../domain/usecases/mark_training_viewed.dart';

class TrainingNotifier extends AsyncNotifier<List<TrainingItem>> {
  TrainingNotifier(this._allocationId);

  final String _allocationId;

  @override
  Future<List<TrainingItem>> build() => _fetch();

  Future<Result<DeploymentWorkflow>> complete() async {
    final Result<List<TrainingItem>> training = await ref.read(getTrainingProvider)(_allocationId);
    if (training case Err<List<TrainingItem>>(:final failure)) return Result.err(failure);
    for (final TrainingItem item in training.valueOrNull ?? const <TrainingItem>[]) {
      if (item.viewed) continue;
      final Result<DeploymentWorkflow> marked = await ref.read(markTrainingViewedProvider)(
        TrainingViewedParams(allocationId: _allocationId, contentCode: item.code),
      );
      if (marked case Err<DeploymentWorkflow>(:final failure)) return Result.err(failure);
    }
    return ref.read(completeTrainingProvider)(_allocationId);
  }

  Future<List<TrainingItem>> _fetch() async {
    final List<TrainingItem> items = (await ref.read(getTrainingProvider)(_allocationId)).getOrThrow();
    return [...items]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }
}

final trainingProvider = AsyncNotifierProvider.autoDispose.family<TrainingNotifier, List<TrainingItem>, String>(
  TrainingNotifier.new,
);
