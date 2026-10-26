import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/attendance_api.dart';
import '../api/auth_api.dart';
import '../api/banks_api.dart';
import '../api/commercial_api.dart';
import '../api/company_api.dart';
import '../api/deployment_api.dart';
import '../api/fleet_search_api.dart';
import '../api/legal_api.dart';
import '../api/media_api.dart';
import '../api/notifications_api.dart';
import '../api/payment_orders_api.dart';
import '../api/push_devices_api.dart';
import '../api/referral_api.dart';
import '../api/rental_agreements_api.dart';
import '../api/ride_returns_api.dart';
import '../api/rider_app_api.dart';
import '../api/rider_billing_api.dart';
import '../api/rider_hubs_api.dart';
import '../api/rider_payments_api.dart';
import '../api/submission_penalty_api.dart';
import '../api/support_api.dart';
import '../api/swap_stations_api.dart';
import '../api/token_store.dart';
import '../api/vehicle_exchange_api.dart';
import '../api/vehicle_submission_api.dart';
import '../api/wallet_api.dart';
import '../config/ui_config_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw StateError(
    'sharedPreferencesProvider must be overridden in ProviderScope with the '
    'SharedPreferences instance loaded before runApp.',
  ),
);

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore(ref.watch(sharedPreferencesProvider)));

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(tokens: ref.watch(tokenStoreProvider)));

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(apiClientProvider), ref.watch(tokenStoreProvider)),
);

final riderAppApiProvider = Provider<RiderAppApi>((ref) => RiderAppApi(ref.watch(apiClientProvider)));

final deploymentApiProvider = Provider<DeploymentApi>((ref) => DeploymentApi(ref.watch(apiClientProvider)));

final commercialApiProvider = Provider<CommercialApi>((ref) => CommercialApi(ref.watch(apiClientProvider)));

final mediaApiProvider = Provider<MediaApi>((ref) => MediaApi(ref.watch(apiClientProvider)));

final walletApiProvider = Provider<WalletApi>((ref) => WalletApi(ref.watch(apiClientProvider)));

final riderPaymentsApiProvider = Provider<RiderPaymentsApi>((ref) => RiderPaymentsApi(ref.watch(apiClientProvider)));

final vehicleExchangeApiProvider = Provider<VehicleExchangeApi>(
  (ref) => VehicleExchangeApi(ref.watch(apiClientProvider)),
);

final exchangeOperationsApiProvider = Provider<ExchangeOperationsApi>(
  (ref) => ExchangeOperationsApi(ref.watch(apiClientProvider)),
);

final rentalAgreementsApiProvider = Provider<RentalAgreementsApi>(
  (ref) => RentalAgreementsApi(ref.watch(apiClientProvider)),
);

final uiConfigServiceProvider = Provider<UiConfigService>((_) => UiConfigService());

final riderHubsApiProvider = Provider<RiderHubsApi>((ref) => RiderHubsApi(ref.watch(apiClientProvider)));

final referralApiProvider = Provider<ReferralApi>((ref) => ReferralApi(ref.watch(apiClientProvider)));

final swapStationsApiProvider = Provider<SwapStationsApi>((_) => SwapStationsApi());

final legalApiProvider = Provider<LegalApi>((ref) => LegalApi(ref.watch(apiClientProvider)));

final companyApiProvider = Provider<CompanyApi>((ref) => CompanyApi(ref.watch(apiClientProvider)));

final riderSupportApiProvider = Provider<SupportApi>(
  (ref) => SupportApi.rider(ref.watch(apiClientProvider), ref.watch(mediaApiProvider)),
);

final staffSupportApiProvider = Provider<SupportApi>(
  (ref) => SupportApi.staff(ref.watch(apiClientProvider), ref.watch(mediaApiProvider)),
);

final rideReturnsApiProvider = Provider<RideReturnsApi>((ref) => RideReturnsApi(ref.watch(apiClientProvider)));

final returnDeskApiProvider = Provider<ReturnDeskApi>((ref) => ReturnDeskApi(ref.watch(apiClientProvider)));

final riderBillingApiProvider = Provider<RiderBillingApi>((ref) => RiderBillingApi(ref.watch(apiClientProvider)));

final banksApiProvider = Provider<BanksApi>((ref) => BanksApi(ref.watch(apiClientProvider)));

final fleetSearchApiProvider = Provider<FleetSearchApi>((ref) => FleetSearchApi(ref.watch(apiClientProvider)));

final submissionPenaltyApiProvider = Provider<SubmissionPenaltyApi>(
  (ref) => SubmissionPenaltyApi(ref.watch(apiClientProvider)),
);

final paymentOrdersApiProvider = Provider<PaymentOrdersApi>((ref) => PaymentOrdersApi(ref.watch(apiClientProvider)));

final attendanceApiProvider = Provider<AttendanceApi>((ref) => AttendanceApi(ref.watch(apiClientProvider)));

final notificationsApiProvider = Provider<NotificationsApi>((ref) => NotificationsApi(ref.watch(apiClientProvider)));

final pushDevicesApiProvider = Provider<PushDevicesApi>((ref) => PushDevicesApi(ref.watch(apiClientProvider)));

final vehicleSubmissionApiProvider = Provider<VehicleSubmissionApi>(
  (ref) => VehicleSubmissionApi(ref.watch(apiClientProvider)),
);

Duration? noProviderRetry(int retryCount, Object error) => null;
