import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/referral_repository_impl.dart';
import 'domain/referral_repository.dart';
import 'domain/usecases/create_referral_invite.dart';
import 'domain/usecases/get_referral_activity.dart';
import 'domain/usecases/get_referral_detail.dart';
import 'domain/usecases/get_referral_overview.dart';
import 'domain/usecases/get_referrals.dart';

final referralRepositoryProvider = Provider<ReferralRepository>(
  (ref) => ReferralRepositoryImpl(ref.watch(referralApiProvider)),
);

final getReferralOverviewProvider = Provider<GetReferralOverview>(
  (ref) => GetReferralOverview(ref.watch(referralRepositoryProvider)),
);

final getReferralsProvider = Provider<GetReferrals>((ref) => GetReferrals(ref.watch(referralRepositoryProvider)));

final getReferralDetailProvider = Provider<GetReferralDetail>(
  (ref) => GetReferralDetail(ref.watch(referralRepositoryProvider)),
);

final getReferralActivityProvider = Provider<GetReferralActivity>(
  (ref) => GetReferralActivity(ref.watch(referralRepositoryProvider)),
);

final createReferralInviteProvider = Provider<CreateReferralInvite>(
  (ref) => CreateReferralInvite(ref.watch(referralRepositoryProvider)),
);
