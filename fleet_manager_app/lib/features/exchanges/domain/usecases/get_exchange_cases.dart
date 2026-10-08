import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_case.dart';
import '../exchange_desk_repository.dart';

class GetExchangeCases extends UseCase<List<ExchangeCase>, NoParams> {
  const GetExchangeCases(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<List<ExchangeCase>>> call(NoParams params) => _repository.cases();
}

class GetExchangeCase extends UseCase<ExchangeCase, String> {
  const GetExchangeCase(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<ExchangeCase>> call(String params) => _repository.caseDetail(params);
}

class GetAvailableScooters extends UseCase<List<ScooterOption>, NoParams> {
  const GetAvailableScooters(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<List<ScooterOption>>> call(NoParams params) => _repository.availableScooters();
}

class GetExchangeQuote extends UseCase<CaseQuote, String> {
  const GetExchangeQuote(this._repository);

  final ExchangeDeskRepository _repository;

  @override
  Future<Result<CaseQuote>> call(String params) => _repository.quote(params);
}
