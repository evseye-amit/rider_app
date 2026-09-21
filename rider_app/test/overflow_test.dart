import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
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
import 'package:rider_app/features/onboarding_intro/presentation/pages/intro_page.dart';
import 'package:rider_app/features/profile/presentation/pages/profile_page.dart';
import 'package:rider_app/features/rentals/presentation/pages/rentals_page.dart';
import 'package:rider_app/features/scooter/presentation/pages/scooter_page.dart';
import 'package:rider_app/features/support/presentation/pages/raise_ticket_page.dart';
import 'package:rider_app/features/support/presentation/pages/support_page.dart';
import 'package:rider_app/features/wallet/presentation/pages/wallet_page.dart';

void main() {
  const Size small = Size(320, 568);
  const Size tall = Size(430, 932);

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerDefaultWidgets();
    await configureDependencies();

    await sl<SessionController>().signIn('9876543210');

    sl<SessionController>().seedProfile(Demo.profile);
    sl<SessionController>().setAttendance(true);
  });

  final Map<String, Widget Function()> screens = {
    'intro': IntroPage.new,
    'login': LoginPage.new,
    'otp': () => const OtpPage(mobile: '9876543210', otpRequestId: 'preview'),
    'deploymentWaiting': WaitingPage.new,
    'deploymentPayment': PaymentPage.new,
    'deploymentPdi': PdiPage.new,
    'deploymentTraining': TrainingPage.new,
    'deploymentPairing': PairingPage.new,
    'home': HomePage.new,
    'scooter': ScooterPage.new,
    'wallet': WalletPage.new,
    'support': SupportPage.new,
    'raiseTicket': () => const RaiseTicketPage(categoryKey: 'battery'),
    'incentives': IncentivesPage.new,
    'rentals': RentalsPage.new,
    'profile': ProfilePage.new,
    'notifications': NotificationsPage.new,
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
