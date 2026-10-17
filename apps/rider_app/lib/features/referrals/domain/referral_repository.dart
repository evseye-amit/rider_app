import 'package:evseye_core/evseye_core.dart';

import 'entities/referral.dart';
import 'entities/referral_invite.dart';
import 'entities/referral_overview.dart';

abstract interface class ReferralRepository {
  Future<Result<ReferralOverview>> overview();

  Future<Result<List<Referral>>> referrals();

  Future<Result<ReferralDetail>> detail(String id);

  Future<Result<List<ReferralActivity>>> activity();

  Future<Result<ReferralInvite>> invite();
}
