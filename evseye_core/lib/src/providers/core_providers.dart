import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_client.dart';
import '../api/auth_api.dart';
import '../api/deployment_api.dart';
import '../api/media_api.dart';
import '../api/rider_app_api.dart';
import '../api/rider_payments_api.dart';
import '../api/token_store.dart';
import '../api/vehicle_exchange_api.dart';
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

final mediaApiProvider = Provider<MediaApi>((ref) => MediaApi(ref.watch(apiClientProvider)));

final walletApiProvider = Provider<WalletApi>((ref) => WalletApi(ref.watch(apiClientProvider)));

final riderPaymentsApiProvider = Provider<RiderPaymentsApi>((ref) => RiderPaymentsApi(ref.watch(apiClientProvider)));

final vehicleExchangeApiProvider = Provider<VehicleExchangeApi>(
  (ref) => VehicleExchangeApi(ref.watch(apiClientProvider)),
);

final uiConfigServiceProvider = Provider<UiConfigService>((_) => UiConfigService());

Duration? noProviderRetry(int retryCount, Object error) => null;
