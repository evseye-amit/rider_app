import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class SubmitPdiParams {
  const SubmitPdiParams({required this.allocationId, required this.workPartner, required this.checklist});

  final String allocationId;
  final WorkPartnerOption workPartner;
  final List<PdiChecklistItem> checklist;
}

class SubmitPdi extends UseCase<DeploymentWorkflow, SubmitPdiParams> {
  const SubmitPdi(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(SubmitPdiParams params) =>
      _repository.submitPdi(params.allocationId, workPartner: params.workPartner, checklist: params.checklist);
}
