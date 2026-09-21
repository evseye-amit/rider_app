import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';

import 'di/injector.dart';
import 'router/app_router.dart';

class FleetManagerApp extends StatefulWidget {
  const FleetManagerApp({super.key});

  @override
  State<FleetManagerApp> createState() => _FleetManagerAppState();
}

class _FleetManagerAppState extends State<FleetManagerApp> {
  late final AppRouter _router = AppRouter(session: sl());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EVSEYE Fleet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.dark,
      routerConfig: _router.config,
      builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
    );
  }
}
