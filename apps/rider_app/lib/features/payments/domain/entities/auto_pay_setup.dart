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
    this.maxAmount = 0,
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
  final num maxAmount;
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
    maxAmount,
    approvalUrl,
  ];
}

class AutoPaySetup extends Equatable {
  const AutoPaySetup({required this.canSetUp, required this.maxAmount, this.validityDays = 0, this.mandate});

  final bool canSetUp;
  final num maxAmount;
  final int validityDays;
  final AutoPayMandate? mandate;

  @override
  List<Object?> get props => [canSetUp, maxAmount, validityDays, mandate];
}

enum AutoPayDebitState { pending, settled, failed }

class AutoPayDebit extends Equatable {
  const AutoPayDebit({
    required this.id,
    required this.number,
    required this.amount,
    required this.state,
    this.invoiceNumber,
    this.amountMayChange = false,
    this.scheduledFor,
  });

  final String id;
  final String number;
  final num amount;
  final AutoPayDebitState state;
  final String? invoiceNumber;
  final bool amountMayChange;
  final DateTime? scheduledFor;

  @override
  List<Object?> get props => [id, number, amount, state, invoiceNumber, amountMayChange, scheduledFor];
}
