import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/fleet_session_provider.dart';
import '../../features/allocation/presentation/pages/allocation_detail_page.dart';
import '../../features/allocation/presentation/pages/allocation_done_page.dart';
import '../../features/allocation/presentation/pages/allocations_page.dart';
import '../../features/allocation/presentation/pages/assign_vehicle_page.dart';
import '../../features/allocation/presentation/pages/rider_verification_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/hub/presentation/pages/home_page.dart';
import '../../features/hub/presentation/widgets/fleet_shell.dart';
import '../../features/maintenance/presentation/pages/maintenance_detail_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_page.dart';
import '../../features/maintenance/presentation/pages/raise_maintenance_page.dart';
import '../../features/riders/presentation/pages/team_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/submissions/presentation/pages/submission_confirm_page.dart';
import '../../features/submissions/presentation/pages/submission_page.dart';
import '../../features/submissions/presentation/pages/submission_report_page.dart';
import '../../features/submissions/presentation/pages/submissions_page.dart';
import '../../features/support/presentation/pages/desk_ticket_page.dart';
import '../../features/support/presentation/pages/support_desk_page.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

const Set<String> _publicPaths = {Routes.splash, Routes.company, Routes.language, Routes.login, Routes.otp};

final routerProvider = Provider<GoRouter>((ref) {
  final ValueNotifier<bool> signedIn = ValueNotifier<bool>(ref.read(fleetSessionProvider).isSignedIn);
  ref.onDispose(signedIn.dispose);
  ref.listen(fleetSessionProvider.select((s) => s.isSignedIn), (_, next) => signedIn.value = next);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: signedIn,
    redirect: (context, state) =>
        _redirect(signedIn.value, ref.read(pendingFirstRunStepProvider(false)), state.uri.path),
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: Routes.company,
        name: 'company',
        builder: (context, state) =>
            CompanyResolvePage(audience: LegalAudience.fleetManager, onResolved: () => context.go(Routes.login)),
      ),
      GoRoute(
        path: Routes.language,
        name: 'language',
        builder: (context, state) => LanguageSelectionPage(onSelected: () => context.go(Routes.login)),
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
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) => FleetShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.home, name: 'home', builder: (context, state) => const HomePage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.allocations,
                name: 'allocations',
                builder: (context, state) => const AllocationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.submissions,
                name: 'submissions',
                builder: (context, state) => const SubmissionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: Routes.team, name: 'team', builder: (context, state) => const TeamPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.maintenance,
                name: 'maintenance',
                builder: (context, state) => const MaintenancePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.allocationDetail,
        name: 'allocationDetail',
        builder: (context, state) => AllocationDetailPage(requestId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.riderVerification,
        name: 'riderVerification',
        builder: (context, state) => RiderVerificationPage(riderId: state.uri.queryParameters['rider'] ?? ''),
      ),
      GoRoute(
        path: Routes.assignVehicle,
        name: 'assignVehicle',
        builder: (context, state) => AssignVehiclePage(riderId: state.uri.queryParameters['rider'] ?? ''),
      ),
      GoRoute(
        path: Routes.allocationDone,
        name: 'allocationDone',
        builder: (context, state) => AllocationDonePage(
          riderName: state.uri.queryParameters['rider'] ?? '',
          vehicleNumber: state.uri.queryParameters['vehicle'] ?? '',
          allocationId: state.uri.queryParameters['id'],
        ),
      ),
      GoRoute(
        path: Routes.submission,
        name: 'submission',
        builder: (context, state) => SubmissionPage(submissionId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.submissionReport,
        name: 'submissionReport',
        builder: (context, state) => SubmissionReportPage(submissionId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.submissionConfirm,
        name: 'submissionConfirm',
        builder: (context, state) => SubmissionConfirmPage(submissionId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.maintenanceDetail,
        name: 'maintenanceDetail',
        builder: (context, state) => MaintenanceDetailPage(jobId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.raiseMaintenance,
        name: 'raiseMaintenance',
        builder: (context, state) => RaiseMaintenancePage(vehicleNumber: state.uri.queryParameters['vehicle']),
      ),
      GoRoute(path: Routes.support, name: 'support', builder: (context, state) => const SupportDeskPage()),
      GoRoute(
        path: Routes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: Routes.supportTicket,
        name: 'supportTicket',
        builder: (context, state) => DeskTicketPage(ticketId: state.uri.queryParameters['id'] ?? ''),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorPage(location: state.uri.toString()),
  );
});

String? _redirect(bool signedIn, FirstRunStep? firstRun, String path) {
  if (path == Routes.login) {
    return switch (firstRun) {
      FirstRunStep.company => Routes.company,
      FirstRunStep.language => Routes.language,
      FirstRunStep.consent || null => null,
    };
  }
  if (_publicPaths.contains(path)) return null;
  return signedIn ? null : Routes.login;
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
