import 'package:flutter/widgets.dart';

import '../../config/feature_flags.dart';
import '../models/ui_action.dart';
import '../models/ui_node.dart';
import 'dynamic_form_controller.dart';

typedef UiActionHandler = void Function(BuildContext context, UiAction action, UiNode node);

class DynamicUiScope {
  DynamicUiScope({
    required this.flags,
    required this.form,
    required this.onAction,
    Map<String, Object?> data = const {},
    this.busyFields = const {},
  }) : data = {...data};

  final FeatureFlags flags;
  final DynamicFormController form;
  final UiActionHandler onAction;

  final Map<String, Object?> data;

  final Set<String> busyFields;

  bool isBusy(String key) => busyFields.contains(key);

  bool isVisible(UiNode node) =>
      node.visibleWhen == null ||
      node.visibleWhen!.evaluate(isFlagEnabled: flags.isEnabled, valueOf: _lookup);

  bool isEnabled(UiNode node) =>
      node.enabledWhen == null ||
      node.enabledWhen!.evaluate(isFlagEnabled: flags.isEnabled, valueOf: _lookup);

  List<UiNode> visibleChildren(UiNode node) =>
      node.children.where(isVisible).toList(growable: false);

  Object? _lookup(String key) => form.valueOf(key) ?? resolvePath(key);

  Object? resolvePath(String path) {
    Object? current = data;
    for (final segment in path.split('.')) {
      if (current is Map) {
        current = current[segment];
      } else {
        return null;
      }
    }
    return current;
  }

  String interpolate(String? input) {
    if (input == null || input.isEmpty || !input.contains('{{')) return input ?? '';
    return input.replaceAllMapped(RegExp(r'\{\{\s*([\w.]+)\s*\}\}'), (m) {
      final String key = m.group(1)!;
      final Object? value = form.valueOf(key) ?? resolvePath(key);
      return value?.toString() ?? '';
    });
  }

  DynamicUiScope copyWith({Map<String, Object?>? data}) => DynamicUiScope(
        flags: flags,
        form: form,
        onAction: onAction,
        data: data ?? this.data,
      );
}

class DynamicUiProvider extends InheritedWidget {
  const DynamicUiProvider({required this.scope, required super.child, super.key});

  final DynamicUiScope scope;

  static DynamicUiScope of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DynamicUiProvider>();
    assert(provider != null, 'No DynamicUiProvider found in the widget tree.');
    return provider!.scope;
  }

  static DynamicUiScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DynamicUiProvider>()?.scope;

  @override
  bool updateShouldNotify(DynamicUiProvider oldWidget) => oldWidget.scope != scope;
}
