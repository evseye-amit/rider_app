import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class GetOnboarding extends UseCase<RiderOnboardingConfig, NoParams> {
  const GetOnboarding(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<RiderOnboardingConfig>> call(NoParams params) => _repository.fetch();
}
