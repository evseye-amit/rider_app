import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'section_header.dart';

abstract final class AppSnack {
  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    Color tone = AppColors.primary,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          behavior: SnackBarBehavior.floating,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md + 2),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: Corners.brMd,
              boxShadow: Shadows.raised,
            ),
            child: Row(
              children: [
                Icon(icon ?? Icons.info_rounded, size: 19, color: _onInk(tone)),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Text(
                    message,
                    style: AppText.bodyMedium.copyWith(color: Colors.white, fontSize: 13.5),
                  ),
                ),
                if (actionLabel != null)
                  GhostButton(label: actionLabel, onPressed: onAction, dense: true, color: AppColors.primaryBright),
              ],
            ),
          ),
        ),
      );
  }

  static Color _onInk(Color tone) => switch (tone) {
        AppColors.success => const Color(0xFF4ADE80),
        AppColors.danger => const Color(0xFFFF8A94),
        AppColors.warning => const Color(0xFFFFC969),
        _ => const Color(0xFF7FB8FF),
      };

  static void success(BuildContext context, String message) =>
      show(context, message, icon: Icons.check_circle_rounded, tone: AppColors.success);

  static void error(BuildContext context, String message) =>
      show(context, message, icon: Icons.error_rounded, tone: AppColors.danger);

  static void warning(BuildContext context, String message) =>
      show(context, message, icon: Icons.warning_rounded, tone: AppColors.warning);

  static void info(BuildContext context, String message) =>
      show(context, message, icon: Icons.info_rounded, tone: AppColors.primary);
}

class AppSheet extends StatelessWidget {
  const AppSheet({
    required this.title,
    required this.child,
    this.subtitle,
    this.footer,
    this.maxHeightFactor = 0.82,
    this.showClose = true,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final double maxHeightFactor;
  final bool showClose;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
    String? subtitle,
    Widget? footer,
    double maxHeightFactor = 0.82,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (_) => AppSheet(
        title: title,
        subtitle: subtitle,
        footer: footer,
        maxHeightFactor: maxHeightFactor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: Corners.sheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: Insets.md),
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(color: AppColors.strokeStrong, borderRadius: Corners.pill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.xl, Insets.md, Insets.lg),
            child: Row(
              children: [
                Expanded(child: SectionHeader(title: title, subtitle: subtitle)),
                if (showClose)
                  CircleIconButton(
                    icon: Icons.close_rounded,
                    size: 36,
                    iconSize: 18,
                    onTap: () => Navigator.of(context).pop(),
                  ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
              physics: const BouncingScrollPhysics(),
              child: child,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              Insets.gutter,
              Insets.lg,
              Insets.gutter,
              MediaQuery.paddingOf(context).bottom + Insets.lg,
            ),
            child: footer ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

abstract final class AppDialog {
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    IconData icon = Icons.help_rounded,
    Color tone = AppColors.primary,
    bool destructive = false,
  }) async {
    final Color accent = destructive ? AppColors.danger : tone;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: Insets.xxl),
        child: Container(
          padding: const EdgeInsets.all(Insets.xxl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: Corners.brXl,
            boxShadow: Shadows.raised,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.washFor(accent),
                ),
                child: Icon(icon, size: 28, color: accent),
              ),
              const SizedBox(height: Insets.xl),
              Text(title, textAlign: TextAlign.center, style: AppText.titleLarge),
              const SizedBox(height: Insets.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.bodyMedium.copyWith(fontSize: 13.5),
              ),
              const SizedBox(height: Insets.xxl),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: cancelLabel,
                      size: AppButtonSize.medium,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: PrimaryButton(
                      label: confirmLabel,
                      size: AppButtonSize.medium,
                      fillColor: destructive ? AppColors.danger : null,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas.withValues(alpha: 0.82),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(strokeWidth: 3, color: AppColors.primary),
            ),
            if (message != null) ...[
              const SizedBox(height: Insets.lg),
              Text(message!, style: AppText.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
