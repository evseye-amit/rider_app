import 'package:equatable/equatable.dart';

class TeamLead extends Equatable {
  const TeamLead({
    required this.id,
    required this.name,
    required this.mobile,
    required this.riders,
  });

  final String id;
  final String name;
  final String mobile;
  final int riders;

  @override
  List<Object?> get props => [id, name, mobile, riders];
}

class HubProfile extends Equatable {
  const HubProfile({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.capacity,
    required this.openedOn,
    required this.chargingBays,
    required this.serviceBays,
    required this.teamLeads,
  });

  final String id;

  final String name;
  final String code;
  final String address;
  final String city;
  final int capacity;
  final DateTime? openedOn;
  final int chargingBays;
  final int serviceBays;
  final List<TeamLead> teamLeads;

  bool get hasTeamLeads => teamLeads.isNotEmpty;

  @override
  List<Object?> get props =>
      [id, name, code, address, city, capacity, openedOn, chargingBays, serviceBays, teamLeads];
}
