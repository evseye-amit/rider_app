import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import 'di/injector.dart';
import 'router/app_router.dart';

class RiderApp extends StatefulWidget {
  const RiderApp({super.key});

  @override
  State<RiderApp> createState() => _RiderAppState();
}

class _RiderAppState extends State<RiderApp> {
  late final AppRouter _router = AppRouter(session: sl());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EVSEYE Rider',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.dark,
      routerConfig: _router.config,
      builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
    );
  }
}
