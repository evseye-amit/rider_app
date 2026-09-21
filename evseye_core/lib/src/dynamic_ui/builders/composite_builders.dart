import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../../theme/app_typography.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/inputs.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/glass_card.dart';
import '../models/ui_node.dart';
import '../registry/dynamic_ui_scope.dart';
import '../registry/widget_registry.dart';
import 'node_utils.dart';

const List<String> kRelationOptions = [
  'Spouse',
  'Father',
  'Mother',
  'Son',
  'Daughter',
  'Brother',
  'Sister',
  'Friend',
  'Colleague',
  'Other',
];

Map<String, NodeBuilder> compositeBuilders() => {
      'bankAccountField': (context, node, scope) => _BankAccountField(node: node, scope: scope),
      'referenceField': (context, node, scope) => _ReferenceField(node: node, scope: scope),
      'nomineeField': (context, node, scope) => _NomineeField(node: node, scope: scope),
    };

Future<String?> showRelationPicker(BuildContext context, {String? selected}) async {
  final String? picked = await AppSheet.show<String>(
    context,
    title: 'Relationship',
    subtitle: 'How are they related to you?',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in kRelationOptions)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.sm),
            child: AppRadioTile(
              title: option,
              selected: option == selected,
              onTap: () => Navigator.of(context).pop(option),
            ),
          ),
        const Gap.sm(),
      ],
    ),
  );
  if (picked != 'Other') return picked;
  if (!context.mounted) return null;
  return _askCustomRelation(context);
}

Future<String?> _askCustomRelation(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  return AppSheet.show<String>(
    context,
    title: 'Other relationship',
    subtitle: 'Tell us how they are related to you',
    child: Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: AppTextField(
        label: 'Relationship',
        hint: 'e.g. Guardian',
        controller: controller,
        autofocus: true,
      ),
    ),
    footer: PrimaryButton(
      label: 'Save',
      icon: Icons.check_rounded,
      onPressed: () {
        final String text = controller.text.trim();
        if (text.isNotEmpty) Navigator.of(context).pop(text);
      },
    ),
  );
}

class _BankAccountField extends StatefulWidget {
  const _BankAccountField({required this.node, required this.scope});

  final UiNode node;
  final DynamicUiScope scope;

  @override
  State<_BankAccountField> createState() => _BankAccountFieldState();
}

class _BankAccountFieldState extends State<_BankAccountField> {
  late final TextEditingController _account = TextEditingController(
    text: widget.scope.form.valueOf(widget.node.fieldKey)?.toString() ?? '',
  );
  late final TextEditingController _confirm = TextEditingController(
    text: widget.scope.form.valueOf('${widget.node.fieldKey}__confirm')?.toString() ?? '',
  );

