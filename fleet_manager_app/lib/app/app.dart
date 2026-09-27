import 'package:evseye_core/evseye_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

class FleetManagerApp extends ConsumerWidget {
  const FleetManagerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocale locale = ref.watch(localeProvider.select((p) => p.locale));

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appPinkRidesOps,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(routerProvider),
      locale: locale.locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: AppL10n.localizationsDelegates,
      builder: (context, child) => MediaQuery.withNoTextScaling(child: child ?? const SizedBox()),
    );
  }
}
