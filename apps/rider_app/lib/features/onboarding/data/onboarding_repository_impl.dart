import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

import '../domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._riderApp, this._media, this._referrals, this._banks);

  final RiderAppApi _riderApp;
  final MediaApi _media;
  final ReferralApi _referrals;
  final BanksApi _banks;

  @override
  Future<Result<RiderOnboardingConfig>> fetch() => _riderApp.onboarding();

  @override
  Future<Result<RiderOnboardingConfig>> saveStep(String stepId, Map<String, Object?> values) =>
      _riderApp.saveStep(stepId, values);

  @override
  Future<Result<RemotePhoto>> uploadDocument({required String fieldCode, required File file}) {
    final String name = file.path.toLowerCase();
    final String mime = name.endsWith('.pdf')
        ? 'application/pdf'
        : name.endsWith('.png')
        ? 'image/png'
        : name.endsWith('.webp')
        ? 'image/webp'
        : 'image/jpeg';
    return _media.uploadOnboardingDocument(fieldCode: fieldCode, file: file, mimeType: mime);
  }

  @override
  Future<Result<IfscBankDetails>> lookupIfsc(String ifsc) => _banks.lookupIfsc(ifsc);

  @override
  Future<Result<void>> applyReferralCode(
    String input, {
    ReferralSource source = ReferralSource.referralCode,
    String? inviteToken,
    String? campaignCode,
  }) async {
    final String trimmed = input.trim();
    final String code;
    if (RegExp(r'^EVS-', caseSensitive: false).hasMatch(trimmed)) {
      code = trimmed.toUpperCase();
    } else {
      switch (await _referrals.resolveInput(trimmed)) {
        case Ok<String>(:final value) when value.isNotEmpty:
          code = value;
        case Ok<String>():
          return Result.err(ValidationFailure(ActiveLocale.strings.onboardingReferralNotFound));
        case Err<String>(:final failure):
          return Result.err(failure);
      }
    }
    final Result<void> result = await _referrals.attribute(
      code,
      source: source,
      inviteToken: inviteToken,
      campaignCode: campaignCode,
    );
    if (result case Err<void>(failure: ValidationFailure()) when inviteToken != null || campaignCode != null) {
      return _referrals.attribute(code, source: source);
    }
    return result;
  }
}
