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
  late final LocaleController _locale = sl<LocaleController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _locale,
      builder: (context, _) => MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appPinkRidesRental,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        themeMode: ThemeMode.dark,
        routerConfig: _router.config,
        locale: _locale.locale,
        supportedLocales: AppL10n.supportedLocales,
        localizationsDelegates: AppL10n.localizationsDelegates,
        builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
      ),
    );
  }
}
