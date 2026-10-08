import 'package:equatable/equatable.dart';
import 'package:evseye_core/evseye_core.dart';

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

class AcceptExchangeOffer extends UseCase<void, AcceptOfferParams> {
  const AcceptExchangeOffer(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<void>> call(AcceptOfferParams params) =>
      _repository.acceptOffer(id: params.id, offerId: params.offerId, offerHash: params.offerHash);
}

class RejectExchangeOffer extends UseCase<void, RejectOfferParams> {
  const RejectExchangeOffer(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<void>> call(RejectOfferParams params) =>
      _repository.rejectOffer(id: params.id, offerId: params.offerId, reason: params.reason);
}

class CancelExchange extends UseCase<void, String> {
  const CancelExchange(this._repository);

  final ExchangeRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.cancel(params);
}
