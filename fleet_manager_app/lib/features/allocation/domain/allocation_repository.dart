import 'package:evseye_core/evseye_core.dart';

import 'entities/allocation_board.dart';
import 'entities/deallocation_request.dart';

abstract interface class AllocationRepository {
  Future<Result<AllocationBoard>> getBoard();

  Future<Result<PendingRider>> getPendingRider(String riderId);

  Future<Result<List<EligibleFleet>>> getEligibleFleets();

  Future<Result<DeploymentAllocation>> allocate({required String riderId, required String fleetId});

  Future<Result<DeploymentAllocation>> getRequest(String allocationId);

  Future<Result<DeploymentWorkflow>> requestFleet(String allocationId);

  Future<Result<DeploymentPayment>> askPayment(String allocationId, List<PaymentLineItem> items);

  Future<Result<DeploymentWorkflow>> verifyPayment(String allocationId);

  Future<Result<AllocationEvidence>> getEvidence(String allocationId);

  Future<Result<DeploymentWorkflow>> submitPdi(
    String allocationId, {
    required String workPartnerName,
    required List<PdiChecklistItem> checklist,
  });

  Future<Result<IotHealth>> getIotHealth(String allocationId);

  Future<Result<DeploymentWorkflow>> bypassPairing(String allocationId, String remarks);

  Future<Result<DeallocationRequest>> getDeallocationRequest(String allocationId);

  Future<Result<DeallocationStart>> initiateDeallocation(String allocationId);

  Future<Result<OtpChallenge>> requestDeallocationOtp(
    String allocationId, {
    required String phone,
    required String party,
  });

  Future<Result<void>> verifyDeallocationOtp(
    String allocationId, {
    required String otpRequestId,
    required String code,
  });

  Future<Result<void>> completeInspection(String inspectionId);

  Future<Result<void>> completeDeallocation(String allocationId);
}

class DeallocationStart {
  const DeallocationStart({required this.allocationId, required this.inspectionId});

  final String allocationId;
  final String inspectionId;
}
