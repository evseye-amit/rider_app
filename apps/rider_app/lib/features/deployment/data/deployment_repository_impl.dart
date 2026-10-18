import 'package:evseye_core/evseye_core.dart';

import '../domain/deployment_repository.dart';

class DeploymentRepositoryImpl implements DeploymentRepository {
  const DeploymentRepositoryImpl(this._api, this._commercial);

  final DeploymentApi _api;
  final CommercialApi _commercial;

  @override
  Future<Result<RiderDeployment>> current() => _api.riderCurrent();

  @override
  Future<Result<CommercialAgreement>> acceptPlan(String offerId, {required String termsVersion}) =>
      _commercial.acceptOffer(offerId, termsVersion: termsVersion);

  @override
  Future<Result<RiderWallet>> wallet() => _api.riderWallet();

  @override
  Future<Result<DeploymentPayment>> payment(String allocationId) => _api.payment(allocationId);

  @override
  Future<Result<DeploymentPayment>> submitPayment(
    String allocationId, {
    required String provider,
    required String reference,
  }) => _api.submitPayment(allocationId, provider: provider, providerReference: reference);

  @override
  Future<Result<DeploymentWorkflow>> acceptPdi(String allocationId, List<PdiItemResponse> items) =>
      _api.acceptPdi(allocationId, items);

  @override
  Future<Result<List<TrainingItem>>> training(String allocationId) => _api.training(allocationId);

  @override
  Future<Result<DeploymentWorkflow>> markTrainingViewed(String allocationId, String contentCode) =>
      _api.markTrainingViewed(allocationId, contentCode);

  @override
  Future<Result<DeploymentWorkflow>> completeTraining(String allocationId) => _api.completeTraining(allocationId);
}
