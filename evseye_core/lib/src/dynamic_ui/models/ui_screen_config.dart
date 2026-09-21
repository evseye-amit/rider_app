import 'package:equatable/equatable.dart';

import 'ui_node.dart';

class UiScreenConfig extends Equatable {
  const UiScreenConfig({
    required this.id,
    this.version = 1,
    this.title,
    this.subtitle,
    this.scrollable = true,
    this.showAppBar = true,
    this.showBackButton = true,
    this.background,
    this.body = const [],
    this.footer = const [],
    this.meta = const {},
  });

  final String id;
  final int version;
  final String? title;
  final String? subtitle;
  final bool scrollable;
  final bool showAppBar;
  final bool showBackButton;

  final String? background;

  final List<UiNode> body;

  final List<UiNode> footer;

  final Map<String, dynamic> meta;

  factory UiScreenConfig.fromJson(Map<String, dynamic> json) => UiScreenConfig(
        id: json['id'] as String,
        version: json['version'] as int? ?? 1,
        title: json['title'] as String?,
        subtitle: json['subtitle'] as String?,
        scrollable: json['scrollable'] as bool? ?? true,
        showAppBar: json['showAppBar'] as bool? ?? true,
        showBackButton: json['showBackButton'] as bool? ?? true,
        background: json['background'] as String?,
        body: _nodes(json['body']),
        footer: _nodes(json['footer']),
        meta: Map<String, dynamic>.from(json['meta'] as Map? ?? const {}),
      );

  static List<UiNode> _nodes(Object? raw) => (raw as List<dynamic>? ?? const [])
      .map((e) => UiNode.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(growable: false);

  @override
  List<Object?> get props => [id, version, title, subtitle, body, footer, meta];
}

class UiFlowConfig extends Equatable {
  const UiFlowConfig({
    required this.id,
    this.title,
    this.steps = const [],
    this.meta = const {},
  });

  final String id;
  final String? title;
  final List<UiFlowStep> steps;
  final Map<String, dynamic> meta;

  factory UiFlowConfig.fromJson(Map<String, dynamic> json) => UiFlowConfig(
        id: json['id'] as String,
        title: json['title'] as String?,
        steps: (json['steps'] as List<dynamic>? ?? const [])
            .map((e) => UiFlowStep.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(growable: false),
        meta: Map<String, dynamic>.from(json['meta'] as Map? ?? const {}),
      );

  @override
  List<Object?> get props => [id, title, steps];
}

class UiFlowStep extends Equatable {
  const UiFlowStep({
    required this.key,
    required this.label,
    required this.screen,
    this.shortLabel,
    this.icon,
    this.skippable = false,
  });

  final String key;
  final String label;
  final String? shortLabel;
  final String? icon;
  final bool skippable;
  final UiScreenConfig screen;

  factory UiFlowStep.fromJson(Map<String, dynamic> json) => UiFlowStep(
        key: json['key'] as String,
        label: json['label'] as String? ?? '',
        shortLabel: json['shortLabel'] as String?,
        icon: json['icon'] as String?,
        skippable: json['skippable'] as bool? ?? false,
        screen: UiScreenConfig.fromJson(Map<String, dynamic>.from(json['screen'] as Map)),
      );

  @override
  List<Object?> get props => [key, label, shortLabel, icon, skippable, screen];
}
