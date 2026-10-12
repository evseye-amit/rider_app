import 'package:evseye_core/evseye_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/referral.dart';
import '../../domain/entities/referral_overview.dart';
import '../../referrals_dependencies.dart';

final referralOverviewProvider = FutureProvider.autoDispose<ReferralOverview>(
  (ref) async => (await ref.watch(getReferralOverviewProvider)(const NoParams())).getOrThrow(),
);

final referralsProvider = FutureProvider.autoDispose<List<Referral>>(
  (ref) async => (await ref.watch(getReferralsProvider)(const NoParams())).getOrThrow(),
);
