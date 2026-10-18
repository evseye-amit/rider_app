import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import 'entities/allocation_board.dart';

abstract interface class AllocationRepository {
  Future<Result<AllocationBoard>> getBoard();

  Future<Result<PendingRider>> getPendingRider(String riderId);

  Future<Result<List<EligibleFleet>>> getEligibleFleets();

  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId});

  Future<Result<DeploymentAllocation>> getRequest(String allocationId);

  Future<Result<DeploymentWorkflow>> requestFleet(String allocationId);

  Future<Result<DeploymentPayment>> askPayment(String allocationId);

  Future<Result<RentalPlanList>> getPlans(String allocationId, {String? batteryPlanId});

  Future<Result<AllocationCommercial>> selectPlan(String allocationId, RentalPlanOption plan);

  Future<Result<AllocationCommercial>> getCommercial(String allocationId);

  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId);

  Future<Result<AllocationEvidence>> getEvidence(String allocationId);

  Future<Result<RemotePhoto>> uploadEvidencePhoto(String inspectionId, {required String photoType, required File file});

  Future<Result<String>> photoUrl(String photoId);

  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required String workPartnerName,
    required List<PdiChecklistItem> checklist,
  });

  Future<Result<String>> startReturn({required String riderId, required String idempotencyKey, String? hubId});
}
