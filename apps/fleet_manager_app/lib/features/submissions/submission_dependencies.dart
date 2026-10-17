import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/submission_repository_impl.dart';
import 'domain/submission_repository.dart';
import 'domain/usecases/submission_usecases.dart';

final submissionRepositoryProvider = Provider<SubmissionRepository>(
  (ref) => SubmissionRepositoryImpl(ref.watch(vehicleSubmissionApiProvider), ref.watch(mediaApiProvider)),
);

final getSubmissionQueueProvider = Provider<GetSubmissionQueue>(
  (ref) => GetSubmissionQueue(ref.watch(submissionRepositoryProvider)),
);

final startSubmissionProvider = Provider<StartSubmission>(
  (ref) => StartSubmission(ref.watch(submissionRepositoryProvider)),
);

final getSubmissionProvider = Provider<GetSubmission>((ref) => GetSubmission(ref.watch(submissionRepositoryProvider)));

final getSubmissionPhotoUrlProvider = Provider<GetSubmissionPhotoUrl>(
  (ref) => GetSubmissionPhotoUrl(ref.watch(submissionRepositoryProvider)),
);

final uploadSubmissionPhotoProvider = Provider<UploadSubmissionPhoto>(
  (ref) => UploadSubmissionPhoto(ref.watch(submissionRepositoryProvider)),
);

final getPenaltyPricesProvider = Provider<GetPenaltyPrices>(
  (ref) => GetPenaltyPrices(ref.watch(submissionRepositoryProvider)),
);

final recordSubmissionReportProvider = Provider<RecordSubmissionReport>(
  (ref) => RecordSubmissionReport(ref.watch(submissionRepositoryProvider)),
);

final imposeSubmissionReportProvider = Provider<ImposeSubmissionReport>(
  (ref) => ImposeSubmissionReport(ref.watch(submissionRepositoryProvider)),
);

final cancelSubmissionReportProvider = Provider<CancelSubmissionReport>(
  (ref) => CancelSubmissionReport(ref.watch(submissionRepositoryProvider)),
);

final requestSubmissionOtpsProvider = Provider<RequestSubmissionOtps>(
  (ref) => RequestSubmissionOtps(ref.watch(submissionRepositoryProvider)),
);

final verifySubmissionOtpProvider = Provider<VerifySubmissionOtp>(
  (ref) => VerifySubmissionOtp(ref.watch(submissionRepositoryProvider)),
);

final confirmSubmissionReportProvider = Provider<ConfirmSubmissionReport>(
  (ref) => ConfirmSubmissionReport(ref.watch(submissionRepositoryProvider)),
);
