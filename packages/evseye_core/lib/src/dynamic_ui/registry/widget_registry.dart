import 'package:flutter/material.dart';

import '../../theme/app_dimens.dart';
import '../models/ui_node.dart';
import 'dynamic_ui_scope.dart';

typedef NodeBuilder = Widget Function(BuildContext context, UiNode node, DynamicUiScope scope);

class WidgetRegistry {
  WidgetRegistry._();

  static final WidgetRegistry instance = WidgetRegistry._();

  final Map<String, NodeBuilder> _builders = {};
  NodeBuilder? _fallback;

  Iterable<String> get registeredTypes => _builders.keys;

  bool contains(String type) => _builders.containsKey(type);

  void register(String type, NodeBuilder builder) => _builders[type] = builder;

  void registerAll(Map<String, NodeBuilder> builders) => _builders.addAll(builders);

  void registerFallback(NodeBuilder builder) => _fallback = builder;

  Widget build(BuildContext context, UiNode node, DynamicUiScope scope) {
    if (!scope.isVisible(node)) return const SizedBox.shrink();
    final NodeBuilder? builder = _builders[node.type] ?? _fallback;
    if (builder == null) return _unknown(node);
    Widget child = builder(context, node, scope);
    return _applyStyle(child, node.style);
  }

  List<Widget> buildAll(BuildContext context, List<UiNode> nodes, DynamicUiScope scope) {
    final Set<String> seen = {};
    return nodes
        .where(scope.isVisible)
        .map((n) => keyed(n, build(context, n, scope), seen))
        .toList(growable: false);
  }

  static Widget keyed(UiNode node, Widget child, Set<String> seen) {
    final String? name = (node.props['key'] as String?) ?? node.id;
    if (name == null || !seen.add(name)) return child;
    return KeyedSubtree(key: ValueKey<String>('node:$name'), child: child);
  }

  Widget _applyStyle(Widget child, Map<String, dynamic> style) {
    if (style.isEmpty) return child;

    final double? width = _d(style['width']);
    final double? height = _d(style['height']);
    if (width != null || height != null) {
      child = SizedBox(width: width, height: height, child: child);
    }

    final EdgeInsets? padding = _edge(style['padding']);
    if (padding != null) child = Padding(padding: padding, child: child);

    final double? opacity = _d(style['opacity']);
    if (opacity != null) child = Opacity(opacity: opacity, child: child);

    final String? align = style['align'] as String?;
    if (align != null) child = Align(alignment: _alignment(align), child: child);

    final EdgeInsets? margin = _edge(style['margin']);
    if (margin != null) child = Padding(padding: margin, child: child);

    final int? flex = style['flex'] as int?;
    if (flex != null) child = Expanded(flex: flex, child: child);

    return child;
  }

  static Widget _unknown(UiNode node) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.xs),
        child: Text(
          'Unsupported component "${node.type}"',
          style: const TextStyle(color: Color(0xFF61809B), fontSize: 12),
        ),
      );

  static double? _d(Object? v) => v is num ? v.toDouble() : null;

  static EdgeInsets? _edge(Object? raw) {
    if (raw == null) return null;
    if (raw is num) return EdgeInsets.all(raw.toDouble());
    if (raw is List && raw.length == 2) {
      return EdgeInsets.symmetric(
        horizontal: (raw[0] as num).toDouble(),
        vertical: (raw[1] as num).toDouble(),
      );
    }
    if (raw is List && raw.length == 4) {
      return EdgeInsets.fromLTRB(
        (raw[0] as num).toDouble(),
        (raw[1] as num).toDouble(),
        (raw[2] as num).toDouble(),
        (raw[3] as num).toDouble(),
      );
    }
    if (raw is Map) {
      return EdgeInsets.only(
        left: _d(raw['left']) ?? 0,
        top: _d(raw['top']) ?? 0,
        right: _d(raw['right']) ?? 0,
        bottom: _d(raw['bottom']) ?? 0,
      );
    }
    return null;
  }

  static Alignment _alignment(String v) => switch (v) {
        'topLeft' => Alignment.topLeft,
        'topCenter' => Alignment.topCenter,
        'topRight' => Alignment.topRight,
        'centerLeft' => Alignment.centerLeft,
        'center' => Alignment.center,
        'centerRight' => Alignment.centerRight,
        'bottomLeft' => Alignment.bottomLeft,
        'bottomCenter' => Alignment.bottomCenter,
        'bottomRight' => Alignment.bottomRight,
        _ => Alignment.centerLeft,
      };
}
