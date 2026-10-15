import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/return_case.dart';
import '../return_desk_repository.dart';

class ReturnCaseQuery extends Equatable {
  const ReturnCaseQuery({this.cursor, this.state});

  final String? cursor;
  final ReturnState? state;

  @override
  List<Object?> get props => [cursor, state];
}

class ReceiveReturnParams extends Equatable {
  const ReceiveReturnParams({required this.id, required this.hubId, this.receivedAt, this.backdateReason});

  final String id;
  final String hubId;
  final DateTime? receivedAt;
  final String? backdateReason;

  @override
  List<Object?> get props => [id, hubId, receivedAt, backdateReason];
}

class InspectionPhotoParams extends Equatable {
  const InspectionPhotoParams({required this.inspectionId, required this.photoType, required this.photo});

  final String inspectionId;
  final String photoType;
  final File photo;

  @override
  List<Object?> get props => [inspectionId, photoType, photo];
}

class CompleteReturnInspectionParams extends Equatable {
  const CompleteReturnInspectionParams({required this.inspectionId, required this.safeForReuse, this.unsafeReason});

  final String inspectionId;
  final bool safeForReuse;
  final String? unsafeReason;

  @override
  List<Object?> get props => [inspectionId, safeForReuse, unsafeReason];
}

class SaveChargesParams extends Equatable {
  const SaveChargesParams({required this.id, required this.lines});

  final String id;
  final List<PenaltyLine> lines;

  @override
  List<Object?> get props => [id, lines];
}

class OverrideApprovalParams extends Equatable {
  const OverrideApprovalParams({required this.id, required this.reason});

  final String id;
  final String reason;

  @override
  List<Object?> get props => [id, reason];
}

class GetReturnCases extends UseCase<ReturnCasePage, ReturnCaseQuery> {
  const GetReturnCases(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<ReturnCasePage>> call(ReturnCaseQuery params) =>
      _repository.cases(cursor: params.cursor, state: params.state);
}

class GetReturnCase extends UseCase<ReturnCase, String> {
  const GetReturnCase(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<ReturnCase>> call(String params) => _repository.detail(params);
}

class ReceiveReturn extends UseCase<void, ReceiveReturnParams> {
  const ReceiveReturn(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(ReceiveReturnParams params) => _repository.receive(
    params.id,
    hubId: params.hubId,
    receivedAt: params.receivedAt,
    backdateReason: params.backdateReason,
  );
}

class GetInspectionSheet extends UseCase<InspectionSheet, String> {
  const GetInspectionSheet(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<InspectionSheet>> call(String params) => _repository.inspection(params);
}

class UploadInspectionPhoto extends UseCase<InspectionPhoto, InspectionPhotoParams> {
  const UploadInspectionPhoto(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<InspectionPhoto>> call(InspectionPhotoParams params) =>
      _repository.uploadPhoto(params.inspectionId, photoType: params.photoType, photo: params.photo);
}

class CompleteReturnInspection extends UseCase<void, CompleteReturnInspectionParams> {
  const CompleteReturnInspection(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(CompleteReturnInspectionParams params) => _repository.completeInspection(
    params.inspectionId,
    safeForReuse: params.safeForReuse,
    unsafeReason: params.unsafeReason,
  );
}

class GetPenaltyPrices extends UseCase<List<PenaltyPrice>, NoParams> {
  const GetPenaltyPrices(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<List<PenaltyPrice>>> call(NoParams params) => _repository.prices();
}

class SaveReturnCharges extends UseCase<void, SaveChargesParams> {
  const SaveReturnCharges(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(SaveChargesParams params) => _repository.saveCharges(params.id, params.lines);
}

class SubmitReturnCharges extends UseCase<void, String> {
  const SubmitReturnCharges(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.submitCharges(params);
}

class ApproveReturnCharges extends UseCase<void, String> {
  const ApproveReturnCharges(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.approveCharges(params);
}

class OverrideRiderApproval extends UseCase<void, OverrideApprovalParams> {
  const OverrideRiderApproval(this._repository);

  final ReturnDeskRepository _repository;

  @override
  Future<Result<void>> call(OverrideApprovalParams params) =>
      _repository.overrideRiderApproval(params.id, params.reason);
}
