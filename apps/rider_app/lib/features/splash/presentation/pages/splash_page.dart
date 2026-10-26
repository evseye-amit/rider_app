import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/push_routes.dart';
import '../../../../core/session/rider_session_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with SingleTickerProviderStateMixin {
  static const Duration _dwell = Duration(milliseconds: 2400);

  late final AnimationController _progress = AnimationController(vsync: this, duration: _dwell)..forward();

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final Future<void> boot = ref.read(riderSessionProvider.notifier).bootstrap();
    _timer = Timer(_dwell, () async {
      await boot;
      if (!mounted) return;
      final RiderSession session = ref.read(riderSessionProvider);
      final GoRouter router = GoRouter.of(context);
      context.go(session.isSignedIn ? session.homeRoute : Routes.intro);
      if (!session.isSignedIn) return;
      final Map<String, String>? tap = await PushNotifications.initialTap();
      if (tap != null) unawaited(router.push(pushLocation(tap)));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SplashArtwork.ground,
      body: SplashArtwork(progress: _progress),
    );
  }
}
