import 'package:flutter/foundation.dart';

import '../models/ui_node.dart';
import '../models/validation_rule.dart';
import 'validators.dart';

class DynamicFormController extends ChangeNotifier {
  DynamicFormController({Map<String, Object?>? initial})
      : _values = {...?initial};

  final Map<String, Object?> _values;
  final Map<String, String?> _errors = {};
  final Set<String> _touched = {};

  Map<String, Object?> get values => Map.unmodifiable(_values);
  Map<String, String?> get errors => Map.unmodifiable(_errors);

  Object? valueOf(String key) => _values[key];
  String stringOf(String key) => _values[key]?.toString() ?? '';
  bool boolOf(String key) => _values[key] == true;
  String? errorOf(String key) => _touched.contains(key) ? _errors[key] : null;
  bool isTouched(String key) => _touched.contains(key);

  void setValue(String key, Object? value, {bool markTouched = true}) {
    if (_values[key] == value) return;
    _values[key] = value;
    if (markTouched) _touched.add(key);
    _errors.remove(key);
    notifyListeners();
  }

  void patch(Map<String, Object?> next) {
    _values.addAll(next);
    notifyListeners();
  }

  void setError(String key, String? message) {
    _errors[key] = message;
    _touched.add(key);
    notifyListeners();
  }

  void clear() {
    _values.clear();
    _errors.clear();
    _touched.clear();
    notifyListeners();
  }

  bool validateNodes(
    List<UiNode> nodes, {
    required bool Function(UiNode node) isVisible,
  }) {
    _errors.clear();
    var ok = true;
    void walk(List<UiNode> list) {
      for (final node in list) {
        if (!isVisible(node)) continue;
        if (node.validations.isNotEmpty) {
          final String key = node.fieldKey;
          _touched.add(key);
          final String? err = validateValue(
            _values[key],
            node.validations,
            lookup: (k) => _values[k],
            label: node.label,
          );
          if (err != null) {
            _errors[key] = err;
            ok = false;
          }
        }
        walk(node.children);
      }
    }

    walk(nodes);
    notifyListeners();
    return ok;
  }

  String? validateField(String key, List<ValidationRule> rules, {String? label}) {
    final String? err = validateValue(_values[key], rules, lookup: (k) => _values[k], label: label);
    _errors[key] = err;
    return err;
  }
}
