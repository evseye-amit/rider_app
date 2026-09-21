import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_typography.dart';
import '../../widgets/capture_tiles.dart';
import '../../widgets/date_wheel.dart';
import '../../widgets/feedback.dart';
import '../../widgets/inputs.dart';
import '../models/ui_action.dart';
import '../models/ui_node.dart';
import '../registry/dynamic_ui_scope.dart';
import '../registry/widget_registry.dart';
import 'node_utils.dart';

Map<String, NodeBuilder> inputBuilders(WidgetRegistry r) => {
      'textField': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => AppTextField(
              label: node.text(scope, 'label'),
              hint: node.props['hint'] == null ? null : node.text(scope, 'hint'),
              helper: node.props['helper'] == null ? null : node.text(scope, 'helper'),
              errorText: error,
              enabled: enabled,
              initialValue: value,
              required: _isRequired(node),
              maxLines: (node.props['maxLines'] as num?)?.toInt() ?? 1,
              maxLength: (node.props['maxLength'] as num?)?.toInt(),
              prefixText: node.props['prefixText'] as String?,
              prefixIcon: node.props['icon'] == null
                  ? null
                  : NodeTokens.icon(node.props['icon'] as String?),
              keyboardType: _keyboard(node.props['keyboard'] as String?),
              textCapitalization: node.props['caps'] == true
                  ? TextCapitalization.characters
                  : TextCapitalization.words,
              inputFormatters: _formatters(node),
              onChanged: (v) => scope.form.setValue(key, v),
            ),
          ),
      'pickerField': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => AppPickerField(
              label: node.text(scope, 'label'),
              hint: node.props['hint'] == null ? null : node.text(scope, 'hint'),
              helper: node.props['helper'] == null ? null : node.text(scope, 'helper'),
              value: value,
              errorText: error,
              enabled: enabled,
              required: _isRequired(node),
              prefixIcon: node.props['icon'] == null
                  ? null
                  : NodeTokens.icon(node.props['icon'] as String?),
              onTap: () => _openOptions(context, node, scope, key),
            ),
          ),
      'dateField': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => AppPickerField(
              label: node.text(scope, 'label'),
              hint: node.props['hint'] as String? ?? 'DD / MM / YYYY',
              helper: node.props['helper'] == null ? null : node.text(scope, 'helper'),
              value: value == null || value.isEmpty ? null : _prettyDate(value),
              errorText: error,
              enabled: enabled,
              required: _isRequired(node),
              icon: Icons.calendar_today_rounded,
              prefixIcon: _dateIcon(node),
              onTap: () async {
                final DateTime now = DateTime.now();
                final DateTime today = DateTime(now.year, now.month, now.day);
                final bool future = node.props['future'] == true;
                final DateTime first = _dateProp(node, 'minDate') ??
                    (future ? today.add(const Duration(days: 1)) : DateTime(now.year - 80));
                final DateTime last = _dateProp(node, 'maxDate') ??
                    (future ? DateTime(now.year + 30) : today);
                final DateTime? picked = await AppDateWheel.show(
                  context,
                  first: first,
                  last: last,
                  initial: DateTime.tryParse(value ?? '') ??
                      (future ? first : DateTime(now.year - 22, now.month, now.day)),
                  title: node.text(scope, 'label').isEmpty
                      ? 'Select a date'
                      : node.text(scope, 'label'),
                );
                if (picked != null) {
                  scope.form.setValue(key, picked.toIso8601String().split('T').first);
                }
              },
            ),
          ),
      'checkbox': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => AppCheckTile(
              value: scope.form.boolOf(key),
              title: node.text(scope, 'label'),
              subtitle: node.props['subtitle'] == null ? null : node.text(scope, 'subtitle'),
              errorText: error,
              onChanged: (v) => scope.form.setValue(key, v),
            ),
          ),
      'switchTile': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => Container(
              padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.6),
                borderRadius: Corners.brMd,
                border: Border.all(color: AppColors.stroke),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(node.text(scope, 'label'), style: AppText.titleSmall.copyWith(fontSize: 14)),
                        if (node.props['subtitle'] != null) ...[
                          const SizedBox(height: 2),
                          Text(node.text(scope, 'subtitle'),
                              style: AppText.bodySmall.copyWith(fontSize: 11.5)),
                        ],
                      ],
                    ),
                  ),
                  Switch(
                    value: scope.form.boolOf(key),
                    onChanged: (v) => scope.form.setValue(key, v),
                  ),
                ],
              ),
            ),
          ),
      'radioGroup': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) {
              final List<_Option> options = _options(node, scope);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (node.props['label'] != null) ...[
                    Text(node.text(scope, 'label'), style: AppText.label),
                    const SizedBox(height: Insets.md),
                  ],
                  ...spaced(
                    options
                        .map(
                          (o) => AppRadioTile(
                            selected: value == o.value,
                            title: o.label,
                            subtitle: o.subtitle,
                            badge: o.badge,
                            trailing: o.trailing == null
                                ? null
                                : Text(o.trailing!, style: AppText.numericSmall.copyWith(fontSize: 15)),
                            onTap: () => scope.form.setValue(key, o.value),
                          ),
                        )
                        .toList(),
                    Insets.md,
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: Insets.sm),
                      child: Text(error,
                          style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12)),
                    ),
                ],
              );
            },
          ),
      'otpField': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OtpInput(
                  length: (node.props['length'] as num?)?.toInt() ?? 6,
                  hasError: error != null,
                  onChanged: (v) => scope.form.setValue(key, v),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Insets.md),
                    child: Text(error,
                        style: AppText.bodySmall.copyWith(color: AppColors.danger, fontSize: 12)),
                  ),
              ],
            ),
          ),
      'upload': (context, node, scope) => _Field(
            node: node,
            scope: scope,
            builder: (key, value, error, enabled) => UploadTile(
              label: node.text(scope, 'label'),
              hint: node.props['hint'] == null ? null : node.text(scope, 'hint'),
              required: _isRequired(node),

              state: scope.isBusy(key)
                  ? UploadState.uploading
                  : (value == null || value.isEmpty
                      ? UploadState.empty
                      : UploadState.uploaded),
              fileName: value,
              rejectReason: error,
              onRemove: () => scope.form.setValue(key, null),

              onTap: () => scope.onAction(
                context,
                node.action ?? const UiAction(type: 'pickFile'),
                node,
              ),
            ),
          ),
      'photoGrid': (context, node, scope) {
        final List<_Option> slots = _options(node, scope, key: 'slots');
        final int columns = (node.props['columns'] as num?)?.toInt() ?? 3;
        return ListenableBuilder(
          listenable: scope.form,
          builder: (context, _) => GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: Insets.md,
            mainAxisSpacing: Insets.md,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: slots
                .map(
                  (s) => PhotoSlot(
                    label: s.label,
                    captured: scope.form.boolOf('${node.fieldKey}.${s.value}'),
                    icon: s.icon == null ? Icons.photo_camera_rounded : NodeTokens.icon(s.icon),
                    onTap: () {
                      scope.form.setValue('${node.fieldKey}.${s.value}', true);
                      AppSnack.success(context, '${s.label} captured');
                    },
                    onRetake: () => scope.form.setValue('${node.fieldKey}.${s.value}', false),
                  ),
                )
                .toList(),
          ),
        );
      },
    };


