import 'package:equatable/equatable.dart';

class UiCondition extends Equatable {
  const UiCondition({
    this.flag,
    this.notFlag,
    this.field,
    this.equals,
    this.notEquals,
    this.oneOf,
    this.gte,
    this.lte,
    this.isNotEmpty,
    this.allOf = const [],
    this.anyOf = const [],
    this.not,
  });

  final String? flag;

  final String? notFlag;

  final String? field;

  final Object? equals;
  final Object? notEquals;
  final List<Object?>? oneOf;
  final num? gte;
  final num? lte;
  final bool? isNotEmpty;

  final List<UiCondition> allOf;
  final List<UiCondition> anyOf;
  final UiCondition? not;

  bool get isEmpty =>
      flag == null &&
      notFlag == null &&
      field == null &&
      allOf.isEmpty &&
      anyOf.isEmpty &&
      not == null;

  bool evaluate({
    required bool Function(String flag) isFlagEnabled,
    required Object? Function(String key) valueOf,
  }) {
    if (flag != null && !isFlagEnabled(flag!)) return false;
    if (notFlag != null && isFlagEnabled(notFlag!)) return false;

    if (field != null) {
      final Object? v = valueOf(field!);
      if (equals != null && !_looseEquals(v, equals)) return false;
      if (notEquals != null && _looseEquals(v, notEquals)) return false;
      if (oneOf != null && !oneOf!.any((o) => _looseEquals(v, o))) return false;
      if (gte != null && !(v is num && v >= gte!)) return false;
      if (lte != null && !(v is num && v <= lte!)) return false;
      if (isNotEmpty != null) {
        final bool filled = switch (v) {
          null => false,
          final String s => s.trim().isNotEmpty,
          final Iterable<Object?> it => it.isNotEmpty,
          final Map<Object?, Object?> m => m.isNotEmpty,
          final bool b => b,
          _ => true,
        };
        if (filled != isNotEmpty!) return false;
      }
    }

    for (final c in allOf) {
      if (!c.evaluate(isFlagEnabled: isFlagEnabled, valueOf: valueOf)) return false;
    }
    if (anyOf.isNotEmpty &&
        !anyOf.any((c) => c.evaluate(isFlagEnabled: isFlagEnabled, valueOf: valueOf))) {
      return false;
    }
    if (not != null && not!.evaluate(isFlagEnabled: isFlagEnabled, valueOf: valueOf)) {
      return false;
    }
    return true;
  }

  static bool _looseEquals(Object? a, Object? b) {
    if (a == b) return true;
    if (a == null || b == null) return false;
    if (a is num && b is num) return a.toDouble() == b.toDouble();
    return a.toString().toLowerCase() == b.toString().toLowerCase();
  }

  factory UiCondition.fromJson(Map<String, dynamic> json) => UiCondition(
        flag: json['flag'] as String?,
        notFlag: json['notFlag'] as String?,
        field: json['field'] as String?,
        equals: json['equals'],
        notEquals: json['notEquals'],
        oneOf: (json['oneOf'] as List<dynamic>?)?.cast<Object?>(),
        gte: json['gte'] as num?,
        lte: json['lte'] as num?,
        isNotEmpty: json['isNotEmpty'] as bool?,
        allOf: _list(json['allOf']),
        anyOf: _list(json['anyOf']),
        not: json['not'] == null
            ? null
            : UiCondition.fromJson(Map<String, dynamic>.from(json['not'] as Map)),
      );

  static List<UiCondition> _list(Object? raw) => (raw as List<dynamic>? ?? const [])
      .map((e) => UiCondition.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList(growable: false);

  @override
  List<Object?> get props =>
      [flag, notFlag, field, equals, notEquals, oneOf, gte, lte, isNotEmpty, allOf, anyOf, not];
}
