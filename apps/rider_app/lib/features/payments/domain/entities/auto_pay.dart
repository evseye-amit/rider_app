import 'package:equatable/equatable.dart';

enum AutoPayState {
  off,
  setupRequired,
  authorizationPending,
  activationPending,
  mandateActionRequired,
  waitingForAllocation,
  active,
  actionRequired,
  pausedByClient,
  migrationBlocked,
  unknown,
}

enum AutoPayMandateState { awaitingApproval, active, paused, closed }

class AutoPayMandate extends Equatable {
  const AutoPayMandate({
    required this.id,
    required this.state,
    required this.maxAmount,
    required this.cancellationPending,
    this.expiresAt,
    this.approvalUrl,
  });

  final String id;
  final AutoPayMandateState state;
  final num maxAmount;
  final bool cancellationPending;
  final DateTime? expiresAt;
  final String? approvalUrl;

  @override
  List<Object?> get props => [id, state, maxAmount, cancellationPending, expiresAt, approvalUrl];
}

enum AutoRechargeState {
  creating,
  pending,
  unknown,
  review,
  success,
  failed,
  cancelled;

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

class AutoRechargePage extends Equatable {
  const AutoRechargePage({required this.items, required this.page, required this.hasMore});

  final List<AutoRecharge> items;
  final int page;
  final bool hasMore;

  @override
  List<Object?> get props => [items, page, hasMore];
}

class AutoPay extends Equatable {
  const AutoPay({
    required this.state,
    required this.enabled,
    required this.threshold,
    required this.rechargeAmount,
    required this.leadHours,
    required this.cooldownHours,
    required this.canSetUp,
    this.setupLimit,
    this.mandate,
    this.requests = const [],
  });

  final AutoPayState state;
  final bool enabled;
  final num threshold;
  final num rechargeAmount;
  final num leadHours;
  final num cooldownHours;
  final bool canSetUp;
  final num? setupLimit;
  final AutoPayMandate? mandate;
  final List<AutoRecharge> requests;

  bool get isOn => state == AutoPayState.active || state == AutoPayState.waitingForAllocation;

  bool get awaitingApproval => state == AutoPayState.authorizationPending;

  bool get activating => state == AutoPayState.activationPending;

  bool get needsSetup => awaitingApproval || activating || canSetUp;

  bool get isVisible => state != AutoPayState.pausedByClient || enabled || mandate != null || requests.isNotEmpty;

  AutoRecharge? get openRequest {
    for (final AutoRecharge request in requests) {
      if (request.state.isOpen) return request;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    state,
    enabled,
    threshold,
    rechargeAmount,
    leadHours,
    cooldownHours,
    canSetUp,
    setupLimit,
    mandate,
    requests,
  ];
}
