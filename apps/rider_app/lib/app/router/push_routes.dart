import 'dart:async';

import 'package:go_router/go_router.dart';

import 'app_routes.dart';

const Set<String> _tabLocations = {
  Routes.home,
  Routes.batterySwap,
  Routes.scooter,
  Routes.nearbyHubs,
  Routes.referEarn,
};

bool isAllocationPush(Map<String, String> data) => data['action'] == 'ALLOCATION_DETAILS';

void openPushLocation(GoRouter router, String location) {
  if (_tabLocations.contains(location)) {
    router.go(location);
  } else {
    unawaited(router.push(location));
  }
}

String pushLocation(Map<String, String> data) => switch (data) {
  {'route': 'SUBMISSION_PENALTY_PAYMENT', 'invoiceId': final String invoiceId} when invoiceId.isNotEmpty =>
    '${Routes.damageChargeDetail}?id=$invoiceId',
  {'schemaVersion': '1', 'action': 'ALLOCATION_DETAILS', 'event': final String event} => switch (event) {
    'REQUESTED' => Routes.home,
    'ACTIVATED' => Routes.scooter,
    'RETURN_STARTED' || 'RETURN_COMPLETED' => Routes.rideReturns,
    _ => Routes.notifications,
  },
  {'screen': 'wallet'} => Routes.ledger,
  _ => Routes.notifications,
};
