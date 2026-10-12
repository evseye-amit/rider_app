import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/section_header.dart';
import '../registry/widget_registry.dart';
import 'node_utils.dart';

Map<String, NodeBuilder> layoutBuilders(WidgetRegistry r) => {
      'column': (context, node, scope) => Column(
            crossAxisAlignment: NodeTokens.crossAxis(node.props['crossAxis'] as String?),
            mainAxisAlignment: NodeTokens.mainAxis(node.props['mainAxis'] as String?),
            mainAxisSize: node.props['expand'] == true ? MainAxisSize.max : MainAxisSize.min,
            children: spaced(
              r.buildAll(context, node.children, scope),
              gapOf(node),
            ),
          ),
      'row': (context, node, scope) => Row(
            crossAxisAlignment:
                NodeTokens.crossAxis(node.props['crossAxis'] as String? ?? 'center'),
            mainAxisAlignment: NodeTokens.mainAxis(node.props['mainAxis'] as String?),
            children: spaced(
              r.buildAll(context, node.children, scope),
              gapOf(node),
              axis: Axis.horizontal,
            ),
          ),
      'wrap': (context, node, scope) => Wrap(
            spacing: gapOf(node, Insets.sm),
            runSpacing: (node.props['runGap'] as num?)?.toDouble() ?? gapOf(node, Insets.sm),
            children: r.buildAll(context, node.children, scope),
          ),
      'stack': (context, node, scope) => Stack(
            alignment: Alignment.center,
            children: r.buildAll(context, node.children, scope),
          ),
      'grid': (context, node, scope) {
        final int columns = (node.props['columns'] as num?)?.toInt() ?? 2;
        final double gap = gapOf(node);
        final double ratio = (node.props['aspectRatio'] as num?)?.toDouble() ?? 1.45;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: gap,
          mainAxisSpacing: gap,
          childAspectRatio: ratio,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: r.buildAll(context, node.children, scope),
        );
      },
      'expanded': (context, node, scope) => Expanded(
            flex: (node.props['flex'] as num?)?.toInt() ?? 1,
            child: node.children.isEmpty
                ? const SizedBox.shrink()
                : r.build(context, node.children.first, scope),
          ),
      'spacer': (context, node, scope) => const Spacer(),
      'gap': (context, node, scope) => SizedBox(
            height: (node.props['size'] as num?)?.toDouble() ?? Insets.lg,
            width: (node.props['size'] as num?)?.toDouble() ?? Insets.lg,
          ),
      'divider': (context, node, scope) => Divider(
            height: (node.props['space'] as num?)?.toDouble() ?? Insets.xxl,
            color: AppColors.stroke.withValues(alpha: 0.7),
          ),
      'card': (context, node, scope) => GlassCard(
            padding: EdgeInsets.all((node.props['padding'] as num?)?.toDouble() ?? Insets.lg),
            onTap: node.action == null
                ? null
                : () => scope.onAction(context, node.action!, node),
            child: Column(
              crossAxisAlignment: NodeTokens.crossAxis(node.props['crossAxis'] as String?),
              mainAxisSize: MainAxisSize.min,
              children: spaced(r.buildAll(context, node.children, scope), gapOf(node)),
            ),
          ),
      'accentCard': (context, node, scope) => AccentCard(
            accent: NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary),
            onTap: node.action == null
                ? null
                : () => scope.onAction(context, node.action!, node),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: spaced(r.buildAll(context, node.children, scope), gapOf(node, Insets.sm)),
            ),
          ),
      'section': (context, node, scope) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SectionHeader(
                title: node.text(scope, 'title'),
                subtitle: node.props['subtitle'] == null ? null : node.text(scope, 'subtitle'),
                actionLabel: node.props['actionLabel'] as String?,
                onAction: node.action == null
                    ? null
                    : () => scope.onAction(context, node.action!, node),
              ),
              const SizedBox(height: Insets.lg),
              ...spaced(r.buildAll(context, node.children, scope), gapOf(node)),
            ],
          ),
      'group': (context, node, scope) {
        final String title = node.text(scope, 'title');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty) ...[
              GroupLabel(
                title,
                icon: node.props['icon'] == null
                    ? null
                    : NodeTokens.icon(node.props['icon'] as String?),
              ),
              const SizedBox(height: Insets.lg),
            ],
            ...spaced(r.buildAll(context, node.children, scope), gapOf(node, Insets.lg)),
          ],
        );
      },
    };