  @override
  void dispose() {
    _account.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? get _mismatch {
    final String a = _account.text.trim();
    final String b = _confirm.text.trim();
    if (a.isEmpty || b.isEmpty) return null;
    return a == b ? null : 'Account numbers do not match';
  }

  void _sync() {
    final String a = _account.text.trim();
    final String b = _confirm.text.trim();
    widget.scope.form.setValue(widget.node.fieldKey, a == b ? a : '');
    widget.scope.form.setValue('${widget.node.fieldKey}__confirm', b);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String label = widget.node.text(widget.scope, 'label', 'Bank account number');
    final String? error = widget.scope.form.errorOf(widget.node.fieldKey) ?? _mismatch;
    final bool matched = _account.text.trim().isNotEmpty && _mismatch == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: label,
          hint: 'Enter your account number',
          controller: _account,
          required: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          blockClipboard: true,
          onChanged: (_) => _sync(),
        ),
        const Gap.lg(),
        AppTextField(
          label: 'Confirm account number',
          hint: 'Type it again',
          controller: _confirm,
          required: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          blockClipboard: true,
          errorText: error,
          onChanged: (_) => _sync(),
        ),
        if (matched) ...[
          const Gap.sm(),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, size: 15, color: AppColors.success),
              const SizedBox(width: 4),
              Text(
                'Account numbers match',
                style: AppText.bodySmall.copyWith(fontSize: 11.5, color: AppColors.success),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ReferenceField extends StatefulWidget {
  const _ReferenceField({required this.node, required this.scope});

  final UiNode node;
  final DynamicUiScope scope;

  @override
  State<_ReferenceField> createState() => _ReferenceFieldState();
}

class _ReferenceEntry {
  _ReferenceEntry({this.name = '', this.mobile = '', this.relation = ''});

  factory _ReferenceEntry.fromJson(Map<String, dynamic> json) => _ReferenceEntry(
        name: json['name']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        relation: json['relation']?.toString() ?? '',
      );

  String name;
  String mobile;
  String relation;

  Map<String, String> toJson() => {'name': name, 'mobile': mobile, 'relation': relation};

  bool get isEmpty => name.trim().isEmpty && mobile.trim().isEmpty;
}

class _ReferenceFieldState extends State<_ReferenceField> {
  late final List<_ReferenceEntry> _entries = _decode();

  List<_ReferenceEntry> _decode() {
    final Object? raw = widget.scope.form.valueOf(widget.node.fieldKey);
    if (raw is String && raw.isNotEmpty) {
      try {
        final Object? parsed = jsonDecode(raw);
        if (parsed is List && parsed.isNotEmpty) {
          return [
            for (final e in parsed)
              if (e is Map) _ReferenceEntry.fromJson(Map<String, dynamic>.from(e)),
          ];
        }
      } catch (_) {}
    }
    return [_ReferenceEntry()];
  }

  int get _minCount => (widget.node.props['minCount'] as num?)?.toInt() ?? 1;
  int get _maxCount => (widget.node.props['maxCount'] as num?)?.toInt() ?? 3;

  String get _ownMobile =>
      _digits(widget.scope.resolvePath('mobile')?.toString() ?? '');

  static String _digits(String value) {
    final String d = value.replaceAll(RegExp(r'\D'), '');
    return d.length > 10 ? d.substring(d.length - 10) : d;
  }

  String? _errorFor(int index) {
    final _ReferenceEntry entry = _entries[index];
    final String mobile = _digits(entry.mobile);
    if (mobile.isEmpty) return null;
    if (mobile.length != 10) return 'Enter a valid 10-digit mobile number';
    if (mobile == _ownMobile) return 'This is your own number. Use a different one.';
    for (int i = 0; i < _entries.length; i++) {
      if (i != index && _digits(_entries[i].mobile) == mobile) {
        return 'You have already used this number for another reference';
      }
    }
    return null;
  }

  void _sync() {
    final bool valid = List.generate(_entries.length, _errorFor).every((e) => e == null);
    final List<_ReferenceEntry> filled = _entries.where((e) => !e.isEmpty).toList();
    widget.scope.form.setValue(
      widget.node.fieldKey,
      valid && filled.length >= _minCount ? jsonEncode([for (final e in filled) e.toJson()]) : '',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _entries.length; i++) ...[
          if (i > 0) const Gap.lg(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reference ${i + 1}',
                  style: AppText.label.copyWith(color: AppColors.textSecondary),
                ),
              ),
              if (_entries.length > _minCount)
                GhostButton(
                  label: 'Remove',
                  icon: Icons.close_rounded,
                  onPressed: () {
                    _entries.removeAt(i);
                    _sync();
                  },
                ),
            ],
          ),
          const Gap.sm(),
          AppTextField(
            label: 'Full name',
            hint: 'Their name',
            initialValue: _entries[i].name,
            required: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (v) {
              _entries[i].name = v;
              _sync();
            },
          ),
          const Gap.md(),
          AppTextField(
            label: 'Mobile number',
            hint: '98765 43210',
            initialValue: _entries[i].mobile,
            required: true,
            prefixText: '+91',
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            errorText: _errorFor(i),
            onChanged: (v) {
              _entries[i].mobile = v;
              _sync();
            },
          ),
          const Gap.md(),
          AppPickerField(
            label: 'Relationship',
            hint: 'Select',
            value: _entries[i].relation.isEmpty ? null : _entries[i].relation,
            onTap: () async {
              final String? picked =
                  await showRelationPicker(context, selected: _entries[i].relation);
              if (picked != null) {
                _entries[i].relation = picked;
                _sync();
              }
            },
          ),
        ],
        if (_entries.length < _maxCount) ...[
          const Gap.lg(),
          SecondaryButton(
            label: 'Add another reference',
            icon: Icons.person_add_alt_rounded,
            onPressed: () {
              _entries.add(_ReferenceEntry());
              _sync();
            },
          ),
        ],
      ],
    );
  }
}

class _NomineeEntry {
  _NomineeEntry({this.name = '', this.relation = '', this.share = 0});

  factory _NomineeEntry.fromJson(Map<String, dynamic> json) => _NomineeEntry(
        name: json['name']?.toString() ?? '',
        relation: json['relation']?.toString() ?? '',
        share: num.tryParse(json['share']?.toString() ?? '') ?? 0,
      );

  String name;
  String relation;
  num share;

  Map<String, Object?> toJson() => {'name': name, 'relation': relation, 'share': share};

  bool get isEmpty => name.trim().isEmpty && share == 0;
}

class _NomineeField extends StatefulWidget {
  const _NomineeField({required this.node, required this.scope});

  final UiNode node;
  final DynamicUiScope scope;

  @override
  State<_NomineeField> createState() => _NomineeFieldState();
}

class _NomineeFieldState extends State<_NomineeField> {
  late final List<_NomineeEntry> _entries = _decode();

