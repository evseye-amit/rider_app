import '../models/validation_rule.dart';

final RegExp _emailRe = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
final RegExp _mobileRe = RegExp(r'^[6-9]\d{9}$');
final RegExp _aadhaarRe = RegExp(r'^\d{4}\s?\d{4}\s?\d{4}$');
final RegExp _panRe = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');
final RegExp _ifscRe = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
final RegExp _upiRe = RegExp(r'^[\w.\-]{2,}@[a-zA-Z]{2,}$');

String? validateValue(
  Object? value,
  List<ValidationRule> rules, {
  Object? Function(String key)? lookup,
  String? label,
}) {
  final String name = label ?? 'This field';
  final String text = value?.toString().trim() ?? '';

  for (final rule in rules) {
    final String? message = switch (rule.type) {
      'required' => switch (value) {
          null => '$name is required',
          final bool b => b ? null : '$name is required',
          final Iterable<Object?> it => it.isEmpty ? '$name is required' : null,
          _ => text.isEmpty ? '$name is required' : null,
        },
      'minLength' when text.isNotEmpty && text.length < _int(rule.value) =>
        '$name must be at least ${_int(rule.value)} characters',
      'maxLength' when text.length > _int(rule.value) =>
        '$name must be at most ${_int(rule.value)} characters',
      'pattern' when text.isNotEmpty && !RegExp(rule.value.toString()).hasMatch(text) =>
        'Enter a valid $name',
      'email' when text.isNotEmpty && !_emailRe.hasMatch(text) => 'Enter a valid email address',
      'mobile' when text.isNotEmpty && !_mobileRe.hasMatch(text) =>
        'Enter a valid 10-digit mobile number',
      'aadhaar' when text.isNotEmpty && !_aadhaarRe.hasMatch(text) =>
        'Enter a valid 12-digit Aadhaar number',
      'pan' when text.isNotEmpty && !_panRe.hasMatch(text.toUpperCase()) =>
        'Enter a valid PAN (ABCDE1234F)',
      'ifsc' when text.isNotEmpty && !_ifscRe.hasMatch(text.toUpperCase()) =>
        'Enter a valid IFSC code',
      'upi' when text.isNotEmpty && !_upiRe.hasMatch(text) => 'Enter a valid UPI ID',
      'min' when _num(value) != null && _num(value)! < _num(rule.value)! =>
        '$name must be at least ${rule.value}',
      'max' when _num(value) != null && _num(value)! > _num(rule.value)! =>
        '$name must be at most ${rule.value}',
      'minAge' => _minAge(text, _int(rule.value)),
      'match' when lookup != null && text != (lookup(rule.value.toString())?.toString() ?? '') =>
        '$name does not match',
      _ => null,
    };
    if (message != null) return rule.message ?? message;
  }
  return null;
}

String? _minAge(String text, int min) {
  if (text.isEmpty) return null;
  final DateTime? dob = DateTime.tryParse(text);
  if (dob == null) return null;
  final DateTime now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
  return age < min ? 'You must be at least $min years old' : null;
}

int _int(Object? v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
num? _num(Object? v) => v is num ? v : num.tryParse(v?.toString() ?? '');
