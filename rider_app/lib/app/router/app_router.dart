import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/deployment/presentation/pages/pairing_page.dart';
import '../../features/deployment/presentation/pages/payment_page.dart';
import '../../features/deployment/presentation/pages/pdi_page.dart';
import '../../features/deployment/presentation/pages/training_page.dart';
import '../../features/deployment/presentation/pages/waiting_page.dart';
import '../../features/earnings/presentation/pages/incentives_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/widgets/rider_shell.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_flow_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_preview_page.dart';
import '../../features/onboarding_intro/presentation/pages/intro_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/rentals/presentation/pages/rentals_page.dart';
import '../../features/scooter/presentation/pages/scooter_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/support/presentation/pages/raise_ticket_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter({required SessionController session}) : _session = session;

  final SessionController _session;

  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootKey;

  late final GoRouter config = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    refreshListenable: _session,
    redirect: _guard,
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: Routes.intro, name: 'intro', builder: (context, state) => const IntroPage()),
      GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: Routes.otp,
        name: 'otp',
        builder: (context, state) => OtpPage(
          mobile: state.uri.queryParameters['mobile'] ?? '',
          otpRequestId: state.uri.queryParameters['request'] ?? '',
        ),
      ),

      GoRoute(
        path: Routes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlowPage(),
        routes: [
          GoRoute(
            path: 'preview',
            name: 'onboardingPreview',
            builder: (context, state) => const OnboardingPreviewPage(),
          ),
        ],
      ),

      GoRoute(path: Routes.deploymentWaiting, name: 'deploymentWaiting', builder: (context, state) => const WaitingPage()),
      GoRoute(path: Routes.deploymentPayment, name: 'deploymentPayment', builder: (context, state) => const PaymentPage()),
      GoRoute(path: Routes.deploymentPdi, name: 'deploymentPdi', builder: (context, state) => const PdiPage()),
      GoRoute(path: Routes.deploymentTraining, name: 'deploymentTraining', builder: (context, state) => const TrainingPage()),
      GoRoute(path: Routes.deploymentPairing, name: 'deploymentPairing', builder: (context, state) => const PairingPage()),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) => RiderShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [GoRoute(path: Routes.home, name: 'home', builder: (context, state) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.scooter, name: 'scooter', builder: (context, state) => const ScooterPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.support,
                name: 'support',
                builder: (context, state) => const SupportPage(),
                routes: [
                  GoRoute(
                    path: 'raise',
                    name: 'raiseTicket',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => RaiseTicketPage(categoryKey: state.uri.queryParameters['category']),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.wallet, name: 'wallet', builder: (context, state) => const WalletPage())],
          ),
        ],
      ),

      GoRoute(path: Routes.incentives, name: 'incentives', builder: (context, state) => const IncentivesPage()),
      GoRoute(path: Routes.rentals, name: 'rentals', builder: (context, state) => const RentalsPage()),
      GoRoute(path: Routes.profile, name: 'profile', builder: (context, state) => const ProfilePage()),
      GoRoute(path: Routes.notifications, name: 'notifications', builder: (context, state) => const NotificationsPage()),
    ],
    errorBuilder: (context, state) => _RouteErrorPage(location: state.uri.toString()),
  );

  String? _guard(BuildContext context, GoRouterState state) {
    final String path = state.uri.path;
    const Set<String> preAuth = {Routes.splash, Routes.intro, Routes.login, Routes.otp};
    if (preAuth.contains(path)) return null;

    final RiderStage stage = _session.stage;
    return switch (stage) {
      RiderStage.signedOut => Routes.login,
      RiderStage.onboarding => path.startsWith(Routes.onboarding) ? null : Routes.onboarding,

      RiderStage.waiting ||
      RiderStage.payment ||
      RiderStage.pdi ||
      RiderStage.training ||
      RiderStage.devicePairing =>
        path == stage.route ? null : stage.route,
      RiderStage.active =>
        path.startsWith(Routes.onboarding) || path.startsWith('/deployment') ? Routes.home : null,
    };
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off_rounded, size: 44),
              const SizedBox(height: 16),
              Text('No screen at $location', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go(Routes.home), child: const Text('Go home')),
            ],
          ),
        ),
      ),
    );
  }
}
