import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../widgets/app_scaffold.dart';
import 'models/ui_node.dart';
import 'models/ui_screen_config.dart';
import 'registry/dynamic_ui_scope.dart';
import 'registry/widget_registry.dart';

class DynamicScreen extends StatelessWidget {
  const DynamicScreen({
    required this.config,
    required this.scope,
    this.registry,
    this.appBarActions = const [],
    this.leading,
    this.onBack,
    this.headerSlot,
    super.key,
  });

  final UiScreenConfig config;
  final DynamicUiScope scope;
  final WidgetRegistry? registry;
  final List<Widget> appBarActions;
  final Widget? leading;
  final VoidCallback? onBack;

  final Widget? headerSlot;

  WidgetRegistry get _registry => registry ?? WidgetRegistry.instance;

  @override
  Widget build(BuildContext context) {
    return DynamicUiProvider(
      scope: scope,
      child: AppScaffold(
        title: config.title == null ? null : scope.interpolate(config.title),
        subtitle: config.subtitle == null ? null : scope.interpolate(config.subtitle),
        showBack: config.showBackButton,
        onBack: onBack,
        leading: leading,
        actions: appBarActions,
        showBlooms: config.background != 'plain',
        footer: config.footer.isEmpty
            ? null
            : DynamicNodeList(
                nodes: config.footer,
                scope: scope,
                registry: _registry,
                gap: Insets.md,
              ),
        body: Column(
          children: [
            if (headerSlot != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(Insets.gutter, 0, Insets.gutter, Insets.lg),
                child: headerSlot!,
              ),
            Expanded(
              child: config.scrollable
                  ? PageBody(
                      children: [
                        DynamicNodeList(
                          nodes: config.body,
                          scope: scope,
                          registry: _registry,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Insets.gutter),
                      child: DynamicNodeList(
                        nodes: config.body,
                        scope: scope,
                        registry: _registry,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicNodeList extends StatelessWidget {
  const DynamicNodeList({
    required this.nodes,
    required this.scope,
    this.registry,
    this.gap = Insets.xl,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    super.key,
  });

  final List<UiNode> nodes;
  final DynamicUiScope scope;
  final WidgetRegistry? registry;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final WidgetRegistry r = registry ?? WidgetRegistry.instance;
    return ListenableBuilder(
      listenable: scope.form,
      builder: (context, _) {
        final List<Widget> children = [];
        final Set<String> seen = {};
        final visible = nodes.where(scope.isVisible).toList(growable: false);
        for (var i = 0; i < visible.length; i++) {
          children.add(WidgetRegistry.keyed(visible[i], r.build(context, visible[i], scope), seen));
          if (i != visible.length - 1) children.add(SizedBox(height: gap));
        }
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      },
    );
  }
}
