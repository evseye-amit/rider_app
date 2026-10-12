import 'package:equatable/equatable.dart';

class UiAction extends Equatable {
  const UiAction({required this.type, this.target, this.params = const {}});

  final String type;

  final String? target;

  final Map<String, dynamic> params;

  factory UiAction.fromJson(Map<String, dynamic> json) => UiAction(
        type: json['type'] as String? ?? 'custom',
        target: json['target'] as String?,
        params: Map<String, dynamic>.from(json['params'] as Map? ?? const {}),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        if (target != null) 'target': target,
        if (params.isNotEmpty) 'params': params,
      };

  @override
  List<Object?> get props => [type, target, params];
}
