import 'package:equatable/equatable.dart';

class ValidationRule extends Equatable {
  const ValidationRule({
    required this.type,
    this.value,
    this.message,
  });

  final String type;
  final Object? value;
  final String? message;

  factory ValidationRule.fromJson(Map<String, dynamic> json) => ValidationRule(
        type: json['type'] as String,
        value: json['value'],
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        if (value != null) 'value': value,
        if (message != null) 'message': message,
      };

  @override
  List<Object?> get props => [type, value, message];
}
