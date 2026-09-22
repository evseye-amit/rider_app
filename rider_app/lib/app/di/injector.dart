import 'package:evseye_core/evseye_core.dart';
import 'package:get_it/get_it.dart';

import '../../core/session/session_controller.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/usecases/enroll_rider.dart';
import '../../features/auth/domain/usecases/request_otp.dart';
import '../../features/auth/domain/usecases/restore_session.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/deployment/data/deployment_repository_impl.dart';
import '../../features/deployment/domain/deployment_repository.dart';
import '../../features/deployment/domain/usecases/get_current_deployment.dart';
import '../../features/earnings/data/earnings_repository_impl.dart';
import '../../features/earnings/domain/earnings_repository.dart';
import '../../features/home/data/home_repository_impl.dart';
import '../../features/home/domain/home_repository.dart';
import '../../features/onboarding/data/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/get_onboarding.dart';
import '../../features/onboarding/domain/usecases/upload_onboarding_document.dart';
import '../../features/onboarding_intro/data/intro_repository_impl.dart';
import '../../features/onboarding_intro/domain/intro_repository.dart';
import '../../features/rentals/data/rentals_repository_impl.dart';
import '../../features/rentals/domain/rentals_repository.dart';
import '../../features/scooter/data/scooter_repository_impl.dart';
import '../../features/scooter/domain/scooter_repository.dart';
import '../../features/support/data/support_repository_impl.dart';
import '../../features/support/domain/support_repository.dart';
import '../../features/wallet/data/wallet_repository_impl.dart';
import '../../features/wallet/domain/wallet_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<UiConfigService>(UiConfigService.new);

  final TokenStore tokens = TokenStore();
  await tokens.load();
  sl.registerSingleton<TokenStore>(tokens);
  sl.registerSingleton<ApiClient>(ApiClient(tokens: tokens));
  sl.registerSingleton<AuthApi>(AuthApi(sl<ApiClient>(), tokens));
  sl.registerSingleton<RiderAppApi>(RiderAppApi(sl<ApiClient>()));
  sl.registerSingleton<DeploymentApi>(DeploymentApi(sl<ApiClient>()));
  sl.registerSingleton<MediaApi>(MediaApi(sl<ApiClient>()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthApi>(), sl<RiderAppApi>()));
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(sl<RiderAppApi>(), sl<MediaApi>()));
  sl.registerLazySingleton<DeploymentRepository>(() => DeploymentRepositoryImpl(sl<DeploymentApi>()));
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(sl<DeploymentApi>()));

  sl.registerLazySingleton<ScooterRepository>(() => ScooterRepositoryImpl(sl<DeploymentApi>()));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl<DeploymentApi>()));
  sl.registerLazySingleton<EarningsRepository>(() => EarningsRepositoryImpl());
  sl.registerLazySingleton<RentalsRepository>(() => RentalsRepositoryImpl());
  sl.registerLazySingleton<SupportRepository>(() => SupportRepositoryImpl());
  sl.registerLazySingleton<IntroRepository>(() => IntroRepositoryImpl(sl()));

  sl.registerLazySingleton<SessionController>(
    () => SessionController(
      config: sl(),
      enrollRider: EnrollRider(sl()),
      requestOtp: RequestOtp(sl()),
      verifyOtp: VerifyOtp(sl()),
      restoreSession: RestoreSession(sl()),
      signOut: SignOut(sl()),
      getOnboarding: GetOnboarding(sl()),
      getCurrentDeployment: GetCurrentDeployment(sl()),
      uploadDocument: UploadOnboardingDocument(sl()),
      tokens: sl<TokenStore>(),
    ),
  );

  sl<ApiClient>().onSessionExpired = () => sl<SessionController>().handleSessionExpired();
}
