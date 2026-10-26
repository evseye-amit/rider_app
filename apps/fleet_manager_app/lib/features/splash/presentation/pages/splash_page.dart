import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/session/fleet_session_provider.dart';

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

    final Future<void> boot = ref.read(fleetSessionProvider.notifier).bootstrap();
    _timer = Timer(_dwell, () async {
      await boot;
      if (!mounted) return;
      final bool signedIn = ref.read(fleetSessionProvider).isSignedIn;
      final GoRouter router = GoRouter.of(context);
      context.go(signedIn ? Routes.home : Routes.login);
      if (!signedIn) return;
      if (await PushNotifications.initialTap() != null) unawaited(router.push(Routes.notifications));
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
