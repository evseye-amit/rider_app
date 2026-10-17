import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/referral/referral_scanner_page.dart';
import '../../core/session/rider_session_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/battery_swap/presentation/pages/battery_swap_page.dart';
import '../../features/deployment/presentation/pages/payment_page.dart';
import '../../features/deployment/presentation/pages/pdi_page.dart';
import '../../features/deployment/presentation/pages/training_page.dart';
import '../../features/deployment/presentation/pages/waiting_page.dart';
import '../../features/earnings/presentation/pages/incentives_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/widgets/rider_shell.dart';
import '../../features/nearby_hubs/presentation/pages/nearby_hubs_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_flow_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_preview_page.dart';
import '../../features/onboarding_intro/presentation/pages/intro_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/referrals/presentation/pages/refer_earn_page.dart';
import '../../features/rentals/presentation/pages/rentals_page.dart';
import '../../features/ride_returns/presentation/pages/request_return_page.dart';
import '../../features/ride_returns/presentation/pages/return_detail_page.dart';
import '../../features/ride_returns/presentation/pages/returns_page.dart';
import '../../features/scooter/presentation/pages/scooter_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/support/presentation/pages/raise_ticket_page.dart';
import '../../features/support/presentation/pages/support_page.dart';
import '../../features/support/presentation/pages/ticket_thread_page.dart';
import '../../features/vehicle_exchange/presentation/pages/exchange_detail_page.dart';
import '../../features/vehicle_exchange/presentation/pages/exchanges_page.dart';
import '../../features/vehicle_exchange/presentation/pages/request_exchange_page.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wallet/presentation/pages/wallet_statement_page.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

const Set<String> _publicPaths = {
  Routes.splash,
  Routes.company,
  Routes.language,
  Routes.consent,
  Routes.intro,
  Routes.login,
  Routes.otp,
};

final routerProvider = Provider<GoRouter>((ref) {
  final ValueNotifier<RiderStage> stage = ValueNotifier<RiderStage>(ref.read(riderSessionProvider).stage);
  ref.onDispose(stage.dispose);
  ref.listen(riderSessionProvider.select((s) => s.stage), (_, next) => stage.value = next);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: stage,
    redirect: (context, state) => _redirect(stage.value, ref.read(pendingFirstRunStepProvider(true)), state.uri.path),
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: Routes.intro, name: 'intro', builder: (context, state) => const IntroPage()),
      GoRoute(
        path: Routes.company,
        name: 'company',
        builder: (context, state) =>
            CompanyResolvePage(audience: LegalAudience.rider, onResolved: () => context.go(Routes.intro)),
      ),
      GoRoute(
        path: Routes.language,
        name: 'language',
        builder: (context, state) => LanguageSelectionPage(onSelected: () => context.go(Routes.intro)),
      ),
      GoRoute(
        path: Routes.consent,
        name: 'consent',
        builder: (context, state) => ConsentPage(
          audience: LegalAudience.rider,
          title: context.l10n.consentRiderTitle,
          onAccepted: () => context.go(Routes.intro),
        ),
      ),
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
          GoRoute(
            path: 'referral-scan',
            name: 'onboardingReferralScan',
            builder: (context, state) => const ReferralScannerPage(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.deploymentWaiting,
        name: 'deploymentWaiting',
        builder: (context, state) => const WaitingPage(),
      ),
      GoRoute(
        path: Routes.deploymentPayment,
        name: 'deploymentPayment',
        builder: (context, state) => const PaymentPage(),
      ),
      GoRoute(path: Routes.deploymentPdi, name: 'deploymentPdi', builder: (context, state) => const PdiPage()),
      GoRoute(
        path: Routes.deploymentTraining,
        name: 'deploymentTraining',
        builder: (context, state) => const TrainingPage(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) => RiderShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [GoRoute(path: Routes.home, name: 'home', builder: (context, state) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.batterySwap,
                name: 'batterySwap',
                builder: (context, state) => const BatterySwapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.scooter, name: 'scooter', builder: (context, state) => const ScooterPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.nearbyHubs, name: 'nearbyHubs', builder: (context, state) => const NearbyHubsPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.referEarn, name: 'referEarn', builder: (context, state) => const ReferEarnPage()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.wallet,
        name: 'wallet',
        builder: (context, state) => const WalletPage(),
        routes: [
          GoRoute(path: 'statement', name: 'walletStatement', builder: (context, state) => const WalletStatementPage()),
        ],
      ),
      GoRoute(
        path: Routes.support,
        name: 'support',
        builder: (context, state) => const SupportPage(),
        routes: [
          GoRoute(path: 'raise', name: 'raiseTicket', builder: (context, state) => const RaiseTicketPage()),
          GoRoute(
            path: 'ticket',
            name: 'supportTicket',
            builder: (context, state) => TicketThreadPage(ticketId: state.uri.queryParameters['id'] ?? ''),
          ),
        ],
      ),
      GoRoute(path: Routes.incentives, name: 'incentives', builder: (context, state) => const IncentivesPage()),
      GoRoute(path: Routes.rentals, name: 'rentals', builder: (context, state) => const RentalsPage()),
      GoRoute(path: Routes.profile, name: 'profile', builder: (context, state) => const ProfilePage()),
      GoRoute(
        path: Routes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: Routes.vehicleExchanges,
        name: 'vehicleExchanges',
        builder: (context, state) => const ExchangesPage(),
      ),
      GoRoute(
        path: Routes.vehicleExchangeRequest,
        name: 'vehicleExchangeRequest',
        builder: (context, state) => const RequestExchangePage(),
      ),
      GoRoute(
        path: Routes.vehicleExchangeDetail,
        name: 'vehicleExchangeDetail',
        builder: (context, state) => ExchangeDetailPage(exchangeId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(path: Routes.rideReturns, name: 'rideReturns', builder: (context, state) => const ReturnsPage()),
      GoRoute(
        path: Routes.rideReturnRequest,
        name: 'rideReturnRequest',
        builder: (context, state) => const RequestReturnPage(),
      ),
      GoRoute(
        path: Routes.rideReturnDetail,
        name: 'rideReturnDetail',
        builder: (context, state) => ReturnDetailPage(returnId: state.uri.queryParameters['id'] ?? ''),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorPage(location: state.uri.toString()),
  );
});

String? _redirect(RiderStage stage, FirstRunStep? firstRun, String path) {
  if (path == Routes.intro || path == Routes.login) return _firstRunRoute(firstRun);
  if (_publicPaths.contains(path)) return null;
  return switch (stage) {
    RiderStage.signedOut => Routes.login,
    RiderStage.onboarding => path.startsWith(Routes.onboarding) ? null : Routes.onboarding,
    RiderStage.waiting ||
    RiderStage.payment ||
    RiderStage.pdi ||
    RiderStage.training => path == stage.route ? null : stage.route,
    RiderStage.active => path.startsWith(Routes.onboarding) || path.startsWith('/deployment') ? Routes.home : null,
  };
}

String? _firstRunRoute(FirstRunStep? step) => switch (step) {
  FirstRunStep.company => Routes.company,
  FirstRunStep.language => Routes.language,
  FirstRunStep.consent => Routes.consent,
  null => null,
};

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
              Text(context.l10n.routerNoScreenAt(location), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go(Routes.home), child: Text(context.l10n.appGoHome)),
            ],
          ),
        ),
      ),
    );
  }
}
