import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_request.dart';
import '../exchange_repository.dart';

class GetExchange extends UseCase<ExchangeRequest, String> {
  const GetExchange(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<ExchangeRequest>> call(String params) => _repository.details(params);
}
