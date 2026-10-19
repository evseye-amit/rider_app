import 'dart:io';

import 'package:evseye_core/evseye_core.dart';

abstract interface class OnboardingRepository {
  Future<Result<RiderOnboardingConfig>> fetch();

  Future<Result<RiderOnboardingConfig>> saveStep(String stepId, Map<String, Object?> values);

  Future<Result<RemotePhoto>> uploadDocument({required String fieldCode, required File file});

  Future<Result<IfscBankDetails>> lookupIfsc(String ifsc);

  Future<Result<void>> applyReferralCode(
    String input, {
    ReferralSource source = ReferralSource.referralCode,
    String? inviteToken,
    String? campaignCode,
  });
}
