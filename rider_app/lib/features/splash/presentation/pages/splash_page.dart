import 'dart:async';

import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/session/session_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  static const Duration _dwell = Duration(milliseconds: 2400);

  late final AnimationController _progress =
      AnimationController(vsync: this, duration: _dwell)..forward();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final Future<void> boot = sl<SessionController>().bootstrap();
    _timer = Timer(_dwell, () async {
      await boot;
      if (!mounted) return;
      final SessionController session = sl<SessionController>();
      context.go(session.isSignedIn ? session.homeRoute : Routes.intro);
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
