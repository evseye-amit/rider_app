import 'app_routes.dart';

String pushLocation(Map<String, String> data) => switch (data) {
  {'route': 'SUBMISSION_PENALTY_PAYMENT', 'invoiceId': final String invoiceId} when invoiceId.isNotEmpty =>
    '${Routes.damageChargeDetail}?id=$invoiceId',
  _ => Routes.notifications,
};
