import 'package:equatable/equatable.dart';

enum AutoPayMandateState { awaitingApproval, active, paused, closed }

class AutoPayMandate extends Equatable {
  const AutoPayMandate({
    required this.id,
    required this.state,
    required this.autoDebitOn,
    required this.canPause,
    required this.canResume,
    required this.canCancel,
    required this.canTurnOff,
    required this.cancellationPending,
    required this.managedInUpiApp,
    this.approvalUrl,
  });

  final String id;
  final AutoPayMandateState state;
  final bool autoDebitOn;
  final bool canPause;
  final bool canResume;
  final bool canCancel;
  final bool canTurnOff;
  final bool cancellationPending;
  final bool managedInUpiApp;
  final String? approvalUrl;

  @override
  List<Object?> get props => [
    id,
    state,
    autoDebitOn,
    canPause,
    canResume,
    canCancel,
    canTurnOff,
    cancellationPending,
    managedInUpiApp,
    approvalUrl,
  ];
}

class AutoPaySetup extends Equatable {
  const AutoPaySetup({required this.canSetUp, required this.maxAmount, this.mandate});

  final bool canSetUp;
  final num maxAmount;
  final AutoPayMandate? mandate;

  @override
  List<Object?> get props => [canSetUp, maxAmount, mandate];
}
