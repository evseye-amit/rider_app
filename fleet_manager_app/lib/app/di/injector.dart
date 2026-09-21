import 'package:evseye_core/evseye_core.dart';
import 'package:get_it/get_it.dart';

import '../../core/session/session_controller.dart';
import '../../features/allocation/data/allocation_repository_impl.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/allocation/domain/allocation_repository.dart';
import '../../features/hub/data/hub_repository_impl.dart';
import '../../features/hub/domain/hub_repository.dart';
import '../../features/hub/domain/usecases/list_hubs.dart';
import '../../features/maintenance/data/maintenance_repository_impl.dart';
import '../../features/maintenance/domain/maintenance_repository.dart';
import '../../features/riders/data/riders_repository_impl.dart';
import '../../features/riders/domain/riders_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<UiConfigService>(UiConfigService.new);

  final TokenStore tokens = TokenStore();
  await tokens.load();
  sl.registerSingleton<TokenStore>(tokens);
  sl.registerSingleton<ApiClient>(ApiClient(tokens: tokens));
  sl.registerSingleton<AuthApi>(AuthApi(sl<ApiClient>(), tokens));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerSingleton<MediaApi>(MediaApi(sl<ApiClient>()));
  sl.registerSingleton<DeploymentApi>(DeploymentApi(sl<ApiClient>()));

  sl.registerLazySingleton<HubRepository>(() => HubRepositoryImpl(sl<ApiClient>()));
  sl.registerLazySingleton<AllocationRepository>(() => AllocationRepositoryImpl(sl<ApiClient>(), sl<DeploymentApi>()));
  sl.registerLazySingleton<MaintenanceRepository>(() => MaintenanceRepositoryImpl(sl<ApiClient>()));
  sl.registerLazySingleton<RidersRepository>(() => RidersRepositoryImpl(sl<ApiClient>()));

  sl.registerLazySingleton<SessionController>(
    () => SessionController(
      config: sl(),
      requestOtpUseCase: RequestOtp(sl()),
      verifyOtpUseCase: VerifyOtp(sl()),
      restoreSession: RestoreSession(sl()),
      signOutUseCase: SignOut(sl()),
      listHubs: ListHubs(sl()),
    ),
  );

  await sl<SessionController>().bootstrap();
}
