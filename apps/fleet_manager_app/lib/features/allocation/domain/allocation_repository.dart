import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import 'entities/allocation_board.dart';
import 'entities/payment_review.dart';

abstract interface class AllocationRepository {
  Future<Result<AllocationBoard>> getBoard();

  Future<Result<PendingRider>> getPendingRider(String riderId);

  Future<Result<List<EligibleFleet>>> getEligibleFleets();

  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId});

  Future<Result<List<TeamLeadOption>>> getTeamLeads({String? search});

  Future<Result<AllocationTeamLead>> getTeamLead(String allocationId);

  Future<Result<AllocationTeamLead>> assignTeamLead(String allocationId, String teamLeaderId);

  Future<Result<DeploymentAllocation>> getRequest(String allocationId);

  Future<Result<DeploymentWorkflow>> requestFleet(String allocationId);

  Future<Result<DeploymentPayment>> askPayment(String allocationId);

  Future<Result<RentalPlanList>> getPlans(String allocationId, {String? batteryPlanId});

  Future<Result<AllocationCommercial>> selectPlan(String allocationId, RentalPlanOption plan);

  Future<Result<AllocationCommercial>> getCommercial(String allocationId);

  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId, {int? expectedVersion});

  Future<Result<PaymentReview>> paymentReview(String allocationId);

  Future<Result<DeploymentPayment>> rejectPayment(
    String allocationId, {
    required String reason,
    required int expectedVersion,
  });

  Future<Result<String>> paymentReceiptUrl(String paymentId, String photoId);

  Future<Result<AllocationEvidence>> getEvidence(String allocationId);

  Future<Result<RemotePhoto>> uploadEvidencePhoto(String inspectionId, {required String photoType, required File file});

  Future<Result<String>> photoUrl(String photoId);

  Future<Result<List<WorkPartnerOption>>> getWorkPartners();

  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required WorkPartnerOption workPartner,
    required List<PdiChecklistItem> checklist,
  });

  Future<Result<String>> startReturn({required String riderId, required String idempotencyKey, String? hubId});
}
