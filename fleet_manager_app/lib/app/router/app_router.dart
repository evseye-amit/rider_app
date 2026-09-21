import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/session_controller.dart';
import '../../features/allocation/presentation/pages/allocation_detail_page.dart';
import '../../features/allocation/presentation/pages/allocation_done_page.dart';
import '../../features/allocation/presentation/pages/allocations_page.dart';
import '../../features/allocation/presentation/pages/deallocations_page.dart';
import '../../features/allocation/presentation/pages/assign_vehicle_page.dart';
import '../../features/allocation/presentation/pages/deallocation_detail_page.dart';
import '../../features/allocation/presentation/pages/deallocation_flow_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/hub/presentation/pages/home_page.dart';
import '../../features/hub/presentation/widgets/fleet_shell.dart';
import '../../features/maintenance/presentation/pages/maintenance_detail_page.dart';
import '../../features/maintenance/presentation/pages/maintenance_page.dart';
import '../../features/maintenance/presentation/pages/raise_maintenance_page.dart';
import '../../features/riders/presentation/pages/team_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter({required SessionController session}) : _session = session;

  final SessionController _session;

  static final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootKey;

  late final GoRouter config = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: _session,
    redirect: (context, state) {
      const Set<String> preAuth = {Routes.splash, Routes.login, Routes.otp};
      if (preAuth.contains(state.uri.path)) return null;
      return _session.isSignedIn ? null : Routes.login;
    },
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (c, s) => const SplashPage()),
      GoRoute(path: Routes.login, name: 'login', builder: (c, s) => const LoginPage()),
      GoRoute(
        path: Routes.otp,
        name: 'otp',
        builder: (c, s) => OtpPage(
          mobile: s.uri.queryParameters['mobile'] ?? '',
          otpRequestId: s.uri.queryParameters['request'] ?? '',
        ),
      ),

      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) => FleetShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, name: 'home', builder: (c, s) => const HomePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.allocations,
                name: 'allocations',
                builder: (c, s) => const AllocationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.deallocations,
                name: 'deallocations',
                builder: (c, s) => const DeallocationsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.team, name: 'team', builder: (c, s) => const TeamPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.maintenance,
                name: 'maintenance',
                builder: (c, s) => const MaintenancePage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: Routes.allocationDetail,
        name: 'allocationDetail',
        builder: (c, s) => AllocationDetailPage(requestId: s.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.assignVehicle,
        name: 'assignVehicle',
        builder: (c, s) => AssignVehiclePage(riderId: s.uri.queryParameters['rider'] ?? ''),
      ),
      GoRoute(
        path: Routes.allocationDone,
        name: 'allocationDone',
        builder: (c, s) => AllocationDonePage(
          riderName: s.uri.queryParameters['rider'] ?? '',
          vehicleNumber: s.uri.queryParameters['vehicle'] ?? '',
          allocationId: s.uri.queryParameters['id'],
        ),
      ),

      GoRoute(
        path: Routes.deallocationDetail,
        name: 'deallocationDetail',
        builder: (c, s) => DeallocationDetailPage(requestId: s.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.deallocationFlow,
        name: 'deallocationFlow',
        builder: (c, s) => DeallocationFlowPage(requestId: s.uri.queryParameters['id'] ?? ''),
      ),

      GoRoute(
        path: Routes.maintenanceDetail,
        name: 'maintenanceDetail',
        builder: (c, s) => MaintenanceDetailPage(jobId: s.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.raiseMaintenance,
        name: 'raiseMaintenance',
        builder: (c, s) => RaiseMaintenancePage(
          vehicleNumber: s.uri.queryParameters['vehicle'],
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('No screen at ${state.uri}')),
    ),
  );
}
