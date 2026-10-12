import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class ApplyReferralCode extends UseCase<void, String> {
  const ApplyReferralCode(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.applyReferralCode(params);
}
