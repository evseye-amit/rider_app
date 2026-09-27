import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../deployment_dependencies.dart';
import '../../domain/usecases/mark_training_viewed.dart';

class TrainingNotifier extends AsyncNotifier<List<TrainingItem>> {
  TrainingNotifier(this._allocationId);

  final String _allocationId;

  @override
  Future<List<TrainingItem>> build() => _fetch();

  Future<Result<DeploymentWorkflow>> markViewed(String contentCode) async {
    final Result<DeploymentWorkflow> result = await ref.read(markTrainingViewedProvider)(
      TrainingViewedParams(allocationId: _allocationId, contentCode: contentCode),
    );
    if (result.isOk) {
      final AsyncValue<List<TrainingItem>> refreshed = await AsyncValue.guard(_fetch);
      if (ref.mounted) state = refreshed;
    }
    return result;
  }

  Future<Result<DeploymentWorkflow>> complete() => ref.read(completeTrainingProvider)(_allocationId);

  Future<List<TrainingItem>> _fetch() async {
    final List<TrainingItem> items = (await ref.read(getTrainingProvider)(_allocationId)).getOrThrow();
    return [...items]..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }
}

final trainingProvider = AsyncNotifierProvider.autoDispose.family<TrainingNotifier, List<TrainingItem>, String>(
  TrainingNotifier.new,
);
