import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'gradient_background.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.leading,
    this.showBack = true,
    this.onBack,
    this.footer,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.padding,
    this.showBlooms = true,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.centerTitle = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;

  final Widget? footer;

  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final EdgeInsetsGeometry? padding;
  final bool showBlooms;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final bool hasAppBar = title != null || showBack || actions.isNotEmpty || leading != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: drawer,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: GradientBackground(
        showBlooms: showBlooms,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              if (hasAppBar)
                AppTopBar(
                  title: title,
                  subtitle: subtitle,
                  actions: actions,
                  leading: leading,
                  showBack: showBack,
                  onBack: onBack,
                  centerTitle: centerTitle,
                ),
              Expanded(
                child: padding == null
                    ? body
                    : Padding(padding: padding!, child: body),
              ),
              if (footer != null)
                Container(
                  padding: EdgeInsets.fromLTRB(
                    Insets.gutter,
                    Insets.md,
                    Insets.gutter,
                    MediaQuery.paddingOf(context).bottom + Insets.md,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.canvas,
                    border: Border(top: BorderSide(color: AppColors.stroke)),
                  ),
                  child: footer,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    this.title,
    this.subtitle,
    this.actions = const [],
    this.leading,
    this.showBack = true,
    this.onBack,
    this.centerTitle = false,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;
  final bool showBack;
  final VoidCallback? onBack;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final Widget? titleBlock = title == null
        ? null
        : Column(
            crossAxisAlignment:
                centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.titleLarge.copyWith(fontSize: 19),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ],
          );

    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.md, Insets.md, Insets.gutter, Insets.md),
      child: Row(
        children: [
          if (leading != null)
            leading!
          else if (showBack)
            CircleIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
            ),
          if (leading != null || showBack) const SizedBox(width: Insets.md),
          if (titleBlock != null) Expanded(child: titleBlock) else const Spacer(),
          for (final action in actions) ...[const SizedBox(width: Insets.sm), action],
        ],
      ),
    );
  }
}

class PageBody extends StatelessWidget {
  const PageBody({
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: Insets.gutter),
    this.bottomPadding = Insets.x4l,
    this.controller,
    this.physics,
    super.key,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double bottomPadding;
  final ScrollController? controller;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: padding.add(EdgeInsets.only(bottom: bottomPadding)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  const Gap.xs({super.key}) : size = Insets.xs;
  const Gap.sm({super.key}) : size = Insets.sm;
  const Gap.md({super.key}) : size = Insets.md;
  const Gap.lg({super.key}) : size = Insets.lg;
  const Gap.xl({super.key}) : size = Insets.xl;
  const Gap.xxl({super.key}) : size = Insets.xxl;
  const Gap.x3l({super.key}) : size = Insets.x3l;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size, width: size);
}