  List<_NomineeEntry> _decode() {
    final Object? raw = widget.scope.form.valueOf(widget.node.fieldKey);
    if (raw is String && raw.isNotEmpty) {
      try {
        final Object? parsed = jsonDecode(raw);
        if (parsed is List && parsed.isNotEmpty) {
          return [
            for (final e in parsed)
              if (e is Map) _NomineeEntry.fromJson(Map<String, dynamic>.from(e)),
          ];
        }
      } catch (_) {}
    }
    return [_NomineeEntry(share: 100)];
  }

  int get _maxCount => (widget.node.props['maxCount'] as num?)?.toInt() ?? 4;

  num get _total => _entries.fold<num>(0, (sum, e) => sum + e.share);

  num get _remaining => 100 - _total;

  void _sync() {
    final List<_NomineeEntry> filled = _entries.where((e) => !e.isEmpty).toList();
    final bool complete = filled.isNotEmpty &&
        _total == 100 &&
        filled.every((e) => e.name.trim().isNotEmpty);
    widget.scope.form.setValue(
      widget.node.fieldKey,
      complete ? jsonEncode([for (final e in filled) e.toJson()]) : '',
    );
    setState(() {});
  }

  void _balanceToHundred() {
    if (_entries.isEmpty) return;
    final num diff = 100 - _total;
    final _NomineeEntry last = _entries.last;
    last.share = (last.share + diff).clamp(0, 100);
    _sync();
  }

  @override
  Widget build(BuildContext context) {
    final num remaining = _remaining;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _entries.length; i++) ...[
          if (i > 0) const Gap.lg(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Nominee ${i + 1}',
                  style: AppText.label.copyWith(color: AppColors.textSecondary),
                ),
              ),
              if (_entries.length > 1)
                GhostButton(
                  label: 'Remove',
                  icon: Icons.close_rounded,
                  onPressed: () {
                    _entries.removeAt(i);
                    _sync();
                  },
                ),
            ],
          ),
          const Gap.sm(),
          AppTextField(
            label: 'Full name',
            hint: 'Their name',
            initialValue: _entries[i].name,
            required: true,
            textCapitalization: TextCapitalization.words,
            onChanged: (v) {
              _entries[i].name = v;
              _sync();
            },
          ),
          const Gap.md(),
          AppPickerField(
            label: 'Relationship',
            hint: 'Select',
            value: _entries[i].relation.isEmpty ? null : _entries[i].relation,
            onTap: () async {
              final String? picked =
                  await showRelationPicker(context, selected: _entries[i].relation);
              if (picked != null) {
                _entries[i].relation = picked;
                _sync();
              }
            },
          ),
          const Gap.md(),
          AppTextField(
            label: 'Share',
            hint: '0 - 100',
            initialValue: _entries[i].share == 0 ? '' : '${_entries[i].share}',
            required: true,
            keyboardType: TextInputType.number,
            suffixText: '%',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            onChanged: (v) {
              _entries[i].share = num.tryParse(v) ?? 0;
              _sync();
            },
          ),
        ],
        const Gap.lg(),
        if (remaining != 0)
          _ShareNotice(
            tone: AppColors.warning,
            icon: Icons.pie_chart_rounded,
            title: remaining > 0
                ? 'Shares add up to $_total%, which is less than 100%'
                : 'Shares add up to $_total%, which is more than 100%',
            message: remaining > 0
                ? 'Add another nominee for the remaining $remaining%, or give it to the last nominee.'
                : 'Reduce a share by ${-remaining}% so the total comes to 100%.',
          )
        else
          const _ShareNotice(
            tone: AppColors.success,
            icon: Icons.check_circle_rounded,
            title: 'Shares add up to 100%',
            message: 'Your nomination is complete.',
          ),
        if (remaining != 0) ...[
          const Gap.md(),
          Row(
            children: [
              if (remaining > 0 && _entries.length < _maxCount) ...[
                Expanded(
                  child: SecondaryButton(
                    label: 'Add nominee',
                    icon: Icons.person_add_alt_rounded,
                    onPressed: () {
                      _entries.add(_NomineeEntry(share: remaining));
                      _sync();
                    },
                  ),
                ),
                const SizedBox(width: Insets.sm),
              ],
              Expanded(
                child: SecondaryButton(
                  label: 'Make it 100%',
                  icon: Icons.auto_fix_high_rounded,
                  onPressed: _balanceToHundred,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ShareNotice extends StatelessWidget {
  const _ShareNotice({
    required this.title,
    required this.message,
    required this.tone,
    required this.icon,
  });

  final String title;
  final String message;
  final Color tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AccentCard(
        accent: tone,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: tone),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.titleSmall.copyWith(fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(message, style: AppText.bodySmall.copyWith(fontSize: 11.5, height: 1.45)),
                ],
              ),
            ),
          ],
        ),
      );
}
