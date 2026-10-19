import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class AssignTeamLeadParams {
  const AssignTeamLeadParams({required this.allocationId, required this.teamLeaderId});

  final String allocationId;
  final String teamLeaderId;
}

class GetTeamLeads extends UseCase<List<TeamLeadOption>, String> {
  const GetTeamLeads(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<List<TeamLeadOption>>> call(String search) => _repository.getTeamLeads(search: search);
}

class GetAllocationTeamLead extends UseCase<AllocationTeamLead, String> {
  const GetAllocationTeamLead(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationTeamLead>> call(String allocationId) => _repository.getTeamLead(allocationId);
}

class AssignTeamLead extends UseCase<AllocationTeamLead, AssignTeamLeadParams> {
  const AssignTeamLead(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationTeamLead>> call(AssignTeamLeadParams params) =>
      _repository.assignTeamLead(params.allocationId, params.teamLeaderId);
}
