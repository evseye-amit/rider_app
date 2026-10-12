import 'package:evseye_core/evseye_core.dart';

import 'entities/referral.dart';
import 'entities/referral_invite.dart';
import 'entities/referral_overview.dart';

abstract interface class ReferralRepository {
  Future<Result<ReferralOverview>> overview();

  Future<Result<List<Referral>>> referrals();

  Future<Result<ReferralInvite>> invite();
}
