import 'package:evseye_core/evseye_core.dart';
import 'package:fleet_manager_app/app/di/injector.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/allocation_detail_page.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/allocation_done_page.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/allocations_page.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/deallocations_page.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/assign_vehicle_page.dart';
import 'package:fleet_manager_app/features/allocation/presentation/pages/deallocation_detail_page.dart';
import 'package:fleet_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:fleet_manager_app/features/auth/presentation/pages/otp_page.dart';
import 'package:fleet_manager_app/features/hub/presentation/pages/home_page.dart';
import 'package:fleet_manager_app/features/maintenance/presentation/pages/maintenance_detail_page.dart';
import 'package:fleet_manager_app/features/maintenance/presentation/pages/maintenance_page.dart';
import 'package:fleet_manager_app/features/maintenance/presentation/pages/raise_maintenance_page.dart';
import 'package:fleet_manager_app/features/riders/presentation/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Size small = Size(320, 568);
  const Size tall = Size(430, 932);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerDefaultWidgets();
    await configureDependencies();
  });

  final Map<String, Widget Function()> screens = {
    'login': LoginPage.new,
    'otp': () => const OtpPage(mobile: '9845012345', otpRequestId: 'preview'),
    'home': HomePage.new,
    'allocations': AllocationsPage.new,
    'deallocations': DeallocationsPage.new,
    'allocationDetail': () => const AllocationDetailPage(requestId: 'ALC-3391'),
    'assignVehicle': () => const AssignVehiclePage(riderId: 'rider-1'),
    'allocationDone': () =>
        const AllocationDonePage(riderName: 'Kunal Verma', vehicleNumber: 'DL 1S CD 9012'),
    'deallocationDetail': () => const DeallocationDetailPage(requestId: 'DAL-1182'),
    'maintenance': MaintenancePage.new,
    'maintenanceDetail': () => const MaintenanceDetailPage(jobId: 'MNT-2291'),
    'raiseMaintenance': () => const RaiseMaintenancePage(vehicleNumber: 'DL 1S CA 4102'),
    'team': TeamPage.new,
  };

  for (final size in [small, tall]) {
    final label = '${size.width.toInt()}x${size.height.toInt()}';

    for (final entry in screens.entries) {
      testWidgets('${entry.key} lays out without overflow at $label', (tester) async {
        tester.view
          ..physicalSize = size
          ..devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            home: entry.value(),
          ),
        );

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump(const Duration(seconds: 2));

        expect(
          tester.takeException(),
          isNull,
          reason: '${entry.key} overflowed or threw at $label',
        );
      });
    }
  }
}
