import 'package:evseye_core/evseye_core.dart';

import '../domain/entities/exchange_request.dart';
import '../domain/exchange_repository.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  const ExchangeRepositoryImpl(this._api);

  final VehicleExchangeApi _api;

  @override
  Future<Result<List<ExchangeRequest>>> list() async =>
      (await _api.list()).map((items) => [for (final VehicleExchange item in items) _request(item)]);

  @override
  Future<Result<ExchangeRequest>> details(String id) async => (await _api.details(id)).map(_request);

  @override
  Future<Result<ExchangeRequest>> request({
    required String agreementId,
    required String reasonCode,
    String? reason,
  }) async => (await _api.request(agreementId: agreementId, reasonCode: reasonCode, reason: reason)).map(_request);

  @override
  Future<Result<ExchangeRequest>> acceptOffer({
    required String id,
    required String offerId,
    required String offerHash,
  }) async => (await _api.accept(id: id, offerId: offerId, offerHash: offerHash)).map(_request);

  @override
  Future<Result<ExchangeRequest>> rejectOffer({
    required String id,
    required String offerId,
    required String reason,
  }) async => (await _api.rejectOffer(id: id, offerId: offerId, reason: reason)).map(_request);

  @override
  Future<Result<ExchangeRequest>> cancel(String id) async => (await _api.cancel(id)).map(_request);

  static ExchangeRequest _request(VehicleExchange exchange) => ExchangeRequest(
    id: exchange.id,
    agreementId: exchange.agreementId,
    stage: _stage(exchange.status),
    statusCode: exchange.status.wire,
    reasonCode: exchange.reasonCode,
    createdAt: exchange.createdAt,
    reason: exchange.reason,
    effectiveAt: exchange.effectiveAt ?? exchange.proposedEffectiveAt,
    reservationExpiresAt: exchange.reservationExpiresAt,
    completedAt: exchange.completedAt,
    canCancel: exchange.status.canCancel,
    offers: [for (final VehicleExchangeOffer offer in exchange.offers) _offer(offer)],
  );

  static ExchangeStage _stage(VehicleExchangeStatus status) => switch (status) {
    VehicleExchangeStatus.requested => ExchangeStage.requested,
    VehicleExchangeStatus.approved || VehicleExchangeStatus.replacementSelected => ExchangeStage.inReview,
    VehicleExchangeStatus.offerPresented => ExchangeStage.offerReady,
    VehicleExchangeStatus.accepted => ExchangeStage.accepted,
    VehicleExchangeStatus.returnPending ||
    VehicleExchangeStatus.depositPending ||
    VehicleExchangeStatus.handoverPending => ExchangeStage.awaitingHandover,
    VehicleExchangeStatus.completed => ExchangeStage.completed,
    VehicleExchangeStatus.rejected ||
    VehicleExchangeStatus.cancelled ||
    VehicleExchangeStatus.expired => ExchangeStage.closed,
  };

  static ExchangeOffer _offer(VehicleExchangeOffer offer) => ExchangeOffer(
    id: offer.id,
    hash: offer.offerHash,
    termsTitle: offer.termsTitle,
    termsBody: offer.termsSnapshot,
    termsVersion: offer.termsVersion,
    expiresAt: offer.expiresAt,
    isPresented: offer.isPresented,
    rentDifference: _amount(offer.commercialDifference, const ['rent', 'rentDelta', 'rentDifference']),
    depositDifference: _amount(offer.commercialDifference, const ['deposit', 'depositDelta', 'depositDifference']),
  );

  static num? _amount(Map<String, dynamic> source, List<String> keys) {
    for (final String key in keys) {
      final Object? value = source[key];
      if (value is num) return value;
      final num? parsed = num.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    return null;
  }
}
