import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class SaveStepParams {
  const SaveStepParams({required this.stepId, required this.values});

  final String stepId;

  final Map<String, Object?> values;
}

class SaveOnboardingStep extends UseCase<RiderOnboardingConfig, SaveStepParams> {
  const SaveOnboardingStep(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<RiderOnboardingConfig>> call(SaveStepParams params) =>
      _repository.saveStep(params.stepId, params.values);
}
