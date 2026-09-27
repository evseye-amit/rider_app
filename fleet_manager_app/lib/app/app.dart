import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return ListenableBuilder(
      listenable: AppLocaleController.instance,
      builder: (context, _) => MaterialApp.router(
        title: 'Pink Rides Ops',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        themeMode: ThemeMode.dark,
        routerConfig: _router.config,
        locale: AppLocaleController.instance.locale.locale,
        supportedLocales: AppLocale.values.map((l) => l.locale),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
      ),
    );
  }
}
