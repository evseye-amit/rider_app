@Tags(['screenshots'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

void main() {
  const String outDir = String.fromEnvironment('OUT', defaultValue: 'build/screens');
  const Size viewport = Size(390, 844);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    for (final family in ['Manrope', 'Sora']) {
      final loader = FontLoader(family);
      for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
        final file = File('assets/fonts/$family-$weight.ttf');
        if (file.existsSync()) {
          loader.addFont(Future.value(file.readAsBytesSync().buffer.asByteData()));
        }
      }
      await loader.load();
    }

    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(Future.value(
        File('/Users/user/develop/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf')
            .readAsBytesSync()
            .buffer
            .asByteData(),
      ));
    await iconLoader.load();

    registerDefaultWidgets();
    await configureDependencies();

    Directory(outDir).createSync(recursive: true);
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

  for (final entry in screens.entries) {
    testWidgets('capture ${entry.key}', (tester) async {
      tester.view
        ..physicalSize = viewport
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(
            theme: AppTheme.light,
            debugShowCheckedModeBanner: false,
            home: entry.value(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      await tester.runAsync(() async {
        for (final element in find.byType(Image).evaluate()) {
          final Image image = element.widget as Image;
          await precacheImage(image.image, element);
        }
      });
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

      await tester.runAsync(() async {
        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        File('$outDir/${entry.key}.png').writeAsBytesSync(bytes!.buffer.asUint8List());
        image.dispose();
      });
    });
  }
}
