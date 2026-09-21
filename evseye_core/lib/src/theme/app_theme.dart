import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryWash,
      onPrimaryContainer: AppColors.primaryDeep,
      secondary: AppColors.cyan,
      onSecondary: Colors.white,
      tertiary: AppColors.mint,
      onTertiary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      errorContainer: AppColors.dangerWash,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerLowest: AppColors.canvas,
      surfaceContainer: AppColors.surfaceMuted,
      surfaceContainerHighest: AppColors.surfaceSunken,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.stroke,
      outlineVariant: AppColors.strokeStrong,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      canvasColor: AppColors.canvas,

      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      fontFamily: AppFonts.body,
      textTheme: const TextTheme(
        displayLarge: AppText.displayLarge,
        displayMedium: AppText.displayMedium,
        displaySmall: AppText.displaySmall,
        headlineMedium: AppText.displaySmall,
        headlineSmall: AppText.titleLarge,
        titleLarge: AppText.titleLarge,
        titleMedium: AppText.titleMedium,
        titleSmall: AppText.titleSmall,
        bodyLarge: AppText.bodyLarge,
        bodyMedium: AppText.bodyMedium,
        bodySmall: AppText.bodySmall,
        labelLarge: AppText.button,
        labelMedium: AppText.label,
        labelSmall: AppText.overline,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppText.titleLarge,
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.stroke,
        thickness: 1,
        space: 1,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: Corners.brLg,
          side: Strokes.hairline,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        titleTextStyle: AppText.titleSmall,
        subtitleTextStyle: AppText.bodySmall,
        contentPadding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.xs),
        shape: RoundedRectangleBorder(borderRadius: Corners.brMd),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceMuted,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.lg),
        hintStyle: AppText.bodyMedium.copyWith(color: AppColors.textMuted),
        labelStyle: AppText.label,
        floatingLabelStyle: AppText.label.copyWith(color: AppColors.primary),
        errorStyle: AppText.bodySmall.copyWith(color: AppColors.danger, fontWeight: FontWeight.w600),
        border: const OutlineInputBorder(borderRadius: Corners.brMd, borderSide: Strokes.hairline),
        enabledBorder: const OutlineInputBorder(borderRadius: Corners.brMd, borderSide: Strokes.hairline),
        focusedBorder: const OutlineInputBorder(borderRadius: Corners.brMd, borderSide: Strokes.focus),
        errorBorder: const OutlineInputBorder(borderRadius: Corners.brMd, borderSide: Strokes.error),
        focusedErrorBorder: const OutlineInputBorder(borderRadius: Corners.brMd, borderSide: Strokes.error),
        disabledBorder: OutlineInputBorder(
          borderRadius: Corners.brMd,
          borderSide: BorderSide(color: AppColors.stroke.withValues(alpha: 0.6)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: Corners.sheet),
        showDragHandle: true,
        dragHandleColor: AppColors.strokeStrong,
        dragHandleSize: Size(40, 4),
        elevation: 0,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: Corners.brXl),
        titleTextStyle: AppText.titleLarge,
        contentTextStyle: AppText.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppText.bodyMedium.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: Corners.brMd),
        insetPadding: const EdgeInsets.all(Insets.lg),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMuted,
        side: const BorderSide(color: AppColors.stroke),
        labelStyle: AppText.bodySmall.copyWith(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
        shape: const RoundedRectangleBorder(borderRadius: Corners.pill),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.transparent : AppColors.strokeStrong,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.transparent,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: AppColors.strokeStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : AppColors.strokeStrong,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceSunken,
        thumbColor: Colors.white,
        overlayColor: Color(0x1FC21784),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceSunken,
        circularTrackColor: AppColors.surfaceSunken,
      ),
      tabBarTheme: TabBarThemeData(
        labelStyle: AppText.titleSmall,
        unselectedLabelStyle: AppText.titleSmall.copyWith(fontWeight: FontWeight.w600),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textMuted,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.stroke,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: AppColors.textPrimary, borderRadius: Corners.brSm),
        textStyle: AppText.bodySmall.copyWith(color: Colors.white),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: Color(0x33C21784),
        selectionHandleColor: AppColors.primary,
      ),
    );
  }

  const AppTheme._();
}
