import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/submission_repository.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  const SubmissionRepositoryImpl(this._api, this._media);

  final VehicleSubmissionApi _api;
  final MediaApi _media;

  @override
  Future<Result<SubmissionQueuePage>> queue({
    required SubmissionSource source,
    required SubmissionPhase phase,
    required int page,
  }) => _api.queue(source: source, phase: phase, page: page);

  @override
  Future<Result<String>> start({required SubmissionSource source, required String requestId, String? hubId}) =>
      _api.start(source: source, requestId: requestId, hubId: hubId);

  @override
  Future<Result<VehicleSubmissionDto>> detail(String id) => _api.detail(id);

  @override
  Future<Result<String>> photoUrl(String id, String photoId) => _api.photoUrl(id, photoId);

  @override
  Future<Result<RemotePhoto>> uploadPhoto({
    required String inspectionId,
    required String photoType,
    required File file,
  }) => _media.upload(
    entity: PhotoEntity.inspection,
    entityId: inspectionId,
    photoType: photoType,
    file: file,
    mimeType: _mimeOf(file),
  );

  @override
  Future<Result<List<PenaltyPriceDto>>> penaltyPrices() => _api.penaltyPrices();

  @override
  Future<Result<void>> recordReport(String id, SubmissionReportInput input, {required String idempotencyKey}) =>
      _api.recordReport(id, input, idempotencyKey: idempotencyKey);

  @override
  Future<Result<void>> impose(String reportId) => _api.impose(reportId);

  @override
  Future<Result<void>> cancelReport(String reportId, String reason) => _api.cancelReport(reportId, reason);

  @override
  Future<Result<SubmissionOtpDispatch>> requestOtps(String reportId, {SubmissionParty? party}) =>
      _api.requestOtps(reportId, party: party);

  @override
  Future<Result<void>> verifyOtp(
    String reportId, {
    required SubmissionParty party,
    required String otpRequestId,
    required String code,
  }) async {
    final Result<void> result = await _api.verifyOtp(reportId, party: party, otpRequestId: otpRequestId, code: code);
    if (result case Err<void>(failure: UnauthorizedFailure(:final message))) {
      return Result.err(
        ValidationFailure(
          message.toLowerCase().contains('expired')
              ? ActiveLocale.strings.returnsCodeExpired
              : ActiveLocale.strings.returnsCodeInvalid,
        ),
      );
    }
    return result;
  }

  @override
  Future<Result<void>> confirm(String reportId, {String? riderBypassReason, String? teamLeadBypassReason}) =>
      _api.confirm(reportId, riderBypassReason: riderBypassReason, teamLeadBypassReason: teamLeadBypassReason);

  static String _mimeOf(File file) {
    final String name = file.path.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
