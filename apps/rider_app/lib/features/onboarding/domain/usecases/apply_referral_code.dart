import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../onboarding_repository.dart';

class ReferralApplication extends Equatable {
  const ReferralApplication({
    required this.input,
    this.source = ReferralSource.referralCode,
    this.inviteToken,
    this.campaignCode,
  });

  final String input;
  final ReferralSource source;
  final String? inviteToken;
  final String? campaignCode;

  @override
  List<Object?> get props => [input, source, inviteToken, campaignCode];
}

class ApplyReferralCode extends UseCase<void, ReferralApplication> {
  const ApplyReferralCode(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Result<void>> call(ReferralApplication params) => _repository.applyReferralCode(
    params.input,
    source: params.source,
    inviteToken: params.inviteToken,
    campaignCode: params.campaignCode,
  );
}
