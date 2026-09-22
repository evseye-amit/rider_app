@Tags(['screenshots'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/app/di/injector.dart';
import 'package:rider_app/core/demo/demo_data.dart';
import 'package:rider_app/core/session/session_controller.dart';
import 'package:rider_app/features/auth/presentation/pages/login_page.dart';
import 'package:rider_app/features/auth/presentation/pages/otp_page.dart';
import 'package:rider_app/features/deployment/presentation/pages/pairing_page.dart';
import 'package:rider_app/features/deployment/presentation/pages/payment_page.dart';
import 'package:rider_app/features/deployment/presentation/pages/pdi_page.dart';
import 'package:rider_app/features/deployment/presentation/pages/training_page.dart';
import 'package:rider_app/features/deployment/presentation/pages/waiting_page.dart';
import 'package:rider_app/features/earnings/presentation/pages/incentives_page.dart';
import 'package:rider_app/features/home/presentation/pages/home_page.dart';
import 'package:rider_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:rider_app/features/onboarding/domain/onboarding_draft.dart';
import 'package:rider_app/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:rider_app/features/onboarding/presentation/pages/onboarding_preview_page.dart';
import 'package:rider_app/features/onboarding_intro/presentation/pages/intro_page.dart';
import 'package:rider_app/features/profile/presentation/pages/profile_page.dart';
import 'package:rider_app/features/rentals/presentation/pages/rentals_page.dart';
import 'package:rider_app/features/scooter/domain/entities/vehicle.dart';
import 'package:rider_app/features/scooter/presentation/pages/scooter_details_page.dart';
import 'package:rider_app/features/scooter/presentation/pages/scooter_page.dart';
import 'package:rider_app/features/home/presentation/widgets/rider_drawer.dart';
import 'package:rider_app/features/home/presentation/widgets/rider_shell.dart';
import 'package:rider_app/features/support/presentation/pages/raise_ticket_page.dart';
import 'package:rider_app/features/support/presentation/pages/support_page.dart';
import 'package:rider_app/features/wallet/presentation/pages/wallet_page.dart';

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
    await sl<SessionController>().signIn('9876543210');

    sl<SessionController>().seedProfile(Demo.profile);
    sl<SessionController>().setAttendance(true);

    Directory(outDir).createSync(recursive: true);
  });

  final Map<String, Widget Function()> screens = {
    '00_splash': () => const Scaffold(
          backgroundColor: Color(0xFF04171A),
          body: SplashArtwork(progress: AlwaysStoppedAnimation<double>(0.62)),
        ),
    '01_intro': IntroPage.new,
    '03_login': LoginPage.new,
    '04_otp': () => const OtpPage(mobile: '9876543210', otpRequestId: 'preview'),

    '02a_onboarding_1_profile': () => _onboardingAt(0),
    '02b_onboarding_2_kyc': () => _onboardingAt(1),
    '02c_onboarding_3_eligibility': () => _onboardingAt(2),
    '02d_onboarding_4_money': () => _onboardingAt(3),
    '02e_onboarding_5_training': () => _onboardingAt(4),
    '02f_onboarding_6_agreement': () => _onboardingAt(5),
    '02g_onboarding_preview': OnboardingPreviewPage.new,

    '05_deployment_waiting': WaitingPage.new,
    '05b_deployment_payment': PaymentPage.new,
    '05c_deployment_pdi': PdiPage.new,
    '05d_deployment_training': TrainingPage.new,
    '05e_deployment_pairing': PairingPage.new,
    '07_home': HomePage.new,
    '08_scooter': ScooterPage.new,
    '08b_scooter_details': () => ScooterDetailsPage(
          vehicle: Vehicle(
            vehicleNumber: 'DL 1S CD 9012',
            model: 'Ather 450X Gen 3',
            vin: 'CHS100005',
            colour: 'Space Grey',
            allocatedOn: DateTime(2026, 9, 22),
            batteryPercent: 68,
            charging: false,
            rangeKm: 61,
            odometerKm: 2440,
            healthPercent: 94,
            lastServiceKm: 0,
            nextServiceKm: 5000,
            tyrePressureFront: 30,
            tyrePressureRear: 32,
            iot: const VehicleIot(
              deviceId: 'EVS-IOT-0005',
              online: true,
              signal: 3,
              lastPing: 'a moment ago',
              firmware: '—',
            ),
            documents: const [],
            accessories: const [],
            recentTrips: const [],
            motorNumber: 'MOT-9012',
            controllerNumber: 'CTRL-0004',
            batteryType: 'FIXED_DOUBLE',
            batterySerial: 'BAT-0004',
            homeHubName: 'Okhla Phase II Hub',
            currentHubName: 'Okhla Phase II Hub',
            teamLeadName: 'Rohit Sharma',
          ),
        ),
    '09_wallet': WalletPage.new,
    '10_support': SupportPage.new,
    '11_raise_ticket': () => const RaiseTicketPage(categoryKey: 'battery'),
    '14_incentives': IncentivesPage.new,
    '15_rentals': RentalsPage.new,
    '16_profile': ProfilePage.new,
    '19_notifications': NotificationsPage.new,

    '23_bottom_bar': () => Scaffold(
          backgroundColor: AppColors.canvas,
          bottomNavigationBar: RiderBottomBar(
            currentIndex: 0,
            onTap: (_) {},
            onPowerTap: () {},
            canRide: true,
          ),
        ),

    '24_drawer': () => const Scaffold(body: RiderDrawer()),
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

Widget _onboardingAt(int index) {
  OnboardingDraft.instance.jumpToStepIndex = index;
  return const OnboardingFlowPage();
}
