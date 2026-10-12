import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class UploadDocumentParams {
  const UploadDocumentParams({required this.fieldCode, required this.file});

  final String fieldCode;
  final File file;
}

class UploadOnboardingDocument extends UseCase<RemotePhoto, UploadDocumentParams> {
  const UploadOnboardingDocument(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<RemotePhoto>> call(UploadDocumentParams params) =>
      _repository.uploadDocument(fieldCode: params.fieldCode, file: params.file);
}
