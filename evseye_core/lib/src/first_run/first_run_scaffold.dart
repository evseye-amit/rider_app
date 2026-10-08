import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import '../widgets/illustrations.dart';

class FirstRunScaffold extends StatelessWidget {
  const FirstRunScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Insets.gutter, Insets.xxl, Insets.gutter, Insets.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTile(icon: icon, size: 52, solid: true),
                  const SizedBox(height: Insets.lg),
                  Text(title, style: AppText.displaySmall.copyWith(fontSize: 25, letterSpacing: -0.6)),
                  const SizedBox(height: Insets.sm),
                  Text(subtitle, style: AppText.bodyMedium.copyWith(height: 1.55, fontSize: 13.5)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
                child: body,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Insets.gutter,
                Insets.lg,
                Insets.gutter,
                Insets.lg + MediaQuery.paddingOf(context).bottom,
              ),
              child: footer,
            ),
          ],
        ),
      ),
    );
  }
}
