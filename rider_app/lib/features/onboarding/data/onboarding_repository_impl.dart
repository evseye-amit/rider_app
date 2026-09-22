import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._riderApp, this._media);

  final RiderAppApi _riderApp;
  final MediaApi _media;

  @override
  Future<Result<RiderOnboardingConfig>> fetch() => _riderApp.onboarding();

  @override
  Future<Result<RiderOnboardingConfig>> saveStep(String stepId, Map<String, Object?> values) =>
      _riderApp.saveStep(stepId, values);

  @override
  Future<Result<RemotePhoto>> uploadDocument({
    required String fieldCode,
    required File file,
  }) {
    final String name = file.path.toLowerCase();
    final String mime = name.endsWith('.pdf')
        ? 'application/pdf'
        : name.endsWith('.png')
            ? 'image/png'
            : name.endsWith('.webp')
                ? 'image/webp'
                : 'image/jpeg';
    return _media.uploadOnboardingDocument(
      fieldCode: fieldCode,
      file: file,
      mimeType: mime,
    );
  }
}
