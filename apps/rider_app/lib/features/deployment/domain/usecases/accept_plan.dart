import 'package:evseye_core/evseye_core.dart';

import '../deployment_repository.dart';

class AcceptPlanParams {
  const AcceptPlanParams({required this.offerId, required this.termsVersion});

  final String offerId;
  final String termsVersion;
}

class AcceptPlan extends UseCase<CommercialAgreement, AcceptPlanParams> {
  const AcceptPlan(this._repository);

  final DeploymentRepository _repository;

  @override
  Future<Result<CommercialAgreement>> call(AcceptPlanParams params) =>
      _repository.acceptPlan(params.offerId, termsVersion: params.termsVersion);
}
