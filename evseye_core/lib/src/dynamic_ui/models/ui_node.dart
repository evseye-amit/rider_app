import 'ui_action.dart';
import 'ui_condition.dart';
import 'validation_rule.dart';

class UiNode {
  const UiNode({
    required this.type,
    this.id,
    this.props = const {},
    this.children = const [],
    this.visibleWhen,
    this.enabledWhen,
    this.action,
    this.validations = const [],
    this.style = const {},
  });

  final String type;

  final String? id;

  final Map<String, dynamic> props;
  final List<UiNode> children;

  final UiCondition? visibleWhen;
  final UiCondition? enabledWhen;

  final UiAction? action;
  final List<ValidationRule> validations;

  final Map<String, dynamic> style;

  String get fieldKey => (props['key'] as String?) ?? id ?? type;

  T? prop<T>(String name, [T? fallback]) {
    final Object? v = props[name];
    if (v is T) return v;
    if (fallback != null) return fallback;
    return null;
  }

  String? get label => props['label'] as String?;

  factory UiNode.fromJson(Map<String, dynamic> json) => UiNode(
        type: json['type'] as String,
        id: json['id'] as String?,
        props: Map<String, dynamic>.from(json['props'] as Map? ?? const {}),
        children: (json['children'] as List<dynamic>? ?? const [])
            .map((e) => UiNode.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(growable: false),
        visibleWhen: json['visibleWhen'] == null
            ? null
            : UiCondition.fromJson(Map<String, dynamic>.from(json['visibleWhen'] as Map)),
        enabledWhen: json['enabledWhen'] == null
            ? null
            : UiCondition.fromJson(Map<String, dynamic>.from(json['enabledWhen'] as Map)),
        action: json['action'] == null
            ? null
            : UiAction.fromJson(Map<String, dynamic>.from(json['action'] as Map)),
        validations: (json['validations'] as List<dynamic>? ?? const [])
            .map((e) => ValidationRule.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(growable: false),
        style: Map<String, dynamic>.from(json['style'] as Map? ?? const {}),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        if (id != null) 'id': id,
        if (props.isNotEmpty) 'props': props,
        if (children.isNotEmpty) 'children': children.map((c) => c.toJson()).toList(),
        if (action != null) 'action': action!.toJson(),
        if (validations.isNotEmpty) 'validations': validations.map((v) => v.toJson()).toList(),
        if (style.isNotEmpty) 'style': style,
      };
}
