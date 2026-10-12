import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_request.dart';
import '../exchange_repository.dart';

class GetExchanges extends UseCase<List<ExchangeRequest>, NoParams> {
  const GetExchanges(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<List<ExchangeRequest>>> call(NoParams params) => _repository.list();
}
