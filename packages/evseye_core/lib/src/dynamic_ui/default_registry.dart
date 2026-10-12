import 'builders/composite_builders.dart';
import 'builders/content_builders.dart';
import 'builders/input_builders.dart';
import 'builders/layout_builders.dart';
import 'registry/widget_registry.dart';

void registerDefaultWidgets([WidgetRegistry? registry]) {
  final WidgetRegistry r = registry ?? WidgetRegistry.instance;
  r
    ..registerAll(layoutBuilders(r))
    ..registerAll(contentBuilders(r))
    ..registerAll(inputBuilders(r))
    ..registerAll(compositeBuilders());
}
