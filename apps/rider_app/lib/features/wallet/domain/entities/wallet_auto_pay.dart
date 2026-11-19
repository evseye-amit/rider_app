import 'package:equatable/equatable.dart';

enum AutoRechargeState {
  creating('CREATING'),
  pending('PENDING'),
  unknown('UNKNOWN'),
  review('REVIEW_REQUIRED'),
  success('SUCCESS'),
  failed('FAILED'),
  cancelled('CANCELLED');

  const AutoRechargeState(this.wire);

  final String wire;

  static AutoRechargeState parse(String value) =>
      AutoRechargeState.values.firstWhere((state) => state.wire == value, orElse: () => AutoRechargeState.unknown);

  bool get isOpen => this == creating || this == pending || this == unknown || this == review;

  bool get isAwaitingBank => this == creating || this == pending || this == unknown;
}

class AutoRecharge extends Equatable {
  const AutoRecharge({
    required this.id,
    required this.state,
    required this.amount,
    this.scheduledAt,
    this.completedAt,
    this.createdAt,
  });

  final String id;
  final AutoRechargeState state;
  final num amount;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, state, amount, scheduledAt, completedAt, createdAt];
}

class WalletAutoPay extends Equatable {
  const WalletAutoPay({
    required this.policyEnabled,
    required this.threshold,
    required this.rechargeAmount,
    required this.revision,
    required this.enabled,
    required this.actionRequired,
    required this.consentRequired,
    required this.leadHours,
    required this.cooldownHours,
    required this.requests,
    this.mandateId,
  });

  final bool policyEnabled;
  final num threshold;
  final num rechargeAmount;
  final int revision;
  final bool enabled;
  final bool actionRequired;
  final bool consentRequired;
  final num leadHours;
  final num cooldownHours;
  final String? mandateId;
  final List<AutoRecharge> requests;

  bool get isOn => enabled && !consentRequired;

  bool get isVisible => policyEnabled || enabled || requests.isNotEmpty;

  AutoRecharge? get openRequest {
    for (final AutoRecharge request in requests) {
      if (request.state.isOpen) return request;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    policyEnabled,
    threshold,
    rechargeAmount,
    revision,
    enabled,
    actionRequired,
    consentRequired,
    leadHours,
    cooldownHours,
    mandateId,
    requests,
  ];
}
