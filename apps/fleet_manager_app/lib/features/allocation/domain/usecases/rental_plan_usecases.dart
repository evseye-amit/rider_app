import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../allocation_repository.dart';

class RentalPlansQuery extends Equatable {
  const RentalPlansQuery({required this.allocationId, this.batteryPlanId, this.workPartnerId});

  final String allocationId;
  final String? batteryPlanId;
  final String? workPartnerId;

  @override
  List<Object?> get props => [allocationId, batteryPlanId, workPartnerId];
}

class SelectRentalPlanParams {
  const SelectRentalPlanParams({required this.allocationId, required this.plan});

  final String allocationId;
  final RentalPlanOption plan;
}

class GetRentalPlans extends UseCase<RentalPlanList, RentalPlansQuery> {
  const GetRentalPlans(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<RentalPlanList>> call(RentalPlansQuery query) =>
      _repository.getPlans(query.allocationId, batteryPlanId: query.batteryPlanId, workPartnerId: query.workPartnerId);
}

class SelectRentalPlan extends UseCase<AllocationCommercial, SelectRentalPlanParams> {
  const SelectRentalPlan(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationCommercial>> call(SelectRentalPlanParams params) =>
      _repository.selectPlan(params.allocationId, params.plan);
}

class GetAllocationCommercial extends UseCase<AllocationCommercial, String> {
  const GetAllocationCommercial(this._repository);

  final AllocationRepository _repository;

  @override
  Future<Result<AllocationCommercial>> call(String allocationId) => _repository.getCommercial(allocationId);
}
