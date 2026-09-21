import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class UploadDocumentParams {
  const UploadDocumentParams({required this.riderId, required this.photoType, required this.file});

  final String riderId;

  final String photoType;
  final File file;
}

class UploadOnboardingDocument extends UseCase<RemotePhoto, UploadDocumentParams> {
  const UploadOnboardingDocument(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<RemotePhoto>> call(UploadDocumentParams params) =>
      _repository.uploadDocument(riderId: params.riderId, photoType: params.photoType, file: params.file);
}
