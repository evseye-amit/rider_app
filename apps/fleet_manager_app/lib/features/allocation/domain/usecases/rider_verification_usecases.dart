import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/rider_verification.dart';
import '../rider_verification_repository.dart';

class ReviewParams extends Equatable {
  const ReviewParams({required this.id, required this.approve, this.reason});

  final String id;
  final bool approve;
  final String? reason;

  @override
  List<Object?> get props => [id, approve, reason];
}

class GetVerificationRider extends UseCase<VerificationRider, String> {
  const GetVerificationRider(this._repository);

  final RiderVerificationRepository _repository;

  @override
  Future<Result<VerificationRider>> call(String params) => _repository.rider(params);
}

class GetRiderDocuments extends UseCase<List<RiderDocument>, VerificationRider> {
  const GetRiderDocuments(this._repository);

  final RiderVerificationRepository _repository;

  @override
  Future<Result<List<RiderDocument>>> call(VerificationRider params) => _repository.documents(params);
}

class ReviewRiderDocument extends UseCase<void, ReviewParams> {
  const ReviewRiderDocument(this._repository);

  final RiderVerificationRepository _repository;

  @override
  Future<Result<void>> call(ReviewParams params) =>
      _repository.reviewDocument(params.id, approve: params.approve, reason: params.reason);
}

class GetRiderReferences extends UseCase<List<RiderReference>, String> {
  const GetRiderReferences(this._repository);

  final RiderVerificationRepository _repository;

  @override
  Future<Result<List<RiderReference>>> call(String params) => _repository.references(params);
}

class ReviewRiderReference extends UseCase<void, ReviewParams> {
  const ReviewRiderReference(this._repository);

  final RiderVerificationRepository _repository;

  @override
  Future<Result<void>> call(ReviewParams params) =>
      _repository.reviewReference(params.id, approve: params.approve, reason: params.reason);
}
