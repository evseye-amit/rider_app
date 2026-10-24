import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../damage_charges_repository.dart';
import '../entities/damage_charge.dart';

class DamagePhotoParams extends Equatable {
  const DamagePhotoParams({required this.submissionId, required this.photoId});

  final String submissionId;
  final String photoId;

  @override
  List<Object?> get props => [submissionId, photoId];
}

class GetDamageChargesSummary extends UseCase<DamageChargesSummary, NoParams> {
  const GetDamageChargesSummary(this._repository);

  final DamageChargesRepository _repository;

  @override
  Future<Result<DamageChargesSummary>> call(NoParams params) => _repository.getSummary();
}

class GetDamageCharges extends UseCase<List<DamageCharge>, NoParams> {
  const GetDamageCharges(this._repository);

  final DamageChargesRepository _repository;

  @override
  Future<Result<List<DamageCharge>>> call(NoParams params) => _repository.getCharges();
}

class GetDamageCharge extends UseCase<DamageCharge, String> {
  const GetDamageCharge(this._repository);

  final DamageChargesRepository _repository;

  @override
  Future<Result<DamageCharge>> call(String params) => _repository.getCharge(params);
}

class GetDamagePhotoUrl extends UseCase<String, DamagePhotoParams> {
  const GetDamagePhotoUrl(this._repository);

  final DamageChargesRepository _repository;

  @override
  Future<Result<String>> call(DamagePhotoParams params) =>
      _repository.getPhotoUrl(submissionId: params.submissionId, photoId: params.photoId);
}
