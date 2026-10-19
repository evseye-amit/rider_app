import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

abstract interface class DeploymentRepository {
  Future<Result<RiderDeployment>> current();

  Future<Result<RiderWallet>> wallet();

  Future<Result<DeploymentPayment>> payment(String allocationId);

  Future<Result<DeploymentPayment>> submitPayment(
    String allocationId, {
    required String provider,
    required String reference,
    List<String> receiptPhotoIds = const [],
  });

  Future<Result<String>> uploadReceipt(String paymentId, File file);

  Future<Result<String>> receiptUrl(String paymentId, String photoId);

  Future<Result<DeploymentWorkflow>> acceptPdi(String allocationId, List<PdiItemResponse> items);

  Future<Result<CommercialAgreement>> acceptPlan(String offerId, {required String termsVersion});

  Future<Result<List<TrainingItem>>> training(String allocationId);

  Future<Result<DeploymentWorkflow>> markTrainingViewed(String allocationId, String contentCode);

  Future<Result<DeploymentWorkflow>> completeTraining(String allocationId);
}
