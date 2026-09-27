import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/session/fleet_session_provider.dart';
import '../../features/allocation/presentation/pages/allocation_detail_page.dart';
import '../../features/allocation/presentation/pages/allocation_done_page.dart';
import '../../features/allocation/presentation/pages/allocations_page.dart';
import '../../features/allocation/presentation/pages/assign_vehicle_page.dart';
import '../../features/allocation/presentation/pages/deallocation_detail_page.dart';
import '../../features/allocation/presentation/pages/deallocation_flow_page.dart';
import '../../features/allocation/presentation/pages/deallocations_page.dart';
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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

const Set<String> _publicPaths = {Routes.splash, Routes.login, Routes.otp};

final routerProvider = Provider<GoRouter>((ref) {
  final ValueNotifier<bool> signedIn = ValueNotifier<bool>(ref.read(fleetSessionProvider).isSignedIn);
  ref.onDispose(signedIn.dispose);
  ref.listen(fleetSessionProvider.select((s) => s.isSignedIn), (_, next) => signedIn.value = next);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: signedIn,
    redirect: (context, state) {
      if (_publicPaths.contains(state.uri.path)) return null;
      return signedIn.value ? null : Routes.login;
    },
    routes: [
      GoRoute(path: Routes.splash, name: 'splash', builder: (context, state) => const SplashPage()),
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
                path: Routes.deallocations,
                name: 'deallocations',
                builder: (context, state) => const DeallocationsPage(),
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
        path: Routes.deallocationDetail,
        name: 'deallocationDetail',
        builder: (context, state) => DeallocationDetailPage(requestId: state.uri.queryParameters['id'] ?? ''),
      ),
      GoRoute(
        path: Routes.deallocationFlow,
        name: 'deallocationFlow',
        builder: (context, state) => DeallocationFlowPage(requestId: state.uri.queryParameters['id'] ?? ''),
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
    ],
    errorBuilder: (context, state) => _RouteErrorPage(location: state.uri.toString()),
  );
});

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
