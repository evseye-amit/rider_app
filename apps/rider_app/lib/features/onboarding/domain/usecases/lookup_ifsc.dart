import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class LookupIfsc extends UseCase<IfscBankDetails, String> {
  const LookupIfsc(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<IfscBankDetails>> call(String params) => _repository.lookupIfsc(params);
}
