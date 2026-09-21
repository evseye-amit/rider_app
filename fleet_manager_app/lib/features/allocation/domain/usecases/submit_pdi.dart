import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class SubmitPdiParams {
  const SubmitPdiParams({required this.allocationId, required this.workPartnerName, required this.checklist});

  final String allocationId;
  final String workPartnerName;
  final List<PdiChecklistItem> checklist;
}

class SubmitPdi extends UseCase<DeploymentWorkflow, SubmitPdiParams> {
  const SubmitPdi(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<DeploymentWorkflow>> call(SubmitPdiParams params) => _repository.submitPdi(params.allocationId, workPartnerName: params.workPartnerName, checklist: params.checklist);
}
