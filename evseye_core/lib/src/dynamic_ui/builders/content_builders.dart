import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gauges.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/list_tiles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/step_progress.dart';
import '../registry/widget_registry.dart';
import 'node_utils.dart';

Map<String, NodeBuilder> contentBuilders(WidgetRegistry r) => {
      'text': (context, node, scope) => Text(
            node.text(scope, 'text'),
            textAlign: NodeTokens.textAlign(node.props['align'] as String?),
            maxLines: (node.props['maxLines'] as num?)?.toInt(),
            overflow: node.props['maxLines'] == null ? null : TextOverflow.ellipsis,
            style: NodeTokens.textStyle(node.props['style'] as String?).copyWith(
              color: node.props['color'] == null
                  ? null
                  : NodeTokens.color(node.props['color'] as String?),
              fontSize: (node.props['size'] as num?)?.toDouble(),
            ),
          ),
      'heading': (context, node, scope) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                node.text(scope, 'title'),
                style: NodeTokens.textStyle(node.props['style'] as String? ?? 'displaySmall'),
              ),
              if (node.props['subtitle'] != null) ...[
                const SizedBox(height: Insets.sm),
                Text(
                  node.text(scope, 'subtitle'),
                  style: AppText.bodyMedium.copyWith(height: 1.55),
                ),
              ],
            ],
          ),
      'icon': (context, node, scope) => Icon(
            NodeTokens.icon(node.props['icon'] as String?),
            size: (node.props['size'] as num?)?.toDouble() ?? 22,
            color: NodeTokens.color(node.props['color'] as String?, fallback: AppColors.primary),
          ),
      'image': (context, node, scope) {
        final String src = node.text(scope, 'src');
        final BoxFit fit = node.props['fit'] == 'cover' ? BoxFit.cover : BoxFit.contain;
        final double? h = (node.props['height'] as num?)?.toDouble();
        final Widget img = src.startsWith('http')
            ? Image.network(src, fit: fit, height: h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink())
            : Image.asset(src, fit: fit, height: h,
                errorBuilder: (_, __, ___) => const SizedBox.shrink());
        return ClipRRect(borderRadius: Corners.brMd, child: img);
      },
      'illustration': (context, node, scope) => Center(
            child: Container(
              width: (node.props['size'] as num?)?.toDouble() ?? 96,
              height: (node.props['size'] as num?)?.toDouble() ?? 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.washFor(
                  NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary),
                ),
                border: Border.all(
                  color: NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary)
                      .withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                NodeTokens.icon(node.props['icon'] as String?),
                size: ((node.props['size'] as num?)?.toDouble() ?? 96) * 0.38,
                color: NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary),
              ),
            ),
          ),
      'banner': (context, node, scope) {
        final Color tone =
            NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary);
        return AccentCard(
          accent: tone,
          onTap: node.action == null ? null : () => scope.onAction(context, node.action!, node),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                NodeTokens.icon(node.props['icon'] as String?, fallback: Icons.info_outline_rounded),
                size: 19,
                color: tone,
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (node.props['title'] != null)
                      Text(
                        node.text(scope, 'title'),
                        style: AppText.titleSmall.copyWith(fontSize: 13.5, color: tone),
                      ),
                    if (node.props['message'] != null) ...[
                      if (node.props['title'] != null) const SizedBox(height: 3),
                      Text(
                        node.text(scope, 'message'),
                        style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.45),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
      'chip': (context, node, scope) => StatusChip(
            label: node.text(scope, 'label'),
            tone: switch (node.props['tone'] as String?) {
              'success' => StatusTone.success,
              'warning' => StatusTone.warning,
              'danger' => StatusTone.danger,
              'info' => StatusTone.info,
              'brand' => StatusTone.brand,
              _ => StatusTone.neutral,
            },
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
          ),
      'statCard': (context, node, scope) => StatCard(
            label: node.text(scope, 'label'),
            value: node.text(scope, 'value'),
            caption: node.props['caption'] == null ? null : node.text(scope, 'caption'),
            delta: node.props['delta'] == null ? null : node.text(scope, 'delta'),
            deltaPositive: node.props['deltaPositive'] as bool? ?? true,
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            accent: NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.primary),
            compact: node.props['compact'] as bool? ?? false,
            onTap: node.action == null ? null : () => scope.onAction(context, node.action!, node),
          ),
      'heroStat': (context, node, scope) => HeroStatCard(
            label: node.text(scope, 'label'),
            value: node.text(scope, 'value'),
            caption: node.props['caption'] == null ? null : node.text(scope, 'caption'),
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            onTap: node.action == null ? null : () => scope.onAction(context, node.action!, node),
          ),
      'keyValue': (context, node, scope) => KeyValueRow(
            label: node.text(scope, 'label'),
            value: node.text(scope, 'value'),
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            valueColor: node.props['valueColor'] == null
                ? null
                : NodeTokens.color(node.props['valueColor'] as String?),
          ),
      'navTile': (context, node, scope) => AppNavTile(
            title: node.text(scope, 'title'),
            subtitle: node.props['subtitle'] == null ? null : node.text(scope, 'subtitle'),
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            iconColor: node.props['tone'] == null
                ? null
                : NodeTokens.color(node.props['tone'] as String?),
            badge: node.props['badge'] == null ? null : node.text(scope, 'badge'),
            destructive: node.props['destructive'] as bool? ?? false,
            onTap: node.action == null ? null : () => scope.onAction(context, node.action!, node),
          ),
      'progress': (context, node, scope) => LabeledProgress(
            value: (node.props['value'] as num?)?.toDouble() ?? 0,
            label: node.props['label'] == null ? null : node.text(scope, 'label'),
            trailingLabel:
                node.props['trailingLabel'] == null ? null : node.text(scope, 'trailingLabel'),
            color: NodeTokens.color(node.props['tone'] as String?, fallback: AppColors.cyan),
          ),
      'ringGauge': (context, node, scope) => Center(
            child: RingGauge(
              value: (node.props['value'] as num?)?.toDouble() ?? 0,
              size: (node.props['size'] as num?)?.toDouble() ?? 120,
              label: node.props['label'] == null ? null : node.text(scope, 'label'),
              centerText:
                  node.props['centerText'] == null ? null : node.text(scope, 'centerText'),
              icon: node.props['icon'] == null
                  ? null
                  : NodeTokens.icon(node.props['icon'] as String?),
            ),
          ),
      'emptyState': (context, node, scope) => EmptyState(
            title: node.text(scope, 'title'),
            message: node.props['message'] == null ? null : node.text(scope, 'message'),
            icon: NodeTokens.icon(node.props['icon'] as String?, fallback: Icons.inbox_rounded),
            actionLabel: node.props['actionLabel'] as String?,
            compact: node.props['compact'] as bool? ?? false,
            onAction: node.action == null ? null : () => scope.onAction(context, node.action!, node),
          ),
      'bulletList': (context, node, scope) {
        final List<dynamic> items = node.props['items'] as List<dynamic>? ?? const [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: spaced(
            items.map((item) {
              final Map<String, dynamic> m = item is Map
                  ? Map<String, dynamic>.from(item)
                  : {'text': item.toString()};
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: NodeTokens.color(m['tone'] as String?, fallback: AppColors.cyan),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Text(
                      scope.interpolate(m['text']?.toString()),
                      style: AppText.bodyMedium.copyWith(fontSize: 13.5, height: 1.5),
                    ),
                  ),
                ],
              );
            }).toList(),
            Insets.md,
          ),
        );
      },
      'termsBlock': (context, node, scope) => GlassCard(
            padding: const EdgeInsets.all(Insets.lg),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (node.props['maxHeight'] as num?)?.toDouble() ?? 220,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    node.text(scope, 'body'),
                    style: AppText.bodySmall.copyWith(fontSize: 12.5, height: 1.65),
                  ),
                ),
              ),
            ),
          ),
      'primaryButton': (context, node, scope) => PrimaryButton(
            label: node.text(scope, 'label', 'Continue'),
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            expand: node.props['expand'] as bool? ?? true,
            onPressed: !scope.isEnabled(node) || node.action == null
                ? null
                : () => scope.onAction(context, node.action!, node),
          ),
      'secondaryButton': (context, node, scope) => SecondaryButton(
            label: node.text(scope, 'label'),
            icon: node.props['icon'] == null
                ? null
                : NodeTokens.icon(node.props['icon'] as String?),
            expand: node.props['expand'] as bool? ?? true,
            onPressed: node.action == null
                ? null
                : () => scope.onAction(context, node.action!, node),
          ),
      'ghostButton': (context, node, scope) => Align(
            alignment: Alignment.center,
            child: GhostButton(
              label: node.text(scope, 'label'),
              icon: node.props['icon'] == null
                  ? null
                  : NodeTokens.icon(node.props['icon'] as String?),
              onPressed:
                  node.action == null ? null : () => scope.onAction(context, node.action!, node),
            ),
          ),
    };
