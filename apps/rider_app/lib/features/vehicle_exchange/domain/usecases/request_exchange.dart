import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_request.dart';
import '../exchange_repository.dart';

class RequestExchangeParams extends Equatable {
  const RequestExchangeParams({required this.agreementId, required this.reasonCode, this.reason});

  final String agreementId;
  final String reasonCode;
  final String? reason;

  @override
  List<Object?> get props => [agreementId, reasonCode, reason];
}

class RequestExchange extends UseCase<ExchangeRequest, RequestExchangeParams> {
  const RequestExchange(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<ExchangeRequest>> call(RequestExchangeParams params) =>
      _repository.request(agreementId: params.agreementId, reasonCode: params.reasonCode, reason: params.reason);
}
