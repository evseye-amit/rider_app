import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

import '../entities/exchange_request.dart';
import '../exchange_repository.dart';

class AcceptOfferParams extends Equatable {
  const AcceptOfferParams({required this.id, required this.offerId, required this.offerHash});

  final String id;
  final String offerId;
  final String offerHash;

  @override
  List<Object?> get props => [id, offerId, offerHash];
}

class RejectOfferParams extends Equatable {
  const RejectOfferParams({required this.id, required this.offerId, required this.reason});

  final String id;
  final String offerId;
  final String reason;

  @override
  List<Object?> get props => [id, offerId, reason];
}

class AcceptExchangeOffer extends UseCase<ExchangeRequest, AcceptOfferParams> {
  const AcceptExchangeOffer(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<ExchangeRequest>> call(AcceptOfferParams params) =>
      _repository.acceptOffer(id: params.id, offerId: params.offerId, offerHash: params.offerHash);
}

class RejectExchangeOffer extends UseCase<ExchangeRequest, RejectOfferParams> {
  const RejectExchangeOffer(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<ExchangeRequest>> call(RejectOfferParams params) =>
      _repository.rejectOffer(id: params.id, offerId: params.offerId, reason: params.reason);
}

class CancelExchange extends UseCase<ExchangeRequest, String> {
  const CancelExchange(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<ExchangeRequest>> call(String params) => _repository.cancel(params);
}
