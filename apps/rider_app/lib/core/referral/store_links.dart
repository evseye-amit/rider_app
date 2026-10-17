import 'package:evseye_core/evseye_core.dart';

import 'referral_link.dart';

abstract final class ReferralStoreLinks {
  static String playStore(ReferralLink link) {
    final String referrer = Uri(
      queryParameters: {
        'utm_source': link.code,
        'utm_medium': 'referral',
        'utm_campaign': 'rider_referral',
        'invite': ?link.inviteToken,
        'campaign': ?link.campaignCode,
      },
    ).query;
    return Uri.https('play.google.com', '/store/apps/details', {
      'id': FlavorConfig.riderAndroidApplicationId,
      'referrer': referrer,
    }).toString();
  }

  static String? appStore() {
    const String id = FlavorConfig.riderAppStoreId;
    return id.isEmpty ? null : 'https://apps.apple.com/app/id$id';
  }

  const ReferralStoreLinks._();
}
