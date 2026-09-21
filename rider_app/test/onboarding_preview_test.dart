import 'dart:convert';
import 'dart:io';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rider_app/app/di/injector.dart';
import 'package:rider_app/core/session/session_controller.dart';
import 'package:rider_app/features/onboarding/presentation/pages/onboarding_preview_page.dart';

void main() {
  late RiderOnboardingConfig config;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerDefaultWidgets();
    await configureDependencies();
    await sl<SessionController>().signIn('9876543299');
    final Map<String, dynamic> json =
        jsonDecode(File('test/fixtures/onboarding_config.json').readAsStringSync()) as Map<String, dynamic>;
    config = RiderOnboardingConfig.fromJson(json);
    await sl<SessionController>().applyOnboarding(config);
  });

  testWidgets('review lists every step with the saved answers', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: const OnboardingPreviewPage()));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Review your application'), findsOneWidget);
    for (final step in config.steps) {
      expect(find.text(step.stepName), findsOneWidget, reason: step.stepCode);
    }
    expect(find.text('Ravi Kumar'), findsOneWidget);
    expect(find.text('Submit application'), findsOneWidget);
  });
}
