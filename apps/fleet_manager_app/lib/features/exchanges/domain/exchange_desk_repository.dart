import 'package:evseye_core/evseye_core.dart';

import 'entities/exchange_case.dart';

abstract interface class ExchangeDeskRepository {
  Future<Result<List<ExchangeCase>>> cases();

  Future<Result<ExchangeCase>> caseDetail(String id);

  Future<Result<List<ScooterOption>>> availableScooters();

  Future<Result<CaseQuote>> quote(String id);

  Future<Result<void>> reject(String id, {required String reason});

  Future<Result<String>> startCheckIn(String id, {String? hubId});

  Future<Result<void>> chooseScooter(ExchangeCase exchange, ScooterOption scooter);

  Future<Result<void>> sendOffer(String id);

  Future<Result<DepositOutcome>> settleDeposits(String id);

  Future<Result<void>> acceptOnBehalf(
    String id,
    CaseOffer offer, {
    required String consentReference,
    required String reason,
  });

  Future<Result<void>> rejectOnBehalf(String id, CaseOffer offer, {required String reason});

  Future<Result<void>> startHandover(String id);

  Future<Result<void>> complete(String id);

  Future<Result<void>> cancel(String id);
}
