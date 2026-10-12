import 'package:equatable/equatable.dart';

import 'exchange_request.dart';

class RentalAgreement extends Equatable {
  const RentalAgreement({required this.id, required this.number, required this.rent, this.period, this.scooterName});

  final String id;
  final String number;
  final num rent;
  final RentPeriod? period;
  final String? scooterName;

  @override
  List<Object?> get props => [id, number, rent, period, scooterName];
}

enum RevisionState { current, pending, previous }

class AgreementRevision extends Equatable {
  const AgreementRevision({
    required this.number,
    required this.rent,
    required this.effectiveFrom,
    required this.state,
    this.scooterName,
  });

  final int number;
  final num rent;
  final DateTime effectiveFrom;
  final RevisionState state;
  final String? scooterName;

  @override
  List<Object?> get props => [number, rent, effectiveFrom, state, scooterName];
}