DateTime? _dateProp(UiNode node, String key) {
  final Object? raw = node.props[key];
  return raw == null ? null : DateTime.tryParse(raw.toString());
}

IconData _dateIcon(UiNode node) =>
    node.props['future'] == true ? Icons.event_available_rounded : Icons.cake_rounded;

class _Field extends StatelessWidget {
  const _Field({required this.node, required this.scope, required this.builder});

  final UiNode node;
  final DynamicUiScope scope;
  final Widget Function(String key, String? value, String? error, bool enabled) builder;

  @override
  Widget build(BuildContext context) {
    final String key = node.fieldKey;
    return ListenableBuilder(
      listenable: scope.form,
      builder: (context, _) {
        final Object? raw = scope.form.valueOf(key);
        return builder(
          key,
          raw?.toString(),
          scope.form.errorOf(key),
          scope.isEnabled(node),
        );
      },
    );
  }
}

class _Option {
  const _Option(this.value, this.label, {this.subtitle, this.badge, this.trailing, this.icon});

  final String value;
  final String label;
  final String? subtitle;
  final String? badge;
  final String? trailing;
  final String? icon;
}

List<_Option> _options(UiNode node, DynamicUiScope scope, {String key = 'options'}) {
  final List<dynamic> raw = node.props[key] as List<dynamic>? ?? const [];
  return raw.map((e) {
    if (e is Map) {
      final m = Map<String, dynamic>.from(e);
      return _Option(
        m['value']?.toString() ?? m['label'].toString(),
        scope.interpolate(m['label']?.toString()),
        subtitle: m['subtitle'] == null ? null : scope.interpolate(m['subtitle'].toString()),
        badge: m['badge'] as String?,
        trailing: m['trailing'] == null ? null : scope.interpolate(m['trailing'].toString()),
        icon: m['icon'] as String?,
      );
    }
    return _Option(e.toString(), e.toString());
  }).toList(growable: false);
}

Future<void> _openOptions(
  BuildContext context,
  UiNode node,
  DynamicUiScope scope,
  String key,
) async {
  final List<_Option> options = _options(node, scope);
  if (options.isEmpty) return;
  final String? picked = await AppSheet.show<String>(
    context,
    title: node.text(scope, 'label', 'Select'),
    child: Column(
      children: spaced(
        options
            .map(
              (o) => AppRadioTile(
                selected: scope.form.stringOf(key) == o.value,
                title: o.label,
                subtitle: o.subtitle,
                onTap: () => Navigator.of(context).pop(o.value),
              ),
            )
            .toList(),
        Insets.sm + 2,
      ),
    ),
  );
  if (picked != null) scope.form.setValue(key, picked);
}

bool _isRequired(UiNode node) =>
    node.props['required'] == true || node.validations.any((v) => v.type == 'required');

TextInputType? _keyboard(String? name) => switch (name) {
      'number' => TextInputType.number,
      'phone' => TextInputType.phone,
      'email' => TextInputType.emailAddress,
      'multiline' => TextInputType.multiline,
      'name' => TextInputType.name,
      _ => null,
    };

List<TextInputFormatter>? _formatters(UiNode node) {
  final List<TextInputFormatter> out = [];
  if (node.props['keyboard'] == 'number' || node.props['keyboard'] == 'phone') {
    out.add(FilteringTextInputFormatter.digitsOnly);
  }
  if (node.props['caps'] == true) {
    out.add(TextInputFormatter.withFunction(
      (_, next) => next.copyWith(text: next.text.toUpperCase()),
    ));
  }
  final int? max = (node.props['maxLength'] as num?)?.toInt();
  if (max != null) out.add(LengthLimitingTextInputFormatter(max));
  return out.isEmpty ? null : out;
}

String _prettyDate(String iso) {
  final DateTime? d = DateTime.tryParse(iso);
  if (d == null) return iso;
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
}
