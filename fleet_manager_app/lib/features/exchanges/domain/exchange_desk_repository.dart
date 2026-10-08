import 'package:evseye_core/evseye_core.dart';

import 'entities/exchange_case.dart';

abstract interface class ExchangeDeskRepository {
  Future<Result<List<ExchangeCase>>> cases();

  Future<Result<ExchangeCase>> caseDetail(String id);

  Future<Result<List<ScooterOption>>> availableScooters();

  Future<Result<CaseQuote>> quote(String id);

  Future<Result<void>> approve(String id);

  Future<Result<void>> reject(String id, {required String reason});

  Future<Result<void>> startReturn(String id);

  Future<Result<void>> confirmReturn(String id);

  Future<Result<void>> chooseScooter(ExchangeCase exchange, ScooterOption scooter);

  Future<Result<void>> sendOffer(String id);

  Future<Result<num>> settleDeposits(String id);

  Future<Result<void>> startHandover(String id);

  Future<Result<void>> complete(String id);

  Future<Result<void>> cancel(String id);
}
