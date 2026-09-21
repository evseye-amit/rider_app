import 'package:equatable/equatable.dart';

enum RiderState { active, onboarding, exited }

extension RiderStateX on RiderState {
  String get label => switch (this) {
        RiderState.active => 'Active',
        RiderState.onboarding => 'Onboarding',
        RiderState.exited => 'Exited',
      };
}

class Rider extends Equatable {
  const Rider({
    required this.id,
    required this.name,
    required this.riderCode,
    required this.mobile,
    required this.teamLead,
    required this.plan,
    required this.state,
    this.vehicleNumber,
    this.joinedOn,
    this.kycStatus,
    this.exitReason,
  });

  final String id;
  final String name;
  final String riderCode;
  final String mobile;
  final String teamLead;
  final String plan;
  final RiderState state;
  final String? vehicleNumber;
  final DateTime? joinedOn;
  final String? kycStatus;
  final String? exitReason;

  bool get hasVehicle => (vehicleNumber ?? '').isNotEmpty;

  @override
  List<Object?> get props =>
      [id, name, riderCode, mobile, teamLead, plan, state, vehicleNumber, exitReason];
}
