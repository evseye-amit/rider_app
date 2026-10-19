import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../submission_repository.dart';

class SubmissionQueueQuery extends Equatable {
  const SubmissionQueueQuery({required this.source, required this.phase, this.page = 1});

  final SubmissionSource source;
  final SubmissionPhase phase;
  final int page;

  @override
  List<Object?> get props => [source, phase, page];
}

class StartSubmissionParams extends Equatable {
  const StartSubmissionParams({required this.source, required this.requestId, this.hubId});

  final SubmissionSource source;
  final String requestId;
  final String? hubId;

  @override
  List<Object?> get props => [source, requestId, hubId];
}

class SubmissionPhotoParams extends Equatable {
  const SubmissionPhotoParams({required this.id, required this.photoId});

  final String id;
  final String photoId;

  @override
  List<Object?> get props => [id, photoId];
}

class UploadSubmissionPhotoParams extends Equatable {
  const UploadSubmissionPhotoParams({required this.inspectionId, required this.photoType, required this.file});

  final String inspectionId;
  final String photoType;
  final File file;

  @override
  List<Object?> get props => [inspectionId, photoType, file];
}

class RecordReportParams extends Equatable {
  const RecordReportParams({required this.id, required this.input, required this.idempotencyKey});

  final String id;
  final SubmissionReportInput input;
  final String idempotencyKey;

  @override
  List<Object?> get props => [id, input, idempotencyKey];
}

class CancelReportParams extends Equatable {
  const CancelReportParams({required this.reportId, required this.reason});

  final String reportId;
  final String reason;

  @override
  List<Object?> get props => [reportId, reason];
}

class RequestOtpParams extends Equatable {
  const RequestOtpParams({required this.reportId, this.party});

  final String reportId;
  final SubmissionParty? party;

  @override
  List<Object?> get props => [reportId, party];
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.reportId, required this.party, required this.otpRequestId, required this.code});

  final String reportId;
  final SubmissionParty party;
  final String otpRequestId;
  final String code;

  @override
  List<Object?> get props => [reportId, party, otpRequestId, code];
}

class ConfirmReportParams extends Equatable {
  const ConfirmReportParams({required this.reportId, this.riderBypassReason, this.teamLeadBypassReason});

  final String reportId;
  final String? riderBypassReason;
  final String? teamLeadBypassReason;

  @override
  List<Object?> get props => [reportId, riderBypassReason, teamLeadBypassReason];
}

class GetSubmissionQueue extends UseCase<SubmissionQueuePage, SubmissionQueueQuery> {
  const GetSubmissionQueue(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<SubmissionQueuePage>> call(SubmissionQueueQuery params) =>
      _repository.queue(source: params.source, phase: params.phase, page: params.page);
}

class StartSubmission extends UseCase<String, StartSubmissionParams> {
  const StartSubmission(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<String>> call(StartSubmissionParams params) =>
      _repository.start(source: params.source, requestId: params.requestId, hubId: params.hubId);
}

class GetSubmission extends UseCase<VehicleSubmissionDto, String> {
  const GetSubmission(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<VehicleSubmissionDto>> call(String params) => _repository.detail(params);
}

class GetSubmissionPhotoUrl extends UseCase<String, SubmissionPhotoParams> {
  const GetSubmissionPhotoUrl(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<String>> call(SubmissionPhotoParams params) => _repository.photoUrl(params.id, params.photoId);
}

class UploadSubmissionPhoto extends UseCase<RemotePhoto, UploadSubmissionPhotoParams> {
  const UploadSubmissionPhoto(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<RemotePhoto>> call(UploadSubmissionPhotoParams params) =>
      _repository.uploadPhoto(inspectionId: params.inspectionId, photoType: params.photoType, file: params.file);
}

class GetPenaltyPrices extends UseCase<List<PenaltyPriceDto>, String> {
  const GetPenaltyPrices(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<List<PenaltyPriceDto>>> call(String submissionId) => _repository.penaltyPrices(submissionId);
}

class RecordSubmissionReport extends UseCase<void, RecordReportParams> {
  const RecordSubmissionReport(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<void>> call(RecordReportParams params) =>
      _repository.recordReport(params.id, params.input, idempotencyKey: params.idempotencyKey);
}

class ImposeSubmissionReport extends UseCase<void, String> {
  const ImposeSubmissionReport(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.impose(params);
}

class CancelSubmissionReport extends UseCase<void, CancelReportParams> {
  const CancelSubmissionReport(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<void>> call(CancelReportParams params) => _repository.cancelReport(params.reportId, params.reason);
}

class RequestSubmissionOtps extends UseCase<SubmissionOtpDispatch, RequestOtpParams> {
  const RequestSubmissionOtps(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<SubmissionOtpDispatch>> call(RequestOtpParams params) =>
      _repository.requestOtps(params.reportId, party: params.party);
}

class VerifySubmissionOtp extends UseCase<void, VerifyOtpParams> {
  const VerifySubmissionOtp(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<void>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(params.reportId, party: params.party, otpRequestId: params.otpRequestId, code: params.code);
}

class ConfirmSubmissionReport extends UseCase<void, ConfirmReportParams> {
  const ConfirmSubmissionReport(this._repository);

  final SubmissionRepository _repository;

  @override
  Future<Result<void>> call(ConfirmReportParams params) => _repository.confirm(
    params.reportId,
    riderBypassReason: params.riderBypassReason,
    teamLeadBypassReason: params.teamLeadBypassReason,
  );
}
