import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

abstract interface class SubmissionRepository {
  Future<Result<SubmissionQueuePage>> queue({
    required SubmissionSource source,
    required SubmissionPhase phase,
    required int page,
  });

  Future<Result<String>> start({required SubmissionSource source, required String requestId, String? hubId});

  Future<Result<VehicleSubmissionDto>> detail(String id);

  Future<Result<String>> photoUrl(String id, String photoId);

  Future<Result<RemotePhoto>> uploadPhoto({
    required String inspectionId,
    required String photoType,
    required File file,
  });

  Future<Result<List<PenaltyPriceDto>>> penaltyPrices();

  Future<Result<void>> recordReport(String id, SubmissionReportInput input, {required String idempotencyKey});

  Future<Result<void>> impose(String reportId);

  Future<Result<void>> cancelReport(String reportId, String reason);

  Future<Result<SubmissionOtpDispatch>> requestOtps(String reportId, {SubmissionParty? party});

  Future<Result<void>> verifyOtp(
    String reportId, {
    required SubmissionParty party,
    required String otpRequestId,
    required String code,
  });

  Future<Result<void>> confirm(String reportId, {String? riderBypassReason, String? teamLeadBypassReason});
}
